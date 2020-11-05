// This is meant to illustrate use of `screwBoss.scad`. The screwBoss
// library is most easily called using variables laying out the dimensions
// of the screw of interest.
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


// Include modules from the library.
use <screwBoss.scad>;


// Set the resolution pretty low for design. Increase for final render.
$fn = 10;

// Set dimensions for the screw. These are for an M3x20mm cap screw.
headHeight = 3;
headDiam = 5.4;
screwLength = 10;
screwDiam = 3;
nutHeight = 2.4;
nutFlats = 5.5;
filletRadius = 2;
isFloating = false;

bossW = 10;


// EXAMPLE 1: PLace a boss
// Place a boss. Use named parameters for readability.
boss(W=bossW, L=screwLength, R=filletRadius);


// EXAMPLE 2: PLace a boss with an interference hole cut out.
// Subtract a clearance hole from the boss. The result can be relocated.
translate([2*bossW, 0, 0]) difference() {
  boss(W=bossW, L=screwLength, R=filletRadius);
  interferenceNegative(D=screwDiam, L=screwLength, W=bossW);
}


// EXAMPLE 3: Place a boss with a clearance hole and a screw head recess.
// Note that an interference hole and screw head recess would not be used
// together because the screw wouldn't hold anything in place. It would
// be like placing a nut on a bolt with nothing between the bolt head and
// the nut.
translate([4*bossW, 0, 0]) difference() {
  boss(W=bossW, L=screwLength, R=filletRadius);
  clearanceNegative(D=screwDiam, L=screwLength, W=bossW);
  screwHeadNegative(D=headDiam, H=headHeight, d=screwDiam, W=bossW);
}
