module DebugHalf(dimension=100) {
  difference() {
    children();

    translate([-dimension/2,0,-dimension/2])
    cube([dimension,dimension,dimension]);
  }
}
