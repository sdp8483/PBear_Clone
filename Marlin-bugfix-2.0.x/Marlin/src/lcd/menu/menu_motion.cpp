/**
 * Marlin 3D Printer Firmware
 * Copyright (c) 2019 MarlinFirmware [https://github.com/MarlinFirmware/Marlin]
 *
 * Based on Sprinter and grbl.
 * Copyright (c) 2011 Camiel Gubbels / Erik van der Zalm
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

//
// Motion Menu
//

#include "../../inc/MarlinConfigPre.h"

#if HAS_LCD_MENU

#include "menu.h"

#include "../lcdprint.h"

#if HAS_GRAPHICAL_LCD
  #include "../dogm/ultralcd_DOGM.h"
#endif

#include "../../module/motion.h"

#if ENABLED(DELTA)
  #include "../../module/delta.h"
#endif

#if ENABLED(PREVENT_COLD_EXTRUSION)
  #include "../../module/temperature.h"
#endif

#if HAS_LEVELING
  #include "../../module/planner.h"
  #include "../../feature/bedlevel/bedlevel.h"
#endif

extern millis_t manual_move_start_time;
extern int8_t manual_move_axis;
#if ENABLED(MANUAL_E_MOVES_RELATIVE)
  float manual_move_e_origin = 0;
#endif
#if IS_KINEMATIC
  extern float manual_move_offset;
#endif

//
// Tell ui.update() to start a move to current_position" after a short delay.
//
inline void manual_move_to_current(AxisEnum axis
  #if E_MANUAL > 1
    , const int8_t eindex=-1
  #endif
) {
  #if E_MANUAL > 1
    if (axis == E_AXIS) ui.manual_move_e_index = eindex >= 0 ? eindex : active_extruder;
  #endif
  manual_move_start_time = millis() + (move_menu_scale < 0.99f ? 0UL : 250UL); // delay for bigger moves
  manual_move_axis = (int8_t)axis;
}

//
// "Motion" > "Move Axis" submenu
//

static void _lcd_move_xyz(PGM_P name, AxisEnum axis) {
  if (ui.use_click()) return ui.goto_previous_screen_no_defer();
  if (ui.encoderPosition && !ui.processing_manual_move) {

    // Start with no limits to movement
    float min = current_position[axis] - 1000,
          max = current_position[axis] + 1000;

    // Limit to software endstops, if enabled
    #if HAS_SOFTWARE_ENDSTOPS
      if (soft_endstops_enabled) switch (axis) {
        case X_AXIS:
          #if ENABLED(MIN_SOFTWARE_ENDSTOP_X)
            min = soft_endstop.min.x;
          #endif
          #if ENABLED(MAX_SOFTWARE_ENDSTOP_X)
            max = soft_endstop.max.x;
          #endif
          break;
        case Y_AXIS:
          #if ENABLED(MIN_SOFTWARE_ENDSTOP_Y)
            min = soft_endstop.min.y;
          #endif
          #if ENABLED(MAX_SOFTWARE_ENDSTOP_Y)
            max = soft_endstop.max.y;
          #endif
          break;
        case Z_AXIS:
          #if ENABLED(MIN_SOFTWARE_ENDSTOP_Z)
            min = soft_endstop.min.z;
          #endif
          #if ENABLED(MAX_SOFTWARE_ENDSTOP_Z)
            max = soft_endstop.max.z;
          #endif
        default: break;
      }
    #endif // HAS_SOFTWARE_ENDSTOPS

    // Delta limits XY based on the current offset from center
    // This assumes the center is 0,0
    #if ENABLED(DELTA)
      if (axis != Z_AXIS) {
        max = SQRT(sq((float)(DELTA_PRINTABLE_RADIUS)) - sq(current_position[Y_AXIS - axis])); // (Y_AXIS - axis) == the other axis
        min = -max;
      }
    #endif

    // Get the new position
    const float diff = float(int16_t(ui.encoderPosition)) * move_menu_scale;
    #if IS_KINEMATIC
      manual_move_offset += diff;
      if (int16_t(ui.encoderPosition) < 0)
        NOLESS(manual_move_offset, min - current_position[axis]);
      else
        NOMORE(manual_move_offset, max - current_position[axis]);
    #else
      current_position[axis] += diff;
      if (int16_t(ui.encoderPosition) < 0)
        NOLESS(current_position[axis], min);
      else
        NOMORE(current_position[axis], max);
    #endif

    manual_move_to_current(axis);
    ui.refresh(LCDVIEW_REDRAW_NOW);
  }
  ui.encoderPosition = 0;
  if (ui.should_draw()) {
    const float pos = NATIVE_TO_LOGICAL(ui.processing_manual_move ? destination[axis] : current_position[axis]
      #if IS_KINEMATIC
        + manual_move_offset
      #endif
    , axis);
    draw_edit_screen(name, move_menu_scale >= 0.1f ? ftostr41sign(pos) : ftostr43sign(pos));
  }
}
void lcd_move_x() { _lcd_move_xyz(PSTR(MSG_MOVE_X), X_AXIS); }
void lcd_move_y() { _lcd_move_xyz(PSTR(MSG_MOVE_Y), Y_AXIS); }
void lcd_move_z() { _lcd_move_xyz(PSTR(MSG_MOVE_Z), Z_AXIS); }

#if E_MANUAL

  static void _lcd_move_e(
    #if E_MANUAL > 1
      const int8_t eindex=-1
    #endif
  ) {
    if (ui.use_click()) return ui.goto_previous_screen_no_defer();
    if (ui.encoderPosition) {
      if (!ui.processing_manual_move) {
        const float diff = float(int16_t(ui.encoderPosition)) * move_menu_scale;
        #if IS_KINEMATIC
          manual_move_offset += diff;
        #else
          current_position.e += diff;
        #endif
        manual_move_to_current(E_AXIS
          #if E_MANUAL > 1
            , eindex
          #endif
        );
        ui.refresh(LCDVIEW_REDRAW_NOW);
      }
      ui.encoderPosition = 0;
    }
    if (ui.should_draw()) {
      PGM_P pos_label;
      #if E_MANUAL == 1
        pos_label = PSTR(MSG_MOVE_E);
      #else
        switch (eindex) {
          default: pos_label = PSTR(MSG_MOVE_E MSG_MOVE_E1); break;
          case 1: pos_label = PSTR(MSG_MOVE_E MSG_MOVE_E2); break;
          #if E_MANUAL > 2
            case 2: pos_label = PSTR(MSG_MOVE_E MSG_MOVE_E3); break;
            #if E_MANUAL > 3
              case 3: pos_label = PSTR(MSG_MOVE_E MSG_MOVE_E4); break;
              #if E_MANUAL > 4
                case 4: pos_label = PSTR(MSG_MOVE_E MSG_MOVE_E5); break;
                #if E_MANUAL > 5
                  case 5: pos_label = PSTR(MSG_MOVE_E MSG_MOVE_E6); break;
                #endif // E_MANUAL > 5
              #endif // E_MANUAL > 4
            #endif // E_MANUAL > 3
          #endif // E_MANUAL > 2
        }
      #endif // E_MANUAL > 1

      draw_edit_screen(pos_label, ftostr41sign(current_position.e
        #if IS_KINEMATIC
          + manual_move_offset
        #endif
        #if ENABLED(MANUAL_E_MOVES_RELATIVE)
          - manual_move_e_origin
        #endif
      ));
    }
  }

  inline void lcd_move_e() { _lcd_move_e(); }
  #if E_MANUAL > 1
    inline void lcd_move_e0() { _lcd_move_e(0); }
    inline void lcd_move_e1() { _lcd_move_e(1); }
    #if E_MANUAL > 2
      inline void lcd_move_e2() { _lcd_move_e(2); }
      #if E_MANUAL > 3
        inline void lcd_move_e3() { _lcd_move_e(3); }
        #if E_MANUAL > 4
          inline void lcd_move_e4() { _lcd_move_e(4); }
          #if E_MANUAL > 5
            inline void lcd_move_e5() { _lcd_move_e(5); }
          #endif // E_MANUAL > 5
        #endif // E_MANUAL > 4
      #endif // E_MANUAL > 3
    #endif // E_MANUAL > 2
  #endif // E_MANUAL > 1

#endif // E_MANUAL

//
// "Motion" > "Move Xmm" > "Move XYZ" submenu
//

#ifndef SHORT_MANUAL_Z_MOVE
  #define SHORT_MANUAL_Z_MOVE 0.025
#endif

screenFunc_t _manual_move_func_ptr;

void _goto_manual_move(const float scale) {
  ui.defer_status_screen();
  move_menu_scale = scale;
  ui.goto_screen(_manual_move_func_ptr);
}
void menu_move_10mm()   { _goto_manual_move(10); }
void menu_move_1mm()    { _goto_manual_move( 1); }
void menu_move_01mm()   { _goto_manual_move( 0.1f); }

void _menu_move_distance(const AxisEnum axis, const screenFunc_t func, const int8_t eindex=-1) {
  _manual_move_func_ptr = func;
  START_MENU();
  if (LCD_HEIGHT >= 4) {
    switch (axis) {
      case X_AXIS: STATIC_ITEM(MSG_MOVE_X, SS_CENTER|SS_INVERT); break;
      case Y_AXIS: STATIC_ITEM(MSG_MOVE_Y, SS_CENTER|SS_INVERT); break;
      case Z_AXIS: STATIC_ITEM(MSG_MOVE_Z, SS_CENTER|SS_INVERT); break;
      default:
        #if ENABLED(MANUAL_E_MOVES_RELATIVE)
          manual_move_e_origin = current_position.e;
        #endif
        STATIC_ITEM(MSG_MOVE_E, SS_CENTER|SS_INVERT);
        break;
    }
  }
  #if ENABLED(PREVENT_COLD_EXTRUSION)
    if (axis == E_AXIS && thermalManager.tooColdToExtrude(eindex >= 0 ? eindex : active_extruder))
      BACK_ITEM(MSG_HOTEND_TOO_COLD);
    else
  #endif
  {
    BACK_ITEM(MSG_MOVE_AXIS);
    SUBMENU(MSG_MOVE_10MM, menu_move_10mm);
    SUBMENU(MSG_MOVE_1MM, menu_move_1mm);
    SUBMENU(MSG_MOVE_01MM, menu_move_01mm);
    if (axis == Z_AXIS && (SHORT_MANUAL_Z_MOVE) > 0.0f && (SHORT_MANUAL_Z_MOVE) < 0.1f) {
      SUBMENU("", []{ _goto_manual_move(float(SHORT_MANUAL_Z_MOVE)); });
      MENU_ITEM_ADDON_START(1);
        char tmp[20], numstr[10];
        // Determine digits needed right of decimal
        const uint8_t digs = !UNEAR_ZERO((SHORT_MANUAL_Z_MOVE) * 1000 - int((SHORT_MANUAL_Z_MOVE) * 1000)) ? 4 :
                             !UNEAR_ZERO((SHORT_MANUAL_Z_MOVE) *  100 - int((SHORT_MANUAL_Z_MOVE) *  100)) ? 3 : 2;
        sprintf_P(tmp, PSTR(MSG_MOVE_Z_DIST), dtostrf(SHORT_MANUAL_Z_MOVE, 1, digs, numstr));
        LCDPRINT(tmp);
      MENU_ITEM_ADDON_END();
    }
  }
  END_MENU();
}
void lcd_move_get_x_amount() { _menu_move_distance(X_AXIS, lcd_move_x); }
void lcd_move_get_y_amount() { _menu_move_distance(Y_AXIS, lcd_move_y); }
void lcd_move_get_z_amount() { _menu_move_distance(Z_AXIS, lcd_move_z); }

#if E_MANUAL
  void lcd_move_get_e_amount() { _menu_move_distance(E_AXIS, lcd_move_e, -1); }
  #if E_MANUAL > 1
    void lcd_move_get_e0_amount()     { _menu_move_distance(E_AXIS, lcd_move_e0, 0); }
    void lcd_move_get_e1_amount()     { _menu_move_distance(E_AXIS, lcd_move_e1, 1); }
    #if E_MANUAL > 2
      void lcd_move_get_e2_amount()   { _menu_move_distance(E_AXIS, lcd_move_e2, 2); }
      #if E_MANUAL > 3
        void lcd_move_get_e3_amount() { _menu_move_distance(E_AXIS, lcd_move_e3, 3); }
        #if E_MANUAL > 4
          void lcd_move_get_e4_amount() { _menu_move_distance(E_AXIS, lcd_move_e4, 4); }
          #if E_MANUAL > 5
            void lcd_move_get_e5_amount() { _menu_move_distance(E_AXIS, lcd_move_e5, 5); }
          #endif // E_MANUAL > 5
        #endif // E_MANUAL > 4
      #endif // E_MANUAL > 3
    #endif // E_MANUAL > 2
  #endif // E_MANUAL > 1
#endif // E_MANUAL

#if ENABLED(DELTA)
  void lcd_lower_z_to_clip_height() {
    line_to_z(delta_clip_start_height);
    ui.synchronize();
  }
#endif

void menu_move() {
  START_MENU();
  BACK_ITEM(MSG_MOTION);

  #if HAS_SOFTWARE_ENDSTOPS && ENABLED(SOFT_ENDSTOPS_MENU_ITEM)
    EDIT_ITEM(bool, MSG_LCD_SOFT_ENDSTOPS, &soft_endstops_enabled);
  #endif

  if (
    #if IS_KINEMATIC || ENABLED(NO_MOTION_BEFORE_HOMING)
      all_axes_homed()
    #else
      true
    #endif
  ) {
    if (
      #if ENABLED(DELTA)
        current_position.z <= delta_clip_start_height
      #else
        true
      #endif
    ) {
      SUBMENU(MSG_MOVE_X, lcd_move_get_x_amount);
      SUBMENU(MSG_MOVE_Y, lcd_move_get_y_amount);
    }
    #if ENABLED(DELTA)
      else
        ACTION_ITEM(MSG_FREE_XY, lcd_lower_z_to_clip_height);
    #endif

    SUBMENU(MSG_MOVE_Z, lcd_move_get_z_amount);
  }
  else
    GCODES_ITEM(MSG_AUTO_HOME, PSTR("G28"));

  #if ANY(SWITCHING_EXTRUDER, SWITCHING_NOZZLE, MAGNETIC_SWITCHING_TOOLHEAD)

    #if EXTRUDERS == 6
      switch (active_extruder) {
        case 0: GCODES_ITEM(MSG_SELECT " " MSG_E2, PSTR("T1")); break;
        case 1: GCODES_ITEM(MSG_SELECT " " MSG_E1, PSTR("T0")); break;
        case 2: GCODES_ITEM(MSG_SELECT " " MSG_E4, PSTR("T3")); break;
        case 3: GCODES_ITEM(MSG_SELECT " " MSG_E3, PSTR("T2")); break;
        case 4: GCODES_ITEM(MSG_SELECT " " MSG_E6, PSTR("T5")); break;
        case 5: GCODES_ITEM(MSG_SELECT " " MSG_E5, PSTR("T4")); break;
      }
    #elif EXTRUDERS == 5 || EXTRUDERS == 4
      switch (active_extruder) {
        case 0: GCODES_ITEM(MSG_SELECT " " MSG_E2, PSTR("T1")); break;
        case 1: GCODES_ITEM(MSG_SELECT " " MSG_E1, PSTR("T0")); break;
        case 2: GCODES_ITEM(MSG_SELECT " " MSG_E4, PSTR("T3")); break;
        case 3: GCODES_ITEM(MSG_SELECT " " MSG_E3, PSTR("T2")); break;
      }
    #elif EXTRUDERS == 3
      if (active_extruder < 2) {
        if (active_extruder)
          GCODES_ITEM(MSG_SELECT " " MSG_E1, PSTR("T0"));
        else
          GCODES_ITEM(MSG_SELECT " " MSG_E2, PSTR("T1"));
      }
    #else
      if (active_extruder)
        GCODES_ITEM(MSG_SELECT " " MSG_E1, PSTR("T0"));
      else
        GCODES_ITEM(MSG_SELECT " " MSG_E2, PSTR("T1"));
    #endif

  #elif ENABLED(DUAL_X_CARRIAGE)

    if (active_extruder)
      GCODES_ITEM(MSG_SELECT " " MSG_E1, PSTR("T0"));
    else
      GCODES_ITEM(MSG_SELECT " " MSG_E2, PSTR("T1"));

  #endif

  #if E_MANUAL

    #if EITHER(SWITCHING_EXTRUDER, SWITCHING_NOZZLE)

      // Only the current...
      SUBMENU(MSG_MOVE_E, lcd_move_get_e_amount);
      // ...and the non-switching
      #if E_MANUAL == 5
        SUBMENU(MSG_MOVE_E MSG_MOVE_E5, lcd_move_get_e4_amount);
      #elif E_MANUAL == 3
        SUBMENU(MSG_MOVE_E MSG_MOVE_E3, lcd_move_get_e2_amount);
      #endif

    #else

      // Independent extruders with one E-stepper per hotend
      SUBMENU(MSG_MOVE_E, lcd_move_get_e_amount);
      #if E_MANUAL > 1
        SUBMENU(MSG_MOVE_E MSG_MOVE_E1, lcd_move_get_e0_amount);
        SUBMENU(MSG_MOVE_E MSG_MOVE_E2, lcd_move_get_e1_amount);
        #if E_MANUAL > 2
          SUBMENU(MSG_MOVE_E MSG_MOVE_E3, lcd_move_get_e2_amount);
          #if E_MANUAL > 3
            SUBMENU(MSG_MOVE_E MSG_MOVE_E4, lcd_move_get_e3_amount);
            #if E_MANUAL > 4
              SUBMENU(MSG_MOVE_E MSG_MOVE_E5, lcd_move_get_e4_amount);
              #if E_MANUAL > 5
                SUBMENU(MSG_MOVE_E MSG_MOVE_E6, lcd_move_get_e5_amount);
              #endif // E_MANUAL > 5
            #endif // E_MANUAL > 4
          #endif // E_MANUAL > 3
        #endif // E_MANUAL > 2
      #endif // E_MANUAL > 1

    #endif

  #endif // E_MANUAL

  END_MENU();
}

#if ENABLED(AUTO_BED_LEVELING_UBL)
  void _lcd_ubl_level_bed();
#elif ENABLED(LCD_BED_LEVELING)
  void menu_bed_leveling();
#endif

void menu_motion() {
  START_MENU();

  //
  // ^ Main
  //
  BACK_ITEM(MSG_MAIN);

  //
  // Move Axis
  //
  #if ENABLED(DELTA)
    if (all_axes_homed())
  #endif
      SUBMENU(MSG_MOVE_AXIS, menu_move);

  //
  // Auto Home
  //
  GCODES_ITEM(MSG_AUTO_HOME, PSTR("G28"));
  #if ENABLED(INDIVIDUAL_AXIS_HOMING_MENU)
    GCODES_ITEM(MSG_AUTO_HOME_X, PSTR("G28 X"));
    GCODES_ITEM(MSG_AUTO_HOME_Y, PSTR("G28 Y"));
    GCODES_ITEM(MSG_AUTO_HOME_Z, PSTR("G28 Z"));
  #endif

  //
  // Auto Z-Align
  //
  #if ENABLED(Z_STEPPER_AUTO_ALIGN)
    GCODES_ITEM(MSG_AUTO_Z_ALIGN, PSTR("G34"));
  #endif

  //
  // Level Bed
  //
  #if ENABLED(AUTO_BED_LEVELING_UBL)

    SUBMENU(MSG_UBL_LEVEL_BED, _lcd_ubl_level_bed);

  #elif ENABLED(LCD_BED_LEVELING)

    if (!g29_in_progress) SUBMENU(MSG_BED_LEVELING, menu_bed_leveling);

  #elif HAS_LEVELING && DISABLED(SLIM_LCD_MENUS)

    #if DISABLED(PROBE_MANUALLY)
      GCODES_ITEM(MSG_LEVEL_BED, PSTR("G28\nG29"));
    #endif
    if (all_axes_homed() && leveling_is_valid()) {
      bool new_level_state = planner.leveling_active;
      EDIT_ITEM(bool, MSG_BED_LEVELING, &new_level_state, _lcd_toggle_bed_leveling);
    }
    #if ENABLED(ENABLE_LEVELING_FADE_HEIGHT)
      EDIT_ITEM_FAST(float3, MSG_Z_FADE_HEIGHT, &lcd_z_fade_height, 0, 100, _lcd_set_z_fade_height);
    #endif

  #endif

  #if ENABLED(LEVEL_BED_CORNERS) && DISABLED(LCD_BED_LEVELING)
    ACTION_ITEM(MSG_LEVEL_CORNERS, _lcd_level_bed_corners);
  #endif

  #if ENABLED(Z_MIN_PROBE_REPEATABILITY_TEST)
    GCODES_ITEM(MSG_M48_TEST, PSTR("G28\nM48 P10"));
  #endif

  //
  // Disable Steppers
  //
  GCODES_ITEM(MSG_DISABLE_STEPPERS, PSTR("M84"));

  END_MENU();
}

#endif // HAS_LCD_MENU
