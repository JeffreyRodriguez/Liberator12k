include <../../../Meta/Common.scad>;

use <../../../Shapes/Semicircle.scad>;
use <../../../Shapes/Chamfer.scad>;

use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Vitamins/Nuts and Bolts/BoltSpec.scad>;

include <Chambers.scad>;

/* [Export] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Prints/ChamberReamer", "Prints/JigBottom", "Prints/JigTop"]

// Reorient the part for printing?
_RENDER_PRINT = true;

/* [Cartridge] */
CARTRIDGE = "300 AAC Blackout"; // ["300 AAC Blackout"]
CHAMBER = ChamberSpec(CARTRIDGE);

/* [Vitamins] */
ELECTRODE_INSET = 0.01;
ELECTRODE_THICKNESS = 0.032;
JIG_THICKNESS = 0.25;
JIG_SIDE = 1;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

module ECM_ChamberReamer(chamber=CHAMBER, electrode=ELECTRODE_THICKNESS, core=Inches(1/8)) {
	height = ChamberLength(chamber);
	boreDiameter = ChamberBoreDiameter(chamber);

	// Electrode
	%color("Gold")
	ChamberProfile(chamber, electrode);

	color("Tan", 0.5)
	render()
	difference() {

		// Chambering Reamer Insulator
		Chamber(chamber);

		// Electrode slot
		ChamberProfile(chamber, electrode);

		// Electrode Water Gap
		difference() {

			rotate([0,-90,0])
			translate([0,Inches(1/16)])
			linear_extrude(electrode*2, center=true)
			scale([1,0.5])
			polygon(chamber);

			rotate([0,-90,0])
			translate([0,-Inches(1/16)])
			linear_extrude(electrode*2, center=true)
			scale([1,0.5])
			polygon(chamber);
		}

		// Core
		*cylinder(d=core, h=height);
	}
}
///

module ECM_ChamberElectrodeJigBolts(chamber=CHAMBER, spec=BoltSpec("M3"), length=Millimeters(10), cutter=false, clearance=0.01) {
	for (X = [BoltSocketCapDiameter(spec),
		        ChamberLength(chamber)/2,
		        ChamberLength(chamber)-BoltSocketCapDiameter(spec)])
	translate([X,-BoltRadius(spec),0])
	mirror([0,0,1])
	NutAndBolt(spec, nut=(cutter?"none":"hex"), boltLength=length,
	           capOrientation=true, clearance=(cutter?clearance:0));
}
///

module ECM_ChamberElectrodeJig(chamber=CHAMBER, electrode=ELECTRODE_THICKNESS, thickness=JIG_THICKNESS, side=JIG_SIDE, inset=ELECTRODE_INSET, cutout=true) {

	jigProfile = [
		[0, -JIG_SIDE*2],
		each(chamber),
		[ChamberLength(chamber), -JIG_SIDE*2]
	];

	color("Tan") render()
	difference() {
		// Jig body
		rotate([0,90,0])
		ChamberProfile(jigProfile, thickness, center=false);

		// Electrode cutout
		if (cutout)
		translate([0,inset,thickness-electrode])
		rotate([0,90,0])
		ChamberProfile(chamber, electrode, center=false);

		ECM_ChamberElectrodeJigBolts(chamber, cutter=true);
	}
}
///

// *************
// * Rendering *
// *************
ScaleToMillimeters()
if ($preview) {

	ECM_ChamberReamer();

	translate([0,2,0]) {

		// Jig electrode
		color("Gold")
		translate([0,0,JIG_THICKNESS-ELECTRODE_THICKNESS+ManifoldGap()])
		rotate([0,90,0])
		ChamberProfile(CHAMBER, ELECTRODE_THICKNESS, center=false);

		// Bolts
		ECM_ChamberElectrodeJigBolts();

		// Top Plate
		translate([0,0,JIG_THICKNESS])
		ECM_ChamberElectrodeJig(cutout=false);

		// Bottom Plate
		ECM_ChamberElectrodeJig();
	}
} else {

  // *****************
  // * Printed Parts *
  // *****************
  if (_RENDER == "Prints/ChamberReamer")
    if (!_RENDER_PRINT)
			ECM_ChamberReamer();
    else
      ECM_ChamberReamer();

  if (_RENDER == "Prints/JigBottom")
    if (!_RENDER_PRINT)
			ECM_ChamberElectrodeJig();
    else
			ECM_ChamberElectrodeJig();

  if (_RENDER == "Prints/JigTop")
    if (!_RENDER_PRINT)
			translate([0,0,JIG_THICKNESS])
			ECM_ChamberElectrodeJig(cutout=false);
    else
			ECM_ChamberElectrodeJig(cutout=false);

  // ************
  // * Hardware *
  // ************
  if (_RENDER == "Hardware/Stock_ButtpadBolt")
  GripBolts();
}
