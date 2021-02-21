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

include <submodules/Screw-Boss-OpenSCAD/src/screwBoss.scad>
include <lid.scad>
include <base.scad>

// Printing layer height (MUST set this do get good bridging).
layerHeight = 0.2;

// Screw dimensions should be consistent amongst all three bodies.
// M3 Screw dimensions.
M3_headD = 5.5;
M3_headH = 3;
M3_d = 3;

screw_inset = 6;

// Decoration parameters - should be kept consistent.
fillet_r = 4.7;
chamfer = 2;

// Body major dimensions must be consistent.
w = 170;
d = 80;


lid_h = 8;

translate([0, 0, 50]) rotate([200, 0, 0])
lid(w=w, d=d, h=lid_h, layerHeight=layerHeight, fillet=fillet_r,
  chamfer=chamfer, screw_D=M3_headD, screw_H=M3_headH, screw_d=M3_d,
  screw_i=screw_inset);


shell = 2.4;
base_h = 4.5;

base(w=w, d=d, h=base_h, layerHeight=layerHeight, fillet=fillet_r, shell=shell,
            screw_D=M3_headD, screw_H=M3_headH, screw_d=M3_d, screw_i=screw_inset);
