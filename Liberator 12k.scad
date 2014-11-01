include <Trigger Assembly.scad>;
include <Receiver.scad>;



grip_overlap = .5;
grip_base_thickness = 0.25;
grip_height = sear_length - sear_top_z_compressed + sear_spring_length_compressed + grip_base_thickness + grip_overlap;
grip_width = max(max(trigger_pin_length, sear_pin_length) + 1/8, 3_4_tee_rim_od) + 1/16;
grip_diameter = grip_width + .05;
//  grip_diameter = (trigger_pin_x_extended + trigger_pin_diameter) * 2;

//receiver();
//firing_pin();

module grip_body() {
      union() {

        // Head (fits inside the tee)
        translate([0,0,0])
%        cylinder(r=3_4_tee_id/2, h=1);
//        cube([3_4_tee_id,3_4_tee_id,1], center=true);

difference() {
  translate([0,0,grip_overlap])
  union() {
        // Lower body
        rotate([0,180,0])
//        cylinder(r=grip_diameter/2, h=grip_height);

//        rotate([0,30,0])
        translate([0,0,grip_height/2])
        cube([grip_diameter, grip_width, grip_height], center=true);

        rotate([0,30,0])
        translate([0,0,-grip_height/2])
        cube([grip_diameter, grip_width, grip_height], center=true);
  }


        translate([
          trigger_assembly_x + (sear_diameter/2) + 1/4,
          (-grip_width/2) - 1,
          trigger_top_z - trigger_height - 1/4 - 10])
        cube([1,grip_width + 2,10]);
}

        // AR15 grip
        translate([-1,-.1,0])
        rotate([180,0,-90])
        scale([1/25.4, 1/25.4, 1/25.4])
        *import("AR15_grip.stl", convexivity=5);
      }
}

module grip() {
    difference() {
      grip_body();

      
      // 3/4" Tee
      #tee(width=3_4_tee_width,
        height=3_4_tee_height,
        od=3_4_tee_diameter,
        id=0,
        rim_od=3_4_tee_rim_od,
        rim_width=3_4_tee_rim_width);


      translate([trigger_assembly_x,0,0])
      trigger_assembly_track(10);
    }
}

// Scale and align for printing
scale([25.4,25.4,25.4]) {
  difference() {
    translate([0,grip_height/2,0])
    rotate([-90,0,0])
    rotate([0,0,180]) // Uncomment to get the right-side
    grip();

  
    // Cutaway
    rotate([90,0,0])
    translate([0,(grip_diameter/2)+.5,(-grip_height/2) + 1])
    cube([100,grip_diameter+1,100], center=true);
  }
}



//trigger_assembly($t);
