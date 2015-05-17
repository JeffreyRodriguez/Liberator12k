$t=0;
//$t=1;
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
trigger_body_od = 0.825;
trigger_leg_od = 18/16;
trigger_arc_angle = 20;
trigger_pin_wall = 1/8;
sear_arc_angle = 50; //60;
interface_arc_angle = 18;
triggerPin = RodOneEighthInch;
searPin = RodOneEighthInch;

reset_spring_width=0.00;
interface_clearance=0.005;



module new_sear(pin=RodOneEighthInch, pin_clearance=RodClearanceLoose, od=sear_major_od, height=sear_height, center=false, angle=160) {

  $fn=30;
  sear_infill = od + .33;


  color("Red")
  translate([0,0,center ? -height/2 : 0])
  difference() {
    union() {

      // Spindle Wall
      cylinder(r=sear_minor_od/2, h=height);

      // Main Body
      linear_extrude(height=height)
      mirror([1,0,0])
      semicircle(od=od, angle=angle); // TODO: Do the trig for this - it needs to clear the striker

      // Trigger Interface Extension
      linear_extrude(height=height)
      rotate([0,0,-45])
      mirror([0,1,0])
      semicircle(od=sear_infill, angle=25);

      // Trigger Interface Infill
      mirror([0,1,0])
      translate([0,sear_infill/2/sqrt(2)/2,0])
      cube([sear_infill/2/sqrt(2), sear_infill/2/sqrt(2)/2, height]);
    }

        // Reset Spring Hole
        translate([0,0,(height-lookup(RodDiameter, pin) - lookup(RodClearanceLoose, pin))/2])
        #linear_extrude(height=lookup(RodDiameter, pin) + lookup(RodClearanceLoose, pin))
        union() {
          rotate([0,0,90])
          difference() {
            semicircle(od=od + 0.1, angle=135);
            circle(r=sear_minor_od/2);
          }

          rotate([0,0,-interface_arc_angle*2])
          translate([sear_minor_od/2,0])
          *square([sear_minor_od/2, sear_major_od]);
        }
       


    // Trigger Interface
    translate([3_4_tee_center_z - trigger_offset+1/16,0,-0.1]) {
      rotate([0,0,40-interface_arc_angle])
      linear_extrude(height=height+0.2)
      mirror([1,0,0])
      semicircle(od=trigger_body_od + (interface_clearance*2), angle=45);
     
      cylinder(r=lookup(RodRadius, triggerPin) + trigger_pin_wall + interface_clearance, height=height+0.2);
    }

    // Pin Hole
    translate([0,0,-0.1])
    Rod(rod=pin, clearance=pin_clearance, length=height + 0.2);
  }
}

module new_trigger(pin=RodOneEighthInch, pin_clearance=RodClearanceSnug, pin_wall=trigger_pin_wall, id=7/8, height=trigger_height, center=false, angle=180) {

  od=3/4;

  color("Gold")
  translate([0,0,center ? -height/2 : 0])
  difference() {
    union() {

      // Main Body
      rotate([0,0,40-interface_arc_angle])
      mirror([1,0,0])
      linear_extrude(height=height)
      semicircle(od=trigger_body_od, angle=angle);

      // Spindle Body
      cylinder(r=lookup(RodRadius, pin) + pin_wall, h=height);

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

    #translate([0,0,(height-lookup(RodDiameter, pin) - lookup(RodClearanceLoose, pin))/2])
    linear_extrude(height=lookup(RodDiameter, pin) + lookup(RodClearanceLoose, pin))
    rotate([0,0,90])
    union() {
      difference() {
        semicircle(od=trigger_body_od, angle=90);
        circle(r=lookup(RodRadius, pin) + pin_wall);
      }
     
      rotate([0,0,-90]) 
      translate([lookup(RodRadius, pin) + pin_wall,0,(height - lookup(RodDiameter, pin))/2])
      square([(trigger_body_od/2) - pin_wall,trigger_body_od]);
    }
  }
}

module trigger_insert(pin=RodOneEighthInch, column_height=0.95, base_thickness=3_4_tee_rim_width, debug=false) {
  overall_height = base_thickness + column_height;
  slot_width = 0.27;

  if (debug) {
    //%3_4_tee();

    // Striker
    translate([0,0,3_4_tee_rim_width]) {

      //translate([-(0.5*$t),0,0])
      translate([-(0.5),0,0])
      translate([0,0,3_4_tee_center_z])
      rotate([0,90,0])
      striker();

      translate([0,0,3_4_tee_center_z])
      translate([0,0,-trigger_offset])
      rotate([90,90,0])
      rotate([0,0,$t*sear_arc_angle])
      //rotate([0,0,sear_arc_angle])
      new_sear(center=true);

      translate([0,0, -1/16])
      rotate([90,90,0])
      rotate([0,0,trigger_arc_angle*$t])
      //rotate([0,0,trigger_arc_angle])
      new_trigger(center=true);
    }
  }

  difference() {
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
      *Rod(rod=pin, clearance=RodClearanceSnug, length=3_4_tee_rim_od, center=true);

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

    // Reset Spring Pins
    translate([3_4_tee_id/2,0,base_thickness])
    rotate([0,42,0])
    #cube([1,
           (lookup(RodDiameter, RodOneEighthInch) + lookup(RodClearanceLoose, RodOneEighthInch)),
           (lookup(RodDiameter, RodOneEighthInch) + lookup(RodClearanceLoose, RodOneEighthInch))*2],
         center=true);

    // Slot
    translate([-3_4_tee_id/2 - 0.005,-slot_width/2,-0.1])
    cube([3_4_tee_id + 0.01, slot_width, overall_height+ 0.2]);
  }
}


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


  translate([1/3,0,0])
  difference() {
    union() {
      translate([-1/8,-1/8,0])
      cube([1/4, 1/4, 1/4]);
  
      // Cap
      translate([0,0,1/4])
      cylinder(r1=1/8, r2=5/64, h=1/16);
    }

    Rod(rod=RodOneEighthInch, clearance=RodClearanceSnug, center=true);
  }

  translate([-3,0,0])
  !trigger_insert(debug=false);

  translate([0,0,3_4_tee_rim_od/2])
  rotate([0,-90,0])
  test_block(debug=false);

  translate([0,2,0])
  new_trigger();

  translate([1,0,0])
  new_sear();
}