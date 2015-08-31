include <Components.scad>;
include <AR15 Grip Mount.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Forend Rail.scad>;
use <Trigger.scad>;

function teeHousingPinRod() = RodOneEighthInch;

front_block_overlap = BushingHeight(breechBushing) - BushingDepth(breechBushing);
front_block_length = TeeRimWidth(receiverTee) + front_block_overlap;
front_block_width = 1.6;

module bottom_tee_housing(receiverTee=receiverTee, rimClearance=0.1,
                          triggerPin = RodOneEighthInch,
                          debug=false) {

  block_length = TeeWidth(receiverTee)
               - (TeeRimWidth(receiverTee)*2) - 0.03;
  block_width = TeeRimDiameter(receiverTee)+(tee_overlap*4);
  block_height = TeeRimWidth(receiverTee)*4;

  union() {
    difference() {
      //render(convexity=4)
      translate([-block_length/2,0,0])
      render(convexity=4)
      union() {

        // Forend Rail
        color("Green")
        translate([block_length,0,TeeCenter(receiverTee)])
        rotate([0,-90,0])
        linear_extrude(height=block_length)
        ForendRail(angles=[50,-50], enableBottomInfill=false, wall=tee_overlap + 0.03);

        // Body (Chamfered cube)
        translate([0,0, -TeeRimWidth(receiverTee)])
        intersection() {

          // Main cube for the body
          translate([0,-block_width/2,0])
          cube([block_length, block_width, block_height]);

          // Chamfer the cube
          translate([-block_length/2,0,-0.5])
          rotate([45,0,0])
          cube([block_length*2,1.8,1.8]);

        }

        // Locking tab wrap
        translate([block_length-0.1,-.5,-tee_overlap-1/8])
        cube([front_block_length+0.27,1,0.628]);
      }

      // Forend Rods
      translate([(block_length/2) + 0.1,0,TeeCenter(receiverTee)])
      rotate([0,-90,0])
      linear_extrude(height=block_length+0.2)
      ForendRods(angles=[50,-50]);

      // Locking tab
      translate([TeeWidth(receiverTee)/2 -TeeRimWidth(receiverTee) + 0.001,-.26,-tee_overlap-3/16])
      cube([front_block_length,0.52,0.8]);

      // Tee
      Tee(tee=receiverTee);

      // Bottom Tee Rim
      TeeRim(receiverTee, height=TeeCenter(receiverTee));

      // Trigger Pocket
      translate([0,0,-TeeRimWidth(receiverTee)+1/8])
      intersection() {
        translate([-TeeRimRadius(receiverTee),-TeeInnerRadius(receiverTee)-0.005,0])
        cube([TeeRimDiameter(receiverTee), TeeInnerDiameter(receiverTee) + 0.01, TeeRimWidth(receiverTee)*3]);

        difference() {
          TeeRim(receiverTee, height=TeeCenter(receiverTee));
          
          // Center Tabs
          translate([-TeeRimRadius(receiverTee),-0.12,-TeeRimWidth(receiverTee)-0.1])
          cube([TeeRimDiameter(receiverTee), 0.24, TeeCenter(receiverTee)+0.2]);
        }
      }

      // Trigger Hole
      translate([-TeeInnerRadius(receiverTee),-(TeeInnerDiameter(receiverTee)/2) -0.005,-TeeRimWidth(receiverTee)-0.1])
      cube([TeeInnerDiameter(receiverTee), TeeInnerDiameter(receiverTee) + 0.01, TeeRimWidth(receiverTee)+0.2]);

      // Trigger Pin
      %translate([-TeeInnerDiameter(receiverTee)/2 +3/16,0,-RodRadius(triggerPin)])
      rotate([90,0,0])
      Rod(rod=triggerPin,
           length=TeeRimDiameter(receiverTee)*2,
           center=true,
           clearance=RodClearanceSnug);
    }

    // Trigger
    if (debug)
    translate([0,0,0])
    rotate([0,0,180])
    trigger_insert(debug=debug);

  }

}

*scale([25.4, 25.4, 25.4])
//rotate([0,90,0])
bottom_tee_housing(debug=true);


module front_tee_housing(debug=false, rimOverlap=tee_overlap) {
  if (debug) {
    translate([-TeeCenter(receiverTee),0,TeeWidth(receiverTee)/2 + front_block_length - TeeRimWidth(receiverTee)])
    rotate([0,90,0])
    %Tee(TeeThreeQuarterInch);
  }

  difference() {
    union() {

      // Locking tab
      translate([-TeeCenter(receiverTee)-rimOverlap-1/8,-1/4,0])
      cube([TeeCenter(receiverTee),1/2,front_block_length]);

      // Forend Rails
      color("Red")
      render(convexity=2)
      linear_extrude(height=front_block_length)
      ForendRail(railClearance=RodClearanceSnug);

      // Tee Rim Block
      color("LightBlue")
      cylinder(r=TeeRimDiameter(receiverTee)/2 + rimOverlap, h=front_block_length);

    }

    // Front Tee Rim
    translate([0,0,front_block_length - TeeRimWidth(receiverTee)])
    cylinder(r=TeeRimDiameter(receiverTee)/2, h=TeeRimWidth(receiverTee)+0.1);

    // Breech Bushing Hole
    translate([0,0,-0.1])
    Pipe(PipeThreeQuartersInch, length=front_block_overlap + 0.2, hollow=false, cutter=true);
  }
}


back_block_length = slot_length + 1/2;
module back_tee_housing(stockPipe=stockPipe, gripOffset = TeeCenter(receiverTee)+tee_overlap+1/8, debug=false) {

  if (debug) {
    translate([TeeCenter(receiverTee),0,
               TeeWidth(receiverTee)/2 + back_block_length - TeeRimWidth(receiverTee)])
    rotate([0,-90,0])
    %Tee(TeeThreeQuarterInch);
  }

  difference() {
    union() {

      intersection() {
        union() {
          // Backstrap
          color("Red")
          render(convexity=2)
          rotate([0,0,180])
          linear_extrude(height=back_block_length)
          ForendRail(railClearance=RodClearanceSnug);

          // Main Body and Stock Sleeve
          color("LightBlue")
          cylinder(r=TeeRimDiameter(receiverTee)/2 + tee_overlap, h=back_block_length);
        }

        // Taper
        translate([0,0,-0.01])
        cylinder(r1=TeeRimRadius(receiverTee),
                 r2=TeeRimDiameter(receiverTee),
                 h=back_block_length+0.02);
      }

      // AR15 Grip
      translate([gripOffset,0,slot_length+1/4])
      rotate([0,-90,0])
      ar15_grip(mount_height=gripOffset,
                mount_length=0, top_extension=1/4, extension=1/4, debug=debug);

      // Grip Mount Support Block
      translate([gripOffset+0.3,-1/4,0])
      cube([3/4, 1/2,1/4 + 0.001]);

    }

    // Back Tee Rim
    translate([0,0,back_block_length - TeeRimWidth(receiverTee)])
    cylinder(r=TeeRimDiameter(receiverTee)/2, h=TeeRimWidth(receiverTee) + 0.1);

    // Stock Pipe
    translate([0,0,-0.1])
    Pipe(pipe=stockPipe, length=back_block_length + 0.2, clearance=PipeClearanceLoose);

    // AR15 Grip Bolt
    translate([gripOffset,0,slot_length+1/4])
    rotate([0,-90,0])
    ar15_grip_bolt(nut_offset=1.5, nut_height=1/4, nut_slot_length=1, nut_slot_angle=-90, nut_angle=90);
  }
}



module tee_housing_plater(debug=false) {
  translate([0,3,0])
  front_tee_housing(debug=debug);

  translate([0,0,TeeRimWidth(receiverTee)])
  bottom_tee_housing(debug=debug);

  translate([0,-3,0])
  back_tee_housing(debug=debug);
}


scale([25.4, 25.4, 25.4])
rotate([0,0,90])
tee_housing_plater();

module tee_housing_reference(debug=false) {

  // Bottom insert
  color("Green")
  translate([0,0,-TeeRimWidth(receiverTee)])
  *cylinder(r=TeeInnerDiameter(receiverTee)/2, h=TeeCenter(receiverTee));

  translate([TeeWidth(receiverTee)/2 - TeeRimWidth(receiverTee) + front_block_length,0,TeeCenter(receiverTee)])
  rotate([0,-90,0])
  front_tee_housing(debug=false);

  bottom_tee_housing(debug=debug);

  // Trigger Insert
  rotate([0,0,180])
  translate([0,0,-TeeRimWidth(receiverTee)])
  trigger_insert();

  translate([-back_block_length -TeeWidth(receiverTee)/2 +TeeRimWidth(receiverTee),0,TeeCenter(receiverTee)])
  rotate([0,90,0])
  back_tee_housing(debug=false);

  // Barrel
  if (debug)
  translate([TeeWidth(receiverTee)/2+0.5,0,TeeCenter(receiverTee)])
  rotate([0,90,0])
  Pipe(barrelPipe, length=barrel_length);
}

*!scale([25.4, 25.4, 25.4])
tee_housing_reference();
