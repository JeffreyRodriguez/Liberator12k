include <Components.scad>;
include <AR15 Grip Mount.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Forend Rail.scad>;
use <New Trigger.scad>;

function teeHousingPinRod() = RodOneEighthInch;

module front_tee_housing_pins(rod=teeHousingPinRod(), clearance=RodClearanceSnug, debug=false) {

    if (debug)
    %Tee(TeeThreeQuarterInch);

    // Top Pin
    translate([TeeWidth(receiverTee)/2-TeeRimWidth(receiverTee)/2,0,TeeRimWidth(receiverTee)])
    rotate([90,0,0])
    Rod(rod=rod, length=TeeRimDiameter(receiverTee) + 0.2,
        center=true, clearance=clearance);

    // Bottom Pin
    translate([TeeWidth(receiverTee)/2 + TeeRimWidth(receiverTee)/2,0,0])
    rotate([90,0,0])
    Rod(rod=rod, length=TeeRimDiameter(receiverTee) + 0.2,
        center=true, clearance=clearance);
}

module back_tee_housing_pins(rod=teeHousingPinRod(), clearance=RodClearanceSnug, debug=false) {

    if (debug)
    %Tee(TeeThreeQuarterInch);

    // Back-Top Pin
    translate([-TeeWidth(receiverTee)/2,0,TeeRimWidth(receiverTee)])
    rotate([90,0,0])
    Rod(rod=rod, length=TeeRimDiameter(receiverTee) + 0.2,
        center=true, clearance=clearance);
    // Back-Bottom Pin
    translate([-TeeWidth(receiverTee)/2 - back_block_length/2,0,0])
    rotate([90,0,0])
    Rod(rod=rod, length=TeeRimDiameter(receiverTee) + 0.2,
        center=true, clearance=clearance);
}

front_block_overlap = BushingHeight(breechBushing) - BushingDepth(breechBushing);
front_block_length = TeeRimWidth(receiverTee) + front_block_overlap;
front_block_x_offset = -TeeRimWidth(receiverTee)/2;
front_block_width = grip_width;

module bottom_tee_housing(receiverTee=receiverTee, rimClearance=0.1,
                          triggerPin = RodOneEighthInch,
                          debug=false) {

  block_length = lookup(TeeWidth, receiverTee)
               - (lookup(TeeRimWidth, receiverTee)*2)
               + slot_length;

  if (debug)
  translate([0,0,0])
  %Tee(TeeThreeQuarterInch);

  difference() {
    translate([-slot_length,0,0])
    union() {

      // Forend Rail
      color("Green")
      translate([0,0,TeeCenter(receiverTee)])
      rotate([0,-90,0])
      render(convexity=3)
      linear_extrude(height=block_length, center=true)
      ForendRail(enableTop=false, enableBottomInfill=false, wall=tee_overlap + 0.03);

      // Body
      translate([0,0,TeeRimWidth(receiverTee)])
      intersection() {
        union() {
          translate([-slot_length+tee_overlap,
                     -TeeRimRadius(receiverTee)-(tee_overlap*2),
                     -TeeRimWidth(receiverTee)*2])
          #cube([block_length,
                TeeRimDiameter(receiverTee)+(tee_overlap*4),
                TeeRimWidth(receiverTee)*4]);
        }

        // Chamfer the cube
        rotate([45,0,0])
        cube([block_length*4,1.9,1.9], center=true);
      }

      // Grip Nut Block
      translate([-block_length/2 - .5,-grip_width/2,-TeeRimWidth(receiverTee)])
      #cube([.501,grip_width,.676]);

      // AR15 Grip
      translate([-TeeWidth(receiverTee)/2 +TeeRimWidth(receiverTee),0,-TeeRimWidth(receiverTee)])
      //translate([0,0,slot_length+1/4])
      *ar15_grip(mount_height=1,
                mount_length=0, top_extension=1/4, extension=1/4,
                nut_offset=1.475, nut_height=0.25, nut_angle=90,
                debug=true);
    }

    // Forend Rods
    translate([0,0,TeeCenter(receiverTee)])
    rotate([0,-90,0])
    render(convexity=3)
    linear_extrude(height=TeeWidth(receiverTee), center=true)
    ForendRods();

    // Trigger Pin
    translate([-TeeInnerDiameter(receiverTee)/2 +3/16,0,-lookup(RodRadius, triggerPin)])
    rotate([90,0,0])
    Rod(rod=triggerPin,
         length=TeeRimDiameter(receiverTee)*2,
         center=true,
         clearance=RodClearanceSnug);

    // Trigger Insert Hole
    cube([TeeInnerDiameter(receiverTee) * 1.2, TeeInnerDiameter(receiverTee)*.8, TeeRimWidth(receiverTee)*3], center=true);

    // Tee Top
    translate([-TeeRimWidth(receiverTee),0,TeeCenter(receiverTee)])
    rotate([0,90,0])
    cylinder(r=TeeOuterDiameter(receiverTee)/2,
              h=TeeWidth(receiverTee) + front_block_length + back_block_length + 0.1,
              center=true,
              $fn=360);


    // Rim casting clearance
    for (i = [1, -1])
    translate([(i*TeeWidth(receiverTee)/2) - (i*TeeRimWidth(receiverTee)),0,TeeCenter(receiverTee)])
    rotate([0,i*-90,0])
    cylinder(r1=lookup(TeeRimDiameter, receiverTee)/2,
              r2=lookup(TeeOuterDiameter, receiverTee)/2,
               h=rimClearance);
    
    // Tee Body Saddle Corners Clearance
    *intersection() {

      translate([0,0,TeeCenter(receiverTee) +0.25])
      sphere(r=TeeRimDiameter(receiverTee)/2 + .38);

      // DEBUG: Previous print
      *translate([0,0,TeeCenter(receiverTee) +0.15])
      %sphere(r=TeeRimDiameter(receiverTee)/2 + .3);

      cube([TeeRimDiameter(receiverTee),TeeOuterDiameter(receiverTee),TeeHeight(receiverTee)], center=true);
    }

    // Bottom Tee Rim
    cylinder(r=TeeRimDiameter(receiverTee)/2, h=TeeCenter(receiverTee));

    // AR15 Grip Nut
    translate([-TeeWidth(receiverTee)/2 +TeeRimWidth(receiverTee),0,-TeeRimWidth(receiverTee)])
    #ar15_grip_bolt(nut_offset=1.475, nut_height=1/4, nut_angle=90, nut_side = 1);
  }

}

*!scale([25.4, 25.4, 25.4])
bottom_tee_housing(debug=true);

module front_tee_housing(debug=false, rimOverlap=tee_overlap) {
  if (debug) {
    translate([-TeeCenter(receiverTee),0,TeeWidth(receiverTee)/2 + front_block_length - TeeRimWidth(receiverTee)])
    rotate([0,90,0])
    %Tee(TeeThreeQuarterInch);
  }

  difference() {
    union() {

      // Forend Rails
      color("Red")
      render(convexity=2)
      linear_extrude(height=front_block_length)
      ForendRail(railClearance=RodClearanceSnug);


      // Tee Rim Block
      color("LightBlue")
      cylinder(r=TeeRimDiameter(receiverTee)/2 + rimOverlap, h=front_block_length);

      // Spindle Block
      color("Orange")
      translate([-TeeCenter(receiverTee)-TeeRimWidth(receiverTee),
                 -front_block_width/2,
                 0])
      cube([TeeCenter(receiverTee),
            front_block_width,
            front_block_length]);
    }

    // Pins
    *translate([-TeeCenter(receiverTee),0,TeeWidth(receiverTee)/2 + front_block_length - TeeRimWidth(receiverTee)])
    rotate([0,90,0])
    front_tee_housing_pins(debug=false);

    // Front Tee Rim
    translate([0,0,front_block_length - TeeRimWidth(receiverTee)])
    cylinder(r=TeeRimDiameter(receiverTee)/2, h=TeeRimWidth(receiverTee)+0.1);

    // Gas Sealing Pipe Hole
    translate([0,0,-0.1])
    Pipe(PipeOneInch, length=front_block_overlap + 0.2, hollow=false, cutter=true);
  }
}


back_block_length = slot_length + 1/2;
module back_tee_housing(stockPipe=stockPipe, gripOffset = TeeCenter(receiverTee) + TeeRimWidth(receiverTee), debug=false) {

  if (debug) {
    translate([TeeCenter(receiverTee),0,TeeWidth(receiverTee)/2 + back_block_length - TeeRimWidth(receiverTee)])
    rotate([0,-90,0])
    %Tee(TeeThreeQuarterInch);
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
      cylinder(r=TeeRimDiameter(receiverTee)/2 + tee_overlap, h=back_block_length);

      // AR15 Grip
      *translate([gripOffset,0,slot_length+1/4])
      rotate([0,-90,0])
      #ar15_grip(mount_height=1,
                mount_length=0, top_extension=1/4, extension=1/4, debug=true);

      // Grip Mount Support Block
      translate([TeeCenter(receiverTee) + 6.2/16,-1/4,0])
      cube([3/4, 1/2,1/4 + 0.001]);

    }

    // Pins
    translate([TeeCenter(receiverTee),0,TeeWidth(receiverTee)/2 + back_block_length - TeeRimWidth(receiverTee)])
    rotate([0,-90,0])
    *back_tee_housing_pins(debug=false);

    // Back Tee Rim
    translate([0,0,back_block_length - TeeRimWidth(receiverTee)])
    cylinder(r=TeeRimDiameter(receiverTee)/2, h=TeeRimWidth(receiverTee) + 0.1);

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
  translate([0,0,TeeRimWidth(receiverTee)])
  bottom_tee_housing(debug=debug);

  color("Orange")
  translate([0,-2,0])
  *back_tee_housing(debug=debug);
}

module tee_housing_reference() {

  // Bottom insert
  color("Green")
  translate([0,0,-TeeRimWidth(receiverTee)])
  *cylinder(r=TeeInnerDiameter(receiverTee)/2, h=TeeCenter(receiverTee));

  translate([TeeWidth(receiverTee)/2 - TeeRimWidth(receiverTee) + front_block_length,0,TeeCenter(receiverTee)])
  rotate([0,-90,0])
  front_tee_housing(debug=false);

  bottom_tee_housing(debug=true);

  // Trigger Insert
  rotate([0,0,180])
  translate([0,0,-TeeRimWidth(receiverTee)])
  trigger_insert();

  translate([-back_block_length -TeeWidth(receiverTee)/2 +TeeRimWidth(receiverTee),0,TeeCenter(receiverTee)])
  rotate([0,90,0])
  back_tee_housing(debug=false);

  // Barrel
  translate([TeeWidth(receiverTee)/2+0.5,0,TeeCenter(receiverTee)])
  rotate([0,90,0])
  %Pipe(barrelPipe, length=barrel_length);
}



scale([25.4, 25.4, 25.4])
rotate([0,0,90])
tee_housing_plater();

*!scale([25.4, 25.4, 25.4])
tee_housing_reference();
