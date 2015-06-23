$t=0;
//$t=1;
include <Components.scad>;
use <Components/Semicircle.scad>;
use <Vitamins/Rod.scad>;
use <Vitamins/Pipe.scad>;
use <Striker.scad>;
use <Firing Pin Guide.scad>;

$fn=50;

function sear_height() = 1/4;

searPin = RodOneEighthInch;
sear_arc_angle = 40;
sear_height = sear_height();
sear_major_od = 53/64;
sear_minor_od = 0.372;
sear_interface_extension = 0.414;




triggerPin = RodOneEighthInch;
trigger_offset = 18/32; // 19/32; // Offset from center_z
trigger_backset = TeeInnerDiameter(receiverTee)/2  -3/16;
trigger_height = 1/4;
trigger_body_od = 1.17;
trigger_major_od = .88;
trigger_arc_angle = 24.5;



interface_clearance=0.005;

module new_sear(pin=RodOneEighthInch, pin_clearance=RodClearanceLoose, od=sear_major_od, height=sear_height, center=false, angle=230) {

  $fn=30;

  color("Red")
  translate([0,0,center ? -height/2 : 0])
  difference() {

    linear_extrude(height=height)
    difference() {
      union() {
        // Spindle
        circle(r=0.26);

        // Body Infill + Front and Back Engagement Surfaces
        rotate([0,0,30]) {
          semicircle(od=sear_interface_extension*2, angle=315);

          // Overtravel Stop
          rotate([0,0,-23])
          mirror([0,1])
          square([1,sear_major_od/4]);
        }

        // Striker Engagement extension
        translate([-1/32,0,0])
        mirror([1,0,0])
        square([trigger_offset - 3/16, sear_minor_od]);
      }

      // Clear the striker when engaged
      translate([-trigger_offset +3/4/2,(sear_minor_od/2)*1.3,0])
      rotate([0,0,180])
      semicircle(od=1, angle=130);

      // Clear the striker when disengaged
      rotate([0,0,sear_arc_angle])
      translate([-od-sear_minor_od/2,-od,0])
      square([od, od*2]);

      // Overtravel Trigger Clearance
      translate([-trigger_offset + TeeCenter(receiverTee) + 1/16,trigger_backset])
      circle(r=trigger_major_od/2 + interface_clearance);

    }

    // Pin Hole
    translate([0,0,-0.1])
    Rod(rod=pin, clearance=pin_clearance, length=height + 0.2);
  }
}

module new_trigger(pin=RodOneEighthInch, pin_clearance=RodClearanceLoose, minor_od=.34, id=7/8, height=trigger_height, center=false, angle=196) {

  od=3/4;

  color("Gold")
  translate([0,0,center ? -height/2 : 0])
  difference() {
    linear_extrude(height=height)
    union() {

      // Sear Interface
      translate([0,-0.05,0])
      mirror([1,0,0])
      square([trigger_body_od/2,minor_od/2 + 0.05]);

      // Spindle Body
      circle(r=minor_od/2);

      // Trigger Bar Infill
      rotate([0,0,-45])
      semicircle(od=trigger_major_od, angle=135);


      // Trigger (UI)
      rotate([0,0,-25])
      //translate([-0.1,-0.13,0])
      difference() {
        intersection() {

          // Trigger body
          translate([0,0.18,0])
          mirror([0,1])
          square([1.5,0.6]);

          // Trigger Back Curve
          translate([od/2 * sqrt(2) + 0.09,-od/2 * sqrt(2)-0.15])
          circle(r=1.05);
        }

        // Trigger Front Curve
        translate([.78,-0.5,-0.1])
        translate([TeeRimWidth(receiverTee),0,0])
        circle(r=0.45);
      }
    }

    // Spindle Hole
    translate([0,0,-0.1])
    Rod(rod=pin, clearance=pin_clearance, length=height + 0.2);

  }
}

module trigger_insert(pin=RodOneEighthInch,
                      column_height=0.95,
                      base_thickness=TeeRimWidth(receiverTee),
                      debug=false) {
  overall_height = base_thickness + column_height;
  slot_width = 0.27;

  if (debug) {
    //%Tee(TeeThreeQuarterInch);

    translate([0,0,TeeRimWidth(receiverTee)]) {

      // Striker
      //translate([-(0.5*$t),0,0])
      //translate([-(0.5),0,0])
      translate([(sear_minor_od/2) * 1.75,0,TeeCenter(receiverTee)])
      rotate([0,90,0])
      striker();

      translate([0,0,TeeCenter(receiverTee)])
      translate([0,0,-trigger_offset])
      rotate([0,$t*sear_arc_angle,])
      //rotate([0,sear_arc_angle,0])
      rotate([90,90,0])
      new_sear(center=true);

      translate([trigger_backset,0, -1/16])
      rotate([90,90,0])
      rotate([0,0,trigger_arc_angle*$t])
      //rotate([0,0,trigger_arc_angle])
      new_trigger(center=true);
    }
  }

  difference() {
    union() {
      difference() {
        cylinder(r=TeeInnerDiameter(receiverTee)/2, h=TeeCenter(receiverTee)+base_thickness-(TeeInnerDiameter(receiverTee)/5));

        // Central Slot
        translate([-TeeInnerDiameter(receiverTee)/2 - 0.1,-slot_width/2,-0.1])
        cube([TeeInnerDiameter(receiverTee) + 0.2, slot_width, overall_height+ 0.2]);
      }

      translate([-TeeRimDiameter(receiverTee)/2,-TeeInnerDiameter(receiverTee)/2,0])
      cube([TeeRimDiameter(receiverTee),TeeInnerDiameter(receiverTee),base_thickness]);
    }

    // Move up for base
    translate([0,0,base_thickness]) {

      // Striker Clearance
      translate([0,0,TeeCenter(receiverTee)])
      rotate([0,90,0])
      cylinder(r=0.4, h=TeeInnerDiameter(receiverTee) + 0.01, center=true);

      // Sear Pin
      translate([0,0,TeeCenter(receiverTee) - trigger_offset])
      rotate([90,0,0])
      Rod(rod=pin, clearance=RodClearanceSnug, length=TeeRimDiameter(receiverTee), center=true);

      // Trigger Pin
      translate([trigger_backset,0,-lookup(RodDiameter, pin)/2])
      rotate([90,0,0])
      #Rod(rod=pin, clearance=RodClearanceSnug, length=TeeRimDiameter(receiverTee), center=true);
    }

    // 2 Side Pins
    translate([-lookup(RodDiameter, pin) -lookup(RodClearanceLoose, pin),0,-0.1]) {
      translate([0,(TeeInnerDiameter(receiverTee) - slot_width)/2.4,0])
      Rod(rod=pin, clearance=RodClearanceSnug, length=TeeRimDiameter(receiverTee) + 0.2);

      translate([0,-(TeeInnerDiameter(receiverTee) - slot_width)/2.4,0])
      Rod(rod=pin, clearance=RodClearanceSnug, length=TeeRimDiameter(receiverTee) + 0.2);
    }

    // Trigger Slot
    translate([-TeeInnerDiameter(receiverTee)/2,-slot_width/2,-0.1])
    cube([TeeInnerDiameter(receiverTee), slot_width, base_thickness + 0.2]);
  }
}

!scale([25.4, 25.4, 25.4])
trigger_insert(debug=true);

scale([25.4, 25.4, 25.4]) {

  translate([0,2,0])
  new_trigger();

  translate([1,0,0])
  new_sear();
}
