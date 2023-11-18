include <../../Meta/Animation.scad>;

use <../../Meta/Cutaway.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Conditionals.scad>;
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
_RENDER = ""; // ["", "Prints/BarrelRetainer", "Prints/Forend", "Prints/HammerCompressor", "Prints/BoltCarrier", "Prints/BoltCarrierBack", "Prints/LowerAttachment", "Prints/Trunnion", "Prints/SearSupport", "Prints/TriggerGuide", "Prints/TriggerBar", "Prints/Trigger", "Prints/TriggerPlunger", "Prints/Stock", "Prints/Buttpad"]

// Reorient the part for printing?
_RENDER_PRINT = true;

/* [Assembly] */
_SHOW_BARREL = true;
_SHOW_BARREL_RETAINER = true;
_SHOW_TENSION_BOLTS = true;
_SHOW_RECEIVER = true;
_SHOW_LOWER = true;
_SHOW_TRUNNION = true;
_SHOW_STOCK = true;
_SHOW_BUTTPAD = true;
_SHOW_FOREND=true;
_SHOW_SEAR_SUPPORT=true;
_SHOW_SEAR=true;
_SHOW_HAMMAR=true;
_SHOW_HAMMAR_SCREWS=true;
_SHOW_TRIGGER=true;
_SHOW_TRIGGER_BAR=true;
_SHOW_TRIGGER_GUIDE=true;

/* [Transparency] */
_ALPHA_RECEIVER = 1; // [0:0.1:1])
_ALPHA_TRUNNION = 1; // [0:0.1:1])
_ALPHA_STOCK = 1; // [0:0.1:1])
_ALPHA_LOWER = 1; // [0:0.1:1])
_ALPHA_BOLT_CARRIER = 1; // [0:0.1:1])
_ALPHA_SEAR_SUPPORT = 1; // [0:0.1:1])
_ALPHA_TRIGGER = 1; // [0:0.1:1])

/* [Cutaway] */
_CUTAWAY_TRUNNION = false;
_CUTAWAY_SEAR_SUPPORT = false;

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
barrelRetainerLength = 2.25;
hammerTravel = 0.5;

magwellX = -2.674;
magwellZ = -0.4375;
magwellWallFront = 0.125;
magwellWallBack = 0.5;

// Calculated Values
ejectionPortLength = abs(magwellX)+0.1875;

boltCarrierDiameter = AR15BarrelExtensionDiameter();
boltCarrierRadius = boltCarrierDiameter/2;

boltLockedMinX = barrelX-AR15_BoltLockedLength();
boltLockedMaxX = barrelX+AR15_BoltLockLengthDiff();

firingPinMinX  = boltLockedMinX-AR15_FiringPin_Extension();
hammerMinX = firingPinMinX -hammerTravel;

stockLength=3;

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

lowerX = 4+barrelRetainerLength;
lowerZ = 0;
stockMinX = trunnionMinX-stockLength;
receiverMaxX = LowerMaxX()+lowerX;
ForendLength = 3;

triggerReturnX = lowerX+ReceiverLugRearMaxX();
triggerReturnZ = ReceiverBottomZ()-0.75;

searSpringX = -2;
searSpringZ = 1;

/* [Animation] */
DEBUG_ANIMATION = false;
T = 0; // [0:0.05:1]



// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();
$t = DEBUG_ANIMATION ? AnimationDebug(ANIMATION_STEP_CHARGE, T=T) : $t;
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

module TensionBolts(cutter=false) {
	translate([receiverMaxX+ForendLength+(1/4),0,0])
	Receiver_TensionBolts(length=18, nutType="none", cutter=cutter);
}///

module TriggerBarPin(cutter=false, clearance=0.008) {
	clear = cutter ? clearance : 0;
	
	color("Silver") RenderIf(!cutter)
	translate([lowerX-0.5,0,0.875])
	rotate([90,0,0])
	cylinder(d=Millimeters(2.5)+clear, h=Millimeters(20), center=true);
}
module TriggerSpring(cutter=false, clearance=0.01) {
	color("Silver") RenderIf(!cutter)
	translate([triggerReturnX+0.375,0,triggerReturnZ])
	rotate([0,90,0])
	Spring(CommonSmallLongSpringSpec(),
	       compressed=false,
	       cutter=cutter, clearance=clearance);
}
module SearReturnSpring(cutter=false, clearance=0.01) {
	color("Silver") RenderIf(!cutter)
	translate([searSpringX+0.375,0,searSpringZ])
	rotate([0,90,0])
	Spring(CommonSmallShortSpringSpec(),
	       compressed=false,
	       cutter=cutter, clearance=clearance);
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
    translate([-ejectionPortLength,0,-0.625/2])
    ChamferedCube([ejectionPortLength,
                   AR15BarrelExtensionLipRadius()+barrelWall+1,
                   0.625], r=1/16, teardropFlip=[true,true,true]);

    // Ejection slot forward bevel
    rotate([-AR15_CamPinAngle()*0.75,0,0])
    translate([-0.25,
               -AR15_BoltHeadRadius(),
               -0.625/2])
    mirror([0,1,0])
    rotate(40)
    ChamferedCube([ejectionPortLength,
                   AR15BarrelExtensionLipRadius()+barrelWall+1,
                   0.625], r=1/16);
  }
}

module MlokRailCuts() {
	length = ReceiverLength()+barrelRetainerLength+trunnionLength;
	translate([receiverMaxX,0,0]) {
		ReceiverMlokSlot(length=length);
		Receiver_MlokBolts(cutter=true, holes=[0:Millimeters(20):length-Millimeters(20)]);
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

module SearSupport(cutter=false, clearance=0.01, alpha=_ALPHA_SEAR_SUPPORT, cutaway=false) {
  chamferRadius = 1/16;
	clear = cutter ? clearance : -clearance;
	clear2 = clear*2;
	length = abs(trunnionMinX-barrelX);

	color("Chocolate", alpha) render() Cutaway(cutaway)
	difference() {
		union() {
			translate([trunnionMinX,0,0]) {

				// Vertical slot
				translate([-clear,-(ReceiverTopSlotWidth()/2)-clear,-clear])
				ChamferedCube([length+clear2,
				               ReceiverTopSlotWidth()+clear2,
				               ReceiverTopSlotHeight()+clear2],
										  r=chamferRadius, teardropFlip=[true, true, true]);

				// Horizontal slot
				translate([-clear,
				           -(ReceiverTopSlotHorizontalWidth()/2)-clear,
				           ReceiverTopSlotHeight()+clear])
				mirror([0,0,1])
				ChamferedCube([length+clear2,
				               ReceiverTopSlotHorizontalWidth()+clear2,
				               ReceiverTopSlotHorizontalHeight()+clear2],
										  r=chamferRadius, teardropFlip=[true, true, true]);
			}
		}
		
		translate([trunnionMinX,0,0])
		rotate([0,90,0])
		ChamferedCircularHole(r1=1/2, r2=chamferRadius, h=length);
		
		for (P = [0:0.1:1]) // TODO: Do better, this is a hack.
		HammAR_Sear(pivot=P, cutter=true);
		
		HammAR_SearPin(cutter=true);
		
		HammAR_Cutter();
		
		translate([-TriggerTravel(),0,0])
		TriggerBar(cutter=true);
	}
}
module Trunnion(alpha=_ALPHA_TRUNNION, cutaway=false) {

	color("Tan", alpha) render() Cutaway(cutaway)
	difference() {
		union() {
			translate([trunnionMinX,0,0])
			mirror([1,0,0])
			Receiver_Segment(length=trunnionLength,
			                 highTop=true,
			                 chamferFront=true, chamferBack=true);
			
			Magwell();
		}

		hull() {
			// Bolt Head Passage
			translate([barrelX,0,0])
			rotate([0,-90,0])
			cylinder(r=AR15_BoltHeadRadius()+0.01,
			         h=abs(boltCarrierMaxX)+ManifoldGap(2));
			
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
		
		// Vertical slot
		translate([trunnionMinX,-(ReceiverTopSlotWidth()/2)-ReceiverSlotClearance(),-chamferRadius])
		mirror([1,0,0])
		rotate([0,-90,0])
		ChamferedSquareHole(sides=[ReceiverTopSlotHeight()+ReceiverSlotClearance(),
		                           ReceiverTopSlotWidth()],
		                    length=abs(trunnionMinX),
		                    center=false, corners=false,
		                    chamferRadius=chamferRadius, chamferTop=false);

		
		EjectionPortCutout();
		Barrel(cutter=true);
		HammAR_Cutter();
		HammAR_HandleSlot();
		
		translate([trunnionMinX,0,0])
		HammAR_Chamfer();
		
		translate([magwellX,0,magwellZ])
		AR15_MagwellInsert(extraTop=abs(magwellZ)-(0.3));
		
		translate([-trunnionLength,0,0])
		HammAR_Chamfer();
		
		TensionBolts(cutter=true);
		
		MlokRailCuts();
		
		translate([trunnionMinX,0,0])
		mirror([1,0,0])
		ReceiverTopSlot(length=trunnionLength,
		                verticalSlot=false);
	}
}

module BarrelRetainer(alpha=_ALPHA_RECEIVER, cutaway=false) {

	color("Tan", alpha) render() Cutaway(cutaway)
	difference() {
		translate([barrelRetainerMinX,0,0])
		mirror([1,0,0])
		Receiver_Segment(length=barrelRetainerLength,
		                 highTop=true,
		                 chamferFront=true, chamferBack=true);
		
		translate([barrelRetainerMinX,0,0])
		mirror([1,0,0])
		ReceiverTopSlot(length=barrelRetainerLength,
		                verticalSlot=false);
		
		translate([barrelRetainerMinX,0,0])
		rotate([0,90,0])
		HoleChamfer(r1=AR15BarrelChamberRadius(), r2=1/32);
		
		Barrel(cutter=true);
		TensionBolts(cutter=true);
		
		MlokRailCuts();
	}
}

module Stock(bottomDiameter=1, wall=0.25, clearance=0.008, alpha=_ALPHA_STOCK) {
	clear2 = clearance*2;
	highTopLength = 0.25;

	color("Tan", alpha) render()
	difference() {
		// Body
		hull() {
			translate([trunnionMinX,0,0])
			Receiver_Segment(length=highTopLength,
			                 highTop=true,
			                 chamferFront=true, chamferBack=true);
			
			translate([trunnionMinX-highTopLength,0,0])
			Receiver_Segment(length=stockLength-highTopLength,
			                 highTop=false, chamferBack=true);
		}
		
		HammAR_HandleSlot();
		
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
		
		translate([trunnionMinX,0,0])
		mirror([1,0,0])
		HammAR_Chamfer(pivot=true);
		
		TensionBolts(cutter=true);
		
		for (P = [0:0.1:1]) // TODO: Do better, this is a hack.
		HammAR_Sear(pivot=P, cutter=true);
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
		HammAR_Cutter2D(camTrack=false, pivot=false, clearance=0.02);
		
		translate([stockMinX,0,0])
		mirror([1,0,0])
		HammAR_Chamfer(camTrack=false, pivot=false, clearance=0.02);
		
		TensionBolts(cutter=true);
		
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
module Forend(alpha=_ALPHA_RECEIVER, cutaway=false) {
	CR=1/16;

	color("Tan", alpha) render() Cutaway(cutaway)
	difference() {
		union() {
			hull() {
					
					translate([receiverMaxX,0,0])
					mirror([1,0,0])
					Receiver_Segment(length=ForendLength,
					                 highTop=false,
					                 chamferBack=true, chamferFront=true);
				
					translate([receiverMaxX,0,0])
					mirror([1,0,0])
					Receiver_Segment(length=0.125,
					                 highTop=true,
					                 chamferBack=true, chamferFront=true);
			}
			
			hull() {
				translate([receiverMaxX+ForendLength,0,0])
				Receiver_Segment(length=0.125,
				                 highTop=false,
				                 chamferBack=true, chamferFront=true);
				
				translate([receiverMaxX,-(LowerMaxWidth()/2),0])
				mirror([0,0,1])
				ChamferedCube([0.125,
				               LowerMaxWidth(),
				               TriggerPocketHeight()+abs(ReceiverBottomZ())+0.1875],
				              teardropFlip=[true,true,true], r=CR);
			}
		}
		
		translate([receiverMaxX,0,0])
		rotate([0,90,0])
		ChamferedCircularHole(r1=(1.25/2)+0.01, r2=CR, h=ForendLength);
		
		translate([barrelRetainerMinX,0,0])
		rotate([0,90,0])
		HoleChamfer(r1=AR15BarrelChamberRadius(), r2=1/32);
		
		TensionBolts(cutter=true);
	}
}
module TriggerGuide(clearance=0.01, alpha=_ALPHA_TRIGGER) {
	CR = 1/16;
	roundBodyLength = 2;
	
	bodyX = lowerX-roundBodyLength+0.75;
	
	color("Chocolate", alpha) render()
	difference() {
		translate([bodyX,0,0])
		union() {
			
			// Round body
			rotate([0,90,0])
			ChamferedCylinder(r1=ReceiverIR()-clearance, r2=CR,
												h=roundBodyLength, teardropTop=true);

			// Vertical slot
			translate([0,-(ReceiverTopSlotWidth()/2)+clearance,0])
			ChamferedCube([roundBodyLength,
										 ReceiverTopSlotWidth()-(clearance*2),
										 ReceiverTopSlotHeight()],
										r=chamferRadius, teardropFlip=[true, true, true]);

			// Horizontal slot
			translate([0,
								 -(ReceiverTopSlotHorizontalWidth()/2)+clearance,
								 ReceiverTopSlotHeight()])
			mirror([0,0,1])
			ChamferedCube([roundBodyLength,
										 ReceiverTopSlotHorizontalWidth()-(clearance*2),
										 ReceiverTopSlotHorizontalHeight()-clearance],
										r=chamferRadius, teardropFlip=[true, true, true]);
			
			// Trigger attachment
			translate([roundBodyLength,-(0.75/2)+clearance,ReceiverBottomZ()])
			mirror([1,0,0])
			ChamferedCube([1.25,
										 0.75-(clearance*2),
										 abs(ReceiverBottomZ())],
										r=chamferRadius, teardropFlip=[true, true, true]);
			
			// Side slots
			sideWidth = (ReceiverIR()+Receiver_SideSlotDepth()-clearance)*2;
			sideHeight= Receiver_SideSlotHeight()-clearance;
			translate([0,
								 -(sideWidth/2),
								 -sideHeight/2])
			ChamferedCube([roundBodyLength,
										 sideWidth,
										 sideHeight],
										r=chamferRadius, teardropFlip=[false, true, true]);
		}
		
		// Barrel clearance
		translate([bodyX,0,0])
		rotate([0,90,0])
		ChamferedCircularHole(r1=(1/2), r2=CR, h=roundBodyLength);
		
		TriggerBarPin(cutter=true);
		TriggerBar(cutter=true);
		Trigger(cutter=true);
	}
}
module TriggerBar(cutter=false, clearance=0.008) {
	clear = cutter ? clearance : 0;
	clear2 = clear*2;
	CR = 1/16;
	clearCR = cutter ? CR : 0;
	
	width = 0.25;
	
	color("Olive") RenderIf(!cutter)
	difference() {
		union() {
			
			hull() {
				translate([-0.25,-(width/2)-clear,1-clear])
				ChamferedCube([lowerX, width+clear2, width+clearCR+clear2],
				              r=CR,
				              teardropFlip=[true,true,false]);
				
				// Angled tip (long)
				translate([-0.625,-(width/2)-clear,1.25+clearCR+clear])
				mirror([0,0,1])
				ChamferedCube([1, width+clear2, (1/16)+clearCR+clear2],
				              r=(1/32),
				              teardropFlip=[true,true,false]);
			}
			
			// Trigger Guide Connector Block
			translate([lowerX-1.5-clearCR,-(width/2)-clear,0.625-clear])
			ChamferedCube([1.5+clearCR, width+clear2, 0.625+clearCR+clear2],
			               r=CR,
			               teardropFlip=[true,true,false]);
		}
		
		if (!cutter)
		TriggerBarPin(cutter=true);
	}
}
module Trigger(cutter=false, clearance=0.015, alpha=_ALPHA_TRIGGER) {
	clear = cutter ? clearance : 0;
	clear2 = clear*2;
	CR = 1/16;
	connectionLength = 0.75;
	
	color("Olive", alpha) RenderIf(!cutter)
	difference() {
		union() {
			
			translate([LowerMaxX()+lowerX,0,0])
			TriggerBase(frontLeg=true, backLeg=false);
			
			// Connect trigger base and round body
			translate([lowerX+ReceiverLugRearMaxX()+0.625-clear,
								 -(TriggerWidth()/2)-clear,
								 LowerOffsetZ()-TriggerHeight()+clearance+clear])
			ChamferedCube([connectionLength+clear2,
										 TriggerWidth()+clear2,
										 TriggerHeight()+0.5+clear2],
										 r=1/16);
		}
		
		TriggerSpring(cutter=true);
		TriggerPlunger(cutter=true);
	}
}
module TriggerPlunger(cutter=false, clearance=0.01, alpha=0.5) {
	CR = 1/32;
	clear = cutter ? clearance : 0;
	clear2 = clear*2;
	clearCR = cutter ? CR : 0;
	width = 0.3125;
	
	travelCut = cutter ? 0.375 : 0;
	
	color("Chocolate", alpha) RenderIf(!cutter)
	difference() {
		union() {
			
			// Body
			translate([triggerReturnX,0,triggerReturnZ])
			rotate([0,90,0])
			ChamferedCylinder(r1=(width/2)+clear, r2=CR, h=1.125+travelCut);
			
			// Key
			*translate([triggerReturnX+0.375-clearCR,-(1/8/2)-clear,triggerReturnZ])
			ChamferedCube([0.125+clearCR+travelCut, (1/8)+clear2, (width/2)+(1/16)+clear], r=CR);
		}
		
		TriggerSpring(cutter=true);
	}
	
}
///

ScaleToMillimeters()
//translate([-stockMinX+ButtpadLength(),0,0])
if ($preview) {
	

  triggerAF = SubAnimate(ANIMATION_STEP_FIRE, end=0.5)
	          - SubAnimate(ANIMATION_STEP_CHARGE);
	searAF = SubAnimate(ANIMATION_STEP_FIRE, end=0.5)
	       - SubAnimate(ANIMATION_STEP_LOAD, start=0.35, end=0.8);
	hammerAF = SubAnimate(ANIMATION_STEP_FIRE, start=0.5)
	         - SubAnimate(ANIMATION_STEP_LOAD, start=0.84);
	chargeAF = SubAnimate(ANIMATION_STEP_UNLOAD)
	         - SubAnimate(ANIMATION_STEP_LOAD);
	chargerRotationAF = SubAnimate(ANIMATION_STEP_UNLOCK)
	                  - SubAnimate(ANIMATION_STEP_LOCK);
	disconnectorAF = SubAnimate(ANIMATION_STEP_LOAD, start=0.84, end=0.9)
	               - SubAnimate(ANIMATION_STEP_LOCK);
	echo("Disconnector AF: ", disconnectorAF);
	
	if (_SHOW_BARREL)
	Barrel();
	
	translate([-TriggerTravel()*triggerAF,0,0]) {
		
		if (_SHOW_TRIGGER)
		TriggerSpring();
		
		if (_SHOW_TRIGGER)
		TriggerPlunger();
		
		if (_SHOW_TRIGGER_BAR)
		TriggerBarPin();
		
		if (_SHOW_TRIGGER_BAR)
		TriggerBar();
		
		if (_SHOW_TRIGGER)
		Trigger();
		
		if (_SHOW_TRIGGER_GUIDE)
		TriggerGuide();
	}

	if (_SHOW_LOWER)
	translate([LowerMaxX()+lowerX,0,lowerZ]) {
		LowerMount(searSupport=false, hammerGuide=false, takedownPin=false, alpha=_ALPHA_LOWER);
		Lower(alpha=_ALPHA_LOWER);
	}
	
	if (_SHOW_TENSION_BOLTS)
	TensionBolts();
	
	if (_SHOW_HAMMAR)
	HammAR(rotationAF=chargerRotationAF,
	       travelAF=chargeAF,
	       searAF=searAF,
	       hammerAF=hammerAF,
	       disconnectorAF=disconnectorAF,
	       screws=_SHOW_HAMMAR_SCREWS,
	       sear=_SHOW_SEAR,
	       alpha=_ALPHA_BOLT_CARRIER);
	
	if (_SHOW_SEAR_SUPPORT)
	SearSupport(cutaway=_CUTAWAY_SEAR_SUPPORT);

	if (_SHOW_TRUNNION)
	Trunnion(cutaway=_CUTAWAY_TRUNNION);
	
	if (_SHOW_BARREL_RETAINER)
	BarrelRetainer();
	
	if (_SHOW_FOREND)
	Forend();
	
	if (_SHOW_RECEIVER)
	translate([receiverMaxX,0,0])
	Receiver(alpha=_ALPHA_RECEIVER, highTop=true, mlok=false, takedownPin=false);

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
			rotate([0,-90,0])
			translate([-barrelRetainerMinX,0,0])
			BarrelRetainer();
		
	if (_RENDER == "Prints/Forend")
		if (!_RENDER_PRINT)
			Forend();
		else
			rotate([0,-90,0])
			translate([-receiverMaxX,0,0])
			Forend();
		
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

	if (_RENDER == "Prints/SearSupport")
		if (!_RENDER_PRINT)
			SearSupport();
		else
			rotate([0,90,0])
			SearSupport();

	if (_RENDER == "Prints/TriggerGuide")
		if (!_RENDER_PRINT)
			TriggerGuide();
		else
			rotate([0,90,0])
			translate([-lowerX,0,0])
			TriggerGuide();

	if (_RENDER == "Prints/Trigger")
		if (!_RENDER_PRINT)
			Trigger();
		else
			rotate([0,-90,0])
		  translate([-lowerX,0,-lowerZ])
			Trigger();

	if (_RENDER == "Prints/TriggerPlunger")
		if (!_RENDER_PRINT)
			TriggerPlunger();
		else
			rotate([0,-90,0])
		  translate([-lowerX,0,-lowerZ])
			TriggerPlunger();

	if (_RENDER == "Prints/TriggerBar")
		if (!_RENDER_PRINT)
			TriggerBar();
		else
			rotate([90,0,0])
			TriggerBar();

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
