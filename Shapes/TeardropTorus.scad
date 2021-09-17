use <Teardrop.scad>;

module TeardropTorus(majorRadius=3/8, minorRadius=1/16) {

  render()
  rotate_extrude()
  translate([majorRadius,0]) {
    Teardrop(r=minorRadius, rotation=90);
  }
}


TeardropTorus(majorRadius=3/8, minorRadius=1/16);
