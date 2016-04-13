use <Vitamins/Rod.scad>;
use <Reference.scad>;

module spring_cap(base_length=0.25, cap_length=0.3, od=0.68,
                  major_id=RodDiameter(FrameRod(),RodClearanceLoose())+0.05,
                  minor_id=RodDiameter(FrameRod(),RodClearanceLoose()), $fn=20) {
  render()
  difference() {
    union() {
      cylinder(r=od/2, h=base_length);

      translate([0,0,base_length])
      cylinder(r1=od/2, r2=major_id/2, h=cap_length);
    }

    translate([0,0,-0.1])
    cylinder(r=minor_id/2, h=base_length + cap_length + 0.2);
  }
}

module SpringCartridge(debug=false) {
  spring_cap();

  // Spring
  if (debug)
  cylinder(r=3/8, h=3);

  translate([0,0,3])
  mirror([0,0,1])
  spring_cap();
}

!SpringCartridge();

!scale([25.4, 25.4, 25.4]) {
  spring_cap();

  translate([1,0,0])
  spring_cap();
}
