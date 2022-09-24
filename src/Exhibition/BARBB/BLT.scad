include <../../Meta/Animation.scad>;

use <../../Meta/Cutaway.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Conditionals/RenderIf.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Shapes/Components/T Lug.scad>;
use <../../Shapes/Chamfer.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Springs/Springs.scad>;
use <../../Vitamins/Springs/SpringSpec.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../../Vitamins/AR15/Bolt.scad>;
use <../../Vitamins/AR15/Barrel.scad>;

use <../../Receiver/Magwells/AR15 Magwell.scad>;

use <../../Receiver/FCG.scad>;
use <../../Receiver/Lower.scad>;
use <../../Receiver/Receiver.scad>;
use <../../Receiver/Stock.scad>;

/* [Export] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Prints/BARBB_HammerSpringTrunnion", "Prints/BARBB_HammerGuide", "Prints/BARBB_BoltCarrier", "Prints/BARBB_LowerAttachment", "Prints/BARBB_Trunnion", "Prints/BARBB_Stock"]

// Reorient the part for printing?
_RENDER_PRINT = true;

/* [Assembly] */
_SHOW_TRUNNION = true;
_SHOW_TUBE = false;
_SHOW_STOCK = false;
_SHOW_MAGWELL = true;
_SHOW_HAMMER = true;
_SHOW_HAMMER_SPRING = true;

/* [Transparency] */
_ALPHA_BARBB_TUBE = .1; // [0:0.1:1])
_ALPHA_TRUNNION = .5; // [0:0.1:1])
_ALPHA_STOCK = 5.; // [0:0.1:1])
_ALPHA_BOLT_CARRIER = .3; // [0:0.1:1])
_ALPHA_MAGWELL = .5; // [0:0.1:1])
_ALPHA_HAMMER = .5; // [0:0.1:1])

/* [Cutaway] */
_CUTAWAY_TUBE = false;
_CUTAWAY_TRUNNION = false;
_CUTAWAY_MAGWELL = false;

/* [Vitamins] */

/* [Fine Tuning] */
_BARBB_TUBE_OD = Inches(1.742);//Millimeters(42);
_BARBB_TUBE_ID = Inches(1.48);//Millimeters(40);
_BARBB_TUBE_LENGTH = Inches(26);

// Bullpup AR Barrel Bolt-action (BARBB)


// Configured Values
hammerTravel = 1.25;
hammerOvertravel=0.125;
tubeWall = _BARBB_TUBE_OD-_BARBB_TUBE_ID;
barrelWall = 0.25;
barrelOffset = 1;
barrelExtensionLandingHeight = 0.3;
chamferRadius = 0.1;

barrelX = 0; // To the back of the barrel extension
stockWall = 0.5;

// Vitamin values
function HammerSpringSpec() = [
  ["SpringSpec", "Extractor Spring"],

  ["SpringOuterDiameter", Inches(1.125)],
  ["SpringPitch", Inches(0.35)],

  ["SpringFreeLength", Inches(3)],
  ["SpringSolidHeight", Inches(1)],

  ["SpringWireDiameter", Inches(0.105)]
];

// Measured Values
hammerWidth = 0.25;
hammerLength = 1.5;
tube_width =1.015;// 0.75;x
gasShaftCollarWidth = 0.5;
gasShaftCollarOD    = 1.5;

barrelExtensionDiameter = AR15BarrelExtensionDiameter();
barrelExtensionRadius = barrelExtensionDiameter/2;
barrelExtensionLength = 0.99;
barrelExtensionLipLength=0.125;
barrelGasLength = 7.8; // Back of the barrel extension to the gas block shelf

camPinAngle    = 22.5;
camPinAngleExtra = 22.5*4;
camPinOffset   = 1.262; // From the front of the lugs to the front of the pin
camPinDiameter = 0.3125;
camPinSquareOffset = 0.5;
camPinSquareHeight = 0.1;
camPinSquareWidth = 0.402;
camPinShelfLength = 0;

boltHeadDiameter = 0.75+0.008;
boltHeadRadius = boltHeadDiameter/2;

firingPinRadius = (0.337/2)+0.01;


magwellX = -2.675;
magwellZ = -0.4375;
magwellWallFront = 0.125;
magwellWallBack = 0.5;



// Calculated Values
boltCarrierDiameter = AR15BarrelExtensionDiameter();
boltCarrierRadius = boltCarrierDiameter/2;

boltLockedMinX = barrelX-AR15_BoltLockedLength();
boltLockedMaxX = barrelX+AR15_BoltLockLengthDiff();

lowerX = -ReceiverLugFrontMinX()+barrelGasLength+gasShaftCollarWidth;

camPinLockedMaxX = boltLockedMaxX -camPinOffset;

upperLength = barrelExtensionLength+abs(camPinLockedMaxX)+barrelExtensionLipLength-0.01;
upperMinX = -upperLength+barrelExtensionLength+barrelExtensionLipLength;

firingPinMinX  = boltLockedMinX-AR15_FiringPin_Extension();
hammerMaxX = firingPinMinX + hammerOvertravel;
hammerMinX = firingPinMinX -hammerWidth -hammerTravel;

stockMinX = hammerMinX-stockWall-3.25;
stockLength=abs(hammerMinX)+upperMinX+stockWall;

barbbBoltCarrierLength = AR15_BoltLockedLength()+hammerWidth+0.25;
ejectionPortLength = abs(magwellX);

lowerZ = -1/2;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();
module BARBB_AR15_Bolt(cutter=false) {
  translate([boltLockedMaxX,0,0])
  rotate([0,-90,0])
  rotate(-22.5) {
    AR15_Bolt(cutter=cutter);
    AR15_CamPin(cutter=cutter);
    AR15_FiringPin(clearance=0.01, cutter=cutter, extraShoulder=(cutter?AR15_FiringPin_Extension():0));
  }
}
module BARBB_AR15_Barrel(cutter=false) {
  rotate([0,90,0]) {
    AR15_Barrel(cutter=cutter);

    // Gas block shaft collar  
    color("Black")
    translate([0,0,barrelGasLength+ManifoldGap(2)])
    cylinder(r=gasShaftCollarOD/2, h=gasShaftCollarWidth);
  }
}

module BARBB_HammerSpring() {
  color("Silver") render()
  translate([barrelGasLength,0,])
  rotate([0,-90,0])
  Spring(spring=HammerSpringSpec(), compressed=true);
}

module BARBB_Tube(length=_BARBB_TUBE_LENGTH, clearance=0.01, cutter=false, alpha=_ALPHA_BARBB_TUBE, cutaway=_CUTAWAY_TUBE) {
  clear = cutter ? clearance : 0;
  
  color("lightgrey", alpha) RenderIf(!cutter) Cutaway(cutaway) {
    translate([stockMinX,0,0])
    rotate([0,90, 0])
    difference() {
      cylinder(r=_BARBB_TUBE_OD/2+clear, h=length);
      
      if (!cutter)
      cylinder(r=_BARBB_TUBE_ID/2, h=length);
    }
  }
}

module BARBB_Hammer(clearance=0.01, cutter=false, alpha=_ALPHA_HAMMER) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver", alpha) RenderIf(!cutter)
  translate([firingPinMinX,-(hammerWidth/2)-clear, -AR15_FiringPin_ShoulderRadius()])
  mirror([1,0,0])
  cube([hammerWidth, hammerWidth+clear2, hammerLength]);
  
  color("Silver", alpha) RenderIf(!cutter)
  translate([firingPinMinX-(hammerWidth/2),0, 0.5])
  rotate([90,0,0])
  cylinder(r=Millimeters(2.5/2), h=Millimeters(19), center=true);
}

module BARBB_EjectionPortCutout() {
  union() {
    

    // Ejection slot
    rotate([-AR15_CamPinAngle(),0,0])
    mirror([0,1,0])
    translate([-ejectionPortLength,0,-0.5/2])
    ChamferedCube([ejectionPortLength,
                   AR15BarrelExtensionLipRadius()+barrelWall+1,
                   0.5], r=1/16);

    // Ejection slot forward bevel
    rotate([-AR15_CamPinAngle(),0,0])
    translate([-ejectionPortLength-0.25,
               -AR15_BoltHeadRadius(),
               -0.5/2])
    mirror([0,1,0])
    rotate(40)
    ChamferedCube([ejectionPortLength,
                   AR15BarrelExtensionLipRadius()+barrelWall+1,
                   0.5], r=1/16);
  }
}
module BARBB_CamPinCutout(clearance=0.01, chamferBack=false) {
  clear2 = clearance*2;
  camPinSquareArc = 360/(PI*2*(barrelExtensionRadius+barrelWall)/camPinSquareWidth);

  // Cam Pin cutout
  render()
  rotate(camPinAngleExtra)
  translate([0,0,camPinOffset])
  union() {

    // Cam pin linear travel
    translate([0,-(camPinSquareWidth/2)-clearance,ManifoldGap()])
    cube([camPinSquareOffset+camPinSquareHeight+clearance,
          camPinSquareWidth+clear2,
          abs(stockMinX-camPinLockedMaxX)+ManifoldGap()]);

    // Cam pin rotation arc
    translate([0,0,-clearance-ManifoldGap()])
    linear_extrude(height=camPinDiameter+camPinShelfLength+clear2+ManifoldGap(2)) {
      rotate(camPinSquareArc/2)
      semicircle(od=(camPinSquareOffset
                    +camPinSquareHeight
                    +barrelWall)*3,
                 angle=camPinAngle+camPinAngleExtra+camPinSquareArc);

      // Cam Pin Square, locked position
      rotate(-camPinAngleExtra-camPinAngle)
      translate([0,-(camPinSquareWidth/2)-0.01])
      square([camPinSquareOffset+camPinSquareHeight+barrelWall, camPinSquareWidth+0.02]);

      // Cam Pin Square, Unlocked position
      translate([0,-(camPinSquareWidth/2)-0.01])
      square([camPinSquareOffset+camPinSquareHeight+barrelWall, camPinSquareWidth+0.02]);
    }
  }
}

module BARBB_HammerCutOut(extraX=0) {

  // X-Zero on the firing pin's back face
  translate([hammerMinX,-hammerWidth/2,-(hammerWidth/2)]) {

    // Hammer linear track
    cube([abs(hammerMaxX-hammerMinX)+extraX,
                    hammerWidth,
                    0-+(hammerWidth/2)+firingPinRadius]);


    // Hammer rotary track
    rotate([0,90,0])
    linear_extrude(height=hammerWidth)
    rotate(-90)
    semicircle(od=((0-+(hammerWidth/2)+firingPinRadius)*2), angle=90);

    // Hammer rotary track, rounded inside corner)
    translate([hammerWidth,0,0])
    linear_extrude(height=0-+(hammerWidth/2)+firingPinRadius)
    rotate(180)
    RoundedBoolean(edgeOffset=0, edgeSign=-1, r=hammerWidth);
  }
}



module BARBB_LowerAttachment(clearance=0.007, extraFront=0,wall=tubeWall) {

  render()
  difference() {
    union() {

      translate([LowerMaxX(),0,lowerZ])
      ReceiverLugFront(extraTop=tubeWall);
      
      translate([LowerMaxX(),0,lowerZ])
      ReceiverLugRear(extraTop=tubeWall);
    }

    BARBB_Tube(cutter=true);

    Sear(cutter=true, length=0.9+SearTravel());
  }
}

module BARBB_Trunnion(alpha=_ALPHA_TRUNNION, cutaway=_CUTAWAY_TRUNNION) {

  color("Chocolate", alpha) render() Cutaway(cutaway)
  difference() {
    translate([upperMinX,0,0])
    // Barrel section
    translate([0,0,0])
    rotate([0,90,0])
    ChamferedCylinder(r1=barrelExtensionRadius+barrelWall, r2=chamferRadius,
                      h=upperLength-ManifoldGap());
    
    // Barrel center axis
    translate([upperMinX,0,0]) {

      // Bolt Head Passage
      rotate([0,90,0])
      cylinder(r=boltHeadRadius+0.01, h=upperLength+ManifoldGap(2));

      // Bolt Carrier Passage
      translate([-ManifoldGap(),0,0])
      rotate([0,90,0])
      cylinder(r=boltCarrierRadius+0.015,
               h=barrelExtensionLandingHeight+ManifoldGap(2));

      // Chamfer the bolt passage inside diameter
      rotate([0,90,0])
      HoleChamfer(r1=boltCarrierRadius+0.015, r2=chamferRadius, teardrop=true);

      // Barrel Extension Rear Support Cone
      translate([barrelExtensionLandingHeight,0,0])
      rotate([0,90,0])
      cylinder(r1=boltCarrierRadius+0.015, r2=boltHeadRadius+0.008,
               h=boltCarrierRadius/3);
    }
    BARBB_EjectionPortCutout();
    BARBB_AR15_Barrel(cutter=true);
    BARBB_Magwell(cutter=true);
  }
}

module BARBB_Stock(topDiameter=tube_width+(tubeWall*2), bottomDiameter=1, wall=0.25, clearance=0.008, alpha=_ALPHA_STOCK) {

  clear2 = clearance*2;

  echo("stockLength = ", stockLength);
                     leverMinX=0;

  color("Tan", alpha) render() Cutaway()
  difference() {
    // Body
    translate([stockMinX,0,0])
    rotate([0,90,0])
    translate([-0,0,0])
    ChamferedCylinder(r1=barrelExtensionRadius+barrelWall,
                      r2=chamferRadius,
                       h=stockLength);

    translate([boltLockedMaxX,0,0])
    rotate([0,-90,0])
    BARBB_CamPinCutout(chamferBack=false);

    // Bolt Track
    translate([stockMinX-ManifoldGap(),0,0])
    rotate([0,90,0])
    ChamferedCircularHole(r1=boltCarrierRadius+clear2, r2=chamferRadius,
                           h=stockLength+ManifoldGap(2));

    BARBB_HammerCutOut(extraX=1);
    BARBB_Magwell(cutter=true);
  }
}

module BARBB_Magwell(alpha=_ALPHA_MAGWELL, cutaway=_CUTAWAY_MAGWELL, cutter=false) {
  color("Chocolate", alpha=alpha) RenderIf(!cutter)
  Cutaway(cutaway)
  difference() {

    translate([magwellX,0,magwellZ])
    AR15_Magwell(wallFront=magwellWallFront, wallBack=magwellWallBack, cut=false);

    translate([magwellX,0,magwellZ])
    AR15_MagwellInsert();
    
    BARBB_Tube(cutter=true);
  }
  
  if (cutter)
  translate([magwellX,0,magwellZ])
  AR15_MagwellInsert(extraTop=abs(magwellZ));
}

module BARBB_BoltCarrier(clearance=0.01, alpha=_ALPHA_BOLT_CARRIER) {
  chamferClearance = 0.01;

color("Olive", alpha) render()
  difference() {

    translate([upperMinX+barrelExtensionLandingHeight,0,0])
    rotate([0,-90,0])
    union() {

      // Body
      ChamferedCylinder(r1=boltCarrierRadius,
                        r2=chamferRadius,
                        h=barbbBoltCarrierLength);
    }

    // Firing Pin Rear Hole Chamfer
    translate([stockMinX,0,0])
    rotate([0,90,0])
    HoleChamfer(r1=firingPinRadius+(clearance*2), r2=chamferRadius, teardrop=true);

    BARBB_AR15_Bolt(cutter=true);

    // Hammer Track
    translate([hammerMinX,-(hammerWidth/2),-AR15_FiringPin_ShoulderRadius()])
    cube([hammerWidth+hammerTravel+hammerOvertravel, hammerWidth, barrelOffset]);
  }
}



ScaleToMillimeters()
if ($preview) {
  BARBB_AR15_Barrel();

  translate([LowerMaxX()+lowerX,0,lowerZ]) {
    Lower();
    TriggerGroup();
  }

  translate([lowerX,0,0])
  color("Tan")
  //render() Cutaway()
  BARBB_LowerAttachment();

  if (_SHOW_STOCK)
  BARBB_Stock();
  
  $t = AnimationDebug(ANIMATION_STEP_CHARGE);
  chargeAF = SubAnimate(ANIMATION_STEP_CHARGE, start=0.1)
           - SubAnimate(ANIMATION_STEP_CHARGER_RESET, end=0.1);
  chargerRotationAF = SubAnimate(ANIMATION_STEP_CHARGE, end=0.1)
                    - Animate(ANIMATION_STEP_CHARGER_RESET);
  
  translate([-3.25*chargeAF,0,0])
  rotate([-22.5*chargerRotationAF,0,0]) {
  
    if (_SHOW_HAMMER)
    BARBB_Hammer();
    
    BARBB_AR15_Bolt();

    BARBB_BoltCarrier();
  }

  if (_SHOW_TRUNNION)
  BARBB_Trunnion();
  
  if (_SHOW_MAGWELL)
  BARBB_Magwell();
  
  if (_SHOW_HAMMER_SPRING)
  BARBB_HammerSpring();
  
  if (_SHOW_TUBE)
  BARBB_Tube();
  
  translate([-ButtpadX()+stockMinX,0,0])
  Stock_Buttpad();
} else {

  // *****************
  // * Printed Parts *
  // *****************
  if (_RENDER == "Prints/BARBB_HammerSpringTrunnion")
    if (!_RENDER_PRINT)
      BARBB_HammerSpringTrunnion();
    else
      rotate([0,90,0])
      BARBB_HammerSpringTrunnion();

  if (_RENDER == "Prints/BARBB_HammerGuide")
    if (!_RENDER_PRINT)
      BARBB_HammerGuide();
    else
      rotate([0,-90,0])
      BARBB_HammerGuide();

  if (_RENDER == "Prints/BARBB_BoltCarrier")
    if (!_RENDER_PRINT)
      BARBB_BoltCarrier();
    else
      rotate([0,-90,0])
      BARBB_BoltCarrier();

  if (_RENDER == "Prints/BARBB_LowerAttachment")
    if (!_RENDER_PRINT)
      BARBB_LowerAttachment();
    else
      rotate([0,90,0])
      BARBB_LowerAttachment(extraFront=0);

  if (_RENDER == "Prints/BARBB_Trunnion")
    if (!_RENDER_PRINT)
      BARBB_Trunnion();
    else
      rotate([0,90,0])
      BARBB_Trunnion();

  if (_RENDER == "Prints/BARBB_Stock")
    if (!_RENDER_PRINT)
      BARBB_Stock();
    else
      rotate([0,90,0])
      BARBB_Stock();

  // ************
  // * Hardware *
  // ************
  if (_RENDER == "Prints/BARBB_AR15_Barrel")
  BARBB_AR15_Barrel();

  if (_RENDER == "Prints/BARBB_AR15_Bolt")
  color("Black")
  translate([boltLockedMaxX,0,0])
  rotate([0,-90,0])
  AR15_Bolt(teardrop=false, firingPinRetainer=false);

  if (_RENDER == "Prints/BARBB_Hammer")
  translate([lowerX,0,0])
  BARBB_Hammer();
}
