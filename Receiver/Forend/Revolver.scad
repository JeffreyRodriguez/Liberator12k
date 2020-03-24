include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/RenderIf.scad>;
use <../../Meta/MirrorIf.scad>;

use <../../Meta/Math/Triangles.scad>;

use <../../Shapes/Components/Cylinder Redux.scad>;
use <../../Shapes/Components/Pump Grip.scad>;

use <../Lower/Lower.scad>;
use <../Lower/Trigger.scad>;

use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Helix.scad>;
use <../../Shapes/Bearing Surface.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Shapes/TeardropTorus.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/ZigZag.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Ammo/Shell Slug.scad>;

use <../Receiver.scad>;
use <../Linear Hammer.scad>;
use <../Recoil Plate.scad>;
use <../Charging Pump.scad>;
use <../Lugs.scad>;
use <../Frame.scad>;

/* [What to Render] */

// Configure settings below, then choose a part to render. Render that part (F6) then export STL (F7). Assembly is not for printing.
_RENDER = "Assembly"; // ["Assembly", "FrameSpacer", "RevolverReceiverFront", "Crane", "CraneShield", "CraneSupport", "CraneLatch", "CraneLatchHandle", "Foregrip", "RevolverCylinder"]
//$t = 1; // [0:0.01:1]

_SHOW_ACTION_ROD = true;
_SHOW_BARREL = true;
_SHOW_CHAMBERS = true;
_SHOW_CRANE = true;
_SHOW_CYLINDER = true;
_SHOW_FOREND = true;
_SHOW_FRAME = true;
_SHOW_LATCH = true;
_SHOW_LATCH_HANDLE = true;
_SHOW_RECEIVER = true;
_SHOW_RECEIVER_FRONT = true;
_SHOW_SHIELD = true;

/* [Assembly Transparency] */
_ALPHA_CRANE = 1;              // [0:0.1:1]
_ALPHA_CYLINDER = 1;           // [0:0.1:1]
_ALPHA_FOREND = 1;             // [0:0.1:1]
_ALPHA_LATCH = 1;              // [0:0.1:1]
_ALPHA_LATCH_HANDLE = 1;       // [0:0.1:1]
_ALPHA_RECEIVER_TUBE = 1;      // [0:0.1:1]
_ALPHA_RECEIVER_COUPLING = 1;  // [0:0.1:1]
_ALPHA_RECEIVER_FRONT = 1;     // [0:0.1:1]
_ALPHA_RECOIL_PLATE_HOUSING=1; // [0:0.1:1]
_ALPHA_SHIELD = 1;             // [0:0.1:1]


/* [Assembly Cutaways] */
_CUTAWAY_CRANE = false;
_CUTAWAY_CYLINDER = false;
_CUTAWAY_LATCH = false;
_CUTAWAY_RECEIVER = true;
_CUTAWAY_FOREND = false;

/* [Barrel and Cylinder Dimensions] */
BARREL_LENGTH = 15.5;
BARREL_DIAMETER = 1.0001;
BARREL_CLEARANCE = 0.01;

CYLINDER_DIAMETER = 4;
CYLINDER_LENGTH = 2.75;
CYLINDER_CLEARANCE = 0.005;
CYLINDER_OFFSET = 1.125;
CHAMBER_LENGTH = 3;
CHAMBER_ID = 0.8101;

/* [Ambidexterity] */
CRANE_LEFT_HANDED = false;

/* [Screws] */
GP_BOLT = "#8-32"; // ["M4", "#8-32"]
GP_BOLT_CLEARANCE = 0.015;


// Settings: Lengths
function ShellRimLength() = 0.06;
function ChamberLength() = CHAMBER_LENGTH;
function BarrelLength() = BARREL_LENGTH;
function ActuatorPretravel() = 0;
function CylinderZ() = -(CYLINDER_OFFSET + ManifoldGap());
function WallBarrel() = 0.4375;
function WallSpindle() = 0.25;

function ChamferRadius() = 1/16;
function CR() = 1/16;


// Settings: Vitamins
// ZigZag Cylinder
function CylinderRod() = Spec_RodFiveSixteenthInch();
function SpindleCollarWidth() = 0.32;
function SpindleCollarDiameter() = 0.63;
function SpindleCollarRadius() = SpindleCollarDiameter()/2;

function CraneRod() = Spec_RodOneQuarterInch();
function CraneBolt() = Spec_BoltOneQuarter();
function CraneActuatorBolt() = BoltSpec(GP_BOLT);
assert(CraneActuatorBolt(), "CraneActuatorBolt() is undefined. Unknown GP_BOLT?");



// Shorthand: Measurements
function BarrelRadius(clearance=0)
    = (BARREL_DIAMETER+clearance)/2;

function BarrelDiameter(clearance=0)
    = (BARREL_DIAMETER+clearance);
    
function CylinderDiameter() = CYLINDER_DIAMETER;
function CylinderRadius() = CylinderDiameter()/2;

// Calculated: Lengths
function FrameBoltLength() = 10;
function ReceiverFrontLength() = 0.5;
function ReceiverBackLength() = 0.5;
function ForendLength() = FrameExtension(length=FrameBoltLength())
                        -ReceiverFrontLength()
                        -ReceiverBackLength()
                        -1;
                        
function ForendGasGap() = 0.25;
function CraneSupportLength() = ForendLength()
                             - ChamberLength()
                             - ForendGasGap();


// Calculated: Positions
function ForendMaxX() = ForendLength();
function ForendMinX() = ForendMaxX()-CraneSupportLength();

function RecoilPlateTopZ() = ReceiverOR()
                           + FrameBoltDiameter()
                           + (WallFrameBolt()*2);

// Crane
function CranePivotAngle() = 90;
function WallCrane() = 0.25;

function CranePivotBoltRadius(clearance=0)
    = BoltRadius(CraneBolt(), clearance);
function CranePivotBoltDiameter(clearance=0)
    = BoltDiameter(CraneBolt(), clearance);


function CraneLatchRadius() = BarrelRadius()+0.25;
function CraneLatchTravel() = 0.5;
function CraneLatchLength() = 0.5;
function CraneLengthFront() = 0.5;
function CraneLengthRear() = 0;
function CraneLength() = CraneLengthFront()
                       + CraneLengthRear()
                       + CraneSupportLength();

function CraneMaxX() = ForendMaxX()
                     + CraneLengthFront();
function CraneMinX() = CraneMaxX()-CraneLength();

function CranePivotZ() = 0.5; // CranePivotBoltRadius()+WallCrane();
function CranePivotY() = FrameBoltY()+FrameBoltRadius()-CranePivotBoltRadius();
echo("CranePivotZ: ", CranePivotZ());
echo("CranePivotY: ", CranePivotY());

function CranePivotHypotenuse() = pyth_A_B(CranePivotY(), CranePivotZ());
function CranePivotPinAngle() = CranePivotHypotenuse()*asin(CranePivotZ());

function CraneBodyRadius() = CranePivotY()+CranePivotBoltRadius()+WallCrane();
function CraneNeckRadius() = BarrelRadius()+WallBarrel()+WallCrane()+0.125;

function CraneLatchMinX() = CraneMaxX();
function CraneLatchMaxX() = CraneLatchMinX()+CraneLatchLength();

function CraneLatchHandleRadius() = CraneBodyRadius()+0.375;
function CraneLatchHandlePivotAngle() = 20;
function CraneLatchHandlePivotZ() = 0;//CylinderZ()-0.5;
function CraneLatchHandleZ() = CylinderZ()-0.75;
function CraneLatchHandleY() = 1;
function CraneLatchHandleMaxX() = CraneMaxX()-CraneLengthFront();
function CraneLatchHandleMinX() = CraneMinX();
function CraneLatchHandleLength() = CraneLatchHandleMaxX()-CraneLatchHandleMinX();

function CylinderHeight()=CYLINDER_LENGTH;
function CylinderMaxX() = ShellRimLength()+CylinderHeight();

function GasPortWidth() = 0.75;
function GasPortHeight() = 0.25;

function GasPortMinZ() = FrameBoltZ()-(GasPortHeight()/2);//CylinderZ()+CylinderRadius();

function GasPortMinX() = CylinderMaxX();
function GasPortMaxX() = FrameExtension(); //ForendMaxX()+CraneLengthFront();
function GasPortLength() = GasPortMaxX()- GasPortMinX();

// Pivot modules
module CranePivotPath(clearance=BARREL_CLEARANCE, $fn=Resolution(30,90)) {
  majorRadius = CranePivotHypotenuse()+BarrelRadius(clearance);
  majorDiameter = majorRadius*2;
  
  minorRadius = CranePivotHypotenuse()-BarrelRadius(clearance);
  minorDiameter = minorRadius*2;

  // Clear the barrel through pivot motion
  translate([CylinderMaxX(),0,CranePivotZ()])
  rotate([0,90,0])
  linear_extrude(height=FrameExtension()-CylinderMaxX())
  union() {
    for (M = [0,1]) mirror([0,M]) // Mirrored for ambidexterity
    translate([0,CranePivotY()])
    rotate(-90+((CranePivotPinAngle()/2)+5))
    semidonut(major=majorDiameter,
              minor=minorDiameter,
              angle=90+(CranePivotPinAngle()/2)+5); // TODO: Why is this off by 5 degrees?

    // Round off the pointy 
    for (M = [0,1]) mirror([0,M]) // Mirrored for ambidexterity
    translate([-(1/2)-clearance, -CranePivotY()+majorRadius])
    RoundedBoolean(r=(1/2)+clearance, edgeOffset=0,
                    angle=-90);
  }
}
module CranePivotPosition(Y=CranePivotY(), Z=CranePivotZ(),
                          angle=CranePivotAngle(), factor=1) {
  translate([0,Y,Z])
  rotate([angle*factor,0,0])
  translate([0,-Y,-Z])
  children();
}
module CraneLatchHandlePosition(Z=CraneLatchHandlePivotZ(),
                          angle=CraneLatchHandlePivotAngle(), factor=1) {
  translate([0,0,Z])
  rotate([angle*factor,0,0])
  translate([0,0,-Z])
  children();
}


// Vitamins
module Barrel(barrelLength=BarrelLength(),
              clearance=0.01, cutter=false,
              alpha=1, debug=false) {

  clear = (cutter ? clearance : 0);
  clear2 = clear*2;

  color("Silver", alpha) DebugHalf(enabled=debug) RenderIf(!cutter)
  translate([(cutter?0:ChamberLength()),0,0])
  rotate([0,90,0])
  cylinder(r=BarrelRadius()+clear,
           h=barrelLength+(cutter?ChamberLength():0),
           $fn=Resolution(20,50));
}

module RevolverSpindle(cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") RenderIf(!cutter)
  translate([RecoilPlateRearX(),0,CylinderZ()])
  rotate([0,90,0])
  SquareRod(CylinderRod(),
      length=CraneMaxX()-RecoilPlateRearX()+0.5
            +ManifoldGap(3), 
      clearance=cutter?RodClearanceSnug():undef);


  // Rearward shaft collar
  *color("SteelBlue")
  translate([ManifoldGap(),0,CylinderZ()])
  rotate([0,90,0])
  cylinder(r=SpindleCollarRadius()+clear,
           h=SpindleCollarWidth(),
           $fn=Resolution(20,50));
}

module CranePivotPin(cutter=false, teardrop=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") RenderIf(!cutter)
  translate([CylinderMaxX()-ManifoldGap(),CranePivotY(),CranePivotZ()])
  rotate([0,90,0])
  NutAndBolt(bolt=CraneBolt(), head="socket", nut="heatset",
           boltLength=CraneMaxX()-CylinderMaxX()
                     -BoltSocketCapHeight(CraneBolt())
                     +ManifoldGap(2),
           clearance=cutter?clearance:0,
           capHeightExtra=cutter?1:0,
           nutHeightExtra=cutter?CraneLengthRear():0,
           teardrop=teardrop&&cutter);

}



module CraneLatchActuatorBolt(cutter=false, teardrop=false, clearance=0.01) {
}
// Cutters
module GasPort(cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  // The gas port
  *translate([GasPortMinX(),
             -(GasPortWidth()/2)-clear,
             GasPortMinZ()-clear])
  ChamferedCube([GasPortLength(),
        GasPortWidth()+clear2,
        GasPortHeight()+clear2], r=CR());
  
  
  // Clear out the area from barrel to gas port
  *translate([GasPortMinX(),
             -(GasPortWidth()/2)-clear,
             0])
  ChamferedCube([ForendMinX()-CylinderMaxX(),
        GasPortWidth()+clear2,
        GasPortMinZ()+GasPortHeight()+clear], r=CR());
  
}

// Printed Parts
module RevolverReceiverFront(debug=false, alpha=_ALPHA_RECEIVER_FRONT) {
  length = abs(RecoilPlateRearX());
  
  color("YellowGreen", alpha)
  render() DebugHalf(enabled=debug)
  difference() {
    translate([RecoilPlateRearX(),0,0])
    union() {
      
      FrameSupport(length=length,
                   extraBottom=0.125+1);
      
      ReceiverCouplingPattern(length=length, frameLength=length);

      // Backing plate for the cylinder
      translate([0,0,CylinderZ()])
      rotate([0,90,0])
      ChamferedCylinder(r1=(BarrelRadius()*3)+(CR()*2), r2=CR(),
               h=length-ManifoldGap(), $fn=Resolution(80, 200));
    }
    
    FrameBolts(cutter=true);

    RecoilPlate(cutter=true);

    RecoilPlateFiringPinAssembly(cutter=true);

    translate([RecoilPlateThickness(),0,0])
    ChargingRod(clearance=RodClearanceSnug(), cutter=true);

    RevolverSpindle(cutter=true);
  }
}


module CraneLatchHandle(cutter=false, clearance=0.01,
                        alpha=_ALPHA_LATCH_HANDLE, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Tan", alpha) RenderIf(!cutter)
  difference() {
    union() {
      
      intersection() {
        translate([CraneLatchHandleMinX(), 0, 0])
        rotate([0,90,0])
        ChamferedCylinder(r1=CraneLatchHandleRadius()+clear, r2=CR(),
                          h=CraneLatchHandleLength()-(cutter?0:clearance),
                          chamferBottom=!cutter,
                          $fn=Resolution(20,80));

        // Square off the top
        translate([CraneLatchHandleMinX(),0,0])
        for(M = [0,1]) mirror([0,M,0]) {
          rotate([-CraneLatchHandlePivotAngle(),0,0])
          translate([0,-CR(),0])
          mirror([0,0,1])
          ChamferedCube([CraneLatchHandleLength(),
                        CraneLatchHandleRadius()+CR()+clear,
                        CraneLatchHandleRadius()+clear], r=CR());
        }
      }
    }
    
    CraneLatchActuatorBolt(cutter=true, teardrop=true);

    // Finger Cutouts
    if (!cutter)
    translate([CraneLatchHandleMinX(),0,0])
    for(M = [0,1]) mirror([0,M,0]) {
      rotate([-CraneLatchHandlePivotAngle(),0,0])
      translate([0,CraneNeckRadius(),0])
      rotate([0,90,0])
      ChamferedCircularHole(r1=0.25,
                            r2=CraneBodyRadius()-CraneNeckRadius()-CR(),
                            h=CraneLatchHandleLength());
    }
  
    // Cutout the crane neck chamfer
    translate([CraneMaxX()-CraneLengthFront(),0,0])
    rotate([0,-90,0])
    ChamferedCircularHole(r1=CraneNeckRadius()-(cutter?0:clearance),
                          r2=CraneBodyRadius()-CraneNeckRadius()-CR(),
                          h=CraneLatchHandleLength(),
                          chamferTop=!cutter,
                          teardropBottom=false, teardropTop=false,
                          $fn=Resolution(20,80));
    
    latchCutterDepth=0.1875;
    latchCutterWidth=0.25;
          
    // Lower segment
    for (M = [0,1]) mirror([0,M,0])
    translate([CraneLatchHandleMinX()+0.25, 0, 0])
    rotate([0,90,0])
    HelixSegment(radius=CraneNeckRadius(),
                 angle=CraneLatchHandlePivotAngle(),
                 width=latchCutterWidth, depth=latchCutterDepth,
                 bottomExtra=-latchCutterWidth/2,
                 topExtra=-latchCutterWidth/2,
                 teardropBottom=true,
                 teardropTop=true);
  }
}
module CraneLatchHandle_print() {
  rotate([0,-90,0])
  translate([-CraneLatchHandleMinX(), 0, 0])
  CraneLatchHandle();
}
module CraneLatch(teardrop=false, clearance=0.01,
             $fn=Resolution(30,100), alpha=_ALPHA_LATCH, debug=false) {
  pivotCutterRadius = RodRadius(CylinderRod())+WallCrane()+clearance;
                       
  bodyRadius = CraneBodyRadius();

  color("YellowGreen", alpha)
  render() DebugHalf(enabled=debug)
  difference() {
    union() {
      hull() {

        // Around the crane pivot rods
        for (Y = [1,-1])
        translate([CraneLatchMinX(),CranePivotY()*Y,CranePivotZ()])
        rotate([0,90,0])
        ChamferedCylinder(r1=CranePivotBoltRadius()+WallCrane(), r2=CR(),
                 h=CraneLatchLength(),
                 teardropTop=true);

        intersection() {
          
          // Body around the barrel
          translate([CraneLatchMinX(),0,0])
          rotate([0,90,0])
          ChamferedCylinder(r1=bodyRadius, r2=CR(),
                   h=CraneLatchLength(),
                   teardropTop=true);

          // Square off the top
          translate([CraneLatchMinX(),
                     -(bodyRadius+0.5),
                     CylinderZ()-bodyRadius])
          cube([CraneLatchLength(),
                (bodyRadius+0.5)*2,
                -CylinderZ()+bodyRadius+CranePivotZ()]);
          
        }
      }

      // Around the spindle
      translate([CraneLatchMinX(),0,CylinderZ()])
      rotate([0,90,0])
      ChamferedCylinder(r1=SpindleCollarRadius()+WallSpindle(), r2=CR(),
                        h=CraneLatchLength(),
                 teardropTop=true);
    }

    // Clear latch support that goes around the barrel
    translate([ForendMaxX()+CraneLengthFront()-ManifoldGap(),0,0])
    rotate([0,90,0])
    cylinder(r=CraneLatchRadius()+clearance,
             h=CraneLatchLength()+ManifoldGap(2));
      
    // Chamfer the latch support hole
    translate([ForendMaxX()+CraneLengthFront()-ManifoldGap(),0,0])
    rotate([0,90,0])
    HoleChamfer(r1=CraneLatchRadius()+clearance,
                r2=CR(),
                teardrop=true);

    CranePivotPath(clearance=0.01);

    RevolverSpindle(cutter=true);

    Barrel(cutter=true, clearance=(BARREL_CLEARANCE*2));

    for (M = [0,1]) mirror([0,M,0]) // Ambidexterity mirror
    CranePivotPin(cutter=true);
  }

}

module CraneLatch_print() {
  rotate([0,90,0]) translate([-CraneLatchMaxX(),0,0])
  CraneLatch();
}

module Crane(teardrop=false, clearance=0.01,
             $fn=Resolution(30,100), alpha=_ALPHA_CRANE, debug=false) {
  pivotCutterRadius = RodRadius(CylinderRod())+WallCrane()+clearance;

  color("OliveDrab", alpha)
  render() DebugHalf(enabled=debug)
  difference() {
    union() {
    
      // Latch handle lower support
      hull() for (Z = [CylinderZ(), CylinderZ()-0.5])
      translate([CraneMinX(), 0, Z])
      rotate([0,90,0])
      ChamferedCylinder(r1=0.75, r2=CR(), h=CraneLength(),
                        chamferBottom=false);
      
      // Neck
      intersection() {
        union() {
  
          // Sloped transition to the body
          translate([CraneMaxX()-CraneLengthFront(),0,0])
          rotate([0,-90,0])
          HoleChamfer(r1=CraneNeckRadius(),
                      r2=CraneBodyRadius()-CraneNeckRadius()-CR());
          
          // Neck around the barrel support
          translate([CraneMinX(),0,0])
          rotate([0,90,0])
          ChamferedCylinder(r1=CraneNeckRadius(), r2=CR(),
                   h=CraneLength(), chamferBottom=false,
                   teardropTop=true);
          
        }

        // Square off the top
        translate([CraneMinX(),-(CraneBodyRadius()+0.5),0])
        mirror([0,0,1])
        cube([CraneLength(),
             (CraneBodyRadius()+0.5)*2,
              CraneBodyRadius()]);
      }
      
      // Forward Body
      hull() {

        // Around the crane pivot rods
        for (Y = [1,-1])
        translate([CraneMaxX(),CranePivotY()*Y,CranePivotZ()])
        rotate([0,-90,0])
        ChamferedCylinder(r1=CranePivotBoltRadius()+WallCrane(),
                          r2=CR(),
                          h=CraneLengthFront());

        intersection() {
          
          // Body around the barrel
          translate([CraneMaxX(),0,0])
          rotate([0,-90,0])
          ChamferedCylinder(r1=CraneBodyRadius(), r2=CR(),
                   h=CraneLengthFront(), chamferBottom=true,
                   teardropTop=false);

          // Square off the top
          translate([CraneMinX(),-(CraneBodyRadius()+0.5),-CraneBodyRadius()])
          cube([CraneLength(),
               (CraneBodyRadius()+0.5)*2,
                CraneBodyRadius()]);
          
        }
      }
    }
    
    CraneSupport(cutter=true);
    
    CraneLatchHandle(cutter=true);

    CranePivotPath();

    for (M = [0,1]) mirror([0,M,0]) // Ambidexterity mirror
    CranePivotPin(cutter=true);

    RevolverSpindle(cutter=true);
    
    // Revolver spindle (and then some) slot
    slotWidth = 0.5;
    translate([CraneMinX()-CR(), -(slotWidth/2), CylinderZ()-0.5])
    ChamferedCube([CraneLength()-CraneLengthFront()+CR(), slotWidth, 1], r=CR());

    Barrel(cutter=true, clearance=(BARREL_CLEARANCE*2));
  }
}

module Crane_print() {
  rotate(90) rotate([0,90,0]) translate([-CraneMaxX(),0,0])
  Crane();
}

module CraneShield(clearance=0.01, debug=false, alpha=_ALPHA_SHIELD) {

  pivotCutterRadius = RodRadius(CylinderRod())+WallCrane()+clearance;
  craneRadius = CranePivotY()+CranePivotBoltRadius()+WallCrane();
  cylinderMaxX = 2.75+ShellRimLength();
  length = CraneMinX()-cylinderMaxX-clearance;

  color("YellowGreen", alpha) render() DebugHalf(enabled=debug)
  difference() {
    union() {
      
      // Around the crane pivot rods
      hull()
      for (Z = [0,CranePivotZ()])
      for (Y = [1,-1])
      translate([CraneMinX(),CranePivotY()*Y,Z])
      rotate([0,-90,0])
      ChamferedCylinder(r1=CranePivotBoltRadius()+WallCrane(), r2=CR(),
                        h=length,
                        chamferBottom=false,
                        chamferTop=false, teardropTop=true,
                        $fn=Resolution(20,40));

      // Around cylinder
      translate([CraneMinX(),0,CylinderZ()])
      rotate([0,-90,0])
      ChamferedCylinder(r1=2, r2=CR(),
                        h=length,
                        $fn=Resolution(30,100));
    }

    // Cutout for chambers
    translate([0,0,CylinderZ()])
    rotate([0,90,0])
    ChamferedCylinder(r1=abs(CylinderZ())+BarrelRadius()+(CR()/2), r2=1/64,
                       h=ChamberLength()+ShellRimLength()+clearance,
                       $fn=Resolution(30,90));

    RevolverSpindle(cutter=true);

    Barrel(cutter=true, clearance=(BARREL_CLEARANCE*2));
    
    CranePivotPath();
    
    for (M = [0,1]) mirror([0,M,0])
    CranePivotPin(cutter=true);
  }
}

module CraneShield_print() {
  rotate([0,90,0]) translate([-CraneMinX(),0,0])
  CraneShield();
}

module CraneSupport(cutter=false, clearance=0.01,
                    debug=false, alpha=_ALPHA_FOREND,
                    $fn=Resolution(30,100)) {

  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  // Forward plate
  color("Tan", alpha)
  render() DebugHalf(enabled=debug)
  difference() {
    union() {

      // Around the barrel
      translate([ForendMinX()-clear,0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=BarrelRadius()+WallBarrel()+clear, r2=CR(),
               h=CraneSupportLength()+clear);

      // Join the barrel to the frame
      for (M = [0,1]) mirror([0,M,0])
      translate([ForendMaxX()-clear,
                 BarrelRadius()+WallBarrel(),
                 CranePivotZ()-CranePivotBoltRadius()-WallCrane()])
      rotate([0,-90,0])
      Fillet(r=CR()+clear, h=CraneSupportLength()+clear2,
                     inset=true, taperEnds=true);

    // Crane Pivot Supports
    translate([ForendMinX(),0,0])
    hull() {

        // Around the upper bolts
        FrameSupport(length=CraneSupportLength());

        // Around the crane pivot pin
        for (M = [0,1]) mirror([0,M,0])
        translate([0,CranePivotY(),CranePivotZ()])
        rotate([0,90,0])
        ChamferedCylinder(r1=CranePivotBoltRadius()+WallCrane(), r2=CR(),
                           h=CraneSupportLength());
      }
    }
    
    if (!cutter) {

      // Cutout for a picatinny rail insert
      translate([-ManifoldGap(), -UnitsMetric(15.6/2), FrameTopZ()-0.0625])
      cube([FrameExtension()+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

      FrameBolts(cutter=true);

      Barrel(cutter=true, clearance=BARREL_CLEARANCE);

      ChargingRod(cutter=true);
      
      GasPort(cutter=true);

      RevolverSpindle(cutter=true);
      
      for (M = [0,1]) mirror([0,M,0])
      CranePivotPin(cutter=true);
    }
  }
}

module CraneSupport_print() {
  rotate([0,-90,0]) translate([-ForendMinX(),0,0])
  CraneSupport();
}

module CraneLatchSupport(debug=false, alpha=_ALPHA_FOREND, $fn=Resolution(30,100)) {
  length = 1-CraneLengthFront();
  // Forward plate
  color("Tan", alpha)
  render() DebugHalf(enabled=debug)
  difference() {
    union() {
      
      translate([CraneLengthFront(),0,0])
      intersection() {
        translate([ForendMaxX()-length,-1,BarrelRadius()/2])
        cube([length+CraneLengthFront(), 2, FrameTopZ()-(BarrelRadius()/2)]);
        
        CranePivotPath(clearance=0);
      }

      // Around the barrel
      translate([ForendMaxX()+CraneLengthFront(),0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=CraneLatchRadius(), r2=CR(),
               h=length);

    // Crane Pivot Supports
    translate([ForendMaxX()-ManifoldGap(),0,0]) {
      
      FrameSupport(length=length+CraneLengthFront(),
                   extraBottom=0.125);

      
      translate([CraneLengthFront(),0,0])
      hull() {

          // Around the upper bolts
          FrameSupport(length=length);

          // Around the crane pivot pin
          *for (M = [0,1]) mirror([0,M,0])
          translate([0,CranePivotY(),CranePivotZ()])
          rotate([0,90,0])
          ChamferedCylinder(r1=CranePivotZ(), r2=CR(),
                             h=length);
        }
      }
    }

    // Cutout for a picatinny rail insert
    translate([-ManifoldGap(), -UnitsMetric(15.6/2), FrameTopZ()-0.0625])
    cube([FrameExtension()+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

    FrameBolts(cutter=true);

    Barrel(cutter=true, clearance=BARREL_CLEARANCE);

    ChargingRod(cutter=true);
    
    GasPort(cutter=true);
    
    for (M = [0,1]) mirror([0,M,0])
    CranePivotPin(cutter=true);
  }
}

module CraneLatchSupport_print() {
  rotate([0,90,0]) translate([-ForendMaxX(),0,0])
  CraneLatchSupport();
}
module FrameSpacer(length=ForendMinX(), debug=false, alpha=_ALPHA_FOREND) {
  color("Tan", alpha)
  render() DebugHalf(enabled=debug)
  difference() {
    union() {
      FrameSupport(length=length,
                   extraBottom=0.125);
      
      translate([0,-(3/2),CranePivotZ()])
      ChamferedCube([CylinderMaxX(),
                     3,
                     FrameBoltZ()-CranePivotZ()], r=CR());
    }
    
    for (M = [0,1]) mirror([0,M,0])
    for (F = [0,1]) CranePivotPosition(factor=F)
    translate([0,0,CylinderZ()])
    rotate([0,90,0])
    cylinder(r=CYLINDER_DIAMETER/2,
             h=ForendMinX()+ManifoldGap(2),
             $fn=Resolution(30,80));

    // Picatinny rail cutout
    translate([-ManifoldGap(), -UnitsMetric(15.6/2), FrameTopZ()-0.0625])
    cube([length+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

    FrameBolts(cutter=true);
    
    ChargingRod(cutter=true);
    
    GasPort(cutter=true);
  }
}

module FrameSpacer_print() {
  rotate([0,-90,0])
  translate([0,0,-FrameBoltZ()])
  FrameSpacer();
}


module RevolverReceiverFront_print() {
  rotate([0,-90,0]) translate([-RecoilPlateRearX(),0,0])
  RevolverReceiverFront();
}


module RevolverCylinder(supports=true, chambers=false,
                             chamberBolts=false,
                             debug=_CUTAWAY_CYLINDER,
                             alpha=_ALPHA_CYLINDER) {                               
  OffsetZigZagRevolver(diameter=CYLINDER_DIAMETER, height=CYLINDER_LENGTH,
      centerOffset=abs(CylinderZ()),
      chamberRadius=BarrelRadius(),
      chamberClearance=BARREL_CLEARANCE,
      chamberInnerRadius=CHAMBER_ID/2,
      extraTop=ActuatorPretravel(),
      supportsBottom=false, supportsTop=supports, chamberBolts=chamberBolts,
      chambers=chambers, chamberLength=ChamberLength(),
      debug=debug, alpha=alpha) {
  
    translate([0,0,-ManifoldGap()])
    cylinder(r=SpindleCollarRadius()+0.005,
             h=CYLINDER_LENGTH-0.25+ManifoldGap(2), $fn=60);
  }
}


module RevolverCylinder_print() {
  translate([0,0,2.75])
  rotate([0,180,0])
  RevolverCylinder(supports=true);
}

// Assemblies
module RevolverForendAssembly(stock=true,
                               pipeAlpha=1, debug=false) {

  if (_SHOW_RECEIVER_FRONT)
  RevolverReceiverFront(debug=debug);

  translate([0,0,0]) {

    if (_SHOW_ACTION_ROD)
    ChargingPumpAssembly(debug=debug);

    if (_SHOW_BARREL)
    Barrel(debug=debug);

    CranePivotPosition(factor=Animate(ANIMATION_STEP_UNLOAD)
                     -Animate(ANIMATION_STEP_LOAD)) {

      if (_SHOW_CYLINDER)
      translate([ShellRimLength(),0,CylinderZ()])
      rotate([0,90,0])
      rotate(-360/6/2*SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.25, end=0.8))
      rotate(-360/6/2*SubAnimate(ANIMATION_STEP_CHARGE, start=0.4, end=0.98))
      RevolverCylinder(supports=false, chambers=_SHOW_CHAMBERS);

      MirrorIf(CRANE_LEFT_HANDED, [0,1,0])
      CranePivotPin();

      // Latch
      translate([CraneLatchTravel()*(SubAnimate(ANIMATION_STEP_UNLOCK, end=0.5)
                    -SubAnimate(ANIMATION_STEP_LOCK, start=0.5)),0,0])
      {
          RevolverSpindle();
        
          if (_SHOW_LATCH)
          CraneLatch(debug=debug);
      }
          
      if (_SHOW_LATCH_HANDLE)
      CraneLatchHandlePosition(factor=
                               SubAnimate(ANIMATION_STEP_UNLOCK, end=0.5)
                              -SubAnimate(ANIMATION_STEP_LOCK, start=0.5))
      CraneLatchHandle();
      
      if (_SHOW_CRANE)
      Crane(debug=_CUTAWAY_CRANE);
      
      if (_SHOW_SHIELD)
      CraneShield(debug=_CUTAWAY_CRANE);
    }

    if (_SHOW_FOREND) {
      color("Tan", alpha=_ALPHA_FOREND) render()
      union() {
        FrameSpacer(debug=_CUTAWAY_FOREND);
        CraneSupport(debug=_CUTAWAY_FOREND);
        CraneLatchSupport(debug=_CUTAWAY_FOREND);
      }
    }
  }
}

module RevolverFireControlAssembly(debug=false) {

  translate([FiringPinMinX()-1,0,0])
  HammerAssembly(insertRadius=0.75, alpha=0.5);

  RecoilPlateFiringPinAssembly(debug=debug);

  RecoilPlate(debug=debug);

  *Charger();
}

module PumpZigZagRevolverAssembly() {
  if (_SHOW_RECEIVER) {
  translate([-ReceiverFrontLength(),0,0])
  Receiver(debug=_CUTAWAY_RECEIVER,
           pipeAlpha=_ALPHA_RECEIVER_TUBE,
           buttstockAlpha=_ALPHA_RECEIVER_TUBE,

           couplingAlpha=_ALPHA_RECEIVER_COUPLING,
           couplingBoltHead="flat",
           couplingBoltExtension=ReceiverFrontLength(),
           
           frameBolts=_SHOW_FRAME,
           frameBoltLength=FrameBoltLength(),
           frameBoltBackset=ReceiverBackLength(),
  
           triggerAnimationFactor=Animate(ANIMATION_STEP_TRIGGER)
                          -Animate(ANIMATION_STEP_TRIGGER_RESET));

    RevolverFireControlAssembly();
  }

  RevolverForendAssembly(pipeAlpha=0.5, debug=false);
}

if (_RENDER == "Assembly") {
  PumpZigZagRevolverAssembly();
}

scale(25.4) {

  if (_RENDER == "Crane")
  Crane_print();

  if (_RENDER == "CraneShield")
  CraneShield_print();

  if (_RENDER == "CraneSupport")
  CraneSupport_print();

  if (_RENDER == "CraneLatch")
  CraneLatch_print();

  if (_RENDER == "CraneLatchHandle")
  CraneLatchHandle_print();

  if (_RENDER == "FrameSpacer")
  FrameSpacer_print();

  if (_RENDER == "ReceiverFront")
  ReceiverFront_print();

  if (_RENDER == "RevolverReceiverFront")
  RevolverReceiverFront_print();
  
  if (_RENDER == "RevolverCylinder")
  RevolverCylinder_print();
}
