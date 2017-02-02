module ORing(innerDiameter=3/4, section=1/8, clearance=0.005, $fn=20) {

  render()
  rotate_extrude()
  translate([(innerDiameter/2)+(section/2),0])
  hull() {
    circle(r=(section/2)+clearance);

    // Teardrop
    // FIXME: Having some trouble getting that 45deg pitch here. Greater ok
    translate([-section/2,-section/2])
    mirror([1,0])
    square([section,(section*sqrt(2))+(section/2)]);
  }
}
