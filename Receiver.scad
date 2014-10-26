include <Components.scad>;

module trunnion(length) {
  union() {
    pipe(id=1_8_pipe_id,
         od=1_8_pipe_od,
         length=trunnion_guide_tube_length);

    bushing(id=3_4_x_1_8_bushing_id,
            od=3_4_x_1_8_bushing_od,
            height=3_4_x_1_8_bushing_height,
            head_major_width=3_4_x_1_8_bushing_head_od,
            head_height=3_4_x_1_8_bushing_head_height);

    translate([0,0,-length+3_4_x_1_8_bushing_depth])
    pipe(id=1_pipe_id,
         od=1_pipe_od,
         length=length);
  }
}

module receiver() {

  // 3/4" Tee
  color("Blue")
  difference() {
    tee(width=3_4_tee_width,
        height=3_4_tee_height,
        od=3_4_tee_diameter,
        id=3_4_tee_id,
        rim_od=3_4_tee_rim_od,
        rim_width=3_4_tee_rim_width);

    // Cutaway
    translate([-3_4_tee_width,-1,-3_4_tee_height/2])
    cube([3_4_tee_width+2,1,3_4_tee_height + 2]);
  }

  // Trunnion
  color("LightGreen")
  difference() {
    rotate([0,-90,0])
    translate([3_4_tee_height - (3_4_tee_diameter/2),0,-(3_4_tee_width/2) - 3_4_x_1_8_bushing_depth])
    trunnion(length=trunnion_length);

    // Cutaway
    color("LightGreen")
    translate([trunnion_length/2-2,-.90,1_pipe_od/2 -1])
    cube([trunnion_length+2,1,1_pipe_od + 2]);
  }

  // Barrel
  color("Gray")
  translate([breech_face_x + 0.01, // Model visibility bump
             0,centerline_z])
  rotate([0,90,0])
  pipe(id=barrel_id,
       od=barrel_od+0.05, // Model visibility bump
       length=barrel_length);

   // Stock
   color("Green")
   difference() {
     translate([-(3_4_tee_width/2 - 3_4_pipe_depth),
                0,centerline_z])
     rotate([0,-90,0])
     pipe(id=3_4_pipe_id,
          od=3_4_pipe_od+0.05, // Model visibility bump
          length=stock_length);


      color("Green")
      translate([-(stock_length + 3_4_pipe_depth + 1),-barrel_od + 0.02,0])
      cube([stock_length + 2,barrel_od,barrel_od + 2]);
    }

    translate([-(stock_length + 3_4_pipe_depth),0,3_4_tee_width/2])
    rotate([0,-90,0])
    tee(width=3_4_tee_width,
        height=3_4_tee_height,
        od=3_4_tee_diameter,
        id=3_4_tee_id,
        rim_od=3_4_tee_rim_od,
        rim_width=3_4_tee_rim_width);
}
