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

slot_width = 0.27;

searPin = RodOneEighthInch;
sear_arc_angle = 40;
sear_height = sear_height();
sear_major_od = 53/64;
sear_minor_od = 0.52; //0.372;
sear_interface_extension = 0.414;


triggerPin = RodOneEighthInch;
trigger_offset = 18/32; // 19/32; // Offset from center_z
trigger_backset = TeeInnerDiameter(receiverTee)/2  -3/16;
trigger_height = 1/4;
trigger_body_od = 1.17;
trigger_major_od = .88;
trigger_arc_angle = 24.5;



interface_clearance=0.005;

module sear(pin=RodOneEighthInch, pin_clearance=RodClearanceLoose, od=sear_major_od, height=sear_height, center=false, angle=230) {

  $fn=30;

  color("Red")
  translate([0,0,center ? -height/2 : 0])
  difference() {

    render(convexity=2)
    linear_extrude(height=height)
    difference() {
      union() {
        // Spindle
        circle(r=sear_minor_od/2);

        // Body Infill + Front and Back Engagement Surfaces
        rotate([0,0,160])
        semicircle(od=sear_interface_extension*2, angle=15);

        // Overtravel Stop
        rotate([0,0,30])
        mirror([0,1])
        square([.5,0.26]);

        // Striker Engagement extension
        translate([-1/32,0,0])
        mirror([1,0,0])
        square([0.38, sear_minor_od]);
      }

      // Clear the striker when engaged
      translate([-trigger_offset +3/4/2,(sear_minor_od/2)*1.3,0])
      rotate([0,0,180])
      semicircle(od=1, angle=130);

      // Clear the striker when disengaged
      //-od-sear_minor_od/2
      translate([0,-sear_minor_od/2,0])
      rotate([0,0,180+sear_arc_angle])
      translate([0,-od,0])
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

module trigger(pin=RodOneEighthInch, pin_clearance=RodClearanceLoose, minor_od=.34, id=7/8, height=trigger_height, center=false, angle=196) {

  od=3/4;

  color("Gold")
  translate([0,0,center ? -height/2 : 0])
  difference() {
    render(convexity=2)
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
                      column_height=0.94,
                      half=false,
                      debug=false) {

  if (debug) {
    *%Tee(TeeThreeQuarterInch);

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
    sear(center=true);

    translate([trigger_backset,0, -1/16])
    rotate([90,90,0])
    rotate([0,0,trigger_arc_angle*$t])
    //rotate([0,0,trigger_arc_angle])
    trigger(center=true);
  }

  difference() {
    union() {

      // Insert body
      cylinder(r=TeeInnerDiameter(receiverTee)/2, h=column_height);

      // Foot
      translate([-TeeInnerRadius(receiverTee)+0.01,
                 -TeeInnerRadius(receiverTee),
                 -5/16])
      intersection() {
        cube([TeeInnerDiameter(receiverTee) -0.02,
              TeeInnerDiameter(receiverTee),
              5/16]);
        

        translate([TeeInnerRadius(receiverTee),TeeInnerRadius(receiverTee),5/16])
        rotate([45,0,0])
        cube([TeeInnerDiameter(receiverTee),
              TeeInnerDiameter(receiverTee),
              TeeInnerDiameter(receiverTee)], center=true);
        

        translate([TeeInnerRadius(receiverTee),TeeInnerRadius(receiverTee),1/4])
        rotate([0,45,0])
        cube([TeeInnerDiameter(receiverTee),
              TeeInnerDiameter(receiverTee),
              TeeInnerDiameter(receiverTee)], center=true);
      }

      // Supports
      translate([0,0,-TeeRimWidth(receiverTee)+1/8])
      intersection() {
        translate([-TeeRimRadius(receiverTee),-TeeInnerRadius(receiverTee),0])
        cube([TeeRimDiameter(receiverTee), TeeInnerDiameter(receiverTee), 3/16]);

        TeeRim(receiverTee, height=1/4, clearance=-0.005);
        
        translate([0,0,-0.001])
        cylinder(r1=TeeRimRadius(receiverTee)*0.9, r2=TeeRimRadius(receiverTee)*1.5, h=1/4);
      
        // Taper to help insertion
        translate([-TeeRimRadius(receiverTee),TeeInnerRadius(receiverTee) - 5/16,-1/4])
        rotate([45,0,0])
        cube([TeeRimDiameter(receiverTee), 1, 1]);
      }
    }

    // Central Slot
    if (!half)
    translate([-TeeInnerDiameter(receiverTee)/2 - 0.1,-slot_width/2,-TeeRimWidth(receiverTee)-0.1])
    cube([TeeInnerDiameter(receiverTee) + 0.2, slot_width, column_height + 1]);

    // Sear Pin
    translate([0,0,TeeCenter(receiverTee) - trigger_offset])
    rotate([90,0,0])
    Rod(rod=pin, clearance=RodClearanceSnug, length=TeeRimDiameter(receiverTee), center=true);

    // Trigger Pin
    translate([trigger_backset,0,-RodRadius(pin)])
    rotate([90,0,0])
    Rod(rod=pin, clearance=RodClearanceSnug, length=TeeRimDiameter(receiverTee), center=true);

    // Cut at slot for printing
    if (half)
    mirror([0,1,0])
    translate([-(TeeRimDiameter(receiverTee)/2) - 0.1,-slot_width/2,-1/2])
    cube([TeeRimDiameter(receiverTee)+0.2, slot_width + 1, column_height + 0.7]);
  }
}

module trigger_reference() {
  trigger_insert(debug=true);
}


*scale([25.4, 25.4, 25.4])
trigger_reference();

module trigger_plater() {
  scale([25.4, 25.4, 25.4]) {

    translate([0,1,-slot_width/2])
    rotate([90,0,180])
    trigger_insert(debug=false, half=true);

    translate([0,-1,-slot_width/2])
    mirror([1,0,0])
    rotate([90,0,0])
    trigger_insert(debug=false, half=true);

    translate([1,-0.4,0])
    rotate([0,0,110])
    trigger();

    translate([-1,0,0])
    rotate([0,0,140])
    sear();
  }
}

trigger_plater();
