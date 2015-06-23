module spring_cap(base_length=0.1, cap_length=0.3, od=3/4, major_id=0.32, minor_id=0.3, $fn=20) {
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

module SpringCartridge() {
  spring_cap();
  
  // Spring
  %linear_extrude(height=3, twist=360 * 12)
  translate([.75/2 - 1/16,0,0])
  circle(r=1/32);
  
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
