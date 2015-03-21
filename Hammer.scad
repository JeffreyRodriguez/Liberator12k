include <Components.scad>;
include <Vitamins/Pipe.scad>;

module hammer_end(height=1, od=0.8, id=35/128, rope_width = 1/8, rope_depth=1/16) {
  difference() {

    // Body
    cylinder(r=od/2, h=height, $fs=10);

    // Hammer Hole
    translate([0,0,-0.1])
    cylinder(r=id/2, h=height+0.2, $fs=10);

    // Rope Track
    translate([0,-rope_width/2,-0.1])
    cube([(id/2) + rope_depth, rope_width, height + 0.2]);
  }
}

module hammer_spacer(length=1, od=0.825, id=0.4, contour=false) {
  $fn = 30;
  difference() {
    cylinder(r=od/2, h=length);

    translate([0,0,-0.1])
    cylinder(r=id/2, h=length+0.2);

    if (contour) {
      translate([0,0,length + 3_4_tee_id/3])
      rotate([0,90,0])
      translate([0,0,-od/2 - 0.1])
      cylinder(r=3_4_tee_id/2, h=od + 0.2);
    }
  }
}


module hammer_stock_insert(rim_overlap=1/8, id=1/4, pin=1/8) {
  $fn=30;

  difference() {

    // Body
    union() {

      // Main Column
      cylinder(r=3_4_tee_id/2, h=3_4_tee_width);

      // Rim
      difference() {
        cylinder(r=(3_4_tee_rim_od/2) + rim_overlap, h=3_4_tee_rim_width + rim_overlap);

        translate([0,0,rim_overlap])
        cylinder(r=3_4_tee_rim_od/2, h=3_4_tee_rim_width + 0.1);
      }
    }
    
    // Center rope hole
    translate([0,0,-0.1])
    cylinder(r=id/2, h=(3_4_tee_width/2) + 0.1);

    // Front rope hole
    translate([-id/2,0,3_4_tee_width/2])
    rotate([0,90,0])
    cylinder(r=id/1.5, h=(3_4_tee_id/2) + id + 0.1);

    // Pivot pin hole
    translate([id/2,0,3_4_tee_width/2 - id/2 - pin/2])
    rotate([0,90,90])
    translate([0,0,-3_4_tee_id/2])
    cylinder(r=pin/2, h=3_4_tee_id);
  }

}




scale([25.4, 25.4, 25.4]) {
  translate([-1.5,0,0])
  *hammer_end();

  hammer_stock_insert();
  
  translate([1.5,0,0])
  hammer_spacer(length=4, contour=true);
  
  translate([3,0,0])
  hammer_spacer(length=4);
}