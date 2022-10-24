include <../../../Meta/Animation.scad>;

use <../../../Meta/Cutaway.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Meta/Conditionals/RenderIf.scad>;
use <../../../Shapes/Semicircle.scad>;
use <../../../Shapes/Teardrop.scad>;
use <../../../Shapes/Components/T Lug.scad>;
use <../../../Shapes/Chamfer.scad>;
use <../../../Vitamins/Springs.scad>;
use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../../../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../../../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../../../Vitamins/AR15/Bolt.scad>;
use <../../../Receiver/FCG.scad>;

/* [Export] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Prints/Front", "Prints/Back", "Prints/Compressor"]

// Reorient the part for printing?
_RENDER_PRINT = true;

/* [Assembly] */
_SHOW_BOLT = true;
_SHOW_BOLT_CARRIER=true;
_SHOW_HAMMER = true;
_SHOW_HAMMER_SPRING = true;
_SHOW_SEAR = true;
_SHOW_COMPRESSOR = true;
_SHOW_CHAMFER = true;
_SHOW_CUTTER = true;

/* [Transparency] */
_ALPHA = .3; // [0:0.1:1])

/* [Cutaway] */
_CUTAWAY_COMPRESSOR = false;

/* [Vitamins] */

/* [Fine Tuning] */
hammerTravel = 0.5;
boltCarrierDiameter = 1;
boltCarrierMaxX = -0.125;

/* [Animation] */
travelFactor = 0; // [0:0.1:1]
hammerFactor = 0; // [0:0.1:1]
searPivotFactor = 0; // [0:0.1:1]

// Derived values
boltCarrierRadius = boltCarrierDiameter/2;

boltCarrierMinX = -(AR15_BoltLockedLength()+AR15_FiringPin_Extension());
boltCarrierLength = abs(boltCarrierMinX-boltCarrierMaxX);
boltCarrierBackMinX = boltCarrierMinX-hammerTravel-1.5;
boltCarrierBackLength = abs(boltCarrierBackMinX-boltCarrierMinX);

hammerSpringX = boltCarrierBackMinX+0.25;
hammerX  = boltCarrierMinX-hammerTravel;
searLength = Inches(3);
searExtension = Inches(1.3125);
searWidth = Inches(0.25);
searPinX = hammerX+2.125;
searPinZ = (7/8);

// Variable access functions
function HammAR_X() = boltCarrierMinX + boltCarrierLength;
function HammAR_Length() = boltCarrierLength+boltCarrierBackLength;
function HammAR_Travel() = 3;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

// **********
// * Shapes *
// **********
module HammAR_Chamfer(camTrack = true, pivot=true, clearance=0.01) {
	CR = 1/16;
	
	screwSupportOR = 0.625+clearance;
	screwSupportOD = screwSupportOR*2;
	
	screwSin = sin(22.5)*screwSupportOR;

	// Body
	rotate([0,90,0])
	HoleChamfer(r1=boltCarrierRadius+clearance,
	              r2=CR);
	
	// Screw Support
	angles = pivot ? [0, -22.5] : [0];
	for (R = angles) rotate([R,0,0])
	for (Y = [1,0]) mirror([0,Y,0])
	translate([0,0.4375,0])
	rotate([0,90,0])
	HoleChamfer(r1=0.1875+clearance,
	              r2=CR);
	
	// Screw Support Pivot Clearance
	if (pivot)
	intersection() {
		rotate([-22.5/2,0,0])
		translate([CR,-screwSupportOR-CR,-screwSin/2])
		mirror([1,0,0])
		cube([(CR*4)+(clearance*2), screwSupportOD+(CR*2), screwSin]);
		
		rotate([0,90,0])
		HoleChamfer(r1=screwSupportOR, r2=CR);
	}
	
	if (camTrack)
	translate([0,-(AR15_CamPinSquareWidth()/2)-clearance,-clearance])
	rotate([0,90,0])
	mirror([1,0,0])
	ChamferedSquareHole([AR15_CamPinSquareOffset()+AR15_CamPinSquareHeight()+(clearance*2),
	                     AR15_CamPinSquareWidth()+(clearance*2)],
	                    length=CR, center=false,
	                    chamferRadius=CR, corners=false, chamferTop=false);
}

module HammAR_Cutter(length = HammAR_Length(), camTrack = true, pivot=true, clearance=0.01) {
	CR = 1/32;
	
	screwSupportOR = 0.625+clearance;
	screwSupportOD = screwSupportOR*2;

	// Body
	translate([boltCarrierMaxX,0,0])
	rotate([0,-90,0])
	translate([0,0,-clearance])
	ChamferedCylinder(r1=boltCarrierRadius+clearance,
										r2=CR,
										 h=length+(clearance*2),
										 chamferTop=false);
	
	// Screw Support
	angles = pivot ? [0,22.5] : [0];
	
	for (R = angles) rotate([R,0,0])
	translate([boltCarrierMaxX,0,0])
	rotate([0,-90,0])
	HammAR_ScrewSupport(HammAR_Length(), clearance);
	
	// Screw Support Pivot Clearance
	if (pivot)
	intersection() {
		rotate([-22.5/2,0,0])
		translate([boltCarrierMaxX+clearance,-screwSupportOR,-(sin(22.5)*screwSupportOR)/2])
		mirror([1,0,0])
		cube([length+(clearance*2), screwSupportOD, sin(22.5)*screwSupportOR]);
		
		translate([boltCarrierMaxX+clearance,0,0])
		rotate([0,-90,0])
		ChamferedCylinder(r1=screwSupportOR, r2=CR,
											h=length+(clearance*2),
											teardropTop=true);
	}
	
	if (camTrack)
	translate([AR15_BoltLockLengthDiff(),0,0])
	rotate([0,-90,0])
	AR15_BoltCamPinTrack(extraFront=AR15_BoltLockLengthDiff()+AR15_CamPinRadius(), length=HammAR_Length());
}
module HammAR_Cutter2D(camTrack = true, pivot=true, clearance=0.01) {
	screwSupportOR = 0.625+clearance;
	screwSupportOD = screwSupportOR*2;

	// Body
	circle(r=boltCarrierRadius+clearance);
	
	// Screw Support
	angles = pivot ? [0,22.5] : [0];
	
	for (R = angles) rotate(R)
	//rotate(22.5)
	for (Y = [1,0]) mirror([0,Y,0])
	translate([0,0.4375])
	circle(r=0.1875+clearance);
	
	// Screw Support Pivot Clearance
	if (pivot)
	intersection() {
		rotate(90+(22.5/2))
		translate([-screwSupportOR,-(sin(22.5)*screwSupportOR)/2])
		square([screwSupportOD, sin(22.5)*screwSupportOR]);
		
		circle(r=screwSupportOR);
	}
	
	if (camTrack)
	translate([0, -(AR15_CamPinSquareWidth()/2)-clearance])
	square([AR15_CamPinSquareOffset()+AR15_CamPinSquareHeight()+clearance,
	      AR15_CamPinSquareWidth()+(clearance*2)]);
}

module HammAR_ScrewSupport(length=1, clearance=0) {
	CR = 1/32;
	
	rotate(22.5)
	for (Y = [1,0]) mirror([0,Y,0])
	translate([0,0.4375,-clearance])
	ChamferedCylinder(r1=0.1875+clearance, r2=CR,
	                  h=length+(clearance*2),
										teardropTop=true);
}
module HammAR_SearSlot(clearance=0.01) {
	clear = clearance;
	clear2 = clear*2;
	
	for (R = [0:2:22.5]) rotate([-R,0,0])
	translate([hammerX,-(searWidth/2)-clear,0])
	rotate([0,-15,0])
	cube([2,0.26+clear2, 1]);
}
module HammAR_HandleSlot(clearance=0.01) {
	clear = clearance;
	clear2 = clear*2;
	translate([boltCarrierMinX-HammAR_Travel(),-0.4375,-(0.3125/2)-clear])
	mirror([0,1,0])
	ChamferedCube([0.75+HammAR_Travel(), 1, 0.3125+clear2],
								r=1/16, teardropFlip=[true,true,true]);
}
///

// ************
// * Vitamins *
// ************
module HammAR_Bolt(cutter=false) {
	translate([AR15_BoltLockLengthDiff(),0,0])
	rotate([0,-90,0])
	rotate(22.5) {
		AR15_Bolt(cutter=cutter);
		AR15_CamPin(cutter=cutter, extraCamPinSquareHeight=(cutter?1:0));
		AR15_FiringPin(clearance=0.01, cutter=cutter, extraShoulder=(cutter?AR15_FiringPin_Extension():0));
	}
}
module HammAR_Screws(cutter=false, clearance=0.01) {
	clear = cutter ? clearance : 0;
	
	rotate([-22.5,0,0])
	for (Y = [1,0]) mirror([0,Y,0])
	translate([boltCarrierBackMinX,0.4375,0])
	rotate([0,-90,0])
	NutAndBolt(bolt=BoltSpec("#8-32"),
	           boltLength=HammAR_Length()+ManifoldGap(2),
	           head="flat", capHeightExtra=(cutter?1:0),
	           nut="none",
	           teardrop=false, teardropAngle=180,
	           capOrientation=true,
	           doRender=!cutter, clearance=clear);
}
module HammAR_Spring(cutter=false, clearance=0.01) {
	color("Silver") RenderIf(!cutter)
	translate([hammerSpringX,0,0])
	rotate([0,90,0])
	Spring(spring=CommonHammerSpringSpec(), compressed=!cutter,
	       cutter=cutter, clearance=clearance);
}

module HammAR_Hammer(cutter=false, clearance=0.01) {
	clear = cutter ? clearance : 0;
	clear2 = clear*2;

	translate([hammerX+ManifoldGap(),0,0])
	rotate([0,90,0])
	rotate(30)
	NutAndBolt(bolt=HammerBolt(), boltLength=1.5+ManifoldGap(2),
	           head="flat", nut="none",
	           capOrientation=true,
	           clearance=clear,
	           doRender=!cutter);
}
module HammAR_Sear(pivot=0, cutter=false, clearance=0.01) {
	clear = cutter ? clearance : 0;
	clear2 = clear*2;

	color("DimGrey") RenderIf(!cutter)
	difference() {
		translate([searPinX,0,0])
		translate([0,0,searPinZ])
		rotate([0,75+(11.75*pivot),0])
		translate([-(searWidth/2)-clear,-(searWidth/2)-clear,-searPinZ-searExtension-clear])
		cube([searWidth+clear2, searWidth+clear2, searLength+clear2]);
		
		if (!cutter)
			HammAR_SearPin(cutter=true);
	}
}
module HammAR_SearPin(cutter=false, clearance=0.01) {
	clear = cutter ? clearance : 0;
	clear2 = clear*2;
	
	color("Silver") RenderIf(!cutter)
	translate([searPinX,0,searPinZ])
	rotate([90,0,0])
	cylinder(d=Millimeters(2.5)+clear, h=Millimeters(20), center=true);
}
module HammAR_Handle(cutter=false, clearance=0.01) {
	clear = cutter ? clearance : 0;
	clear2 = clear*2;
	
	*color("Silver") RenderIf(!cutter)
	translate([boltCarrierMinX+0.875,0,0])
	rotate([45+22.5,0,0])
	translate([0,0.25,-0.3125])
	cylinder(r=(1/4/2)+clear, h=2);
}
///

// **********
// * Prints *
// **********
module HammAR_Front(cutter=false, clearance=0.01, alpha=1) {
	CR = 1/32;
	clear = cutter ? clearance : 0;
	clear2 = clear*2;

	color("Olive", alpha) RenderIf(!cutter)
	difference() {

		union() {

			// Body Top
			translate([boltCarrierMaxX,0,0])
			rotate([-90-22.5,0,0])
			rotate([0,-90,0])
			intersection() {
				ChamferedCylinder(r1=boltCarrierRadius,
				                  r2=CR,
				                  h=boltCarrierLength,
				                  teardropTop=true);
				
				linear_extrude(boltCarrierLength, center=false)
				semicircle(angle=180, od=boltCarrierRadius*2);
			}
			
			// Bolt Handle
			rotate([-22.5,0,0]) {
				translate([boltCarrierMinX,-0.4375,-0.3125/2])
				mirror([0,1,0])
				ChamferedCube([0.75, 1, 0.3125],
											r=1/16, teardropFlip=[true,true,true]);
				
				translate([boltCarrierMinX,-1.625,0])
				rotate([0,90,0])
				ChamferedCylinder(r1=0.5, r2=1/16, h=0.75);
			}
			
			
			// Cam Pin Square Follower
			rotate([-22.5,0,0])
			translate([boltCarrierMaxX,-(AR15_CamPinSquareWidth()/2)-clear,0])
			mirror([1,0,0])
			ChamferedCube([AR15_CamPinOffset()-AR15_BoltLockLengthDiff()-0.125,
			               AR15_CamPinSquareWidth()+clear2,
			               AR15_CamPinSquareOffset()+AR15_CamPinSquareHeight()],
			               r=CR, teardropFlip=[false,true,true]);

			translate([boltCarrierMaxX,0,0])
			rotate([0,-90,0])
			HammAR_ScrewSupport(boltCarrierLength);
			
			hull() {
				
				// Body Bottom
				translate([boltCarrierMaxX,0,0])
				rotate([0,-90,0])
				ChamferedCylinder(r1=0.3125,
													r2=CR,
													 h=boltCarrierLength,
													 teardropTop=true);
					
				// Round depressor
				translate([boltCarrierMaxX,0,0])
				rotate([180-(22.5*1.5),0,0])
				rotate([0,-90,0])
				intersection() {
					ChamferedCylinder(r1=AR15_BoltHeadRadius(),
														r2=CR,
														 h=boltCarrierLength,
														 teardropTop=true);
					
					linear_extrude(boltCarrierLength, center=false)
					semicircle(angle=22.5, od=AR15_BoltHeadRadius()*2);
				}
			}
			
			
		}
		
		// Firing Pin Rear Hole Chamfer
		translate([boltCarrierMinX,0,0])
		rotate([0,90,0])
		HoleChamfer(r1=AR15_FiringPin_ShoulderRadius(), r2=(1/16), teardrop=true);
		
		HammAR_SearSlot();
		HammAR_Bolt(cutter=true);
		HammAR_Screws(cutter=true);
		HammAR_Handle(cutter=true);
	}
}
module HammAR_Back(cutter=false, clearance=0.01, alpha=1) {
	clear = cutter ? clearance : 0;
	clear2 = clear*2;
	CR = 1/32;

	color("Olive", alpha) RenderIf(!cutter)
	difference() {
		union() {

			// Body
			translate([boltCarrierMinX,0,0])
			rotate([0,-90,0])
			ChamferedCylinder(r1=boltCarrierRadius,
			                  r2=CR,
			                   h=boltCarrierBackLength,
			                   teardropTop=true);
			
			translate([boltCarrierMinX,0,0])
			rotate([0,-90,0])
			HammAR_ScrewSupport(boltCarrierBackLength);
		}
		
		// Hammer Rear Hole Chamfer
		translate([boltCarrierBackMinX,0,0])
		rotate([0,90,0])
		ChamferedCircularHole(r1=0.15, r2=(1/16), h=0.25);
		

		HammAR_Bolt(cutter=true);
		HammAR_Screws(cutter=true);
		HammAR_Hammer(cutter=true);
		HammAR_Spring(cutter=true);
		HammAR_SearSlot();
	}
}
module HammAR_Compressor(cutter=false, clearance=0.01, alpha=1) {
	length = 0.25;
	CR = 1/32;

	color("Chocolate", alpha) RenderIf(!cutter)
	Cutaway(_CUTAWAY_COMPRESSOR)
	difference() {

		union() {

			// Head
			translate([hammerX,0,0])
			rotate([0,-90,0])
			ChamferedCylinder(r1=SpringOuterRadius(CommonHammerSpringSpec()),
			                  r2=CR,
			                   h=length,
			                   teardropTop=true);

			// Body
			translate([hammerX,0,0])
			rotate([0,-90,0])
			ChamferedCylinder(r1=SpringInnerRadius(CommonHammerSpringSpec())*0.9,
			                  r2=CR,
			                   h=length+SpringSolidHeight(CommonHammerSpringSpec()),
			                   teardropTop=true);
		}

		// Bolt Rear Hole Chamfer
		translate([hammerX-length-SpringSolidHeight(CommonHammerSpringSpec()),0,0])
		rotate([0,90,0])
		HoleChamfer(r1=(1/4/2), r2=CR, teardrop=true);

		HammAR_Hammer(cutter=true);
	}
}
///

// **************
// * Assemblies *
// **************
module HammAR(hardware=true, prints=true, sear=true, rotationAF=0, travelAF=0, hammerAF=0, searAF=0, alpha=_ALPHA) {
	if (_SHOW_SEAR && sear) {
		HammAR_Sear(pivot=searAF);
		HammAR_SearPin();
	}
	
	HammAR_Handle();
	
	translate([-HammAR_Travel()*travelAF,0,0])
	rotate([22.5*rotationAF,0,0]) {
		
		if (_SHOW_BOLT)
		HammAR_Bolt();
		
		translate([hammerTravel*hammerAF,0,0]) {
			if (_SHOW_HAMMER)
			HammAR_Hammer();
			
			if (_SHOW_COMPRESSOR)
			HammAR_Compressor();
		}

		if (_SHOW_HAMMER_SPRING)
		HammAR_Spring();

		if (_SHOW_BOLT_CARRIER) {
			HammAR_Screws();
			HammAR_Front(alpha=alpha);
			HammAR_Back(alpha=alpha);
		}
	}
}

ScaleToMillimeters()
if ($preview) {
	if (_SHOW_CUTTER)
	#render()
	HammAR_Cutter();
	
	if (_SHOW_CUTTER)
	#HammAR_HandleSlot();
	

	*rotate([0,-90,0])
	linear_extrude(0.5)
	HammAR_Cutter2D();
	
	*rotate([0,-90,0])
	linear_extrude(1)
	HammAR_Cutter2D(pivot=false);
	
	
	if (_SHOW_CHAMFER)
	#render()
	translate([boltCarrierMaxX-HammAR_Length(),0,0])
	HammAR_Chamfer();
	
	HammAR(travelAF=travelFactor, hammerAF=hammerFactor, searAF=searPivotFactor);
} else {

  // *****************
  // * Printed Parts *
  // *****************
	if (_RENDER == "Prints/Front")
		if (!_RENDER_PRINT)
			HammAR_Front();
		else
			rotate([0,-90,0])
			translate([-boltCarrierMinX,0,0])
			HammAR_Front();
		
	if (_RENDER == "Prints/Back")
		if (!_RENDER_PRINT)
			HammAR_Back();
		else
			rotate([0,-90,0])
			translate([-boltCarrierMinX,0,0])
			HammAR_Back();
		
	if (_RENDER == "Prints/Compressor")
		if (!_RENDER_PRINT)
			HammAR_Compressor();
		else
			rotate([0,90,0])
			translate([-hammerX,0,0])
			HammAR_Compressor();

	// ************
	// * Hardware *
	// ************
	if (_RENDER == "Hardware/Bolt")
	color("Black")
	translate([AR15_BoltLockLengthDiff(),0,0])
	rotate([0,-90,0])
	HammAR_Bolt(teardrop=false, firingPinRetainer=false);

	if (_RENDER == "Hardware/Hammer")
	translate([lowerX,0,0])
	HammAR_Hammer();

	if (_RENDER == "Hardware/Spring")
	translate([lowerX,0,0])
	HammAR_Spring();

	if (_RENDER == "Hardware/HammerScrews")
	translate([lowerX,0,0])
	HammAR_HammerScrews();

	if (_RENDER == "Hardware/Sear")
	translate([lowerX,0,0])
	HammAR_Sear();
}
