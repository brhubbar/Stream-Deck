// Lid modules for stream-deck.
//
// Derivative of the MisteRdeck (https://www.thingiverse.com/thing:4627779/) by
// MisteR_ofcl (https://www.thingiverse.com/mister_ofcl/designs), made with
// permission.
//
// < additional description here >
//
// Revisions
// ---------
//     v0.0.1:
//
// Copyright (C) 2021  brhubbar
//
// https://github.com/brhubbar/Stream-Deck
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
// brhubbar / v0.0.1

include <submodules/Screw-Boss-OpenSCAD/src/screwBoss.scad>
include <helpers.scad>


// The entire file is contained in this module, so no indentation for this.
// Contains multiple nested modules for readability.
module lid(w=170, d=80, h=8, layerHeight=0.2, fillet=4.7, chamfer=2,
            screw_D=5.5, screw_H=3, screw_d=3, screw_i=6) {
// Generate the lid.
//
// Customizable dimensions and decorations (fillet, chamfer) may be modified
// via inputs. These should be kept consistent between all components of the
// stream-deck.
//
// The lid is a filleted rectangular prism, printed face down. The default
// values match the original MisteRdeck.
//
// Parameters
// ----------
//    w : width; when assembled, this would run horizontally in front of
//        you. Defined here along the x-axis.
//    d : depth; when assembled, this would run "vertically" away from you.
//        Defined here along the y-axis.
//    h : height; this is the thickness of the face, defined on the z-axis.
//    layerHeight : Used to make floating surfaces printable.
//    fillet : radius of the rounding on the outside edges.
//    chamfer : rise/run dimension of a 45 degree chamfer on the front face.
//    screw_D : diameter of the head of the screw (as measured). A clearance
//        will be added by the screwBoss module.
//    screw_H : height of the screw head (as measured). A clearance will be
//        automatically added by the screwBoss module.
//    screw_d : diameter of the screw shaft. For an M3, this is 3.
//    screw_i : screw inset from the edge of the part.

// A small rabbet is cut on the lid to make the seam between the lid and the
// body more visually appealing. The rabbet is cut along the height half as
// deep as along the depth/width.
rabbet_h = 0.5;

// Generate the lid.
difference() {
  mass();
  screws();
}


// Nested modules.
module mass() {
  // Main body of the lid.
  //
  // The lid is rounded on the edges (4.7mm radius) with a 2x2mm chamfer on the
  // front face (which lies on the build plate). The most readable (and
  // hopefully efficient) way I've found to do this is by hull()ing 8
  // cylinders. MisteR_ofcl also included a little rabbet around the bottom to
  // make the seam between the lid and body more pretty, so that must be
  // accounted for and added in a second hull.

  // Define the four corners (at the center of the radii), working clockwise.
  cornersX = cornersX(fillet, w);
  cornersY = cornersY(fillet, d);

  // Generate the main body of the lid, chamfered and filleted.
  hull() {
    for (i = [0:3]) {
      // Broader part sits above since the chamfer is on the bottom edge.
      translate([cornersX[i], cornersY[i], chamfer])
        cylinder(r=fillet, h=h-chamfer-rabbet_h);
      translate([cornersX[i], cornersY[i], 0])
        cylinder(r=fillet-chamfer, h=h-rabbet_h);
    }
  }

  // Generate the rabbet, only filleted.
  hull() {
    for (i = [0:3]) {
      // Just the rabbet. The rabbet is cut twice as deep along the depth/
      // width plane when compared to the height.
      translate([cornersX[i], cornersY[i], h-rabbet_h])
        cylinder(r=fillet-rabbet_h*2, h=rabbet_h);
    }
  }
}


module screws() {
  // Place 4 screw holes, one at each corner. screwBoss.scad uses a boss
  // dimension to locate the holes in space. Setting this globally allows for
  // repeatable screw placement on all generated bodies.

  screw_boss_w = screw_i*2;  // Square cross-sectional dimension
  let(cornersX = [0, 0, w, w],
      cornersY = [0, d, d, 0]){
    for (i=[0:3]) {
      // Recess for cap screw. Use nominal dimensions because screwBoss tacks on a
      // clearance.
      // Place at the four corners. The screw hole is automatically place correctly
      // for the first corner. To move to the other three corners, rotate about the
      // z-axis to allow translate() to place the origin at each outside corner.
      translate([cornersX[i], cornersY[i], 0]) rotate([0, 0, -90*i]) {
        clearanceNegative(D=screw_d, L=h, W=screw_boss_w);
        screwHeadNegative(D=screw_D, H=screw_H, d=screw_d, W=screw_boss_w, layerHeight=layerHeight);
      }
    }
  }
}

} // end of module lid()
