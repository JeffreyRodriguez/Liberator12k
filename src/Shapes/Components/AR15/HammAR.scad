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
_RENDER = ""; // ["", "Prints/BoltCarrier", "Prints/BoltCarrierBack", "Prints/HammerCompressor"]

// Reorient the part for printing?
_RENDER_PRINT = true;

/* [Assembly] */
_SHOW_BOLT = true;
_SHOW_BOLT_CARRIER=true;
_SHOW_HAMMER = true;
_SHOW_HAMMER_SPRING = true;
_SHOW_SEAR = true;

/* [Transparency] */
_ALPHA_BOLT_CARRIER = .3; // [0:0.1:1])
_ALPHA_HAMMER = .5; // [0:0.1:1])

/* [Cutaway] */
_CUTAWAY_TUBE = false;
_CUTAWAY_TRUNNION = false;

/* [Vitamins] */

/* [Fine Tuning] */
hammerTravel = 0.5;
boltCarrierDiameter = 1;
boltCarrierMaxX = -0.375;

// Derived values
boltCarrierRadius = boltCarrierDiameter/2;

boltCarrierMinX = -(AR15_BoltLockedLength()+AR15_FiringPin_Extension());
boltCarrierLength = abs(boltCarrierMinX-boltCarrierMaxX);
boltCarrierBackMinX = boltCarrierMinX-hammerTravel-1.75;
boltCarrierBackLength = abs(boltCarrierBackMinX-boltCarrierMinX);

hammerSpringX = boltCarrierBackMinX+0.25;
hammerX  = boltCarrierMinX-hammerTravel;
searLength = 1.53125;
searWidth = 0.25;

// Variable access functions
function HammAR_Length() = boltCarrierLength+boltCarrierBackLength;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

// **********
// * Shapes *
// **********
module HammAR_Chamfer(camTrack = true, clearance=0.01) {
	CR = 1/16;
	
	screwSupportOR = 0.625+clearance;
	screwSupportOD = screwSupportOR*2;
	
	screwSin = sin(22.5)*screwSupportOR;

	// Body
	rotate([0,90,0])
	HoleChamfer(r1=boltCarrierRadius+clearance,
	              r2=CR);
	
	// Screw Support
	for (R = [0, -22.5]) rotate([R,0,0])
	for (Y = [1,0]) mirror([0,Y,0])
	translate([0,0.375,])
	rotate([0,90,0])
	HoleChamfer(r1=0.25+clearance,
	              r2=CR);
	
	// Screw Support Pivot Clearance
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

module HammAR_Cutter(length = HammAR_Length(), camTrack = true, clearance=0.01) {
	CR = 1/16;
	
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
	for (R = [0,22.5]) rotate([R,0,0])
	translate([boltCarrierMaxX,0,0])
	rotate([0,-90,0])
	HammAR_ScrewSupport(HammAR_Length(), clearance);
	
	// Screw Support Pivot Clearance
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
	AR15_BoltCamPinTrack(length=HammAR_Length());
}
module HammAR_ScrewSupport(length=1, clearance=0) {
	CR = 1/16;
	
	rotate(22.5)
	for (Y = [1,0]) mirror([0,Y,0])
	translate([0,0.375,-clearance])
	ChamferedCylinder(r1=0.25+clearance, r2=CR,
	                  h=length+(clearance*2),
										teardropTop=true);
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
module HammAR_Screws(cutter=false) {
	rotate([-22.5,0,0])
  for (Y = [1,0]) mirror([0,Y,0])
  translate([boltCarrierMaxX,0.375+0.0625,0])
  rotate([0,90,0])
  NutAndBolt(bolt=BoltSpec("#8-32"),
             boltLength=HammAR_Length()+ManifoldGap(2),
             head="flat", capHeightExtra=(cutter?1:0),
             nut="none",
             teardrop=false, teardropAngle=180, capOrientation=true,
             doRender=!cutter);
}
module HammAR_HammerSpring(cutter=false, clearance=0.01) {
	color("Silver") RenderIf(!cutter)
	translate([hammerSpringX,0,0])
	rotate([0,90,0])
	Spring(spring=CommonHammerSpringSpec(), compressed=!cutter,
	       cutter=cutter, clearance=clearance);
}

module HammAR_Hammer(cutter=false, clearance=0.01, alpha=_ALPHA_HAMMER) {
	clear = cutter ? clearance : 0;
	clear2 = clear*2;

	translate([hammerX+ManifoldGap(),0,0])
	rotate([0,90,0])
	rotate(30)
	NutAndBolt(bolt=HammerBolt(), boltLength=3+ManifoldGap(2),
						 head="flat", nut="none",
						 nutBackset=3.25,
						 nutHeightExtra=(cutter?1:0),
						 capOrientation=true,
						 clearance=(cutter?clearance:0),
						 doRender=!cutter);
	
	
	translate([hammerX,0,0])
	rotate([0,-90,0])
	color("Goldenrod", alpha)
	cylinder(d=(9/32)+clear2, h=3);
}
module HammAR_Sear(pivotFactor=0, cutter=false, clearance=0.01, alpha=_ALPHA_HAMMER) {
	clear = cutter ? clearance : 0;
	clear2 = clear*2;

	color("Silver", alpha) RenderIf(!cutter)
	translate([hammerX-clear,-(searWidth/2)-clear,-searLength])
	cube([searWidth, searWidth+clear2, searLength]);
}
///

// **********
// * Prints *
// **********
module HammAR_Front(cutter=false, clearance=0.01, alpha=_ALPHA_BOLT_CARRIER) {
	CR = 1/16;

	color("Olive", alpha) RenderIf(!cutter)
	difference() {

		union() {

			// Body
			translate([boltCarrierMaxX,0,0])
			rotate([0,-90,0])
			ChamferedCylinder(r1=boltCarrierRadius,
			                  r2=CR,
			                   h=boltCarrierLength,
			                   teardropTop=true);
			
			translate([boltCarrierMaxX,0,0])
			rotate([0,-90,0])
			HammAR_ScrewSupport(boltCarrierLength);
		}

		// Firing Pin Rear Hole Chamfer
		translate([boltCarrierMinX,0,0])
		rotate([0,90,0])
		HoleChamfer(r1=AR15_FiringPin_ShoulderRadius(), r2=CR, teardrop=true);

		HammAR_Bolt(cutter=true);
		HammAR_Screws(cutter=true);
	}
}
module HammAR_Back(cutter=false, clearance=0.01, alpha=_ALPHA_BOLT_CARRIER) {
	clear = cutter ? clearance : 0;
	clear2 = clear*2;
	CR = 1/16;

	color("Chocolate", alpha) RenderIf(!cutter)
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

		// Bolt Rear Hole Chamfer
		translate([boltCarrierMinX-boltCarrierBackLength,0,0])
		rotate([0,90,0])
		HoleChamfer(r1=(9/32/2), r2=CR, teardrop=true);

		HammAR_Bolt(cutter=true);
		HammAR_Screws(cutter=true);
		HammAR_Hammer(cutter=true);
		HammAR_HammerSpring(cutter=true);
		HammAR_Sear(cutter=true);
	}
}
module HammAR_Compressor(cutter=false, clearance=0.01, alpha=1) {
	length = 0.5;
	CR = 1/32;

	color("Olive", alpha) RenderIf(!cutter)
	difference() {

		union() {

			// Body
			translate([hammerX,0,0])
			rotate([0,-90,0])
			ChamferedCylinder(r1=SpringOuterRadius(CommonHammerSpringSpec()),
			                  r2=CR,
			                   h=length,
			                   teardropTop=true);
		}

		// Bolt Rear Hole Chamfer
		translate([hammerX-length,0,0])
		rotate([0,90,0])
		HoleChamfer(r1=(9/32/2), r2=CR, teardrop=true);

		HammAR_Bolt(cutter=true);
		HammAR_Hammer(cutter=true);
	}
}
///

// **************
// * Assemblies *
// **************
module HammAR(hardware=true, prints=true, hammerAF=0, cutter=false) {
	if (_SHOW_SEAR)
	HammAR_Sear(cutter=cutter);
	
	if (_SHOW_HAMMER)
	translate([-hammerTravel*hammerAF,0,0]) {
		HammAR_Hammer(cutter=cutter);
		HammAR_Compressor();
	}

	if (_SHOW_HAMMER_SPRING)
	HammAR_HammerSpring(cutter=cutter);
	
	if (_SHOW_BOLT)
	HammAR_Bolt(cutter=cutter);

	if (_SHOW_BOLT_CARRIER) {
		HammAR_Screws(cutter=cutter);
		HammAR_Front(cutter=cutter);
		HammAR_Back(cutter=cutter);
	}
}

ScaleToMillimeters()
if ($preview) {
	#render()
	HammAR_Cutter();
	
	#render()
	translate([boltCarrierMaxX-HammAR_Length(),0,0])
	HammAR_Chamfer();
	
	HammAR(hammerAF=$t);
} else {

  // *****************
  // * Printed Parts *
  // *****************
	if (_RENDER == "Prints/BoltCarrier")
		if (!_RENDER_PRINT)
			HammAR_Front();
		else
			rotate([0,-90,0])
			translate([-boltCarrierMinX,0,0])
			HammAR_Front();
		
	if (_RENDER == "Prints/BoltCarrierBack")
		if (!_RENDER_PRINT)
			HammAR_Back();
		else
			rotate([0,-90,0])
			translate([-boltCarrierMinX,0,0])
			HammAR_Back();
		
	if (_RENDER == "Prints/HammerCompressor")
		if (!_RENDER_PRINT)
			HammAR_Compressor();
		else
			rotate([0,-90,0])
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

	if (_RENDER == "Hardware/HammerSpring")
	translate([lowerX,0,0])
	HammAR_HammerSpring();

	if (_RENDER == "Hardware/HammerScrews")
	translate([lowerX,0,0])
	HammAR_HammerScrews();
}
