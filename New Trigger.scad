//$t=0;
//$t = 1;
include <Components.scad>;
use <Components/Semicircle.scad>;
use <Vitamins/Rod.scad>;
use <Vitamins/Pipe.scad>;
use <Striker.scad>;

$fn=50;

thickness = 1/4;
id = 1_8_rod_d + 1_8_rod_clearance*2;
od = 3_4_tee_id - 1/16;
height = 3/8;
trigger_offset = 18/32; // 19/32;

sear_height = 1/4;
sear_major_od = 3/4;
sear_minor_od = 23/64; //33/64;

trigger_height = 3/8;
trigger_body_od = 0.8;
trigger_leg_od = 18/16;
trigger_arc_angle = 20;
sear_arc_angle = 60;
interface_arc_angle = 18;

module new_sear(spindle=RodOneEighthInch, spindle_clearance=RodClearanceLoose, od=sear_major_od, height=sear_height, angle=140) {

  color("Red")
  difference() {
    union() {
      linear_extrude(height=height)
      mirror([1,0,0])
      semicircle(od=od, angle=200);

      linear_extrude(height=height)
      rotate([0,0,170])
      mirror([1,0,0])
      semicircle(od=od + 0.16, angle=45);

      rotate([0,0,15])
      cube([6/16, sear_minor_od/2, height]);

      // Spindle Wall
      cylinder(r=sear_minor_od/2, h=height);
    }

    // Trigger Interface
    translate([3_4_tee_center_z - trigger_offset+1/16,0,-0.1])
    linear_extrude(height=height+0.2)
    rotate([0,0,-156])
    semicircle(od=trigger_leg_od, angle=interface_arc_angle+2);

    // Backstop
    translate([sear_minor_od/2+0.02,sear_minor_od/2 +0.2,-0.1])
    rotate([0,0,-sear_arc_angle])
    cube([1,1,1]);

    // Spindle Hole
    translate([0,0,-0.1])
    Rod(rod=spindle, clearance=spindle_clearance, length=height + 0.2);
  }
}

module new_trigger(spindle=RodOneEighthInch, spindle_clearance=RodClearanceSnug, id=7/8, height=trigger_height, angle=180) {

  od=3/4;

  color("Gold")
  difference() {
    union() {

      // Front Leg
      linear_extrude(height=height)
      rotate([0,0,203])
      semicircle(od=trigger_leg_od, angle=interface_arc_angle);

      intersection() {

        // Main Body
        #cylinder(r=trigger_body_od/2, h=height);

        translate([0,0,height/2])
        rotate([0,-90,0])
        *#sphere(r=3/8, center=true);
      }

      rotate([0,0,0])
      translate([0,0.05,0])
      difference() {
        intersection() {

          // Trigger body
          translate([0,-0.45,0])
          cube([2.5,3_4_tee_id,height]);

          // Trigger Back Curve
          translate([od/2 * sqrt(2) + 0.25,-od/2 * sqrt(2)+0.1,-0.1])
          cylinder(r=0.75, h=height+0.2);
        }

        // Trigger Front Curve
        translate([0.65,-0.6,-0.1])
        translate([3_4_tee_rim_width,0,0])
        cylinder(r=0.5, h=height + 0.2);
      }
    }

    // Sear Clearance
    rotate([0,0,-10])
    translate([-1/16-3_4_tee_center_z +trigger_offset,0,-0.1])
    *#cylinder(r=sear_major_od/2 + 0.015, height+0.2);

    // Spindle Hole
    translate([0,0,-0.1])
    Rod(rod=spindle, clearance=spindle_clearance, length=height + 0.2);
  }
}



module test_block(spindleRod=RodOneEighthInch, spindleClearance=RodClearanceSnug, debug=false) {
height= 1/2;
width = 1;
inner_width = 3/4;

  if (debug) {
  translate([-trigger_height/2 + 0.01,0,-1/16])
  rotate([(20*$t),0,0])
  rotate([0,90,0])
  new_trigger();

  translate([-trigger_height/2,0,3_4_tee_center_z - trigger_offset])
  rotate([0,90,0])
  rotate([0,0,$t*sear_arc_angle])
  new_sear();

  }

  // Tee Block
    rotate([0,0,-90])
      difference() {
        union() {
          3_4_tee();

          translate([-3_4_tee_width/2,-3_4_tee_rim_od/2,-3_4_tee_rim_width])
          cube([3_4_tee_width, 3_4_tee_rim_od/2 + 0.05, 3_4_tee_height + 3_4_tee_rim_width]);
        }

        // Cut the block in half(ish)
        translate([-2,0.1,-1])
        cube([4,4,4]);

        // Cut out the inner track
        translate([0,-1/8,0])
        intersection() {
          translate([-3_4_tee_id/2,0,0])
          cube([3_4_tee_id,3_4_tee_id,3_4_tee_center_z]);
          cylinder(r=3_4_tee_id/2, h=3_4_tee_center_z);
        }

        // Cut out the Striker
        translate([-0.5,0,3_4_tee_center_z])
        rotate([0,90,0])
        union() {
          #cylinder(r=13/32, h=3_4_tee_width + 0.2, center=true);
          translate([0,0,2])
          #Rod(rod=spindleRod, clearance=spindleClearance, length=3_4_tee_rim_od + 0.1, center=true);
        }

        // Trigger Path and Pin
        translate([0,0,-1/16]) {

          // Trigger Body and Pin
          rotate([90,0,0]) {
            Rod(rod=spindleRod, clearance=spindleClearance, length=3_4_tee_rim_od + 0.1, center=true);

            cylinder(r=trigger_body_od/2 + 0.03, h=trigger_height, center=true);
          }

          // Forward Trigger Clearance
          translate([trigger_body_od/2 + 0.03 - 1/4,-1/8,-3_4_tee_rim_width])
          cube([.25, .25, 3_4_tee_rim_width]);
        }

        // Sear Pin
        translate([0,0,3_4_tee_center_z -trigger_offset])
        rotate([90,0,0])
        Rod(rod=spindleRod, clearance=spindleClearance, length=3_4_tee_rim_od, center=true);
      }
}

scale([25.4, 25.4, 25.4]) {
  translate([0,0,3_4_tee_rim_od/2])
  rotate([0,-90,0])
  test_block();

  translate([0,2,0])
  new_trigger();

  translate([1,0,0])
  new_sear();
}

*translate([0,0,0])
scale([25.4, 25.4, 25.4]) {

  translate([0,0,3_4_tee_rim_od/2])
  rotate([0,-90,-90])
  test_block();

  translate([3_4_tee_center_z -trigger_offset + 1/16,0,0])
  rotate([0,0,trigger_arc_angle*$t])
  *new_trigger();

  rotate([0,0,$t*55])
  *new_sear();
}