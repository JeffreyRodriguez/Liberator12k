include <Components.scad>;
use <Vitamins/Grip.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Forend Rail.scad>;
use <Trigger.scad>;
use <Reference.scad>;
use <Side Tee Housing.scad>;

module TeeHousingTabRear(receiver=Spec_TeeThreeQuarterInch(), clearance=0, length=3) {
  
  // Horizontal Block
  translate([-0.25-clearance,-0.25-clearance,0])
  cube([0.25+(clearance*2),0.5+(clearance*2),length]);
  
  // Vertical Block
  translate([0.37+clearance,-0.125-clearance,0])
  rotate([0,0,90])
  cube([0.25+(clearance*2),0.5,length]);
}

module bottom_tee_housing_position(receiver=Spec_TeeThreeQuarterInch()) {
  
}

module bottom_tee_housing(receiver=Spec_TeeThreeQuarterInch(),
                          rod=Spec_RodFiveSixteenthInch(),
                          triggerPin = Spec_RodOneEighthInch(),
                          rimClearance=0.1,
                          gripExtension=0.69,
                          wall=3/16,
                          support=true,
                          debug=false) {
  wall_height  = 1;
  floor_height = 1/4;
  trigger_floor_height = 0.054;

  block_length = TeeWidth(receiver)
               - (TeeRimWidth(receiver)*2) - 0.03;
  block_width = TeeRimDiameter(receiver)+(tee_overlap*4);
  //block_height = floor_height + TeeRimWidth(receiver) + wall_height;
  gripExtraTop = 0.65;
                            
  gripOffsetZ = TeeCenter(receiver);
  frontOffsetX = (TeeWidth(receiver)/2)-TeeRimWidth(receiver);
  frontWidth = TeeRimDiameter(receiver)+(RodDiameter(rod)*2)+(tee_overlap*2);
  render()
  union() {
    // Bottom Rim and Grip with Trigger Pocket
    translate([0,0,-TeeCenter(receiver)])
    difference() {
     union() {
        
        // Bottom Rim
        color("Green")
        translate([0,0,-floor_height])
        cylinder(r=TeeRimRadius(receiver) + tee_overlap,
                  h=0.69,
                  $fn=30);

        // Sides
        color("CornflowerBlue")
        translate([frontOffsetX,0,TeeCenter(receiver)])
        rotate([0,-90,0])
        linear_extrude(height=0.7)
        ForendRail(angles=[50,-50], rodHoles=false);
  
        // AR15 Grip
        color("Red")
        translate([0,0,gripOffsetZ]) // Hacky positioning
        Reference_Grip_Position(receiver)
        intersection() {
          GripTab(extension=gripExtension, extraFront=0.54, extraTop=gripExtraTop, debug=false);
          
          translate([0, 0, -4])
          rotate([0,10,0])
          rotate([0,0,90+45])
          cube([3,3,4]);          
        }
      }

      // Tee and rim
      translate([0,0,0]) {
        // Bottom Tee Rim
        TeeRim(receiver, height=TeeCenter(receiver));

        // Tee
        Tee(tee=receiver);
      }
      
      // Back Housing Socket
      translate([(-TeeWidth(receiver)/2)-0.045,0,TeeCenter(receiver)-TeeRimRadius(receiver)-0.25])
      rotate([0,-90,0]) 
      TeeHousingTabRear(length=1.4, clearance=0.005);
      
      translate([TeeWidth(receiver)/2,0,TeeCenter(receiver)])
      rotate([0,-90,0])
      linear_extrude(height=TeeWidth(receiver)*2)
      ForendRods();
  
      // AR15 Grip Bolt
      translate([0,0,gripOffsetZ]) // Hacky positioning
      Reference_Grip_Position(receiver)
      Grip_Bolt(extension=gripExtension, nut_height=1, debug=false);

      // Trigger Pocket 
      {
        // Main insert shape
        rotate([0,0,180])
        translate([0,0,-floor_height+trigger_floor_height])
        linear_extrude(height=1)
        trigger_insert_2d(height=TeeCenter(receiver));

        // Trigger Hole with steps for locking
        translate([0,0,-floor_height-0.1])
        difference() {
          translate([-TeeInnerRadius(receiver)-1/8,-(TeeInnerDiameter(receiver)/2),0])
          cube([TeeInnerDiameter(receiver) + 1/8, TeeInnerDiameter(receiver), TeeRimWidth(receiver)+0.2]);

          // Center Tabs
          translate([-TeeInnerRadius(receiver)-0.25,-0.127,-0.1])
          cube([1/4, 0.254, TeeCenter(receiver)+0.2]);
        }
      }      
          
      // DEBUG: Half
      *if (debug)
      translate([-3,TeeRimDiameter(receiver),-1.5])
      //rotate([0,45,0])
      translate([-TeeRimRadius(receiver),-TeeRimDiameter(receiver),-TeeRimDiameter(receiver)/2])
      cube([6,TeeRimDiameter(receiver)*2,5]);
      
      // Cut down the back
      translate([-(TeeWidth(receiver)/2)-1.3,-(grip_width/2)-0.05,-0.1])
      rotate([0,-45,0])
      cube([2,grip_width+0.1,2]);
    }
    
    
    // SUPPORT
    if (support) {
          
      // Grip Front Manual Support (vertical)
      *translate([-TeeRimRadius(receiver)+0.2, -1/2,-floor_height - 1.1])
      cube([frontOffsetX+TeeRimRadius(receiver)-0.2,1,0.15]);
          
      // Grip Front Manual Support (+30 deg)
      translate([-TeeRimRadius(receiver)+0.27, -1/2,-floor_height - 1.1])
      rotate([0,-30,0])
      *cube([frontOffsetX+TeeRimRadius(receiver)+0.5,1,0.17]);
      
      // Front-back trigger support
      translate([0,0,-TeeCenter(receiver)])
      union() {
        for (supportZOffset=[-0.013, -floor_height])
        translate([-TeeInnerRadius(receiver)-0.005,-TeeInnerRadius(receiver),supportZOffset])
        cube([TeeInnerDiameter(receiver)+0.01, TeeInnerDiameter(receiver),+0.013]);
        
        for (supportYOffset=[-0.125,0.125-0.013])
        translate([-TeeInnerRadius(receiver)-0.005,supportYOffset,-floor_height])
        cube([TeeInnerDiameter(receiver)+0.01, 0.013,floor_height]);
      }
      
      // Support the trigger insert tabs
      *union() {
        translate([-TeeInnerRadius(receiver)-0.005,-TeeInnerRadius(receiver)-0.005,TeeRimWidth(receiver) - 0.001])
        cube([TeeInnerDiameter(receiver)+0.01, TeeInnerDiameter(receiver)+0.01, block_height-TeeRimWidth(receiver)+0.001]);
        
        // Support the trigger insert tabs and rim base
        rotate([0,0,90])
        translate([-TeeRimRadius(receiver)-0.005,-0.1,block_height-0.01])
        cube([TeeRimDiameter(receiver)+0.01, 0.2,+0.01]);
      }
    }
  }

  // Trigger
  if (debug)
  translate([0,0,-TeeCenter(receiver)])
  rotate([0,0,180])
  trigger_insert(debug=debug);
}


module front_tee_housing(receiver=Spec_TeeThreeQuarterInch(),
                         barrelPipe=Spec_PipeThreeQuarterInch(),
                         forendRod=Spec_RodFiveSixteenthInch(),
                         breechBushing=BushingThreeQuarterInch,
                         latchRod=Spec_RodOneQuarterInch(), latchRodExtraOffset = 0.1,
                         wall=tee_overlap, $fn=40) {

  length = BushingHeight(breechBushing) - BushingDepth(breechBushing)+TeeRimWidth(receiver) - 0.001;

  latchRodOffset = TeeRimRadius(receiver) + RodRadius(latchRod) + latchRodExtraOffset;

  render(convexity=2)
  difference() {
    linear_extrude(height=length)
    difference() {
      hull()
      union() {

        // Body
        circle(r=TeeRimRadius(receiver) + wall);

        // Latch Rod
        *for (i = [1,-1])
        translate([0,latchRodOffset*i,0])
        circle(r=RodRadius(latchRod)+wall);

        ForendRail(receiver, barrelPipe, railClearance=RodClearanceLoose);
      }

      ForendRods(angles=[180, 50,-50], clearance=RodClearanceSnug);

      // Latch Rod
      *for (i = [1,-1])
      translate([0,latchRodOffset*i,0])
      Rod2d(rod=latchRod, clearance=RodClearanceLoose);
    }

    // Bushing
    translate([0,0,BushingHeight(breechBushing) - BushingDepth(breechBushing)+TeeRimWidth(receiver)])
    //rotate([0,0,0])
    mirror([0,0,1])
    Bushing(breechBushing);

    // Tee Rim
    translate([0,0,-0.001])
    TeeRim(tee=receiver, height=TeeRimWidth(receiver));
  }
}


module back_tee_housing(receiver=Spec_TeeThreeQuarterInch(),
                        stock=Spec_PipeThreeQuarterInch(),
                        rod=Spec_RodFiveSixteenthInch(),
                        wall=tee_overlap,
                        support=true) {

  block_length = TeeRimWidth(receiver)*3;

  render()
  translate([(-TeeWidth(receiver)/2) + TeeRimWidth(receiver),0,0])
  rotate([0,-90,0])
  union() {
    difference() {
      union() {
        linear_extrude(height=block_length)
        difference() {
        
          // Rails
          color("Red")
          hull() {
            ForendRail(railClearance=RodClearanceSnug());
            circle(r=TeeRimDiameter(receiver)/2 + wall);
            
            rotate([0,0,180])
            translate([TeeCenter(receiver)-block_length,-(grip_width/2)-0.125,0])
            square([block_length,grip_width+0.25]);
          }
          
          // Stock Pipe
          Pipe2d(pipe=stock, clearance=PipeClearanceLoose);
          
          // Rails
          ForendRods(receiver, rod, wall=wall, railClearance=RodClearanceLoose);
        
          // Bottom Tee Housing Slot
          translate([-TeeCenter(receiver)-TeeRimRadius(receiver)-0.095,-(grip_width/2)-0.025])
          square([TeeCenter(receiver)+0.015,grip_width+0.05]);
        }
      
        // Back Housing Socket
        translate([-TeeRimRadius(receiver)-0.25,0,TeeRimWidth(receiver)+0.05])
        TeeHousingTabRear(length=block_length-TeeRimWidth(receiver)-0.05);
      }

      // Back Tee Rim
      translate([0,0,-0.1])
      cylinder(r=TeeRimDiameter(receiver)/2, h=TeeRimWidth(receiver) + 0.1);
    }
  }
}
module tee_housing_plater(receiver=Spec_TeeThreeQuarterInch(), debug=false) {
  translate([0,3,0])
  *front_tee_housing(debug=debug);

  rotate([0,135,0])
  bottom_tee_housing(support=true, debug=false);

  translate([0,-3,(TeeWidth(receiver)/2)+(TeeRimWidth(receiver)*2)])
  rotate([0,-90,0])
  *back_tee_housing(debug=debug);
}


!scale([25.4, 25.4, 25.4])
tee_housing_plater();


module Reference_TeeHousing(receiver=Spec_TeeThreeQuarterInch()) {

  translate([1,0,0])
  rotate([0,-90,180])
  front_tee_housing(receiver, debug=false);

  bottom_tee_housing(support=true, debug=false);

  back_tee_housing(debug=false);
}

scale([25.4, 25.4, 25.4]) {
  %Reference();
  //rotate([0,-45,0])
  Reference_TeeHousing();
}