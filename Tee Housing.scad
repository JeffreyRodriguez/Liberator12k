include <Components.scad>;
include <Vitamins/Pipe.scad>;
include <Vitamins/Rod.scad>;
include <AR15 Grip Mount.scad>;
use <Forend Rail.scad>;
use <New Trigger.scad>;

function teeHousingPinRod() = RodOneEighthInch;

module front_tee_housing_pins(rod=teeHousingPinRod(), clearance=RodClearanceSnug, debug=false) {

    if (debug)
    %3_4_tee();

    // Top Pin
    translate([3_4_tee_width/2-3_4_tee_rim_width/2,0,3_4_tee_rim_width])
    rotate([90,0,0])
    Rod(rod=rod, length=3_4_tee_rim_od + 0.2,
        center=true, clearance=clearance);

    // Bottom Pin
    translate([3_4_tee_width/2 + 3_4_tee_rim_width/2,0,0])
    rotate([90,0,0])
    Rod(rod=rod, length=3_4_tee_rim_od + 0.2,
        center=true, clearance=clearance);
}

module back_tee_housing_pins(rod=teeHousingPinRod(), clearance=RodClearanceSnug, debug=false) {

    if (debug)
    %3_4_tee();

    // Back-Top Pin
    translate([-3_4_tee_width/2,0,3_4_tee_rim_width])
    rotate([90,0,0])
    Rod(rod=rod, length=3_4_tee_rim_od + 0.2,
        center=true, clearance=clearance);
    // Back-Bottom Pin
    translate([-3_4_tee_width/2 - back_block_length/2,0,0])
    rotate([90,0,0])
    Rod(rod=rod, length=3_4_tee_rim_od + 0.2,
        center=true, clearance=clearance);
}

front_block_overlap = 3_4_x_1_8_bushing_height - 3_4_x_1_8_bushing_depth;
front_block_length = 3_4_tee_rim_width + front_block_overlap;
front_block_x_offset = -3_4_tee_rim_width/2;
front_block_width = grip_width;

module bottom_tee_housing(receiverTee=receiverTee, rimClearance=0.1,
                          triggerPin = RodOneEighthInch,
                          debug=false) {

  block_length = lookup(TeeWidth, receiverTee)
        - (lookup(TeeRimWidth, receiverTee)*2);

  if (debug)
  translate([0,0,0])
  %3_4_tee();

  difference() {
    union() {

      // Forend Rail
      color("Green")
      translate([0,0,3_4_tee_center_z])
      rotate([0,-90,0])
      render(convexity=3)
      linear_extrude(height=block_length, center=true)
      ForendRail(enableTop=false, enableBottomInfill=false, wall=tee_overlap + 0.03);
      
      // Body
      translate([0,0,3_4_tee_rim_width])
      intersection() {
        union() {
          cube([block_length,
                3_4_tee_rim_od+(tee_overlap*4),
                3_4_tee_rim_width*4], center=true);
          
          // Grip mount
          translate([-block_length/2 - .5,-grip_width/2,-3_4_tee_rim_width*2])
          cube([.501,grip_width,.676]);
        }

        // Chamfer the cube
        rotate([45,0,0])
        cube([block_length*2,1.9,1.9], center=true);
      }
      
      // AR15 Grip
      *translate([-3_4_tee_width/2 +3_4_tee_rim_width,0,-3_4_tee_rim_width])
      //translate([0,0,slot_length+1/4])
      ar15_grip(mount_height=1,
                mount_length=0, top_extension=1/4, extension=1/4,
                nut_offset=1.475, nut_height=0.25, nut_angle=90,
                debug=debug);
    }
    
    // Rim casting clearance
    for (i = [1, -1])
    translate([(i*TeeWidth(receiverTee)/2) - (i*TeeRimWidth(receiverTee)),0,TeeCenter(receiverTee)])
    rotate([0,i*-90,0])
    cylinder(r1=lookup(TeeRimDiameter, receiverTee)/2,
              r2=lookup(TeeOuterDiameter, receiverTee)/2,
               h=rimClearance);

    // Forend Rods
    translate([0,0,3_4_tee_center_z])
    rotate([0,-90,0])
    render(convexity=3)
    linear_extrude(height=3_4_tee_width, center=true)
    ForendRods();

    // Trigger Pin
    translate([-3_4_tee_id/2 +3/16,0,-lookup(RodRadius, triggerPin)])
    rotate([90,0,0])
    Rod(rod=triggerPin,
         length=3_4_tee_rim_od*2,
         center=true,
         clearance=RodClearanceSnug);

    // Trigger Insert Hole
    cube([3_4_tee_id * 1.2, 3_4_tee_id*.8, 3_4_tee_rim_width*3], center=true);


    // Tee Body
    render()
    union() {
      
      // Tee Top
      translate([-3_4_tee_rim_width,0,3_4_tee_center_z])
      rotate([0,90,0])
      #cylinder(r=3_4_tee_diameter/2,
                h=3_4_tee_width + front_block_length + back_block_length + 0.1,
                center=true,
                $fn=360);
      
      // Tee Body Saddle Corners Clearance
      intersection() {
        
        translate([0,0,3_4_tee_center_z +0.25])
        sphere(r=3_4_tee_rim_od/2 + .38);
        
        // DEBUG: Previous print
        *translate([0,0,3_4_tee_center_z +0.15])
        %sphere(r=3_4_tee_rim_od/2 + .3);
        
        cube([3_4_tee_rim_od,3_4_tee_diameter,3_4_tee_height], center=true);
      }
    }
    
    translate([0,0,3_4_tee_center_z - .2])
    *sphere(r=3_4_tee_rim_od/2 + .15);
    
    translate([0,0,3_4_tee_center_z + .4])
    *sphere(r=3_4_tee_rim_od/2 + .5);

    // Bottom Tee Rim
    cylinder(r=3_4_tee_rim_od/2, h=3_4_tee_center_z);

    // AR15 Grip Bolt
    translate([-3_4_tee_width/2 +3_4_tee_rim_width,0,-3_4_tee_rim_width])
    #ar15_grip_bolt(nut_offset=1.475, nut_height=1/4, nut_angle=90, nut_side = 1);
  }

}

*!scale([25.4, 25.4, 25.4])
bottom_tee_housing(debug=false);

module front_tee_housing(debug=false, rimOverlap=tee_overlap) {
  if (debug) {
    translate([-3_4_tee_center_z,0,3_4_tee_width/2 + front_block_length - 3_4_tee_rim_width])
    rotate([0,90,0])
    %3_4_tee();
  }

  difference() {
    union() {

      // Backstrap
      color("Red")
      render(convexity=2)
      linear_extrude(height=front_block_length)
      ForendRail(railClearance=RodClearanceSnug);


      // Tee Rim Block
      color("LightBlue")
      cylinder(r=3_4_tee_rim_od/2 + rimOverlap, h=front_block_length);

      // Spindle Block
      color("Orange")
      translate([-3_4_tee_center_z-3_4_tee_rim_width,
                 -front_block_width/2,
                 0])
      cube([3_4_tee_center_z,
            front_block_width,
            front_block_length]);
    }

    // Pins
    *translate([-3_4_tee_center_z,0,3_4_tee_width/2 + front_block_length - 3_4_tee_rim_width])
    rotate([0,90,0])
    front_tee_housing_pins(debug=false);

    // Front Tee Rim
    translate([0,0,front_block_length - 3_4_tee_rim_width])
    cylinder(r=3_4_tee_rim_od/2, h=3_4_tee_rim_width+0.1);

    // Gas Sealing Pipe Hole
    translate([0,0,-0.1])
    1_pipe(length=front_block_overlap + 0.2, hollow=false, cutter=true);
  }
}


back_block_length = slot_length + 1/2;
module back_tee_housing(stockPipe=stockPipe, gripOffset = 3_4_tee_center_z + 3_4_tee_rim_width, debug=false) {

  if (debug) {
    translate([3_4_tee_center_z,0,3_4_tee_width/2 + back_block_length - 3_4_tee_rim_width])
    rotate([0,-90,0])
    %3_4_tee();
  }

  difference() {
    union() {

      // Backstrap
      rotate([0,0,180]) {
        color("Red")
        render(convexity=2)
        linear_extrude(height=back_block_length)
        ForendRail(railClearance=RodClearanceSnug);

        %render()
        linear_extrude(height=12)
        ForendRods();
      }

      // Main Body and Stock Sleeve
      color("LightBlue")
      cylinder(r=3_4_tee_rim_od/2 + tee_overlap, h=back_block_length);

      // AR15 Grip
      *translate([gripOffset,0,slot_length+1/4])
      rotate([0,-90,0])
      #ar15_grip(mount_height=1,
                mount_length=0, top_extension=1/4, extension=1/4, debug=true);
      
      // Grip Mount Support Block
      translate([3_4_tee_center_z + 6.2/16,-1/4,0])
      cube([3/4, 1/2,1/4 + 0.001]);

    }

    // Pins
    translate([3_4_tee_center_z,0,3_4_tee_width/2 + back_block_length - 3_4_tee_rim_width])
    rotate([0,-90,0])
    *back_tee_housing_pins(debug=false);

    // Back Tee Rim
    translate([0,0,back_block_length - 3_4_tee_rim_width])
    cylinder(r=3_4_tee_rim_od/2, h=3_4_tee_rim_width + 0.1);

    // Stock Pipe
    translate([0,0,-0.1])
    Pipe(pipe=stockPipe, length=back_block_length + 0.2, clearance=PipeClearanceLoose);

    // AR15 Grip Bolt
    translate([gripOffset,0,slot_length])
    rotate([0,-90,0])
    *#ar15_grip_bolt(nut_offset=gripOffset+1/8, nut_height=1, nut_angle=90);
  }
}



module tee_housing_plater(debug=false) {
  color("HotPink")
  translate([0,2,0])
  *front_tee_housing(debug=debug);

  color("LightBlue")
  translate([0,0,3_4_tee_rim_width])
  bottom_tee_housing(debug=debug);

  color("Orange")
  translate([0,-2,0])
  *back_tee_housing(debug=debug);
}

module tee_housing_reference() {

  // Bottom insert
  color("Green")
  translate([0,0,-3_4_tee_rim_width])
  *cylinder(r=3_4_tee_id/2, h=3_4_tee_center_z);

  // Center Backstrap
  *color("Yellow")
  render()
  difference() {
    translate([(3_4_tee_width/2) - 3_4_tee_rim_width,0,3_4_tee_center_z + backstrap_offset])
    rotate([0,-90,0])
    backstrap(length=3_4_tee_width - (3_4_tee_rim_width*2), infill_length = 0.5);

    // Tee Body Clearance
    translate([0,0,3_4_tee_center_z])
    rotate([0,90,0])
    cylinder(r=3_4_tee_diameter/2, h=3_4_tee_width, center=true);
  }

  translate([3_4_tee_width/2 - 3_4_tee_rim_width + front_block_length,0,3_4_tee_center_z])
  rotate([0,-90,0])
  front_tee_housing(debug=false);

  bottom_tee_housing(debug=true);

  // Trigger Insert
  rotate([0,0,180])
  translate([0,0,-3_4_tee_rim_width])
  trigger_insert();

  translate([-back_block_length -3_4_tee_width/2 +3_4_tee_rim_width,0,3_4_tee_center_z])
  rotate([0,90,0])
  back_tee_housing(debug=false);

  // Barrel
  translate([3_4_tee_width/2+0.5,0,3_4_tee_center_z])
  rotate([0,90,0])
  %3_4_pipe(length=barrel_length);
}



scale([25.4, 25.4, 25.4])
rotate([0,0,90])
tee_housing_plater();

*!scale([25.4, 25.4, 25.4])
tee_housing_reference();
