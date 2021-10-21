module Donut2D(major=2, minor=1) {
  difference() {
    circle(r=major);
    circle(r=minor);
  }
}

module Donut(major=2, minor=1, h=1) {
  linear_extrude(height=h)
  Donut2D(major, minor);
}

Donut();
