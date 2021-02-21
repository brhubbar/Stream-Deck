
function cornersX(fillet, x_dim) =
// Define the four corners (at the center of the radii), working clockwise
   [fillet,
    fillet,
    x_dim - fillet,
    x_dim - fillet];

function cornersY(fillet, y_dim) =
// Define the four corners (at the center of the radii), working clockwise.
   [fillet,
    y_dim - fillet,
    y_dim - fillet,
    fillet];
