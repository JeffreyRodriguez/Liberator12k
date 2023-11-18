include <../Meta/Common.scad>;

use <../Meta/slookup.scad>;
use <../Shapes/Chamfer.scad>;

Example_Spec_ = "17"; // ["17"]
Example_Centered_ = true;
Example_Reoriented_ = true;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

/*************************
 * Spec Lookup Functions *
 *************************/
function NEMA_Stepper_SideLength(spec) = slookup("SideLength", spec);
function NEMA_Stepper_HoleSpacing(spec) = slookup("HoleSpacing", spec);
function NEMA_Stepper_HoleDiameter(spec) = slookup("HoleDiameter", spec);
function NEMA_Stepper_ShaftDiameter(spec) = slookup("ShaftDiameter", spec);

// Derived value functions
function NEMA_Stepper_HoleRadius(spec) = NEMA_Stepper_HoleDiameter(spec)/2;
function NEMA_Stepper_ShaftRadius(spec) = NEMA_Stepper_ShaftDiameter(spec)/2;

// Convenience defaults, not part of official spec
function NEMA_Stepper_Height(spec) = slookup("Height", spec);
function NEMA_Stepper_BoltSpec(spec) = slookup("BoltSpec", spec);
function NEMA_Stepper_ShaftLength(spec) = slookup("ShaftLength", spec);
function NEMA_Stepper_BossLength(spec) = slookup("BossLength", spec);
function NEMA_Stepper_BossDiameter(spec) = slookup("BossDiameter", spec);
function NEMA_Stepper_BossRadius(spec) = NEMA_Stepper_BossDiameter(spec)/2;

/**********
 * Shapes *
 **********/
module NEMA_Stepper(spec=NEMA_Stepper_Spec("17"), height=undef, shaftLength=undef, bossLength=undef, center=true, reorient=true, cutter=false, clearance=Millimeters(.25)) {
  holeSpacing = NEMA_Stepper_HoleSpacing(spec);
  holeSpacingHalf = holeSpacing/2;

  sideLength = NEMA_Stepper_SideLength(spec);
  sideLengthHalf = sideLength/2;

	_height = default(NEMA_Stepper_Height(spec), height);

  color("DimGrey", 0.5)
  RenderIf(!cutter) {

		// Motor Body
		TranslateIf(center, [-sideLengthHalf, -sideLengthHalf,0])
		TranslateIf(reorient, [0,0,-_height])
		cube([sideLength, sideLength, _height]);

		// Center boss
		TranslateIf(!center, [sideLengthHalf, sideLengthHalf,0])
		TranslateIf(!reorient, [0,0,_height])
		cylinder(d=NEMA_Stepper_BossDiameter(spec),
		         h=default(NEMA_Stepper_BossLength(spec), bossLength));

		// Output Shaft
		TranslateIf(!center, [sideLengthHalf, sideLengthHalf,0])
		TranslateIf(!reorient, [0,0,_height])
		cylinder(d=NEMA_Stepper_ShaftDiameter(spec),
             h=default(NEMA_Stepper_ShaftLength(spec), shaftLength));
	}
}
//

module NEMA_Stepper_BoltIterator(spec, center=true, height=undef, reorient=true) {
  holeSpacing = NEMA_Stepper_HoleSpacing(spec);
  holeSpacingHalf = holeSpacing/2;

  sideLength = NEMA_Stepper_SideLength(spec);
  sideLengthHalf = sideLength/2;

	_height = default(NEMA_Stepper_Height(spec), height);

	TranslateIf(!center, [sideLengthHalf, sideLengthHalf,0])
	for (X = [1,-1]) for (Y=[1,-1])
	TranslateIf(!reorient, [0,0,_height])
	translate([X*holeSpacingHalf, Y*holeSpacingHalf, 0])
	children();
}
//

/*********
 * Specs *
 *********/
NEMA_STEPPER_SPECS = [
  ["17", [
		["SideLength",    Millimeters(42.3)],
		["HoleSpacing",   Millimeters(31)],
		["HoleDiameter",  Millimeters(3.5)],
		["ShaftDiameter", Millimeters(5)],

		["BoltSpec",      "M3"],
		["BossDiameter",  Millimeters(24)],
		["BossLength",    Millimeters(2)],
		["Height",        Millimeters(42)],
		["ShaftLength",   Millimeters(25)]],
  ]
];

function NEMA_Stepper_Spec(name) = slookup(name, NEMA_STEPPER_SPECS);

/***********
 * Example *
 ***********/

EXAMPLE_SPEC = NEMA_Stepper_Spec(Example_Spec_);

NEMA_Stepper_BoltIterator(EXAMPLE_SPEC,
                          center=Example_Centered_,
													reorient=Example_Reoriented_)
color("Silver")
cylinder(d=NEMA_Stepper_HoleDiameter(EXAMPLE_SPEC),
				 h=Millimeters(3));

NEMA_Stepper(EXAMPLE_SPEC,
             center=Example_Centered_,
						 reorient=Example_Reoriented_);
