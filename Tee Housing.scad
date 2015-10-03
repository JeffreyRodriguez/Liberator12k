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

gripOffset = TeeCenter(receiverTee)+tee_overlap+1/8;

module bottom_tee_housing(receiverTee=receiverTee, rimClearance=0.1,
                          triggerPin = RodOneEighthInch,
                          debug=false) {

  block_length = TeeWidth(receiverTee)
               - (TeeRimWidth(receiverTee)*2) - 0.03;
  block_width = TeeRimDiameter(receiverTee)+(tee_overlap*4);
  block_height = 5/16+TeeRimWidth(receiverTee);
  tee_offset_z = tee_overlap+1/8;

  translate([0,0,tee_offset_z])
  %Tee(receiverTee);
                   
  difference() {
    // Bottom Rim Wrap
    intersection() {
      cylinder(r=TeeRimRadius(receiverTee) + tee_overlap, h=block_height);
      
      // Taper the bottom
      translate([0,0,(TeeRimWidth(receiverTee)/2)+block_height-0.001])
      mirror([0,0,1])
      cylinder(r1=TeeRimDiameter(receiverTee),
               r2=TeeRimRadius(receiverTee),
                h=block_height+TeeRimWidth(receiverTee));
      
              
      // Taper the top      
      translate([0,0,-(TeeRimWidth(receiverTee)/2)-0.001])
      cylinder(r1=TeeRimDiameter(receiverTee),
               r2=TeeRimRadius(receiverTee),
                h=block_height+TeeRimWidth(receiverTee));
    }

    // Bottom Tee Rim
    translate([0,0,tee_offset_z])
    TeeRim(receiverTee, height=block_height+0.2);
    
    // Trigger Pocket NEW
    rotate([0,0,180])
    translate([0,0,1/8])
    linear_extrude(height=1)
    trigger_insert_2d(height=TeeCenter(receiverTee));
    
    
    // Trigger Hole
    difference() {
      translate([-TeeInnerRadius(receiverTee)-1/8,-(TeeInnerDiameter(receiverTee)/2),-0.1])
      cube([TeeInnerDiameter(receiverTee) + 1/8, TeeInnerDiameter(receiverTee), TeeRimWidth(receiverTee)+0.2]);
              
      // Center Tabs
      translate([-TeeInnerRadius(receiverTee)-1/4,-0.127,-0.1])
      cube([1/4, 0.254, TeeCenter(receiverTee)+0.2]);
    }
    
    // AR15 Grip Bolt
    translate([gripOffset,0,slot_length+1/4])
    rotate([0,-90,0])
    #ar15_grip_bolt(nut_offset=1.74, nut_height=1/4, nut_slot_length=1, nut_slot_angle=-90, nut_angle=90);
  }

  // Trigger
  if (debug)
  %translate([0,0,tee_offset_z])
  rotate([0,0,180])
  trigger_insert(debug=debug);
}

*!scale([25.4, 25.4, 25.4])
//rotate([0,90,0])
bottom_tee_housing(debug=true);

module side_tee_housing(receiverTee=receiverTee, rimClearance=0.1, angles=[50,-50],
                          triggerPin = RodOneEighthInch,
                          debug=false, center=false) {

  block_length = TeeWidth(receiverTee)
               - (TeeRimWidth(receiverTee)*2) - 0.03;

  translate([center ? block_length/2 : 0,0,center ? TeeCenter(receiverTee) : 0])
  rotate([0,center ? -90 : 0,0])
  render(convexity=4)
  difference() {
    linear_extrude(height=block_length)
    difference() {
      // Forend Rail
      ForendRail(angles=angles, enableBottomInfill=false, wall=tee_overlap + 0.03);

      // Forend Rods
      ForendRods(angles=angles);
    }

    // Tee
    translate([-TeeCenter(receiverTee),0,block_length/2]) {
      rotate([0,90,0])
      Tee(tee=receiverTee);

      // Bottom Tee Rim
      rotate([0,90,0])
      TeeRim(receiverTee, height=TeeCenter(receiverTee));
    }
  }
}

*!scale([25.4, 25.4, 25.4])
//rotate([0,90,0])
side_tee_housing(center=true, debug=true);


module front_tee_housing(receiverTee=TeeThreeQuarterInch, barrelPipe=PipeThreeQuartersInch,
                breechBushing=BushingThreeQuarterInch, trunnionPipe=PipeOneInch,
                latchRod=RodOneQuarterInch, latchRodExtraOffset = 0.1, trunnionLength=0, wall=tee_overlap, $fn=40) {
                  
  length = BushingHeight(breechBushing) - BushingDepth(breechBushing)+trunnionLength+TeeRimWidth(receiverTee) - 0.001;
  
  latchRodOffset = TeeRimRadius(receiverTee) + RodRadius(latchRod) + latchRodExtraOffset;
                  
  difference() {
    render(convexity=2)
    linear_extrude(height=length)
    difference() {
      hull()
      union() {
        
        // Body
        circle(r=TeeRimRadius(receiverTee) + wall);
        
        // Latch Rod
        for (i = [1,-1])
        translate([0,latchRodOffset*i,0])
        circle(r=RodRadius(latchRod)+wall);
        
        ForendRail(angles=[180, 50,-50],wall=wall, railClearance=RodClearanceLoose);
      }
    
      ForendRods(angles=[180, 50,-50], clearance=RodClearanceSnug);
    
      // Latch Rod
      for (i = [1,-1])
      translate([0,latchRodOffset*i,0])
      Rod2d(rod=latchRod, clearance=RodClearanceLoose);
    }
    
    // Bushing
    translate([0,0,BushingHeight(breechBushing) - BushingDepth(breechBushing)+TeeRimWidth(receiverTee)])
    rotate([0,0,360/6/2])
    mirror([0,0,1])
    Bushing(breechBushing);
    
    // Tee Rim
    translate([0,0,-0.001])
    TeeRim(tee=receiverTee, height=TeeRimWidth(receiverTee));

    // Trunnion Pipe
    translate([0,0,BushingHeight(breechBushing) - BushingDepth(breechBushing)+TeeRimWidth(receiverTee)-0.001])
    *Pipe(pipe=trunnionPipe, length=3,clearance=PipeClearanceLoose);
  }
  
}

*!scale([25.4, 25.4, 25.4])
front_tee_housing();


back_block_length = slot_length + 1/2;
module back_tee_housing(stockPipe=stockPipe, debug=false) {
  taperExtraWall = 1/8;
  gripStorageRadius = (grip_width - 1/4)/2;

  if (debug) {
    translate([TeeCenter(receiverTee),0,
               TeeWidth(receiverTee)/2 + back_block_length - TeeRimWidth(receiverTee)])
    rotate([0,-90,0])
    %Tee(TeeThreeQuarterInch);
  }

  difference() {
    union() {
      intersection() {
        render(convexity=2)
        hull()
        union() {
          // Rails
          color("Red")
          rotate([0,0,180])
          intersection() {
            linear_extrude(height=back_block_length)
            ForendRail(railClearance=RodClearanceSnug);
            
            // Upper Taper
            translate([0,0,0.65])
            cylinder(r2=PipeOuterRadius(barrelPipe) + taperExtraWall,
                     r1=back_block_length+PipeOuterRadius(barrelPipe)+taperExtraWall,
                     h=back_block_length);
          }

          // Main Body and Stock Sleeve
          color("LightBlue")
          linear_extrude(height=back_block_length)
          circle(r=TeeRimDiameter(receiverTee)/2 + tee_overlap);
        }

        // Lower Taper (Narrower than 45*)
        translate([0,0,-0.1])
        cylinder(r1=PipeOuterRadius(barrelPipe) + taperExtraWall,
                 r2=back_block_length*1.25,
                 h=back_block_length+0.2);
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
    
    // Base Cutouts
    for (i = [115, -115])
    rotate([0,0,i])
    translate([(PipeOuterRadius(stockPipe)*3) + taperExtraWall,0,-0.1 -(tee_overlap*3)]) {
      cylinder(r=PipeOuterDiameter(pipe=stockPipe), h=back_block_length - TeeRimWidth(receiverTee) - tee_overlap +0.1);
      
      translate([0,0,back_block_length - TeeRimWidth(receiverTee) - tee_overlap +0.1])
      sphere(r=PipeOuterDiameter(pipe=stockPipe));
    }
    
    // Forend Rods
    linear_extrude(height=back_block_length+0.2)
    rotate([0,0,180])
    ForendRods(clearance=RodClearanceSnug);

    // Back Tee Rim
    translate([0,0,back_block_length - TeeRimWidth(receiverTee)])
    cylinder(r=TeeRimDiameter(receiverTee)/2, h=TeeRimWidth(receiverTee) + 0.1);

    // Stock Pipe
    translate([0,0,-0.1])
    Pipe(pipe=stockPipe, length=back_block_length + 0.2, clearance=PipeClearanceLoose);

    // AR15 Grip Bolt
    translate([gripOffset,0,slot_length+1/4])
    rotate([0,-90,0])
    #ar15_grip_bolt(nut_offset=1.74, nut_height=1/4, nut_slot_length=1, nut_slot_angle=-90, nut_angle=90);
    
    // Grip Storage Hole
    translate([PipeOuterRadius(stockPipe) + tee_overlap + gripStorageRadius + 0.05,0,-0.001])
    cylinder(r=gripStorageRadius, h=back_block_length - TeeRimWidth(receiverTee) - tee_overlap, $fn=20);
  }
}

*!scale([25.4, 25.4, 25.4])
back_tee_housing();

module tee_housing_plater(debug=false) {
  translate([0,3,0])
  front_tee_housing(debug=debug);

  *bottom_tee_housing(debug=debug);
  
  translate([0,-3,0])
  back_tee_housing(debug=debug);
}


*!scale([25.4, 25.4, 25.4])
rotate([0,0,90])
tee_housing_plater();

module tee_housing_reference(debug=false) {

  // Bottom insert
  color("Green")
  translate([0,0,-TeeRimWidth(receiverTee)])
  *cylinder(r=TeeInnerDiameter(receiverTee)/2, h=TeeCenter(receiverTee));

  translate([1,0,TeeCenter(receiverTee)])
  rotate([0,-90,180])
  front_tee_housing(debug=false);

  translate([0,0,-TeeRimWidth(receiverTee)])
  bottom_tee_housing(debug=debug);

  color("CornflowerBlue")
  *side_tee_housing(center=true, debug=debug);

  // Trigger Insert
  rotate([0,0,180])
  translate([0,0,-TeeRimWidth(receiverTee)])
  *trigger_insert();

  translate([-back_block_length -TeeWidth(receiverTee)/2 +TeeRimWidth(receiverTee),0,TeeCenter(receiverTee)])
  rotate([0,90,0])
  render()
  back_tee_housing(debug=false);

  // Barrel
  if (debug)
  translate([TeeWidth(receiverTee)/2+0.5,0,TeeCenter(receiverTee)])
  rotate([0,90,0])
  Pipe(barrelPipe, length=barrel_length);
}

scale([25.4, 25.4, 25.4])
tee_housing_reference();
