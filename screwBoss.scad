// Implements a variety of methods to fixture with screws
//
// Generates the following features:
//  - Clearance hole, where the screw can slide.
//  - Interference hole, where the screw threads into the body.
//  - Recess for the screw head.
//  - Boss for the screw, usually filling a void in a part.
//    - Tolerance hole with a (removable) captive nut.
//    - Interference hole for the screw to thread into.
//
// Inputs
// ------
//  headHeight -- height of the screw head (mm)
//  headDiam -- outer diameter of the head (mm)
//  screwLength -- length of the screw, excluding the head (mm)
//  screwDiam -- outer diameter of the threads (mm)
//  filletRadius -- radius of edge blending (mm)
//  nutHeight -- (optional) thickness of the nut (mm)
//  nutFlats -- (optional) distance from flat-to-flat on the nut (mm)
//  isFloating -- (default=false) adds a 45 degree chamfer to the boss for
//    printability (true | false)
//
// Modules
// -------
//  boss
//    clearanceBoss
//    interferenceBoss
//  negative
//    clearanceNegative
//    interferenceNegative
//  nutTrapNegative
// Need stuff for the screw head...
//
// Changelog
// ---------
//
// brhubbar / v0.0.1


$fn = 10;


// M3
headHeight = 3;
headDiam = 5.4;
screwLength = 20;
screwDiam = 3;
nutHeight = 2.4;
nutFlats = 5.5;
filletRadius = 2;
isFloating = false;

// Tolerance to add to clearance holes (mm).
tol = 1;


difference() {
  boss(10, 20);
  negativeClearance(10, 20);
}


module clearanceBoss() {
  // Generate a boss with a clearance hole and nut trap.
}


module interferenceBoss() {
  // Generate a boss with an interference hole.
}


module clearanceNegative(bossW, bossL) {
  // Generates the 'negative' of a clearance hole cutout.
  //
  // Extends a bit beyond the height of the boss for graphical benefits.
  //
  // Inputs
  // ------
  //  bossW -- boss cross sectional width to locate the negative in
  //    space (mm)
  //  bossL -- boss height for cutout height (mm)

  // Move the cylinder to be centered in the boss and extend 1mm beyond
  // the top and bottom faces (so the hole is fully cut out in graphics).
  translate([bossW/2, bossW/2, bossL/2])
    cylinder(d=screwDiam+tol, h=bossL+2, center=true);
}


module interferenceNegative() {
  // Generate the body to use for cutting out an interference hole.
}


module boss(W, L) {
  // Generate a filleted prism with square WxW cross section and L height.
  //
  // This does not have the negative (hole) cut out.
  //
  // Inputs
  // ------
  //  W -- cross-sectional width of the prism (mm)
  //  L -- height of the prism in the z-axis (mm)
  //
  // Parameters
  // ----------
  //  filletRadius - radius for edge blending on the vertical edges

  if (filletRadius > 0) {
    // Locally shorten the name for filletRadius. `R` only exists within
    // this if() statement.
    R = filletRadius;

    // Define short names for other dimensions. These correct for the
    // effects of the minkowski sum. See `Minkowski Sandbox.scad` for
    // more info.
    cylH = 1;
    W = W - 2*R;
    L = L - cylH;

    // Create a prism with rounded sides. Use a cylinder to round only the
    // vertical edges.
    minkowski() {
      // Correct the size of the cube for what the minkowski sum will add.
      cube([W, W, L]);
      // Shift the center of the cylinder to place three faces of the
      // resulting body on the three planes of the origin. Removing the
      // `translate` command would shift the boss so its origin sat at the
      // center of one of the edge radii, making placement more difficult.
      translate([R, R, 0]) cylinder(r=R, h=cylH);
    }
  } else {
    // If there is no fillet radius, the minkowski sum won't occur (the
    // cylinder is an empty body), which would affect the height of the
    // boss.
    cube([W, W, L]);
  }
}
