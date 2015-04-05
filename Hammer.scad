include <Components.scad>;
include <Vitamins/Pipe.scad>;
include <Vitamins/Rod.scad>;

module striker(length=3_4_tee_width, od=0.75, id=0.14, depth=1.5, rope_width = 3/32, rope_depth=2/32, mocks=true, $fn=20) {

  line_pin_offset = depth + (length - depth)/2;

  difference() {

    union() {

      // Body
      cylinder(r=od/2, h=length);

      // Cap
      translate([0,0,length])
      *cylinder(r1=od/2, r2=id*1.5, h=od/4);
    }

    // Rear Line Hole
    translate([0,0,line_pin_offset - id])
    cylinder(r=id, h=length);

    // Line Pin Hole
    translate([0,od/2 + 0.1,line_pin_offset])
    rotate([90,0,0])
    cylinder(r=id/2, h=od + 0.2, $fn=10);

    // Firing Pin Hole
    translate([0,0,-0.1])
    cylinder(r=id/2, h=depth+0.2, $fn=10);

    // Mocks
    %if (mocks == true) {

      // Firing Pin
      translate([0,0,-1])
      cylinder(r=id/2, h=1 + depth);

      // Line Pin
      translate([0,od/2 + 0.025,line_pin_offset])
      rotate([90,0,0])
      cylinder(r=id/2, h=od + 0.05);
    
      // Line
      translate([0,0,line_pin_offset])
      cylinder(r=id/5, h=12);

      // Spring
      translate([0,0,length])
      linear_extrude(height=3, twist=360 * 12)
      translate([od/2 - 1/16,0,0])
      circle(r=1/32);
    }
  }
}

module spring_cap(length=1/1.5, od=3/4, id=3/16, $fn=20) {
  difference() {
    union() {
      cylinder(r=od/2, h=length/3);

      translate([0,0,length/3])
      cylinder(r1=od/2, r2=od/6, h=length/3*2);
    }

    translate([0,0,-0.1])
    cylinder(r=id/2, h=2);
  }
}

module stock_spacer(length=1, od=0.75, id=0.4, $fn=20) {
  difference() {
    cylinder(r=od/2, h=length);

    translate([0,0,-0.1])
    cylinder(r=id/2, h=length+0.2);
  }
}

module striker_guide(wall = 1/8, overlap=1/4, side_overlap = 3/8, pin = 1/8) {
  difference() {
    union() {
      translate([0,0,overlap])
      *%3_4_tee();

      // Center Rim
      cylinder(r=3_4_tee_rim_od/2 + wall, h=3_4_tee_rim_width+overlap);

      // Center Block
      translate([0,-3_4_tee_id/2,0])
      cube([3_4_tee_width/2 + overlap,3_4_tee_id,3_4_tee_rim_width+overlap]);

      // Side Block
      translate([3_4_tee_width/2 - 3_4_tee_rim_width,-3_4_tee_id/2,0])
      cube([3_4_tee_rim_width +side_overlap,3_4_tee_id,overlap + 3_4_tee_center_z - (3_4_tee_id/2)]);
    }
    
    // Cutaway View
    translate([-5,0,-5])
    *cube([10,10,10]);

    // Center Rim Hole
    translate([0,0,overlap])
    cylinder(r=3_4_tee_rim_od/2, h=3_4_tee_center_z);

    // Pipe Hole
    translate([0,0,-0.1])
    cylinder(r=(3_4_pipe_od+3_4_pipe_clearance)/2, h=3_4_tee_rim_width + overlap + 0.3);
      
    // Side Rim
    translate([(3_4_tee_width/2)-3_4_tee_rim_width -0.1,0,3_4_tee_center_z+overlap])
    rotate([0,90,0])
    union() {
      cylinder(r=3_4_tee_rim_od/2, h=3_4_tee_rim_width +0.1);
      cylinder(r=3_4_tee_id/2, h=3_4_tee_rim_width+side_overlap+0.2);
    }

    // Tee Body
    translate([-3_4_tee_width/2,0,3_4_tee_center_z + overlap])
    rotate([0,90,0])
    cylinder(r=3_4_tee_diameter/2, h=3_4_tee_width-3_4_tee_rim_width + 0.1);

    // Center Pin
    translate([3_4_tee_rim_od/2 + overlap,3_4_tee_id/2 +0.1,overlap])
    rotate([90,0,0])
    #1_8_rod(length=3_4_tee_id + 0.2);

    // Center Pin Track
    translate([3_4_tee_rim_od/2 + overlap - pin,0,-0.1])
    cylinder(r=pin, h=overlap + pin + 0.1);

    // Side/Center Rope Track
    translate([3_4_tee_rim_od/2 + 0.01,-pin,overlap + pin + 0.01])
    rotate([0,53,0])
    cube([pin*3.4,pin*2,2]);

    // Side Tip Rope Track
    translate([3_4_tee_width/2, -pin,3_4_tee_center_z -(3_4_tee_id/2) +overlap - pin])
    cube([side_overlap + 0.1, pin*2,1]);

    // Side Pin
    translate([3_4_tee_width/2 + side_overlap - pin,
               3_4_tee_id/2 +0.1,
               3_4_tee_center_z - (3_4_tee_rim_od - 3_4_tee_id)/2])
    rotate([90,0,0])
    #1_8_rod(length=3_4_tee_id + 0.2);
  }
}

scale([25.4, 25.4, 25.4])
*striker_guide();

scale([25.4, 25.4, 25.4])
*striker();

scale([25.4, 25.4, 25.4])
*spring_cap();
  
scale([25.4, 25.4, 25.4])
*stock_spacer(length=4);
