//
// Pipe dimensions
//

// 3/4" Pipe
3_4_pipe_od    = 1.06;
3_4_pipe_id    = 0.81;
3_4_pipe_depth = 0.5;

// 1/8" Pipe
1_8_pipe_od = 0.415;
1_8_pipe_id = 0.265;

// 3/4" Tee
3_4_tee_diameter  = 1.38; // Diameter of the body, behind the rim
3_4_tee_width     = 2.64; // Across the top of the T
3_4_tee_height    = 2.01; // From the middle of the bottom rim to the top of the body
3_4_tee_id        = 0.91;
3_4_tee_rim_od    = 1.55;
3_4_tee_rim_width = 0.37;
3_4_tee_center_z  = 3_4_tee_height - (3_4_tee_diameter/2); // Centerline of the T
3_4_tee_rim_z_min = 3_4_tee_center_z - (3_4_tee_rim_od/2); // Bottom of the T rims
3_4_tee_rim_z_max = 3_4_tee_center_z + (3_4_tee_rim_od/2); // Top of the T rims

// 3/4" x 1/8" Bushing
3_4_x_1_8_bushing_height      = 0.95;
3_4_x_1_8_bushing_id          = 0.45;
3_4_x_1_8_bushing_od          = 1.0;
3_4_x_1_8_bushing_head_height = 0.22;
3_4_x_1_8_bushing_head_od     = 1.215;
3_4_x_1_8_bushing_head_id     = 1.06;
3_4_x_1_8_bushing_depth       = 0.5;

// 1" Pipe
1_pipe_id            = 1.06;
1_pipe_od            = 1.32;
1_pipe_tapered_od    = 1.285;  // Threaded portion of the pipe, smallest OD
1_pipe_thread_length = 0.982;  // Length of the threads, measured from the end of the pipe to the last thread mark

module bushing(id, od, height, head_major_width, head_height) {
  difference() {
    union() {

      // Body
      translate([0,0,head_height/2])
      cylinder(r=od/2, h=height - (head_height/2));

      // Head
      cylinder(r=head_major_width/2, h=head_height, $fn=6);
    }

    // Hole
    translate([0,0,-1])
    cylinder(r=id/2, h=height + 2);
  }
};

module pipe(id, od, length) {
  difference() {

    // Create the pipe wall
    cylinder(r=od/2, h=length);

    // Hollow it out
    translate([0,0,-1])
    cylinder(r=id/2, h=length + 2);
  }
}

module 1_pipe_tapered(length=2) {
  union() {

    // Thread taper
    rotate([0,90,0])
    color("Orange")
    cylinder(r=1_pipe_tapered_od/2, r2=1_pipe_od/2, h=1_pipe_thread_length);

    // Extra pipe length
    translate([1_pipe_thread_length,0,0])
    rotate([0,90,0])
    color("Blue")
    cylinder(r=1_pipe_od/2, h=length - 1_pipe_thread_length);
  }
}

module tee(width, height, od, id, rim_od, rim_width, cutout = false) {
  difference() {
    union() {

      // T-Top
      rotate([0,-90,0])
      translate([height - (od/2),0,0])
      cylinder(r=od/2, h=width * 0.99, center=true);

      // T-Bottom
      translate([0,0,(height - (od/2)) * 0.01])
      cylinder(r=od/2, h=(height - (od/2)) * 0.98);

      // Bottom rim
      cylinder(r=rim_od/2, h=rim_width);

      // Left rim
      rotate([0,90,0])
      translate([-(height - (od/2)),0,-width/2])
      cylinder(r=rim_od/2, h=rim_width);

      // Right rim
      rotate([0,-90,0])
      translate([height - (od/2),0,-width/2])
      cylinder(r=rim_od/2, h=rim_width);
    }

    // Top Hole
    rotate([0,-90,0])
    translate([height - (od/2),0,0])
    cylinder(r=id/2, h=width * 1.05, center=true);

    // Bottom Hole
    translate([0,0,-height * 0.01])
    cylinder(r=id/2, h=height - (od/2) * 1.01);

    // Cutout
    if (cutout) {
       translate([-width/1.8,-od,-height*0.05])
      cube([width * 1.1, od * 1.1, height * 1.1]);
    }
  }
}

module 3_4_tee(width=3_4_tee_width,
               height=3_4_tee_height,
               od=3_4_tee_diameter,
               id=0,
               rim_od=3_4_tee_rim_od,
               rim_width=3_4_tee_rim_width,
               cutout=false) {
  $fn = 30;

tee(width=width,
     height=height,
     od=od,
     id=id,
     rim_od=rim_od,
     rim_width=rim_width,
     cutout=cutout);
}


*3_4_tee();
