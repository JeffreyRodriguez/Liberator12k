module Teardrop(r=1, rotation=0, $fn=100) {
  side = r*sqrt(2)/2;

  union() {
    circle(r, $fn=$fn);

    rotate(rotation)
    polygon(points=[
             [side,-side],
             [(r*cos(side))*sqrt(2),0],
             [side,side]
    ]);
  }
}

Teardrop();
