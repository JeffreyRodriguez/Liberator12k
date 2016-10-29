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

frameFrontLength = 0.75;
frameFrontOffsetX = max(BARREL_OFFSET_X, LowerPivotBoltOffsetX()+BearingOuterRadius(PivotBearing())+WALL);

actuatorTopZ = CYLINDER_OFFSET_Z + CylinderRadius()+CYLINDER_CLEARANCE+ACTUATOR_HEIGHT;

module PipeHousingFront(extraFront=EXTRA_FRONT, extraRear=0) {
  render()
  difference() {
    union() {
        
      // Match the top of the lower-receiver
      linear_extrude(height=actuatorTopZ-ManifoldGap())
      hull()
      intersection() {
        translate([ReceiverLugFrontMinX()-extraRear,-1])
        square([ReceiverLugFrontLength()+extraFront+extraRear, 2]);
        
        projection(cut=true)
        translate([0,0,ManifoldGap()])
        Lower(showTrigger=false);
      }
      
      ReceiverLugFront(extraHeight=ManifoldGap(2));
    }
    
    // Front slide cutouts
    for (m = [0,1])
    mirror([0,m,0]) {
      translate([ReceiverLugFrontMinX()-ManifoldGap(),
                 PipeOuterRadius(pipe=BARREL_PIPE)+WALL,
                 WALL-(PipeClearance(BARREL_PIPE, PipeClearanceLoose())/2)])
      cube([2,
            GripWidth(),
            PipeOuterDiameter(pipe=BARREL_PIPE, clearance=PipeClearanceLoose())]);
    }
    
    Actuator(cutter=true);
    
    // Striker Rod
    translate([0,0,PipeOuterRadius(RECEIVER_PIPE)+WALL])
    rotate([0,90,0])
    Rod(rod=DEFAULT_STRIKER, clearance=RodClearanceSnug(), length=5);
  }
}

module PipeHousingRear(extraRear=EXTRA_REAR) {
  render()
  difference() {
    union() {
      hull() {
        
        // Match the top of the lower-receiver
        linear_extrude(height=ManifoldGap())
        intersection() {
          translate([ReceiverLugRearMinX()-extraRear,-1])
          square([ReceiverLugRearLength()+extraRear, 2]);
          
          projection(cut=true)
          translate([0,0,ManifoldGap()])
          Lower(showTrigger=false);
        }
        
        // Main body
        translate([ReceiverLugRearMaxX(),0,BARREL_OFFSET_Z])
        rotate([0,-90,0])
        cylinder(r=PipeOuterRadius(RECEIVER_PIPE)+WALL,
                 h=ReceiverLugRearLength()+extraRear,
               $fn=40);
        
        // Rear cap
        translate([ReceiverLugRearMaxX()
                      -PipeThreadLength(RECEIVER_PIPE)
                      -extraRear,0,BARREL_OFFSET_Z])
        rotate([0,-90,0])
        cylinder(r=PipeOuterRadius(RECEIVER_PIPE),
                 h=0.5,
               $fn=PipeFn(RECEIVER_PIPE));
      }
      
      ReceiverLugRear(extraHeight=ManifoldGap(2));
    }
    
    // Striker Rod
    translate([0,0,PipeOuterRadius(RECEIVER_PIPE)+WALL])
    rotate([0,-90,0])
    Rod(rod=DEFAULT_STRIKER, clearance=RodClearanceLoose(), length=5);
    
    Actuator(cutter=true);
  }
}

module Slide() {
  color("LightBlue", 0.5)
  render()
  difference() {
    union() {
      translate([ReceiverLugRearMinX(),-0.125-(GripWidth()/2),WALL])
      *cube([LowerMaxX()+abs(ReceiverLugRearMinX())+SLIDE_TRAVEL, GripWidth()+0.25, PipeOuterDiameter(BARREL_PIPE)]);
      
      // Block to fill the space between receiver lugs
      translate([ReceiverLugRearMaxX()+ManifoldGap(),-GripWidth()/2,0])
      cube([ReceiverLugFrontMinX()+abs(ReceiverLugRearMaxX())-0.01,
            GripWidth(),
            PipeOuterDiameter(BARREL_PIPE) + (WALL*2)]);
    }
    
    *translate([ReceiverLugFrontMinX() - 0.01,-PipeOuterRadius(BARREL_PIPE) - WALL,0])
    cube([ReceiverLugFrontLength()+SLIDE_TRAVEL+0.01, PipeOuterDiameter(BARREL_PIPE) + (WALL*2), 1]);
    
    *translate([ReceiverLugRearMaxX() - 0.01,-PipeOuterRadius(BARREL_PIPE) - WALL,0])
    cube([SLIDE_TRAVEL+0.01, PipeOuterDiameter(BARREL_PIPE) + (WALL*2), 1]);
    

    translate([0.5,0,BARREL_OFFSET_Z])
    FiringPinRetainer();
  }
}

Slide();

module FrontPivotLug(cutter=false) {
  clearance = cutter ? 0.005 :0;
  
  // Lugs for the pivot arms
  translate([frameFrontOffsetX-clearance,-0.625-clearance-ManifoldGap(2),LowerPivotBoltOffsetZ()-clearance])
  cube([frameFrontLength+(clearance*2), 1.25+(clearance*2)+ManifoldGap(4), 0.25+(clearance*2)]);
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
      translate([frameFrontOffsetX,-0.25,LowerPivotBoltOffsetZ()])
      cube([frameFrontLength, 0.5, abs(LowerPivotBoltOffsetZ())]);
      
      FrontPivotLug(cutter=false);
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
  
  // Pivot arms
  render()
  difference() {
    for (m = [0,1])
    mirror([0,m,0])
    hull() {
    
      translate([LowerPivotBoltOffsetX(),0.25+ManifoldGap(),LowerPivotBoltOffsetZ()])
      rotate([-90,0,0])
      cylinder(r=BearingOuterRadius(PivotBearing())+WALL, h=bottomArmWidth,
               $fn=Resolution(15,40));
      
      // Bottom Arm
      translate([frameFrontOffsetX,
                 0.25+ManifoldGap(),
                 LowerPivotBoltOffsetZ()-WALL])
      cube([frameFrontLength+WALL,bottomArmWidth,BearingOuterRadius(PivotBearing())+(WALL*2)]);
    }
    
    FrontPivotLug(cutter=true);
  }
}

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

function PivotBearing() = Spec_Bearing608();

function LowerPivotBoltOffsetX() = LowerMaxX() + BearingOuterRadius(PivotBearing()) + WALL;
function LowerPivotBoltOffsetZ() = CYLINDER_OFFSET_Z
                                 - CylinderRadius()
                                 - CYLINDER_CLEARANCE
                                 - BearingOuterRadius(PivotBearing())
                                 - WALL;

module LowerPivotLug() {
  height = LowerGuardHeight()
           + CYLINDER_OFFSET_Z
           - CylinderRadius()
           - CYLINDER_CLEARANCE;
  render()
  difference() {
    hull() {
      translate([ReceiverLugFrontMinX(), -0.25, -LowerGuardHeight()])
      cube([ManifoldGap(), 0.5, height]);
      
      translate([LowerPivotBoltOffsetX(),0,LowerPivotBoltOffsetZ()])
      rotate([90,0,0])
      cylinder(r=BearingOuterRadius(PivotBearing())+WALL, h=0.5,
               center=true, $fn=Resolution(15,40));
    }
    
    LowerPivotLugBolt(clearance=true);
    
    LowerCutouts();
  }
}

module LowerPivotLugBolt(boltSpec=Spec_BoltM8(),
                             length=UnitsMetric(30),
                             clearance=true) {
  cutter = (clearance) ? 1 : 0;

  color("SteelBlue")
  translate([LowerPivotBoltOffsetX(),
             length-(GripWidth()/2),
             LowerPivotBoltOffsetZ()])
  rotate([90,0,0])
  rotate([0,0,90])
  NutAndBolt(bolt=boltSpec, boltLength=length, clearance=clearance,
              capHeightExtra=cutter, nutBackset=0.06, nutHeightExtra=cutter);
}


// Replacement Lower Middle
Lower(showMiddle=false);

//!scale(25.4) LowerMiddlePlater()
color("DimGrey")
union() {
  LowerMiddle();
  LowerPivotLug();
}

color("Silver")
translate([BARREL_OFFSET_X,0,BARREL_OFFSET_Z])
rotate([0,90,0])
Pipe(pipe=BARREL_PIPE, length=24,
     hollow=true, clearance=undef);

color("Tan")
PipeHousingFront();

color("Tan")
PipeHousingRear();

translate([CYLINDER_OFFSET_X,0,CYLINDER_OFFSET_Z])
rotate([0,90,0])
RevolverCylinder();

RevolverFrameFront();
RevolverFrameTop();

*!scale(25.4)
rotate([0,-90,0])
translate([-ReceiverLugFrontMinX(),0,0])
PipeHousingFront();

*!scale(25.4)
rotate([0,90,0])
translate([-ReceiverLugRearMaxX(),0,0])
PipeHousingRear();
