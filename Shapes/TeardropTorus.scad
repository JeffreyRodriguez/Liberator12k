use <Teardrop.scad>;

module TeardropTorus(majorRadius=3/8, minorRadius=1/16, $fn=30) {

  render()
  rotate_extrude()
  translate([majorRadius+minorRadius,0]) {
    Teardrop(r=minorRadius, rotation=90);
  }
}


TeardropTorus();
