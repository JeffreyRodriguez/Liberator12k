$t=0;
//$t = 1;
include <Components.scad>;
use <Components/Semicircle.scad>;
use <Vitamins/Rod.scad>;
use <Vitamins/Pipe.scad>;
use <Striker.scad>;
use <Firing Pin Guide.scad>;

$fn=50;

thickness = 1/4;
id = 1_8_rod_d + 1_8_rod_clearance*2;
od = 3_4_tee_id - 1/16;
height = 3/8;
trigger_offset = 18/32; // 19/32; // Offset from center_z

sear_height = 1/4;
sear_major_od = 53/64;
sear_minor_od = 0.372;

trigger_height = 1/4;
trigger_body_od = 0.75;
trigger_leg_od = 18/16;
trigger_arc_angle = 20;
sear_arc_angle = 60;
interface_arc_angle = 20;
triggerPin = RodOneEighthInch;
searPin = RodOneEighthInch;

module new_sear(pin=RodOneEighthInch, pin_clearance=RodClearanceLoose, od=sear_major_od, height=sear_height, center=false, angle=140) {

  color("Red")
  translate([0,0,center ? -height/2 : 0])
  difference() {
    union() {
      #linear_extrude(height=height)
      mirror([1,0,0])
      semicircle(od=od, angle=200);

      #linear_extrude(height=height)
      rotate([0,0,170])
      mirror([1,0,0])
      semicircle(od=od + 0.16, angle=45);

      rotate([0,0,15])
      cube([6/16, sear_minor_od/2, height]);

      // Spindle Wall
      cylinder(r=sear_minor_od/2, h=height);

      // Reset Spring
    }

    // Trigger Interface
    #translate([3_4_tee_center_z - trigger_offset+1/16,0,-0.1])
    linear_extrude(height=height+0.2)
    rotate([0,0,-156])
    semicircle(od=trigger_leg_od, angle=interface_arc_angle+2);

    // Backstop
    translate([sear_minor_od/2+0.02,sear_minor_od/2 +0.2,-0.1])
    rotate([0,0,-sear_arc_angle])
    cube([1,1,1]);

    // Pin Hole
    translate([0,0,-0.1])
    Rod(rod=pin, clearance=pin_clearance, length=height + 0.2);
  }
}

module new_trigger(pin=RodOneEighthInch, pin_clearance=RodClearanceSnug, id=7/8, height=trigger_height, center=false, angle=180) {

  od=3/4;

  color("Gold")
  translate([0,0,center ? -height/2 : 0])
  difference() {
    union() {

      // Front Leg
      linear_extrude(height=height)
      rotate([0,0,203])
      semicircle(od=trigger_leg_od, angle=interface_arc_angle);

      intersection() {

        // Main Body
        cylinder(r=trigger_body_od/2, h=height);

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
    Rod(rod=pin, clearance=pin_clearance, length=height + 0.2);
  }
}

module trigger_insert(pin=RodOneEighthInch, column_height=0.95, base_thickness=3_4_tee_rim_width, debug=false) {
  overall_height = base_thickness + column_height;
  slot_width = 0.27;

  if (debug)
  translate([0,0,base_thickness]) {
    *%3_4_tee();

    translate([0,0,3_4_tee_center_z]) {
      rotate([0,90,0])
      striker();

      translate([0,0,-trigger_offset])
      rotate([90,90,0])
      rotate([0,0,$t*sear_arc_angle])
      new_sear(center=true);
    }

    translate([0,0, -1/16])
    rotate([90,90,0])
    rotate([0,0,trigger_arc_angle*$t])
    new_trigger(center=true);
  }

  %difference() {
    union() {
      cylinder(r=3_4_tee_id/2, h=3_4_tee_center_z+base_thickness-(3_4_tee_id/5));

      translate([-3_4_tee_rim_od/2,-3_4_tee_id/2,0])
      cube([3_4_tee_rim_od,3_4_tee_id,base_thickness]);
    }

    // Move up for base
    translate([0,0,base_thickness]) {

      // Striker Clearance
      translate([0,0,3_4_tee_center_z])
      rotate([0,90,0])
      cylinder(r=0.4, h=3_4_tee_id + 0.01, center=true);

      // Sear Pin
      translate([0,0,3_4_tee_center_z - trigger_offset])
      rotate([90,0,0])
      Rod(rod=pin, clearance=RodClearanceSnug, length=3_4_tee_rim_od, center=true);

      // Trigger Pin
      translate([0,0,-lookup(RodDiameter, pin)/2])
      rotate([90,0,0])
      Rod(rod=pin, clearance=RodClearanceSnug, length=3_4_tee_rim_od, center=true);
    }

    // 2 Side Pins
    translate([-lookup(RodDiameter, pin) -lookup(RodClearanceLoose, pin),0,-0.1]) {
      translate([0,(3_4_tee_id - slot_width)/2.4,0])
      Rod(rod=pin, clearance=RodClearanceSnug, length=3_4_tee_rim_od + 0.2);

      translate([0,-(3_4_tee_id - slot_width)/2.4,0])
      Rod(rod=pin, clearance=RodClearanceSnug, length=3_4_tee_rim_od + 0.2);
    }

    // Slot
    translate([-3_4_tee_id/2 - 0.005,-slot_width/2,-0.1])
    cube([3_4_tee_id + 0.01, slot_width, overall_height + 0.2]);
  }
}

!scale([25.4, 25.4, 25.4])
trigger_insert(debug=true);



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
        translate([-(3_4_tee_width/2) +2.2,0,3_4_tee_center_z]) // Back of tee to back of breech measured at 2.2"
        rotate([0,-90,0])
        union() {
          cylinder(r=3_4_tee_id/2 +0.01, h=3_4_tee_width, center=false);
          translate([0,0,-1])
          Rod(rod=spindleRod, clearance=spindleClearance, length=3_4_tee_rim_od + 0.1, center=false);
        }

        // Sear Pin
        translate([0,-0.1,3_4_tee_center_z -trigger_offset])
        rotate([90,0,0])
        Rod(rod=spindleRod, clearance=spindleClearance, length=3_4_tee_rim_od, center=true);

        // Rubberband Pin
        for (i = [0:3]) {
          translate([-i*.25,0,3_4_tee_center_z])
          rotate([90,0,0])
          Rod(rod=spindleRod, clearance=RodClearanceSnug, length=3_4_tee_rim_od+0.2, center=true);
        }
      }
}

scale([25.4, 25.4, 25.4]) {

  translate([-3,0,0])
  trigger_insert();

  translate([0,0,3_4_tee_rim_od/2])
  rotate([0,-90,0])
  test_block();

  translate([0,2,0])
  new_trigger();

  translate([1,0,0])
  !new_sear();
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