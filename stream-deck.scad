// Customize a 3-D printable deck/surface for MIDI/DMX/Streaming control.
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


// Lid
// The lid is a filleted rectangular prism, printed face down. It has outer
// dimensions:
//    width -- when assembled, this would run horizontally in front of you.
//             it's defined here along the x-axis.
//    depth -- when assembled, this would run "vertically" away from you.
//             it's defined here along the y-axis.
//    height -- this is the thickness of the face, defined on the z-axis.
lid_w = 170;
lid_d = 80;
lid_h = 8;
lid_fillet_r = 4.7;

// To fillet efficiently (in a single sum) some pre-algebra is required to
// modify some dimensions. This fillet is gonna be done with a half-sphere,
// leaving the bottom (top, since the face is on the plate) with hard edges.
// See https://github.com/brhubbar/Screw-Boss-OpenSCAD/blob/main/examples/Minkowski%20Sandbox.scad
// if you're not sure what I'm talking about.
// In essence, each dimension is reduced by the dimension of the shaping
// object in that same axis.
lid_dim = [lid_w - 2*lid_fillet_r,  // Full circle
           lid_d - 2*lid_fillet_r,  // Full circle
           lid_h - 1*lid_fillet_r]; // Half circle
let(r = lid_fillet_r) { // temporarliy shorten the name of lid_fillet_r
  minkowski() {
    // Generate the shrunk down lid. Offset it so that the result is cornered
    // at the origin.
    translate([r, r, r]) cube(lid_dim);

    // Add the sphere. the round side needs to face down.
    rotate([180, 0, 0]) half_sphere(lid_fillet_r);
  }
}


module half_sphere(r) {
  // Generate a half-sphere for filleting.
  difference() {  // Cut away the bottom half of the sphere.
    sphere(r=r);
    translate([-r, -r, -2*r]) cube(2*r);
  }
}
