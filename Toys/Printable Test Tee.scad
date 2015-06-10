include <../Components.scad>;
use <../Components/Semicircle.scad>;
use <../Vitamins/Rod.scad>;
use <../Vitamins/Pipe.scad>;
use <../Striker.scad>;
use <../Firing Pin Guide.scad>;


module test_block(spindleRod=RodOneEighthInch, spindleClearance=RodClearanceSnug, debug=false) {
height= 1/2;
width = 1;
inner_width = 3/4;

  if (debug) {
    translate([0,0,-3_4_tee_rim_width])
    rotate([0,0,90])
    trigger_insert(debug=debug);
  }

    // Tee Block
    rotate([0,0,-90])
      difference() {
        union() {
          3_4_tee();

          // Floorplate
          translate([-3_4_tee_width/2,-3_4_tee_rim_od/2,0])
          cube([3_4_tee_width,.25, 3_4_tee_height]);
        }

        // Cut the block in half(ish)
        translate([-3_4_tee_width/2 + 3_4_tee_rim_width,0,3_4_tee_rim_width])
        cube([3_4_tee_width - (3_4_tee_rim_width*2),2,3_4_tee_height]);

        // Cut out the inner track
        translate([0,0,-0.1])
        cylinder(r=3_4_tee_id/2 +0.01, h=3_4_tee_center_z+0.1);

        // Cut out the Striker
        #translate([3_4_tee_id/2,0,3_4_tee_center_z]) // Back of tee to back of breech measured at 2.2"
        rotate([0,-90,0])
        union() {
          #cylinder(r=3_4_tee_id/2 +0.01, h=3_4_tee_width, center=false);
          translate([0,0,-1])
          Rod(rod=spindleRod, clearance=spindleClearance, length=3_4_tee_rim_od + 0.1, center=false);
        }

        // Rubberband Pin
        for (i = [0:3]) {
          translate([-i*.25,0,3_4_tee_center_z])
          rotate([90,0,0])
          Rod(rod=spindleRod, clearance=RodClearanceSnug, length=3_4_tee_rim_od+0.2, center=true);
        }
      }
}

  
scale([25.4, 25.4, 25.4])
translate([0,0,3_4_tee_rim_od/2])
rotate([0,-90,0])
test_block(debug=false);