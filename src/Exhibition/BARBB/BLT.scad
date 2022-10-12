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
_RENDER = ""; // ["", "Prints/BarrelRetainer", "Prints/GasJournalSpacer", "Prints/HammerCompressor", "Prints/BoltCarrier", "Prints/BoltCarrierBack", "Prints/LowerAttachment", "Prints/Trunnion", "Prints/Stock", "Prints/Buttpad"]

// Reorient the part for printing?
_RENDER_PRINT = true;

/* [Assembly] */
_SHOW_TRUNNION = true;
_SHOW_STOCK = true;
_SHOW_BARREL = true;
_SHOW_BARREL_RETAINER = true;
_SHOW_BUTTPAD = true;
_SHOW_RECEIVER = true;
_SHOW_LOWER = true;
_SHOW_TENSION_BOLTS = true;
_SHOW_HAMMAR=true;

/* [Transparency] */
_ALPHA_RECEIVER = .5; // [0:0.1:1])
_ALPHA_TRUNNION = .5; // [0:0.1:1])
_ALPHA_STOCK = .5; // [0:0.1:1])
_ALPHA_BOLT_CARRIER = .3; // [0:0.1:1])

/* [Cutaway] */
_CUTAWAY_TRUNNION = false;

/* [Vitamins] */
gasShaftCollarWidth = 0.5;
gasShaftCollarOD    = 1.25;

/* [Fine Tuning] */
chamferRadius = 0.1;
barrelX = 0; // To the back of the barrel extension
barrelGasLength = 7.8; // Back of the barrel extension to the gas block shelf
barrelWall = 0.25;
barrelOffset = 1;
barrelExtensionLandingHeight = 0.125;
barrelRetainerLength = 2.25; //1.5;
hammerTravel = 0.5;

magwellX = -2.674;
magwellZ = -0.4375;
magwellWallFront = 0.125;
magwellWallBack = 0.5;

// Calculated Values
ejectionPortLength = abs(magwellX);

boltCarrierDiameter = AR15BarrelExtensionDiameter();
boltCarrierRadius = boltCarrierDiameter/2;

boltLockedMinX = barrelX-AR15_BoltLockedLength();
boltLockedMaxX = barrelX+AR15_BoltLockLengthDiff();

firingPinMinX  = boltLockedMinX-AR15_FiringPin_Extension();
hammerMinX = firingPinMinX -hammerTravel;

stockLength=4;

boltCarrierMaxX = barrelX
                -barrelExtensionLandingHeight
                -0.25;
boltCarrierMinX = boltCarrierMaxX
                - (AR15_BoltLockedLength()+AR15_FiringPin_Extension())
                + barrelExtensionLandingHeight
                + 0.25;
boltCarrierLength = abs(boltCarrierMinX-boltCarrierMaxX);

trunnionMinX = -AR15_MagazineBaseLength()
             - AR15_MagazineRearTabLength()
             - magwellWallBack;
trunnionLength = abs(trunnionMinX)
               + AR15BarrelExtensionLength()
               + AR15BarrelExtensionLipLength();

barrelRetainerMinX = barrelX
                   + AR15BarrelExtensionLength()
                   + AR15BarrelExtensionLipLength();

lowerX = 6.25;
lowerZ = 0;
stockMinX = trunnionMinX-stockLength;


// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();
$t = AnimationDebug(ANIMATION_STEP_CHARGE, T=1);
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
    rotate([-AR15_CamPinAngle()*0.75,0,0])
    translate([-0.25,
               -AR15_BoltHeadRadius(),
               -0.75/2])
    mirror([0,1,0])
    rotate(40)
    ChamferedCube([ejectionPortLength,
                   AR15BarrelExtensionLipRadius()+barrelWall+1,
                   0.75], r=1/16);
  }
}
///

// **********
// * Prints *
// **********
module LowerAttachment(clearance=0.007, extraFront=0) {

  color("Tan") render()
  difference() {
    union() {

      translate([LowerMaxX()+lowerX,0,lowerZ])
      ReceiverLugFront(extraTop=lowerZ);
      
      translate([LowerMaxX()+lowerX,0,lowerZ])
      ReceiverLugRear(extraTop=lowerZ);
    }

    translate([LowerMaxX()+lowerX,0,lowerZ])
    Sear(cutter=true, length=0.9+SearTravel());
  }
}

module Trunnion(alpha=_ALPHA_TRUNNION, cutaway=_CUTAWAY_TRUNNION) {

	color("Tan", alpha) render() Cutaway(cutaway)
	difference() {
		union() {
			translate([trunnionMinX,0,0])
			mirror([1,0,0])
			Receiver_Segment(length=trunnionLength,
			                 highTop=false);
			
			Magwell();
		}

		hull() {
			// Bolt Head Passage
			translate([barrelX,0,0])
			rotate([0,-90,0])
			cylinder(r=AR15_BoltHeadRadius()+0.01, h=abs(boltCarrierMaxX)+ManifoldGap(2));
			
			translate([barrelX-0.375-0.01625,0,0])
			rotate([0,-90,0])
			cylinder(r=0.5+0.01, h=ManifoldGap());
			
			translate([magwellX+0.125+0.012,0,-AR15BarrelExtensionRadius()])
			linear_extrude(AR15BarrelExtensionRadius())
			AR15_MagwellTemplate(showRearTab=false);

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
		
		translate([trunnionMinX,0,0])
		HammAR_Chamfer();
		
		translate([magwellX,0,magwellZ])
		AR15_MagwellInsert(extraTop=abs(magwellZ)-(0.3));
		
		translate([-trunnionLength,0,0])
		HammAR_Chamfer();
		
		translate([barrelX+AR15BarrelExtensionLength()+AR15BarrelExtensionLipLength(),0,0])
		Receiver_TensionBolts(cutter=true, nutType="none");
	}
}

module BarrelRetainer(alpha=_ALPHA_RECEIVER, cutaway=false) {

	color("Tan", alpha) render() Cutaway(cutaway)
	difference() {
		translate([barrelRetainerMinX,0,0])
		mirror([1,0,0])
		Receiver_Segment(length=barrelRetainerLength,
		                 highTop=false);

		Barrel(cutter=true);
		
		translate([barrelRetainerMinX+barrelRetainerLength,0,0])
		Receiver_TensionBolts(cutter=true, nutType="none");
	}
}

module Stock(bottomDiameter=1, wall=0.25, clearance=0.008, alpha=_ALPHA_STOCK) {
	clear2 = clearance*2;

	color("Tan", alpha) render()
	difference() {
		// Body
		translate([trunnionMinX,0,0])
		Receiver_Segment(length=stockLength, highTop=false, chamferBack=true);
		
		translate([HammAR_X()-clearance,0,0])
		rotate([0,-90,0])
		linear_extrude(HammAR_Length()+clearance, center=false)
		HammAR_Cutter2D(pivot=true);
		
		
		translate([HammAR_X()-HammAR_Length(),0,0])
		rotate([0,-90,0])
		linear_extrude(stockLength, center=false)
		HammAR_Cutter2D(pivot=false);
		
		translate([trunnionMinX-stockLength,0,0])
		HammAR_Chamfer(pivot=false);
		
		translate([barrelX,0,0])
		Receiver_TensionBolts(cutter=true, nutType="none");
  }
}

module Buttpad(clearance=0.008, alpha=1) {
	color("Tan", alpha) render()
	difference() {
		translate([stockMinX-ButtpadX(),0,0])
		Stock_Buttpad(boltHoles=false, lowerExtension=false, doRender=false, alpha=alpha);
		
		translate([HammAR_X()-HammAR_Length()-clearance,0,0])
		rotate([0,-90,0])
		linear_extrude(stockLength+clearance, center=false)
		HammAR_Cutter2D(camTrack=false, pivot=false);
		
		translate([stockMinX,0,0])
		mirror([1,0,0])
		HammAR_Chamfer(camTrack=false, pivot=false);
		
		translate([barrelX,0,0])
		Receiver_TensionBolts(cutter=true, nutType="none");
		
		translate([stockMinX-0.5,0,0])
		TensionBoltIterator()
		ChamferedCylinder(r1=0.25, r2=1/32, h=ButtpadLength());
	}
}

module Magwell(cutter=false) {
  difference() {

    translate([magwellX,0,magwellZ])
    AR15_Magwell(wallFront=magwellWallFront, wallBack=magwellWallBack, cut=false);

    translate([magwellX,0,magwellZ])
    AR15_MagwellInsert();
  }
  
  if (cutter)
  translate([magwellX,0,magwellZ])
  AR15_MagwellInsert(extraTop=abs(magwellZ));
}
///

//ScaleToMillimeters()
translate([-stockMinX+ButtpadLength(),0,0])
if ($preview) {
	if (_SHOW_BARREL)
	Barrel();

	if (_SHOW_LOWER)
	translate([LowerMaxX()+lowerX,0,lowerZ]) {
		TriggerGroup();
		LowerMount(searSupport=false, hammerGuide=false, takedownPin=false);//LowerAttachment();
		Lower();
	}
	
	if (_SHOW_TENSION_BOLTS)
	translate([LowerMaxX()+lowerX+2,0,0])
	Receiver_TensionBolts(length=18-(1/8), nutType="none");

	searAF = SubAnimate(ANIMATION_STEP_FIRE, end=0.3)-SubAnimate(ANIMATION_STEP_CHARGE, start=0.9);
	hammerAF = SubAnimate(ANIMATION_STEP_FIRE, start=0.3)-SubAnimate(ANIMATION_STEP_CHARGE);
	chargeAF = SubAnimate(ANIMATION_STEP_CHARGE, start=0.1)
	         - SubAnimate(ANIMATION_STEP_CHARGER_RESET, end=0.9);
	chargerRotationAF = SubAnimate(ANIMATION_STEP_CHARGE, end=0.1)
	                  - Animate(ANIMATION_STEP_CHARGER_RESET);

	if (_SHOW_HAMMAR)
	translate([-HammAR_Travel()*chargeAF,0,0])
	rotate([22.5*chargerRotationAF,0,0])
	HammAR(hammerAF=(1-hammerAF), alpha=_ALPHA_BOLT_CARRIER);

	if (_SHOW_TRUNNION)
	Trunnion();
	
	if (_SHOW_BARREL_RETAINER)
	BarrelRetainer();
	
	if (_SHOW_RECEIVER)
	translate([LowerMaxX()+lowerX,0,0])
	Receiver(alpha=_ALPHA_RECEIVER, highTop=false, mlok=false);

	if (_SHOW_STOCK)
	Stock();

	if (_SHOW_BUTTPAD)
	Buttpad(alpha=_ALPHA_STOCK);
} else {

	// *****************
	// * Printed Parts *
	// *****************
	if (_RENDER == "Prints/BarrelRetainer")
		if (!_RENDER_PRINT)
			BarrelRetainer();
		else
			rotate([0,90,0])
			BarrelRetainer();
		
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
			rotate([0,-90,0])
			translate([-trunnionMinX+stockLength,0,0])
			Stock();

	if (_RENDER == "Prints/Buttpad")
		if (!_RENDER_PRINT)
			Buttpad();
		else
			rotate([0,-90,0])
			translate([-stockMinX+ButtpadLength(),0,0])
			Buttpad();

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
