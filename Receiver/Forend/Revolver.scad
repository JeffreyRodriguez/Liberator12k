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
_RENDER = "Assembly"; // ["Assembly", "FrameSpacer", "RevolverReceiverFront", "Crane", "CraneShield", "CraneSupport", "CraneLatch", "Foregrip", "RevolverZigZagCylinder"]
//$t = 1; // [0:0.01:1]

_SHOW_ACTION_ROD = true;
_SHOW_BARREL = true;
_SHOW_CRANE = true;
_SHOW_CYLINDER = true;
_SHOW_FOREND = true;
_SHOW_FRAME = true;
_SHOW_LATCH = true;
_SHOW_RECEIVER_FRONT = true;
_SHOW_SHIELD = true;

/* [Assembly Transparency] */
_ALPHA_CRANE = 1;              // [0:0.1:1]
_ALPHA_CYLINDER = 1;           // [0:0.1:1]
_ALPHA_FOREND = 1;             // [0:0.1:1]
_ALPHA_LATCH = 1;              // [0:0.1:1]
_ALPHA_RECEIVER_TUBE = 1;      // [0:0.1:1]
_ALPHA_RECEIVER_COUPLING = 1;  // [0:0.1:1]
_ALPHA_RECEIVER_FRONT = 1;     // [0:0.1:1]
_ALPHA_RECOIL_PLATE_HOUSING=1; // [0:0.1:1]


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


// Settings: Lengths
function ShellRimLength() = 0.06;
function ChamberLength() = CHAMBER_LENGTH;
function BarrelLength() = BARREL_LENGTH;
function ActuatorPretravel() = 0.125;
function CylinderZ() = CYLINDER_OFFSET + ManifoldGap();
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
function CraneLatchBolt() = Spec_BoltM4();

// Shorthand: Measurements
function BarrelRadius(clearance=0)
    = (BARREL_DIAMETER+clearance)/2;

function BarrelDiameter(clearance=0)
    = (BARREL_DIAMETER+clearance);

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

function CranePivotRadius(clearance=0)
    = BoltRadius(CraneBolt(), clearance);
function CranePivotDiameter(clearance=0)
    = BoltDiameter(CraneBolt(), clearance);


function CraneLatchTravel() = 0.5;
function CraneLatchLength() = SpindleCollarWidth()+0.25;
function CraneLatchHandleWall() = 0.125;
function CraneLatchGuideWidth() = 0.25;
function CraneLatchHandleZ() = -(CylinderZ()*2);
function CraneLatchHandleMaxZ() = -CylinderZ()
                                  -(SpindleCollarRadius()+WallCrane());

function CraneLengthFront() = 0.5;
function CraneLengthRear() = 0;
function CraneLength() = CraneLengthFront()
                       + CraneLengthRear()
                       + CraneSupportLength();
function CraneMaxX() = ForendMaxX()
                     + CraneLengthFront();
function CraneMinX() = CraneMaxX()-CraneLength();

function CranePivotZ() =  0.5;
function CranePivotY() = FrameBoltY()+FrameBoltRadius()-CranePivotRadius();
echo("CranePivotY: ", CranePivotY());

function CranePivotHypotenuse() = pyth_A_B(CranePivotY(), CranePivotZ());
function CranePivotPinAngle() = CranePivotHypotenuse()*asin(CranePivotZ());

function CraneBodyRadius() = CranePivotY()+CranePivotRadius()+WallCrane();

function CraneLatchMinX() = CraneMaxX();
function CraneLatchMaxX() = CraneLatchMinX()+CraneLatchLength();

function CylinderHeight()=2.75;
function CylinderMaxX() = ShellRimLength()+CylinderHeight();

// Pivot modules
module CranePivotPath(clearance=0.005, $fn=Resolution(30,90)) {

  // Clear the barrel through pivot motion
  for (M = [0,1]) mirror([0,M,0]) // Mirrored for ambidexterity
  translate([CylinderMaxX()+ManifoldGap(),CranePivotY(),CranePivotZ()])
  rotate([0,90,0])
  linear_extrude(height=CylinderMaxX())
  rotate(-90+((CranePivotPinAngle()/2)+5))
  semidonut(major=(CranePivotHypotenuse()*2)+BarrelDiameter(BARREL_CLEARANCE),
            minor=(CranePivotHypotenuse()*2)-BarrelDiameter(BARREL_CLEARANCE),
            angle=90+(CranePivotPinAngle()/2)+5); // TODO: Why is this off by 5 degrees?

}
module CranePivotPosition(Y=CranePivotY(), Z=CranePivotZ(),
                          angle=CranePivotAngle(), factor=1) {
  translate([0,Y,Z])
  rotate([angle*factor,0,0])
  translate([0,-Y,-Z])
  children();
}


// Vitamins
module Barrel(barrelLength=BarrelLength(),
              clearance=0.005, cutter=false,
              alpha=1, debug=false) {

  clear = (cutter ? clearance : 0);
  clear2 = clear*2;

  color("Silver", alpha) DebugHalf(enabled=debug) RenderIf(!cutter)
  translate([ChamberLength()+ShellRimLength(),0,0])
  rotate([0,90,0])
  cylinder(r=BarrelRadius()+clear, h=barrelLength, $fn=Resolution(20,50));
}

module RevolverSpindle(cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") RenderIf(!cutter)
  translate([RecoilPlateRearX(),0,-CylinderZ()])
  rotate([0,90,0])
  SquareRod(CylinderRod(),
      length=CraneMaxX()-RecoilPlateRearX()
            +ManifoldGap(3), 
      clearance=cutter?RodClearanceSnug():undef);


  // Rearward shaft collar
  color("SteelBlue")
  translate([ManifoldGap(),0,-CylinderZ()])
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
           nutHeightExtra=cutter?CraneLengthRear():0,
           teardrop=teardrop&&cutter);

}



// Printed Parts
module RevolverReceiverFront(debug=false, alpha=_ALPHA_RECEIVER_FRONT) {
  length = abs(RecoilPlateRearX());
  
  color("YellowGreen", alpha)
  render() DebugHalf(enabled=debug)
  difference() {
    translate([RecoilPlateRearX(),0,0])
    union() {
      
      translate([0,0,-0.0625])
      FrameSupport(length=length,
                   height=((FrameBoltRadius()+WallFrameBolt())*2)+0.125);
        
      ReceiverCouplingPattern(length=length, frameLength=length);

      // Backing plate for the cylinder
      translate([0,0,-CylinderZ()])
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


module CraneLatch(cutter=false, clearance=0.005,
                  alpha=1, debug=false, $fn=Resolution(20,80)) {
    clear = clearance;
    clear2 = clear*2;

  color("BurlyWood", alpha)
  DebugHalf(enabled=debug) RenderIf(!cutter)
  difference() {

    // Around the spindle
    translate([CraneLatchMinX(),0,-CylinderZ()])
    rotate([0,90,0])
    ChamferedCylinder(r1=SpindleCollarRadius()+WallSpindle(), r2=CR(),
                      h=CraneLatchLength());

    CranePivotPath();

    Barrel(cutter=true, clearance=BARREL_CLEARANCE);

    RevolverSpindle(cutter=true);
  }
}

module CraneLatch_print() {
  rotate([0,90,0]) translate([-CraneLatchMaxX(),0,0])
  CraneLatch();
}

module Crane(teardrop=false, clearance=0.005,
                     $fn=Resolution(30,100), alpha=1, debug=false) {
  pivotCutterRadius = RodRadius(CylinderRod())+WallCrane()+clearance;
                       
  bodyRadius = CraneBodyRadius();

  color("OliveDrab", alpha)
  render() DebugHalf(enabled=debug)
  difference() {
    intersection() {
      union() {
        hull() {

          // Around the crane pivot rods
          for (Y = [1,-1])
          translate([CraneMinX(),CranePivotY()*Y,CranePivotZ()])
          rotate([0,90,0])
          ChamferedCylinder(r1=CranePivotRadius()+WallCrane(), r2=CR(),
                   h=CraneLength(), chamferBottom=false,
                   teardropTop=true);

          // Body around the barrel
          translate([CraneMinX(),0,0])
          rotate([0,90,0])
          ChamferedCylinder(r1=bodyRadius, r2=CR(),
                   h=CraneLength(), chamferBottom=false,
                   teardropTop=true);
        }
        
    
        translate([CraneMinX(),0,0])
        rotate([0,90,0])
        HoleChamfer(r1=bodyRadius, r2=0.25, teardrop=true, edgeSign=1);
      }

      // Square off the top
      translate([CraneMinX(),-(bodyRadius+0.5),-bodyRadius-1])
      cube([CraneLength(),
           (bodyRadius+0.5)*2,
            bodyRadius+CranePivotZ()
            + RodRadius(CraneRod())+WallCrane()+1]);
      
    }

    // Fillet cutouts
    for (M = [0,1]) mirror([0,M,0])
    translate([ForendMaxX()+(CR()/2),0,0])
    translate([0,BarrelRadius()+WallBarrel(),0])
    rotate([0,-90,0])
    Fillet(r=CR()*1.25, h=CraneSupportLength()+CR(),
                   inset=true, taperEnds=true);

    // Crane Support Body
    translate([ForendMaxX()+0.005,0,0])
    rotate([0,-90,0])
    ChamferedCylinder(r1=BarrelRadius()+WallBarrel()+0.005, r2=CR(),
             h=CraneSupportLength()+0.01);

    // Forend clearance (Crane Supports)
    translate([ForendMinX()-0.005+ManifoldGap(),
               -CranePivotY()-(pivotCutterRadius*2),-0.005])
    ChamferedCube([CraneSupportLength()+0.01,
                   (CranePivotY()+pivotCutterRadius*2)*2,
                   CranePivotZ()+pivotCutterRadius
                     + CR()],
                  r=CR());

    // Chamfered Barrel Cutout: Front
    translate([CraneMaxX()+ManifoldGap(),0,0])
    rotate([0,-90,0])
    ChamferedCircularHole(r1=BarrelRadius(clearance=(BARREL_CLEARANCE*2)),
                                               r2=CR(), h=CraneMaxX()-ForendMaxX());

    CranePivotPath();

    for (M = [0,1]) mirror([0,M,0]) // Ambidexterity mirror
    CranePivotPin(cutter=true);

    RevolverSpindle(cutter=true);

    Barrel(cutter=true, clearance=(BARREL_CLEARANCE*2));
  }
}

module Crane_print() {
  rotate(90) rotate([0,90,0]) translate([-CraneMaxX(),0,0])
  Crane();
}

module CraneShield(clearance=0.006, debug=false, alpha=1) {

  pivotCutterRadius = RodRadius(CylinderRod())+WallCrane()+clearance;
  craneRadius = CranePivotY()+CranePivotRadius()+WallCrane();
  cylinderMaxX = 2.75+ShellRimLength();
  length = CraneMinX()-cylinderMaxX-clearance;

  color("OliveDrab", alpha) render() DebugHalf(enabled=debug)
  difference() {
    union() {
      
      // Around the crane pivot rods
      hull()
      for (Z = [0,CranePivotZ()])
      for (Y = [1,-1])
      translate([CraneMinX(),CranePivotY()*Y,Z])
      rotate([0,-90,0])
      ChamferedCylinder(r1=CranePivotRadius()+WallCrane(), r2=CR(),
                        h=length,
                        chamferBottom=false,
                        chamferTop=false, teardropTop=true,
                        $fn=Resolution(20,40));

      // Around cylinder
      translate([CraneMinX(),0,-CylinderZ()])
      rotate([0,-90,0])
      ChamferedCylinder(r1=2, r2=CR(),
                        h=length,
                        $fn=Resolution(30,100));
    }

    // Cutout for chambers
    translate([0,0,-CylinderZ()])
    rotate([0,90,0])
    ChamferedCylinder(r1=CylinderZ()+BarrelRadius()+(CR()/2), r2=1/64,
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

module CraneSupport(debug=false, alpha=_ALPHA_FOREND, $fn=Resolution(30,100)) {

  // Forward plate
  color("Tan", alpha)
  render() DebugHalf(enabled=debug)
  difference() {
    union() {

      // Around the barrel
      translate([ForendMaxX(),0,0])
      rotate([0,-90,0])
      ChamferedCylinder(r1=BarrelRadius()+WallBarrel(), r2=CR(),
               h=CraneSupportLength());

      // Join the barrel to the frame
      for (M = [0,1]) mirror([0,M,0])
      translate([ForendMaxX(),
                 BarrelRadius()+WallBarrel(),
                 CranePivotZ()-CranePivotRadius()-WallCrane()])
      rotate([0,-90,0])
      Fillet(r=CR(), h=CraneSupportLength(),
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
        ChamferedCylinder(r1=CranePivotRadius()+WallCrane(), r2=CR(),
                           h=CraneSupportLength());
      }
    }

    // Cutout for a picatinny rail insert
    translate([-ManifoldGap(), -UnitsMetric(15.6/2), FrameTopZ()-0.0625])
    cube([FrameExtension()+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

    FrameBolts(cutter=true);

    Barrel(cutter=true, clearance=BARREL_CLEARANCE);

    ChargingRod(cutter=true);

    RevolverSpindle(cutter=true);
    
    for (M = [0,1]) mirror([0,M,0])
    CranePivotPin(cutter=true);
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

      // Around the barrel
      *translate([ForendMaxX()+CraneLengthFront(),0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=BarrelRadius()+WallBarrel(), r2=CR(),
               h=length);

      // Join the barrel to the frame
      *for (M = [0,1]) mirror([0,M,0])
      translate([ForendMaxX()+CraneLengthFront(),0,0])
      translate([0,BarrelRadius()+WallBarrel(),0])
      rotate([0,90,0])
      Fillet(r=CR(), h=length,
                     inset=true, taperEnds=true);

    // Crane Pivot Supports
    translate([ForendMaxX()-ManifoldGap(),0,0]) {
      
      translate([0,0,-0.0625])
      FrameSupport(length=length+CraneLengthFront(),
                   height=((FrameBoltRadius()+WallFrameBolt())*2)+0.125);

      
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
      translate([0,0,-0.0625])
      FrameSupport(length=length,
                   height=((FrameBoltRadius()+WallFrameBolt())*2)+0.125);
      
      translate([0,-(3/2),CranePivotZ()])
      ChamferedCube([CylinderMaxX(),
                     3,
                     FrameBoltZ()-CranePivotZ()], r=CR());
    }
    
    for (M = [0,1]) mirror([0,M,0])
    for (F = [0,1]) CranePivotPosition(factor=F)
    translate([0,0,-CylinderZ()])
    rotate([0,90,0])
    cylinder(r=CYLINDER_DIAMETER/2,
             h=ForendMinX()+ManifoldGap(2),
             $fn=Resolution(30,80));

    // Picatinny rail cutout
    translate([-ManifoldGap(), -UnitsMetric(15.6/2), FrameTopZ()-0.0625])
    cube([length+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

    FrameBolts(cutter=true);
    
    ChargingRod(cutter=true);
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


module RevolverZigZagCylinder(supports=true, chambers=false,
                             chamberBolts=false,
                             debug=_CUTAWAY_CYLINDER,
                             alpha=_ALPHA_CYLINDER) {                               
  OffsetZigZagRevolver(diameter=CYLINDER_DIAMETER, height=CYLINDER_LENGTH,
      centerOffset=CylinderZ(),
      chamberRadius=BarrelRadius(),
      chamberClearance=BARREL_CLEARANCE,
      chamberInnerRadius=CHAMBER_ID/2,
      zigzagAngle=55,
      extraTop=ActuatorPretravel(),
      supportsBottom=false, supportsTop=supports, chamberBolts=chamberBolts,
      chambers=chambers, chamberLength=ChamberLength(),
      debug=debug, alpha=alpha) {
  
    translate([0,0,-ManifoldGap()])
    cylinder(r=SpindleCollarRadius()+0.005,
             h=CYLINDER_LENGTH-0.25+ManifoldGap(2), $fn=60);
  }
}


module RevolverZigZagCylinder_print() {
  translate([0,0,2.75])
  rotate([0,180,0])
  RevolverZigZagCylinder(supports=true);
}

// Assemblies
module RevolverForendAssembly(stock=true,
                               pipeAlpha=1, debug=false) {

  if (_SHOW_RECEIVER_FRONT)
  translate([0,0,0]) {
    RevolverReceiverFront(debug=debug);
    RecoilPlateFiringPinAssembly(debug=debug);
    RecoilPlate(debug=debug);
  }

  translate([0,0,0]) {

    if (_SHOW_ACTION_ROD)
    ChargingPumpAssembly(debug=debug);

    Barrel(debug=debug);

    CranePivotPosition(factor=Animate(ANIMATION_STEP_UNLOAD)
                     -Animate(ANIMATION_STEP_LOAD)) {

      if (_SHOW_CYLINDER)
      translate([ShellRimLength(),0,-CylinderZ()])
      rotate([0,90,0])
      rotate(-360/6/2*SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.25, end=0.8))
      rotate(-360/6/2*SubAnimate(ANIMATION_STEP_CHARGE, start=0.4, end=0.98))
      RevolverZigZagCylinder(supports=false, chambers=true);

      MirrorIf(CRANE_LEFT_HANDED, [0,1,0])
      CranePivotPin();

      // Latch
      translate([CraneLatchTravel()*(SubAnimate(ANIMATION_STEP_UNLOCK, end=0.5)
                    -SubAnimate(ANIMATION_STEP_LOCK, start=0.5)),0,0])
      {
          RevolverSpindle();
          CraneLatch(debug=debug);
      }
      
      if (_SHOW_CRANE)
      Crane(alpha=_ALPHA_CRANE, debug=_CUTAWAY_CRANE);
      
      if (_SHOW_SHIELD)
      CraneShield(alpha=_ALPHA_CRANE, debug=_CUTAWAY_CRANE);
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

module RevolverFireControlAssembly() {

  translate([FiringPinMinX(),0,0])
  HammerAssembly(insertRadius=0.75, alpha=0.5);

  RecoilPlateFiringPinAssembly();

  RecoilPlate();

  Charger();
}

module PumpZigZagRevolverAssembly() {
    
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

    RevolverForendAssembly(pipeAlpha=0.5, debug=false);

    RevolverFireControlAssembly();
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

  if (_RENDER == "FrameSpacer")
  FrameSpacer_print();

  if (_RENDER == "ReceiverFront")
  ReceiverFront_print();

  if (_RENDER == "RevolverReceiverFront")
  RevolverReceiverFront_print();
  
  if (_RENDER == "RevolverZigZagCylinder")
  RevolverZigZagCylinder_print();
}
