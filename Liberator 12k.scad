include <Trigger Assembly.scad>;
include <Receiver.scad>;



grip_base_thickness = 0.25;
grip_height = sear_length - sear_top_z_compressed + sear_spring_length_compressed + grip_base_thickness;
grip_diameter = 3_4_tee_rim_od;
//  grip_diameter = (trigger_pin_x_extended + trigger_pin_diameter) * 2;

//receiver();
//firing_pin();

module grip_body() {
      union() {

        // Head (fits inside the tee)
        translate([0,0,0])
        cylinder(r=3_4_tee_id/2, h=1);
//        cube([3_4_tee_id,3_4_tee_id,1], center=true);

        // Lower body
        rotate([0,180,0])
        cylinder(r=grip_diameter/2, h=grip_height);

//        translate([0,0,grip_height/2])
//        cube([grip_diameter, 3_4_tee_id, grip_height], center=true);
      }
}

module grip() {
    difference() {
      grip_body();

      translate([trigger_assembly_x,0,0])
      trigger_assembly_track(10);

      // Sear Spring
      color("Green")
      translate([trigger_assembly_x,0,-(grip_height - grip_base_thickness)])
      cylinder(r=sear_spring_diameter/2, h=sear_spring_length_extended);
    }
}

// Scale and align for printing
rotate([-90,0,0])
scale([25.4,25.4,25.4]) {
  color("Brown", .5)
  difference() {
    grip();
  
    // Cutaway
    translate([-grip_diameter,-(grip_diameter+1),-grip_height -1])
    cube([grip_diameter*2,grip_diameter+1,grip_height + 2]);
  }
}


// Scale and align for printing
rotate([90,0,0])
scale([25.4,25.4,25.4]) {
  color("Brown", .5)

  translate([3,0,2])
  difference() {
    grip();
  
    // Cutaway
    translate([-grip_diameter,0,-grip_height -1])
    cube([grip_diameter*2,grip_diameter+1,grip_height + 2]);
  }
}



//trigger_assembly($t);
