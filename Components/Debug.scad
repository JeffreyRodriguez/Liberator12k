module DebugHalf(dimension=100, mirrorArray=[0,0,0]) {
  difference() {
    children();

    mirror(mirrorArray)
    translate([-dimension/2,0,-dimension/2])
    cube([dimension,dimension,dimension]);
  }
}
