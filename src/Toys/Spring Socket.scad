module spring_socket(length=1/2, od=3/4, major_id=.635, minor_id=0.4, $fn=20) {
  difference() {
    cylinder(r=od/2, h=length);

    translate([0,0,length/2])
    cylinder(r=major_id/2, h=2);

    translate([0,0,-0.1])
    cylinder(r=minor_id/2, h=2);
  }
}

scale([25.4, 25.4, 25.4]) {
  spring_socket();
  
  translate([1,0,0])
  spring_socket();
}
