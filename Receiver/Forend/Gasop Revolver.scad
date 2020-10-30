include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/RenderIf.scad>;

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

_CUTAWAY_RECEIVER = true;
_ALPHA_RECEIVER_TUBE = 1; // [0:0.1:1]
_ALPHA_RECEIVER_COUPLING = 1;  // [0:0.1:1]

_SHOW_RECEIVER_FRONT = true;
_ALPHA_RECEIVER_FRONT = 1;   // [0:0.1:1]

_SHOW_FOREND = true;
_CUTAWAY_FOREND = false;
_ALPHA_FOREND = 1;  // [0:0.1:1]

_SHOW_CYLINDER = true;
_CUTAWAY_CYLINDER = false;
_ALPHA_CYLINDER = 1; // [0:0.1:1]

_SHOW_CRANE = true;
_ALPHA_CRANE = 1; // [0:0.1:1]
_CUTAWAY_CRANE = false;

_SHOW_EXTRACTOR = true;
_ALPHA_EXTRACTOR = 1; // [0:0.1:1]
_CUTAWAY_EXTRACTOR = false;

_SHOW_LATCH = true;
_ALPHA_LATCH = 1; // [0:0.1:1]
_CUTAWAY_LATCH = false;

_SHOW_BARREL = true;
_SHOW_FRAME = true;
_ALPHA_RECOIL_PLATE_HOUSING=1; // [0:0.1:1]


BARREL_DIAMETER = 1;
BARREL_CLEARANCE = 0.01;

// Settings: Lengths
function ShellRimLength() = 0.06;
function ChamberLength() = 3;
function BarrelLength() = 18-ChamberLength();
function ActuatorPretravel() = 0.125;
function ForendGasGap() = 0.75;
function RevolverSpindleOffset() = BARREL_DIAMETER+0.125 + ManifoldGap();
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
                        -0.5;
                        
function ForendFrontLength() = ForendLength()
                             - ChamberLength()
                             - ForendGasGap();


// Calculated: Positions
function ForendMaxX() = ForendLength();
function ForendMinX() = ForendMaxX()-ForendFrontLength();

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
function CraneLatchHandleZ() = -(RevolverSpindleOffset()*2);
function CraneLatchHandleMaxZ() = -RevolverSpindleOffset()
                                  -(SpindleCollarRadius()+WallCrane());

function CraneLengthFront() = 0.5;
function CraneLengthRear() = 0.5;
function CraneLength() = CraneLengthFront()
                       + CraneLengthRear()
                       + ForendFrontLength();
function CraneMaxX() = ForendMaxX()
                     + CraneLengthFront();
function CraneMinX() = CraneMaxX()-CraneLength();

function CranePivotY() =  FrameBoltY();
function CranePivotZ() =  0.5 ;

function CranePivotHypotenuse() = pyth_A_B(CranePivotY(), CranePivotZ());
function CranePivotPinAngle() = CranePivotHypotenuse()*asin(CranePivotZ());

function CraneLatchMinX() = CraneMaxX();
function CraneLatchMaxX() = CraneLatchMinX()+CraneLatchLength();


// Pivot modules
module CranePivotPath(clearance=0.005, $fn=Resolution(30,90)) {

    //
    // Pivot Paths (mirrored for ambidexterity)
    // XDL = MaxX, Diameter, Length
    for (M = [0,1]) mirror([0,M,0])
    for (XDL = [[CraneLatchMaxX(),
                 BarrelDiameter(BARREL_CLEARANCE),
                 CraneLatchMaxX()]])
      translate([XDL[0]+ManifoldGap(),CranePivotY(),CranePivotZ()])
      rotate([0,-90,0])
      linear_extrude(height=XDL[2])
      semidonut(major=(CranePivotHypotenuse()*2)+XDL[1],
                minor=(CranePivotHypotenuse()*2)-XDL[1],
                angle=90+(CranePivotPinAngle()/2)+5); // TODO: Why is this off by 5 degrees?
}
module CranePivotPosition(angle=CranePivotAngle(), factor=1) {
  translate([0,CranePivotY(),CranePivotZ()])
  rotate([angle*factor,0,0])
  translate([0,-CranePivotY(),-CranePivotZ()])
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
  translate([RecoilPlateRearX(),0,-RevolverSpindleOffset()])
  rotate([0,90,0])
  SquareRod(CylinderRod(),
      length=CraneMaxX()-RecoilPlateRearX()
            +ManifoldGap(3), 
      clearance=cutter?RodClearanceSnug():undef);


  // Rearward shaft collar
  color("SteelBlue")
  translate([ManifoldGap(),0,-RevolverSpindleOffset()])
  rotate([0,90,0])
  cylinder(r=SpindleCollarRadius()+clear,
           h=SpindleCollarWidth(),
           $fn=Resolution(20,50));
}

module CranePivotPin(cutter=false, teardrop=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") RenderIf(!cutter)
  translate([CraneMinX()+ManifoldGap(),CranePivotY(),CranePivotZ()])
  rotate([0,90,0])
  NutAndBolt(bolt=CraneBolt(), head="socket", nut="heatset",
           boltLength=CraneLength()
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
  DebugHalf(enabled=debug) render()
  difference() {
    translate([RecoilPlateRearX(),0,0])
    union() {
      
      translate([0,0,-0.0625])
      FrameSupport(length=length,
                   height=((FrameBoltRadius()+WallFrameBolt())*2)+0.125);
        
      ReceiverCouplingPattern(length=length, frameLength=length);

      // Backing plate for the cylinder
      translate([0,0,-RevolverSpindleOffset()])
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

  *color("BurlyWood", alpha)
  DebugHalf(enabled=debug) RenderIf(!cutter)
  difference() {

    // Around the spindle
    translate([CraneLatchMinX(),0,-RevolverSpindleOffset()])
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

module Crane(cutter=false, teardrop=false, clearance=0.005,
                     $fn=Resolution(30,100), alpha=1, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  pivotCutterRadius = RodRadius(CylinderRod())+WallCrane()+clearance;
                       
  bodyRadius = CranePivotY()+CranePivotRadius()+WallCrane();

  color("OliveDrab", alpha)
  DebugHalf(enabled=debug) RenderIf(!cutter)
  difference() {
    intersection() {
      hull() {

        // Around the crane pivot rods
        for (Y = [1,-1])
        translate([CraneMinX(),CranePivotY()*Y,CranePivotZ()])
        rotate([0,90,0])
        ChamferedCylinder(r1=CranePivotRadius()+WallCrane(), r2=CR(),
                 h=CraneLength(),
                 teardropTop=true, teardropBottom=true);

        // Body around the barrel
        translate([CraneMinX(),0,0])
        rotate([0,90,0])
        ChamferedCylinder(r1=bodyRadius, r2=CR(),
                 h=CraneLength(),
                 teardropTop=true, teardropBottom=true);
      }

      // Square off the top
      translate([CraneMinX(),-bodyRadius,-bodyRadius])
      ChamferedCube([CraneLength(), bodyRadius*2,
                     bodyRadius+CranePivotZ()
                     + RodRadius(CraneRod())+WallCrane()],
                    r=CR());
      
    }

    // Fillet cutouts
    for (M = [0,1]) mirror([0,M,0])
    translate([ForendMaxX()+(CR()/2),0,0])
    translate([0,BarrelRadius()+WallBarrel(),0])
    rotate([0,-90,0])
    Fillet(r=CR()*1.25, h=ForendFrontLength()+CR(),
                   inset=true, taperEnds=true);

    // Crane Support Body
    translate([ForendMaxX()+0.005,0,0])
    rotate([0,-90,0])
    ChamferedCylinder(r1=BarrelRadius()+WallBarrel()+0.005, r2=CR(),
             h=ForendFrontLength()+0.01);

    // Forend clearance (Crane Supports)
    translate([ForendMinX()-0.005+ManifoldGap(),
               -CranePivotY()-(pivotCutterRadius*2),-0.005])
    ChamferedCube([ForendFrontLength()+0.01,
                   (CranePivotY()+pivotCutterRadius*2)*2,
                   CranePivotZ()+pivotCutterRadius
                     + CR()],
                  r=CR());

    // Chamfered Barrel Cutout: Front
    translate([CraneMaxX()+ManifoldGap(),0,0])
    rotate([0,-90,0])
    ChamferedCircularHole(r1=BarrelRadius(clearance=(BARREL_CLEARANCE*2)),
                                               r2=CR(), h=CraneMaxX()-ForendMaxX());

    // Chamfered Barrel Cutout: Rear
    translate([ManifoldGap(),0,0])
    translate([CraneMinX(),0,0])
    rotate([0,90,0])
    *ChamferedCircularHole(r1=BarrelRadius(clearance=(BARREL_CLEARANCE*2)),
                                                   r2=CR(), h=CraneLengthRear());

    CranePivotPath();

    for (M = [0,1]) mirror([0,M,0]) // Ambidexterity mirror
    CranePivotPin(cutter=true);

    RevolverSpindle(cutter=true);

    Barrel(cutter=true, clearance=(BARREL_CLEARANCE*2));
  }
}

module Crane_print() {
  rotate(90) rotate([0,-90,0]) translate([-CraneMinX(),0,0])
  Crane();
}

module CraneShield(cutter=false, clearance=0.006,
                     debug=false, $fn=Resolution(30,100), alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  pivotCutterRadius = RodRadius(CylinderRod())+WallCrane()+0.005;
  craneRadius = CranePivotY()+CranePivotRadius()+WallCrane();
  cylinderMaxX = 2.75+ShellRimLength();

  color("OliveDrab", alpha) DebugHalf(enabled=debug)  RenderIf(!cutter)
  difference() {
    union() {
      
      // Around the crane pivot rods
      hull() for (Y = [1,-1])
      translate([CraneMinX(),CranePivotY()*Y,CranePivotZ()])
      rotate([0,-90,0])
      ChamferedCylinder(r1=CranePivotRadius()+WallCrane(), r2=CR(),
                        h=CraneMinX()-cylinderMaxX-clearance,
                        teardropTop=true, teardropBottom=true);

      // Around cylinder
      translate([CraneMinX(),0,-RevolverSpindleOffset()])
      rotate([0,-90,0])
      ChamferedCylinder(r1=2, r2=CR(),
                        h=CraneMinX()-cylinderMaxX-clearance);
    }

    // Cutout for chambers
    translate([0,0,-RevolverSpindleOffset()])
    rotate([0,90,0])
    ChamferedCylinder(r1=RevolverSpindleOffset()+BarrelRadius()+(CR()/2), r2=1/64,
    h=ChamberLength()+ShellRimLength()+clearance);

    RevolverSpindle(cutter=true);

    Barrel(cutter=true, clearance=(BARREL_CLEARANCE*2));
  }
}

module CraneShield_print() {
  rotate([0,90,0]) translate([-CraneMinX(),0,0])
  CraneShield();
}

module CraneSupport(debug=false, alpha=_ALPHA_FOREND, $fn=Resolution(30,100)) {

  // Forward plate
  color("Tan", alpha)
  DebugHalf(enabled=debug) render()
  difference() {
    union() {

      // Around the barrel
      translate([ForendMaxX(),0,0])
      rotate([0,-90,0])
      ChamferedCylinder(r1=BarrelRadius()+WallBarrel(), r2=CR(),
               h=ForendFrontLength());

      // Join the barrel to the frame
      for (M = [0,1]) mirror([0,M,0])
      translate([ForendMaxX(),0,0])
      translate([0,BarrelRadius()+WallBarrel(),0])
      rotate([0,-90,0])
      Fillet(r=CR(), h=ForendFrontLength(),
                     inset=true, taperEnds=true);

    // Crane Pivot Supports
    translate([ForendMinX(),0,0])
    hull() {

        // Around the upper bolts
        FrameSupport(length=ForendFrontLength());

        // Around the crane pivot pin
        for (M = [0,1]) mirror([0,M,0])
        translate([0,CranePivotY(),CranePivotZ()])
        rotate([0,90,0])
        ChamferedCylinder(r1=CranePivotZ(), r2=CR(),
                           h=ForendFrontLength());
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

module FrameSpacer(length=ForendMinX(), debug=false, alpha=_ALPHA_FOREND) {
  color("Tan", alpha)
  DebugHalf(enabled=debug) render()
  difference() {
    translate([0,0,-0.0625])
    FrameSupport(length=length,
                 height=((FrameBoltRadius()+WallFrameBolt())*2)+0.125);

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
                             debug=_CUTAWAY_CYLINDER, alpha=_ALPHA_CYLINDER) {                               
  OffsetZigZagRevolver(
      centerOffset=RevolverSpindleOffset(),
      chamberRadius=BarrelRadius(), chamberClearance=BARREL_CLEARANCE,
      chamberInnerRadius=0.81/2,
      zigzagAngle=55, wall=0.1875+0.125,
      extraTop=ActuatorPretravel(),
      supportsBottom=false, supportsTop=supports, chamberBolts=chamberBolts,
      chambers=chambers, chamberLength=ChamberLength(),
      debug=debug, alpha=alpha) {
  
    translate([0,0,-ManifoldGap()])
    cylinder(r=SpindleCollarRadius()+0.005,
             h=2.5+ManifoldGap(2), $fn=60);
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

    ChargingPumpAssembly(debug=debug);

    Barrel(debug=debug);

    if (_SHOW_FOREND) {
      CraneSupport(debug=_CUTAWAY_FOREND);
      
      FrameSpacer(debug=_CUTAWAY_FOREND);
    }

    CranePivotPosition(factor=Animate(ANIMATION_STEP_UNLOAD)
                     -Animate(ANIMATION_STEP_LOAD)) {

      translate([ShellRimLength(),0,0])
      translate([0,0,-RevolverSpindleOffset()])
      rotate([0,90,0])
      rotate(-360/6/2*SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.25, end=0.8))
      rotate(-360/6/2*SubAnimate(ANIMATION_STEP_CHARGE, start=0.4, end=0.98)) {
        RevolverZigZagCylinder(supports=false, chambers=true);
      }

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
      
      if (_SHOW_CRANE)
      CraneShield(alpha=_ALPHA_CRANE, debug=_CUTAWAY_CRANE);
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

if (_RENDER == "Assembly") {
    
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
