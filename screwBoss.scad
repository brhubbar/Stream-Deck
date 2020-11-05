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
// TODO: Holes are implemented with optimized briding to allow them to be
// printed upside down. See [Vector 3D's Video](https://youtu.be/IVtqAn4oDDE)
// for a really good illustration of the technique. For this to work,
// the desired print layer height MUST be set in this file.
//
// The above features are implemented individually as `low-level` features.
// They are all located in such a manner to allow placement of any
// combination of those features. They are not implemented in combination
// because there are few use cases for a pre-cutout feature in OpenSCAD,
// as the cutout will usually have to cut through another feature in the
// main part.
//
// There are clearance parameters defined at the top of this file. Those
// may vary by 3D printer, so feel free to fudge them to meet your needs.
//
// There are a lot of repeated inputs required due to the limitations of
// OpenSCAD to remember information, so just bear with it as you have to
// provide the same parameters to each function call.
//
// Modules
// -------
//  boss(W, L, R) -- returns a WxWxL boss with radius R on vertical edges
//  clearanceNegative(D, L, W) -- returns a negative to cut a
//    clearance hole. Uses `clearance` defined at the top of the file.
//  interferenceNegative(D, L, W) -- returns a negative to cut an
//    interference hole. Uses `interference` defined at the top of the file.
//  screwHeadNegative(D, H, d, W) -- returns a negative to cut a screw
//    head recess. Optimizes briding inside so this recess can be below
//    the smaller hole (d) on a print bed.
//  nutTrapNegative(F, H, L, W) -- returns a negative for a nut trap to
//    cut out of the corner of the boss.
//
// Changelog
// ---------
//
// brhubbar / v0.0.1


// Tolerances for interference and clearance fits. Adjust as necessary
// to meet your printer's needs. Positive values add to the diameter,
// negative values subtract from the diameter. All in mm.
clearance = 1;
interference = 0;

// Layer height for optimized bridging.
layerHeight = 0.2;


module boss(W, L, R=0) {
  // Generate a filleted prism with square WxW cross section and L height.
  //
  // This does not have the negative (hole) cut out.
  //
  // Inputs
  // ------
  //  W -- cross-sectional width of the prism (mm)
  //  L -- height of the prism in the z-axis (mm)
  //  R -- (default=0) radius of edge blend on vertical edges (mm)

  if (R > 0) {
    // Correct dimensions for the effects of the minkowski sum. See
    // `Minkowski Sandbox.scad` for more info.
    // The height of the cylinder is arbitrary, as long as it's corrected
    // for. It also cannot so large that the corrected dimensions become
    // negative.
    cylH = 0.1;
    W = W - 2*R;
    L = L - cylH;

    // Create a prism with rounded sides. Use a cylinder to round only the
    // vertical edges.
    minkowski() {
      // Create the prism to act as the base for the sum.
      cube([W, W, L]);
      // Shift the center of the cylinder to place three faces of the
      // resulting body on the three planes of the origin. Removing the
      // `translate` command would shift the boss so its origin sat at the
      // center of one of the edge radii, making placement more difficult.
      translate([R, R, 0]) cylinder(r=R, h=cylH);
    }
  } else {
    // If the fillet radius is 0, the minkowski sum won't work (the
    // cylinder is an empty body), so the dimensions should not be
    // corrected.
    cube([W, W, L]);
  }
}


module clearanceNegative(D, L, W=0) {
  // Generates the 'negative' of a clearance hole cutout.
  //
  // If W is provided, the negative is properly located to cut directly
  // out of a boss() generated with the same parameters. This allows for
  // fast, sensible location of features intended to build the same boss.
  // Otherwise, will locate coaxial with the z-axis with the bottom
  // resting on the xy plane.
  //
  // Inputs
  // ------
  //  D -- nominal diameter of the screw threads (mm
  //  L -- cutout height/depth (mm)
  //  W -- (default=0) boss cross sectional width to locate the negative
  //    in space (mm)

  // Move the cylinder to be centered in the boss to cut out perfectly
  // within the limits of the boss. Correct the diameter to provide a
  // clearance fit.
  translate([W/2, W/2, L/2])
    cylinder(d=D+clearance, h=L, center=true);
}


module interferenceNegative(D, L, W=0) {
  // Generates the 'negative' of an interference hole cutout.
  //
  // If W is provided, the negative is properly located to cut directly
  // out of a boss() generated with the same parameters. This allows for
  // fast, sensible location of features intended to build the same boss.
  // Otherwise, will locate coaxial with the z-axis with the bottom
  // resting on the xy plane.
  //
  // Inputs
  // ------
  //  D -- nominal diameter of the screw threads (mm)
  //  L -- cutout height/depth (mm)
  //  W -- (default=0) boss cross sectional width to locate the negative
  //    in space (mm)

  // Move the cylinder to be centered in the boss to cut out perfectly
  // within the limits of the boss. Correct the diameter to create an
  // interference fit.
  translate([W/2, W/2, L/2])
    cylinder(d=D+interference, h=L, center=true);
}


module screwHeadNegative(D, H, d=0, W=0) {
  // Generates the negative to recess a screw head into a part.
  //
  // Sets a stepped square hole at the inside of the recess to accomodate
  // recesses that are placed on the bed plate. This works because a 3D
  // printer will bridge across the hole to print those square edges,
  // rather than trying to print a circle in the middle of open air.
  // This action assumes a clearance hole is used because an interference
  // hole with a screw head recess doesn't make practical sense. The bolt
  // should pass through whatever it's recessed in, then thread into the
  // next body.
  //
  // Note that this will overlap with an interferenceNegative or
  // clearanceNegative, so L for those must account for H.
  //
  // Applies clearance to H and D to ensure the head is fully recessed.
  //
  // Inputs
  // ------
  //  D -- nominal diameter of the screw head (mm)
  //  H -- height of the screw head (mm)
  //  d -- (default=0) diameter of the hole being counter-bored (mm). Used
  //    to generate optimized bridging.
  //  W -- (default=0) boss cross sectional width to locate the negative
  //    in space (mm)

  // Adjust dimensions to include clearance.
  D = D + clearance;
  H = H + clearance;
  d = d + clearance;
  // Generate the negative.
  union() {
    // Main recess. This is for the actual screw head.
    translate([W/2, W/2, H/2])
      cylinder(d=D, h=H, center=true);
    // Generate optimized bridging. This is set on top of the recess to
    // allow the reduced hole to print cleanly.
    translate([W/2, W/2, H])
      union() {
        // Create the first layer of bridging, extending to and matching the
        // edges of the head recess.
        intersection() {
          // Round out the edges of the bridging to avoid weird holes in the part.
          // The lower piece must extend to the edges of the circle.
          translate([0, 0, layerHeight/2])
            cube([D, d, layerHeight], center=true);
          // Create a cylinder to round them out.
          cylinder(d=D, h=layerHeight*3, center=true);
        }
        // Create the second layer of bridging, a square circumscribing the
        // smaller hole.
        translate([0, 0, 3*layerHeight/2])
          cube([d, d, layerHeight], center=true);
      }
  }
}


module nutTrapNegative(F, H, L, W) {
  // Creates a nut-trap negative to cut out of the corner of a boss.
  //
  // Places the trap halfway up the boss.
}
