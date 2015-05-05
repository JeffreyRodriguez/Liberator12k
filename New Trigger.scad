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
trigger_offset = 19/32;
sear_height = 1/2;

module new_sear(spindle=RodOneEighthInch, spindle_clearance=RodClearanceLoose, od=3/4, wall=9/32, height=sear_height, angle=140) {

  color("Red")
  difference() {
    union() {
      linear_extrude(height=height)
      mirror([1,0,0])
      semicircle(od=od, angle=180);

      // Spindle Wall
      cylinder(r=(id+wall)/2, h=height);
    }

    // Trigger Interface
    translate([3_4_tee_center_z - trigger_offset+1/16,0,-0.1])
    cylinder(r=9/16, h=height+0.2);

    // Spindle Hole
    translate([0,0,-0.1])
    #Rod(rod=spindle, clearance=spindle_clearance, length=height + 0.2);
  }
}

module new_trigger(spindle=RodOneEighthInch, spindle_clearance=RodClearanceSnug, wall=3/8, height=height, angle=180) {

  od=3/4;

  color("Gold")
  difference() {
    union() {
      linear_extrude(height=height)
      rotate([0,0,-155])
      semicircle(od=18/16, angle=25);

      // Spindle Wall
      cylinder(r=(id/2)+wall, h=height);

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

    // Spindle Hole
    translate([0,0,-0.1])
    #Rod(rod=spindle, clearance=spindle_clearance, length=height + 0.2);
  }
}


module test_insert() {
  difference() {
    union() {
      translate([0,0,3_4_tee_rim_width])
      cylinder(r=3_4_tee_id/2, h=3_4_tee_center_z - 3_4_tee_id/2);

      translate([-3_4_tee_id/2,-3_4_tee_id/2,0])
      cube([3_4_tee_id,3_4_tee_id,3_4_tee_rim_width]);
    }
    translate([0,0,-0.1])
    #Rod(rod=RodOneQuarterInch, clearance=RodClearanceLoose, length=2);
  }
}



!scale([25.4, 25.4, 25.4]) {


  translate([-trigger_offset,0,height/2]) {
    translate([3_4_tee_center_z,0,0]) {
    rotate([-90,0,90])
    %difference() {
      3_4_tee();

      translate([-2,-4,-1])
      cube([4,4,4]);
    }

    %translate([3_4_tee_rim_width,0,0])
    rotate([0,-90,0])
    difference() {
      cylinder(r=3_4_tee_rim_od/2, h=3_4_tee_rim_width);
    
      translate([0,0,3_4_tee_rim_width - 1/16])
      rotate([0,90,0])
      cylinder(r=31/64, h=13/32, center=true);

      // Spindle Hole
      translate([0,0,3_4_tee_rim_width - 1/16])
      rotate([0,90,0])
      #Rod(rod=RodOneEighthInch, clearance=RodClearanceLoose, length=3_4_tee_rim_od, center=true);
    }

    }

    rotate([-90,0,0])
    %cylinder(r=3/8, h=3_4_tee_width);
  }

  translate([3_4_tee_center_z -trigger_offset + 1/16,0,0])
  rotate([0,0,28*$t])
  new_trigger();

  translate([0,0,-1/16])
  new_sear();

  translate([3_4_tee_rim_width,0,0])
  translate([3_4_tee_center_z,0,0])
  translate([-19/32,0,0])
//  translate([0,0,height/2])
  rotate([0,-90,0])
  *test_insert();
}