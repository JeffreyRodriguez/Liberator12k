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
use <../../Shapes/Components/AR15/HammAR.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Springs.scad>;
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
_RENDER = ""; // ["", "Prints/HammerSpringTrunnion", "Prints/GasJournalSpacer", "Prints/HammerCompressor", "Prints/BoltCarrier", "Prints/BoltCarrierBack", "Prints/LowerAttachment", "Prints/Trunnion", "Prints/Stock"]

// Reorient the part for printing?
_RENDER_PRINT = true;

/* [Assembly] */
_SHOW_TRUNNION = false;
_SHOW_TUBE = false;
_SHOW_STOCK = false;
_SHOW_BARREL = true;
_SHOW_BUTTPAD = false;
_SHOW_RECEIVER = false;
_SHOW_LOWER = false;
_SHOW_TENSION_BOLTS = false;
_SHOW_HAMMAR=true;

/* [Transparency] */
_ALPHA_TUBE = .1; // [0:0.1:1])
_ALPHA_TRUNNION = .5; // [0:0.1:1])
_ALPHA_STOCK = 5.; // [0:0.1:1])
_ALPHA_BOLT_CARRIER = .3; // [0:0.1:1])
_ALPHA_HAMMER = .5; // [0:0.1:1])

/* [Cutaway] */
_CUTAWAY_TUBE = false;
_CUTAWAY_TRUNNION = false;

/* [Vitamins] */

/* [Fine Tuning] */
_TUBE_OD = Inches(1.742);//Millimeters(42);
_TUBE_ID = Inches(1.485);//Millimeters(40); Millimeters(35); //
_TUBE_LENGTH = Inches(26);

// Configured Values
hammerTravel = 0.5;
hammerOvertravel=0.125;
tubeWall = _TUBE_OD-_TUBE_ID;
barrelWall = 0.25;
barrelOffset = 1;
barrelExtensionLandingHeight = 0.125;
chamferRadius = 0.1;

barrelX = 0; // To the back of the barrel extension
stockWall = 0.5;

// Measured Values
tube_width =1.015;
gasShaftCollarWidth = 0.5;
gasShaftCollarOD    = 1.5;

barrelExtensionDiameter = AR15BarrelExtensionDiameter();
barrelExtensionRadius = barrelExtensionDiameter/2;
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

//lowerX = -ReceiverLugFrontMinX()+barrelGasLength+gasShaftCollarWidth;
lowerX = 5.5;

camPinLockedMaxX = boltLockedMaxX -camPinOffset;

firingPinMinX  = boltLockedMinX-AR15_FiringPin_Extension();
hammerMinX = firingPinMinX -hammerTravel;

stockMinX = hammerMinX-stockWall-3.25;
stockLength=abs(hammerMinX)+stockWall;

boltCarrierMaxX = barrelX-barrelExtensionLandingHeight-0.25;
boltCarrierMinX = boltCarrierMaxX-(AR15_BoltLockedLength()+AR15_FiringPin_Extension())+barrelExtensionLandingHeight+0.25;
boltCarrierLength = abs(boltCarrierMinX-boltCarrierMaxX);

ejectionPortLength = abs(magwellX);

lowerZ = 0;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();
//$t = AnimationDebug(ANIMATION_STEP_FIRE);
//$t = 0;

// ************
// * Vitamins *
// ************
module Barrel(cutter=false) {
	rotate([0,90,0]) {
		rotate(180)
		AR15_Barrel(cutter=cutter);

		// Gas block shaft collar  
		color("Black")
		translate([0,0,barrelGasLength+ManifoldGap(2)])
		cylinder(r=gasShaftCollarOD/2, h=gasShaftCollarWidth);
	}
}

module Tube(length=_TUBE_LENGTH, clearance=0.01, cutter=false, alpha=_ALPHA_TUBE, cutaway=_CUTAWAY_TUBE) {
  clear = cutter ? clearance : 0;
  
  color("lightgrey", alpha) RenderIf(!cutter) Cutaway(cutaway) {
    translate([stockMinX,0,0])
    rotate([0,90, 0])
    difference() {
      cylinder(r=_TUBE_OD/2+clear, h=length);
      
      if (!cutter)
      cylinder(r=_TUBE_ID/2, h=length);
    }
  }
}

///

// **********
// * Shapes *
// **********
module EjectionPortCutout() {
  union() {
    

    // Ejection slot
    rotate([-AR15_CamPinAngle()*0.75,0,0])
    mirror([0,1,0])
    translate([-ejectionPortLength,0,-0.75/2])
    ChamferedCube([ejectionPortLength,
                   AR15BarrelExtensionLipRadius()+barrelWall+1,
                   0.75], r=1/16);

    // Ejection slot forward bevel
    *rotate([-AR15_CamPinAngle(),0,0])
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
module CamPinCutout(clearance=0.01, chamferBack=false) {
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
///

// **********
// * Prints *
// **********
module GasJournalSpacer(length=0.5, clearance=0.003, cutaway=false, alpha=1) {
	CR=1/16;
	
  color("Chocolate", alpha) render() Cutaway(cutaway)
  difference() {
		
		// Barrel section
		translate([barrelGasLength+0.5,0,0])
		rotate([0,90,0])
		ChamferedCylinder(r1=_TUBE_ID/2, r2=CR,
		                   h=length);
		
		Barrel(cutter=true);
		
		translate([barrelGasLength+0.5,0,0])
		rotate([0,90,0])
		ChamferedCircularHole(r1=(0.625/2)+clearance, r2=CR, h=length);
  }
}
module LowerAttachment(clearance=0.007, extraFront=0,wall=tubeWall) {

  color("Tan") render()
  difference() {
    union() {

      translate([LowerMaxX()+lowerX,0,lowerZ])
      ReceiverLugFront(extraTop=tubeWall);
      
      translate([LowerMaxX()+lowerX,0,lowerZ])
      ReceiverLugRear(extraTop=tubeWall);
    }

    Tube(cutter=true);

    translate([LowerMaxX()+lowerX,0,lowerZ])
    Sear(cutter=true, length=0.9+SearTravel());
  }
}

module Trunnion(alpha=_ALPHA_TRUNNION, cutaway=_CUTAWAY_TRUNNION) {
	
	length = AR15_MagazineBaseLength()+AR15_MagazineRearTabLength()+magwellWallBack;

  color("Tan", alpha) render() Cutaway(cutaway)
  difference() {
		union() {
			translate([-length,0,0])
			mirror([1,0,0])
			Receiver_Segment(length=AR15BarrelExtensionLength()+AR15BarrelExtensionLipLength()+length, /*(LowerMaxX()+lowerX)-ReceiverLength()+*/
			                 highTop=false);
			
			Magwell();
		}

		hull() {
			// Bolt Head Passage
			translate([barrelX,0,0])
			rotate([0,-90,0])
			cylinder(r=boltHeadRadius+0.01, h=abs(boltCarrierMaxX)+ManifoldGap(2));
			
			translate([barrelX-0.375-(1/16),0,0])
			rotate([0,-90,0])
			cylinder(r=0.625, h=ManifoldGap());

			// Barrel Extension Rear Support Cone
			*translate([barrelX,0,0])
			rotate([0,-90,0])
			cylinder(r1=boltHeadRadius+0.008,
							 r2=boltCarrierRadius+0.015,
								h=barrelExtensionLandingHeight);
		}
		
		EjectionPortCutout();
		Barrel(cutter=true);
		HammAR_Cutter();
		
		translate([magwellX,0,magwellZ])
		AR15_MagwellInsert(extraTop=abs(magwellZ)-(0.3));
		
		translate([-length,0,0])
		HammAR_Chamfer();
		
		translate([barrelX+AR15BarrelExtensionLength()+AR15BarrelExtensionLipLength(),0,0])
		Receiver_TensionBolts(nutType="none");
	}
}

module Stock(topDiameter=tube_width+(tubeWall*2), bottomDiameter=1, wall=0.25, clearance=0.008, alpha=_ALPHA_STOCK) {

  clear2 = clearance*2;

  echo("stockLength = ", stockLength);
                     leverMinX=0;

  color("Tan", alpha) render()
  difference() {
    // Body
    translate([stockMinX,0,0])
    Receiver_Segment(length=stockLength, highTop=false);

    translate([boltLockedMaxX,0,0])
    rotate([0,-90,0])
    CamPinCutout(chamferBack=false);

    // Bolt Track
    translate([stockMinX-ManifoldGap(),0,0])
    rotate([0,90,0])
    ChamferedCircularHole(r1=boltCarrierRadius+clear2, r2=chamferRadius,
                           h=stockLength+ManifoldGap(2));

    Magwell(cutter=true);
  }
}

module Magwell(cutter=false) {
  difference() {

    translate([magwellX,0,magwellZ])
    AR15_Magwell(wallFront=magwellWallFront, wallBack=magwellWallBack, cut=false);

    translate([magwellX,0,magwellZ])
    AR15_MagwellInsert();
    
    Tube(cutter=true);
  }
  
  if (cutter)
  translate([magwellX,0,magwellZ])
  AR15_MagwellInsert(extraTop=abs(magwellZ));
}

///

ScaleToMillimeters()
if ($preview)
translate([8.125+3,0,0]) {
	if (_SHOW_BARREL)
  Barrel();

	if (_SHOW_LOWER)
  translate([LowerMaxX()+lowerX,0,lowerZ]) {
    TriggerGroup();
		LowerMount();//LowerAttachment();
    Lower();
  }
	
	if (_SHOW_TENSION_BOLTS)
	translate([LowerMaxX()+lowerX,0,0])
	Receiver_TensionBolts(nutType="none");
	
	if (_SHOW_RECEIVER)
	translate([LowerMaxX()+lowerX,0,0])
	Receiver(highTop=false, mlok=false);

  if (_SHOW_STOCK)
  Stock();
  
	searAF = SubAnimate(ANIMATION_STEP_FIRE, end=0.3)-SubAnimate(ANIMATION_STEP_CHARGE, start=0.9);
	hammerAF = SubAnimate(ANIMATION_STEP_FIRE, start=0.3)-SubAnimate(ANIMATION_STEP_CHARGE);
  chargeAF = SubAnimate(ANIMATION_STEP_CHARGE, start=0.1)
           - SubAnimate(ANIMATION_STEP_CHARGER_RESET, end=0.9);
  chargerRotationAF = SubAnimate(ANIMATION_STEP_CHARGE, end=0.1)
                    - Animate(ANIMATION_STEP_CHARGER_RESET);
  
	if (_SHOW_HAMMAR)
	translate([-3.25*chargeAF,0,0])
	rotate([-22.5*chargerRotationAF,0,0])
	HammAR(hammerAF=hammerAF);
	
	GasJournalSpacer();

	if (_SHOW_TRUNNION)
	Trunnion();

	if (_SHOW_TUBE)
	Tube();

	if (_SHOW_BUTTPAD)
	//translate([-ButtpadX()+stockMinX,0,0])
	translate([-ButtpadX()-8.125,0,0])
	Stock_Buttpad();
} else {

  // *****************
  // * Printed Parts *
  // *****************
  if (_RENDER == "Prints/HammerSpringTrunnion")
    if (!_RENDER_PRINT)
      HammerSpringTrunnion();
    else
      rotate([0,90,0])
      HammerSpringTrunnion();
		
if (_RENDER == "Prints/GasJournalSpacer")
	if (!_RENDER_PRINT)
		GasJournalSpacer();
	else
		rotate([0,-90,0])
	translate([-barrelGasLength-0.5,0,0])
		GasJournalSpacer();
		
  if (_RENDER == "Prints/HammerCompressor")
    if (!_RENDER_PRINT)
      HammerCompressor();
    else
      rotate([0,-90,0])
      HammerCompressor();

	if (_RENDER == "Prints/BoltCarrier")
		if (!_RENDER_PRINT)
			BoltCarrier();
		else
			rotate([0,-90,0])
			translate([-boltCarrierMinX,0,0])
			BoltCarrier();
		
	if (_RENDER == "Prints/BoltCarrierBack")
		if (!_RENDER_PRINT)
			BoltCarrierBack();
		else
			rotate([0,-90,0])
			translate([-boltCarrierMinX,0,0])
			BoltCarrierBack();

  if (_RENDER == "Prints/LowerAttachment")
    if (!_RENDER_PRINT)
      LowerAttachment();
    else
      rotate([0,90,0])
      LowerAttachment(extraFront=0);

  if (_RENDER == "Prints/Trunnion")
    if (!_RENDER_PRINT)
      Trunnion();
    else
      rotate([0,-90,0])
      Trunnion();

  if (_RENDER == "Prints/Stock")
    if (!_RENDER_PRINT)
      Stock();
    else
      rotate([0,90,0])
      Stock();

  // ************
  // * Hardware *
  // ************
  if (_RENDER == "Hardware/Barrel")
  Barrel();

  if (_RENDER == "Hardware/Bolt")
  color("Black")
  translate([boltLockedMaxX,0,0])
  rotate([0,-90,0])
  HammAR_Bolt(teardrop=false, firingPinRetainer=false);

  if (_RENDER == "Hardware/Hammer")
  translate([lowerX,0,0])
  HammAR_Hammer();
}
