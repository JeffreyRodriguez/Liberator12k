use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Resolution.scad>;

use <../../Vitamins/Bearing.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Lower.scad>;
use <../../Lower/Lower Plater.scad>;

use <../../Components/Firing Pin Retainer.scad>;

use <../../Components/Cylinder.scad>;
use <Pivoted Lower Middle.scad>;
use <Pivot Arms.scad>;

//Spec_PipeThreeQuarterInchSch80()
//Spec_PipeOneInch()
//Spec_PipeOneInchSch80()
//Spec_Tubing1628x1125()

DEFAULT_STRIKER = Spec_RodFiveSixteenthInch();
DEFAULT_BARREL = Spec_RodFiveSixteenthInch();
BARREL_PIPE = Spec_FiveSixteenthInchBrakeLine();
RECEIVER_PIPE = Spec_FiveSixteenthInchBrakeLine();
DEFAULT_TEE = Spec_AnvilForgedSteel_TeeThreeQuarterInch();
WALL = 0.25;
PIPE_LENGTH = 3;

PIPE_EXTRA = PIPE_LENGTH
           - ReceiverLugFrontMaxX()
           + ReceiverLugRearMinX();

EXTRA_REAR = 0.6;
EXTRA_FRONT = LowerWallFront();

CYLINDER_CLEARANCE = 0.025;
CYLINDER_LENGTH = 1.3;

CYLINDER_OFFSET_X = LowerMaxX() + CYLINDER_CLEARANCE;
BARREL_OFFSET_X = CYLINDER_OFFSET_X+CYLINDER_LENGTH+CYLINDER_CLEARANCE;

BARREL_OFFSET_Z = PipeOuterRadius(RECEIVER_PIPE)+WALL;
CYLINDER_OFFSET_Z = BARREL_OFFSET_Z - CylinderChamberOffset();

SLIDE_TRAVEL = 1;

ACTUATOR_WIDTH = 0.7;
ACTUATOR_HEIGHT=0.25;

frameFrontLength = 0.5;
frameFrontOffsetX = max(BARREL_OFFSET_X, LowerPivotX()+BearingOuterRadius(PivotBearing())+WALL);

actuatorTopZ = CYLINDER_OFFSET_Z + CylinderRadius()+CYLINDER_CLEARANCE+ACTUATOR_HEIGHT;

module ZigZagPivotArmLug() {
  PivotArmLug(angle=90, offsetZ=0, height=frameFrontLength);
}


module RevolverFrameFront() {
  
  color("Orange")
  render()
  difference() {
    union() {
      
      hull() {
        
        // Cylinder Rod Sleeve
        translate([frameFrontOffsetX,0,CYLINDER_OFFSET_Z])
        rotate([0,90,0])
        cylinder(r=RodRadius(CylinderRod())+WALL, h=frameFrontLength, $fn=Resolution(15,30));
        
        // Barrel Sleeve
        translate([frameFrontOffsetX,0,BARREL_OFFSET_Z])
        rotate([0,90,0])
        cylinder(r=PipeOuterRadius(BARREL_PIPE)+WALL, h=frameFrontLength, $fn=Resolution(15,30));
        
      }
      
      // Barrel and cylinder rod sleeves
      hull() {
        
        // Cylinder Rod Sleeve
        translate([frameFrontOffsetX,0,CYLINDER_OFFSET_Z])
        rotate([0,90,0])
        cylinder(r=RodRadius(CylinderRod())+WALL, h=frameFrontLength, $fn=Resolution(15,30));
        
        // Interface with pivot arms
        translate([frameFrontOffsetX,-0.625,CYLINDER_OFFSET_Z-CylinderRadius()])
        mirror([0,0,1])
        cube([frameFrontLength,1.25,CYLINDER_CLEARANCE]);
      }
      
      hull() {
        
        // Top bit
        translate([frameFrontOffsetX,
                   -(ACTUATOR_WIDTH/2)-WALL,
                   CYLINDER_OFFSET_Z+CylinderRadius()+CYLINDER_CLEARANCE-WALL])
        cube([frameFrontLength,ACTUATOR_WIDTH+(WALL*2),ACTUATOR_HEIGHT+(WALL*2)]);
        
        // Barrel Sleeve
        translate([frameFrontOffsetX,0,BARREL_OFFSET_Z])
        rotate([0,90,0])
        cylinder(r=PipeOuterRadius(BARREL_PIPE)+WALL, h=frameFrontLength, $fn=Resolution(15,30));
      }
      
      // Spacer and lug support for pivot arms
      translate([frameFrontOffsetX,-0.25,LowerPivotZ()])
      cube([frameFrontLength, 0.5, abs(LowerPivotZ())]);
      
      
      ZigZagPivotArmLug();
    }
        
    // Barrel
    translate([frameFrontOffsetX-ManifoldGap(),
               0,BARREL_OFFSET_Z])
    rotate([0,90,0])
    Pipe(pipe=BARREL_PIPE, clearance=PipeClearanceLoose(), length=frameFrontLength+ManifoldGap(2));
    
    // Cylinder Rod Sleeve
    translate([frameFrontOffsetX-ManifoldGap(),
               0,CYLINDER_OFFSET_Z])
    rotate([0,90,0])
    Rod(rod=CylinderRod(), clearance=RodClearanceLoose(), length=frameFrontLength+ManifoldGap(2));
    
    Actuator(cutter=true);
  }
  
  bottomArmWidth = (GripWidth()/2) -0.125;
}
  
  // Pivot arms
  PivotArms(wall=PivotWall(), height=LowerGuardHeight()+CYLINDER_OFFSET_Z-CylinderRadius()-CYLINDER_CLEARANCE)
  ZigZagPivotArmLug();

module Actuator(cutter=false) {
  clearance = cutter ? 0.01: 0;
  
  color("OliveDrab")
  render()
  difference() {
    translate([ReceiverLugRearMaxX()-0.125,-(ACTUATOR_WIDTH/2)-clearance,CYLINDER_OFFSET_Z + CylinderRadius()+CYLINDER_CLEARANCE-clearance])
    cube([BARREL_OFFSET_X+CYLINDER_LENGTH+0.25+abs(ReceiverLugRearMaxX()), ACTUATOR_WIDTH+(clearance*2), ACTUATOR_HEIGHT+(clearance*2)]);
    
    if (cutter==false)
    translate([LowerMaxX()+RodRadius(ActuatorRod()),0,CYLINDER_OFFSET_Z + CylinderRadius()+CYLINDER_CLEARANCE-0.25])
    Rod(rod=ActuatorRod(), clearance=RodClearanceLoose(), length=ACTUATOR_HEIGHT+0.25+ManifoldGap());
  }
}

Actuator();

module RevolverFrameTop(width=1) {
  hull() {
  }
}

PivotedLowerMiddle();

color("Silver")
translate([BARREL_OFFSET_X,0,BARREL_OFFSET_Z])
rotate([0,90,0])
Pipe(pipe=BARREL_PIPE, length=26,
     hollow=true, clearance=undef);

translate([CYLINDER_OFFSET_X,0,CYLINDER_OFFSET_Z])
rotate([0,90,0])
RevolverCylinder();

RevolverFrameFront();
RevolverFrameTop();
