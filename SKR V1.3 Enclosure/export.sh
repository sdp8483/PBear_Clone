#!/bin/bash
# Export files for printing
echo "generating STL files..."

echo "... enclosure_front.scad"
openscad -o stl/enclosure_front.stl parts/enclosure_front.scad
echo "... enclosure_back.scad"
openscad -o stl/enclosure_back.stl parts/enclosure_back.scad
echo "... extruder_clamp.scad"
openscad -o stl/extruder_clamp.stl parts/extruder_clamp.scad
echo "... y_clamp.scad"
openscad -o stl/y_clamp.stl parts/y_clamp.scad

echo "DONE!"
