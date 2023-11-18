use <../../Meta/Animation.scad>;
use <../../Meta/Cutaway.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Conditionals.scad>;
use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Components/ORing.scad>;
use <../../Shapes/Components/Hose Barb.scad>;
use <../../Shapes/Gear.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Vitamins/NEMA Stepper.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe Taper.scad>;
use <aluminumExtrusions.scad>;

/* [Export] */

// Select a part, Render it (F6), then Export to STL (F7)
_RENDER = ""; // ["", "DrivenGear", "DriveGear", "Legs", "Tailstock", "Headstock", "Carriage", "ToolHolder"]

/* [Assembly] */
_SHOW_HARDWARE    = true;
_SHOW_PRINTS      = true;
_SHOW_COLUMN      = true;
_SHOW_COLUMNFOOT  = true;
_SHOW_TAILSTOCK   = true;
_SHOW_HEADSTOCK   = true;
_SHOW_ELECTROLYTE = true;
_SHOW_ROTARY_AXIS = true;
_SHOW_LINEAR_AXIS = true;
_SHOW_CARRIAGE    = true;
_SHOW_DRIP_TRAY   = true;

/* [Transparency] */
_ALPHA_BARREL    = 1;   // [0:0.1:1]
_ALPHA_HEADSTOCK = 0.5; // [0:0.1:1]
_ALPHA_TAILSTOCK = 0.5; // [0:0.1:1]
_ALPHA_CARRIAGE  = 0.5; // [0:0.1:1]
_ALPHA_DRIP_TRAY = 1;   // [0:0.1:1]

/* [Vitamins] */
Barrel_Units = "Inches"; // ["Millimeters", "Inches"]
Barrel_Diameter_ = 0.75;
Barrel_Length_ = 6;
O_Ring_Units = "Inches"; // ["Millimeters", "Inches"]
Oring_Width_ = 0.09375;
Other_Vitamins_Units = "Inches"; // ["Millimeters", "Inches"]
Electrode_Diameter_ = 0.125;
Tap_Diameter_ = 0.1875;
Leadscrew_Units = "Millimeters"; // ["Millimeters", "Inches"]
Leadscrew_Diameter_in_Millimeters = 8;
Column_Extrusion = "2040"; // ["2020", "2040", "2060", "4040", "4060"]
Column_Extrusion_Length_in_Millimeters = 400;

// Derived Vitamin Values
VITAMINS_UNIT = UnitType(Other_Vitamins_Units);
BARREL_UNIT = UnitType(Barrel_Units);
BARREL_DIAMETER = UnitSelect(Barrel_Diameter_, BARREL_UNIT);
BARREL_LENGTH = UnitSelect(Barrel_Length_, BARREL_UNIT);
ORING_UNIT = UnitType(O_Ring_Units);
ORING_WIDTH = UnitSelect(Oring_Width_, ORING_UNIT);
ELECTRODE_DIAMETER = UnitSelect(Electrode_Diameter_, VITAMINS_UNIT);
TAP_DIAMETER = UnitSelect(Tap_Diameter_, VITAMINS_UNIT);

LEADSCREW_UNIT = UnitType(Leadscrew_Units);
DRIVESCREW_DIAMETER = UnitSelect(Leadscrew_Diameter_in_Millimeters, LEADSCREW_UNIT);

/* [Chosen Dimensions] */
Chosen_Dimensions_Units = "Inches"; // ["Millimeters", "Inches"]
Barrel_Offset_X_ = 1.25;
Barrel_Inset_Bottom = 0.5;
Barrel_Inset_Top = 0.375; // Unused yet
Barrel_Wall = 0.25;
CHOSEN_DIMENSIONS_UNIT = UnitType(Chosen_Dimensions_Units);

GEAR_PITCH = Millimeters(4); // all meshing gears need the same GEAR_PITCH
drivenGearTeeth = 31;
driveGearTeeth = 20;
gearClearance = 0.015;
gearThickness = 1/2;

driveGearPitchRadius  = pitch_radius(GEAR_PITCH,driveGearTeeth);
drivenGearPitchRadius = pitch_radius(GEAR_PITCH,drivenGearTeeth);
gearDistance  = driveGearPitchRadius+drivenGearPitchRadius;

echo("Drive Gear Pitch Radius: ", pitch_radius(GEAR_PITCH,driveGearTeeth));
echo("Driven Gear Pitch Radius: ", pitch_radius(GEAR_PITCH,drivenGearTeeth));
echo("Driven:Drive ratio ", drivenGearTeeth/driveGearTeeth);


// Derived Barrel Values
BARREL_OFFSET_X = UnitSelect(Barrel_Offset_X_, CHOSEN_DIMENSIONS_UNIT);
BARREL_INSET_BOTTOM = UnitSelect(Barrel_Inset_Bottom, CHOSEN_DIMENSIONS_UNIT);
BARREL_INSET_TOP = UnitSelect(Barrel_Inset_Top, CHOSEN_DIMENSIONS_UNIT); // Unused yet
BARREL_WALL = UnitSelect(Barrel_Wall, CHOSEN_DIMENSIONS_UNIT);

Electrode_Length_=7;
Column_Wall_ = 0.25;
Drivescrew_Mount_Height_ = 1;
Carriage_Length_ = 0.75;
Column_Foot_Height=1.75;
Column_Foot_Extension = 4;
Column_Foot_Pad_Width = 3/4;
Column_Foot_Plate_Height = 0.5;
Drill_Base_Height_ = 0.75;
Drill_Base_Extension_Height_ = 1.5;
Drill_Head_Height_ = 1.125;
Water_Tap_Offset_X_ = BARREL_OFFSET_X;
Water_Tap_Offset_Y_ = -1;
Tailstock_Pin_Diameter = 0.098425;
Tailstock_Height = 0.5;
Drip_Tray_Length_ = 3;
Drip_Tray_Width_ = 6;
Drip_Tray_Depth_ = 1;
Drip_Tray_Base_ = 0.125;
Drip_Tray_Wall_ = 0.125;
Drive_Screw_Length_ = 15.748;

Intermediate_Shaft_Diameter_ = 5/16;

// Derived other Chosen Dimensions Values
ELECTRODE_LENGTH = UnitSelect(Electrode_Length_, CHOSEN_DIMENSIONS_UNIT);
COLUMNFOOT_HEIGHT = UnitSelect(Column_Foot_Height, CHOSEN_DIMENSIONS_UNIT);
COLUMNFOOT_EXTENSION = UnitSelect(Column_Foot_Extension, CHOSEN_DIMENSIONS_UNIT);
COLUMNFOOT_PAD_WIDTH = UnitSelect(Column_Foot_Pad_Width, CHOSEN_DIMENSIONS_UNIT);
COLUMNFOOT_PLATE_HEIGHT = UnitSelect(Column_Foot_Plate_Height, CHOSEN_DIMENSIONS_UNIT);
function findExtrusionXSegments(extrusiontext) = extrusiontext == "2020" ? 1 : extrusiontext == "2040" ? 1 : extrusiontext == "2060" ? 1 : extrusiontext == "4020" ? 2 : extrusiontext == "4040" ? 2 : extrusiontext == "4060" ? 2 : 0;
function findExtrusionYSegments(extrusiontext) = extrusiontext == "2020" ? 1 : extrusiontext == "2040" ? 2 : extrusiontext == "2060" ? 3 : extrusiontext == "4020" ? 1 : extrusiontext == "4040" ? 2 : extrusiontext == "4060" ? 3 : 0;
COLUMN_X_SEGMENTS= findExtrusionXSegments(Column_Extrusion);
COLUMN_Y_SEGMENTS= findExtrusionYSegments(Column_Extrusion);
DRILLBASE_HEIGHT = UnitSelect(Drill_Base_Height_, CHOSEN_DIMENSIONS_UNIT);
DRILLBASE_EXTENSION_HEIGHT = UnitSelect(Drill_Base_Extension_Height_, CHOSEN_DIMENSIONS_UNIT);
DRILLHEAD_HEIGHT = UnitSelect(Drill_Head_Height_, CHOSEN_DIMENSIONS_UNIT); // Unused yet
WATER_TAP_OFFSET_X = UnitSelect(Water_Tap_Offset_X_, CHOSEN_DIMENSIONS_UNIT);
WATER_TAP_OFFSET_Y = UnitSelect(Water_Tap_Offset_Y_, CHOSEN_DIMENSIONS_UNIT);
TAILSTOCK_PIN_RADIUS = UnitSelect(Tailstock_Pin_Diameter, CHOSEN_DIMENSIONS_UNIT)/2;
TAILSTOCK_HEIGHT = UnitSelect(Tailstock_Height, CHOSEN_DIMENSIONS_UNIT)/2;
DRIP_TRAY_LENGTH = UnitSelect(Drip_Tray_Length_, CHOSEN_DIMENSIONS_UNIT);
DRIP_TRAY_WIDTH = UnitSelect(Drip_Tray_Width_, CHOSEN_DIMENSIONS_UNIT);
DRIP_TRAY_DEPTH = UnitSelect(Drip_Tray_Depth_, CHOSEN_DIMENSIONS_UNIT);
DRIP_TRAY_BASE = UnitSelect(Drip_Tray_Base_, CHOSEN_DIMENSIONS_UNIT);
DRIP_TRAY_WALL = UnitSelect(Drip_Tray_Wall_, CHOSEN_DIMENSIONS_UNIT);

INTERMEDIATE_SHAFT_DIAMETER = UnitSelect(Intermediate_Shaft_Diameter_, CHOSEN_DIMENSIONS_UNIT);

COLUMN_LENGTH = Millimeters(Column_Extrusion_Length_in_Millimeters);
COLUMN_X_WIDTH = Millimeters(COLUMN_X_SEGMENTS*20);
COLUMN_Y_WIDTH = Millimeters(COLUMN_Y_SEGMENTS*20);
COLUMN_WIDTH = COLUMN_Y_WIDTH;
COLUMN_WALL = UnitSelect(Column_Wall_, CHOSEN_DIMENSIONS_UNIT); // Unused yet
DRIVESCREW_MOUNT_HEIGHT = UnitSelect(Drivescrew_Mount_Height_, CHOSEN_DIMENSIONS_UNIT);
DRIVESCREW_LENGTH = UnitSelect(Drive_Screw_Length_, CHOSEN_DIMENSIONS_UNIT);
CARRIAGE_LENGTH = UnitSelect(Carriage_Length_, CHOSEN_DIMENSIONS_UNIT);

// Derived Values
BARREL_RADIUS = BARREL_DIAMETER/2;
ELECTRODE_RADIUS = ELECTRODE_DIAMETER/2;
TAP_RADIUS=TAP_DIAMETER/2;

DRIVESCREW_OFFSET_X = -COLUMN_X_WIDTH - COLUMN_WALL-Millimeters(21);
DRIVESCREW_OFFSET_Y = 0;

BARREL_CONTACT_X = BARREL_OFFSET_X-BARREL_RADIUS-0.25;
BARREL_CONTACT_Y = BARREL_RADIUS; //-(COLUMN_Y_WIDTH/2)-COLUMN_WALL;

BARREL_Z_MIN = COLUMNFOOT_PLATE_HEIGHT;
BARREL_Z_MAX = BARREL_Z_MIN+BARREL_LENGTH;
DRILLHEAD_Z_MIN = BARREL_Z_MAX-BARREL_INSET_TOP;
DRILLHEAD_Z_MAX = DRILLHEAD_Z_MIN+DRILLHEAD_HEIGHT;
CARRIAGE_MAX_X = BARREL_LENGTH+ELECTRODE_LENGTH;
CARRIAGE_MIN_Z = CARRIAGE_MAX_X-CARRIAGE_LENGTH;
ELECTRODE_MIN_Z = BARREL_LENGTH+BARREL_INSET_BOTTOM;
ELECTRODE_MAX_Z = ELECTRODE_MIN_Z+ELECTRODE_LENGTH;

STEPPER = NEMA_Stepper_Spec("17");
STEPPER_BOLT = BoltSpec(NEMA_Stepper_BoltSpec(STEPPER));

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

// ***************
// * Rotary Axis *
// ***************
module RotaryStepper(cutter=false) {
	translate([BARREL_OFFSET_X, 0, DRILLHEAD_Z_MIN+Inches(9/16)])
	translate([0,driveGearPitchRadius+drivenGearPitchRadius,0]) {
		
		NEMA_Stepper_BoltIterator(STEPPER)
		mirror([0,0,1])
		translate([0,0,Inches(9/16)])
		Bolt(STEPPER_BOLT, length=Millimeters(16),
		     head="socket", capOrientation=true);
		
		mirror([0,0,1])
		NEMA_Stepper(STEPPER, cutter=cutter);
		
		// TODO: Move me into the right position for the new stepper location
		// Drive Gear Extension
		if (cutter)
		mirror([0,0,1])
		cylinder(r=0.375,h=1);
	}
}
//

module DrivenGear(id=0.75+0.02, extension=0.375) {
  color("OliveDrab") render()
  difference() {
    union() {
      intersection() {
        ChamferedCylinder(r1=drivenGearPitchRadius+(GEAR_PITCH/3), r2=1/16, h=gearThickness, $fn=60);

        translate([0,0,gearThickness/2])
        gear(GEAR_PITCH,drivenGearTeeth,gearThickness,0,
             clearance=gearClearance);
      }

      ChamferedCylinder(r1=driveGearPitchRadius+GEAR_PITCH, r2=1/16, h=gearThickness+extension, $fn=50);
    }

    ChamferedCircularHole(r1=id/2,
                          r2=1/32,
                           h=gearThickness+extension, $fn=40);

    translate([0,0,gearThickness+0.125])
    for (r = [0, 120, -120]) rotate(r)
    rotate([0,90,0])
    Bolt(bolt=BoltSpec("M4"), teardrop=true, teardropAngle=180, length=2);
  }
}
//

module DriveGear(id=Millimeters(5), extension=0.375, flipZ=false) {
  translate([0,0,flipZ?gearThickness+extension:0]) mirror([0,0,flipZ?1:0])
  color("DarkCyan") render()
  difference() {
    union() {
      intersection() {
        ChamferedCylinder(r1=driveGearPitchRadius+(GEAR_PITCH/3), r2=1/16,
                          h=gearThickness, $fn=60);

        translate([0,0,(gearThickness/2)])
        gear(GEAR_PITCH,driveGearTeeth,gearThickness,0,
             clearance=gearClearance);
      }

      ChamferedCylinder(r1=0.36, r2=1/16,
                        chamferBottom=false, h=gearThickness+extension, $fn=50);
    }
    echo("ID: ", id)
    ChamferedCircularHole(r1=(id/2)+0.005,
                          r2=1/32,
                           h=gearThickness+extension, $fn=40);

    translate([0,0,gearThickness+0.125])
    for (r = [0, 120, -120]) rotate(r)
    rotate([0,90,0])
    Bolt(bolt=BoltSpec("M4"), teardrop=true, teardropAngle=180, length=2);
  }
}
//

// ***************
// * Linear Axis *
// ***************
module LinearStepper(cutter=false) {
		
	translate([DRIVESCREW_OFFSET_X, DRIVESCREW_OFFSET_Y, DRILLHEAD_Z_MIN])
	translate([0,0,Inches(9/16)])
	NEMA_Stepper_BoltIterator(STEPPER)
	Bolt(STEPPER_BOLT, length=Millimeters(16),
			 head="socket", capOrientation=true);
	
	translate([DRIVESCREW_OFFSET_X, DRIVESCREW_OFFSET_Y, DRILLHEAD_Z_MIN])
	NEMA_Stepper(STEPPER, cutter=cutter);
}
//

module DriveScrew(cutter=false) {
	// Screw
	color("Silver")
	translate([DRIVESCREW_OFFSET_X, DRIVESCREW_OFFSET_Y, DRILLHEAD_Z_MAX])
	cylinder(r=(DRIVESCREW_DIAMETER/2) + (cutter?0.01:0), h=DRIVESCREW_LENGTH);
}
//

module DriveNut(cutter=false) {
	translate([0,0,-Millimeters(3)]) {

		// T8 Nut Cap
		color("Gold")
		translate([DRIVESCREW_OFFSET_X, DRIVESCREW_OFFSET_Y, CARRIAGE_MAX_X + ManifoldGap()])
		cylinder(r=22/2/25.4, h=3.5/25.4);

		// T8 Nut Body
		color("Gold")
		translate([DRIVESCREW_OFFSET_X, DRIVESCREW_OFFSET_Y, CARRIAGE_MAX_X + ManifoldGap()-(10/25.4)])
		cylinder(r=11/2/25.4, h=15/25.4);

		// T8 Bolts
		color("DimGrey")
		translate([DRIVESCREW_OFFSET_X, DRIVESCREW_OFFSET_Y, CARRIAGE_MAX_X])
		for (R = [0: 90: 360])
		rotate(R+45)
		translate([8/25.4, 0,-10/25.4])
		cylinder(r=3/64, h=15/25.4);
		
		// Ender 3 compatible bolts
		color("DimGrey")
		translate([DRIVESCREW_OFFSET_X, DRIVESCREW_OFFSET_Y, CARRIAGE_MIN_Z])
		for (R = [90: 180: 270])
		rotate(R)
		translate([Millimeters(18/2), 0, Millimeters(-1)]) //Why is CARRIAGE_MIN_Z 3mm lower than the bottom of the carriage?
		cylinder(d=Millimeters(3), h=Millimeters(10));

		// Ender 3 T8 Nut Cap
		color("Gold")
		translate([DRIVESCREW_OFFSET_X, DRIVESCREW_OFFSET_Y, CARRIAGE_MIN_Z])
		linear_extrude(Millimeters(3.5))
		intersection(){
			circle(d=Millimeters(28));
			
			translate([-Millimeters(13)/2, -Millimeters(28)/2])
			square([Millimeters(13), Millimeters(28)]);
		}

		// Ender 3 T8 Nut Body
		color("Gold")
		translate([DRIVESCREW_OFFSET_X, DRIVESCREW_OFFSET_Y, CARRIAGE_MIN_Z - Millimeters(2)])
		cylinder(d=Millimeters(10.5), h=Millimeters(11));
	}
}
//

module Carriage(extension=1, alpha=_ALPHA_CARRIAGE) {
	color("Tomato", alpha) render()
	difference() {

		union() {
			// Extension
			translate([-COLUMN_X_WIDTH-COLUMN_WALL, -(COLUMN_Y_WIDTH/2)-COLUMN_WALL, CARRIAGE_MIN_Z])
			ChamferedCube([COLUMN_X_WIDTH + (COLUMN_WALL*2), COLUMN_Y_WIDTH + (COLUMN_WALL*2), CARRIAGE_LENGTH + extension], r=Inches(1/16));

			// Linear Drive Nut
			hull() {
				translate([-COLUMN_X_WIDTH - COLUMN_WALL, -(COLUMN_Y_WIDTH/2) - COLUMN_WALL, CARRIAGE_MIN_Z])
				ChamferedCube([COLUMN_X_WIDTH+(COLUMN_WALL*2), COLUMN_Y_WIDTH+(COLUMN_WALL*2)+DRIVESCREW_OFFSET_Y, CARRIAGE_LENGTH], r=Inches(1/16));

				translate([DRIVESCREW_OFFSET_X, DRIVESCREW_OFFSET_Y, CARRIAGE_MIN_Z])
				ChamferedCylinder(r1=Inches(0.625), r2=Inches(1/16), h=CARRIAGE_LENGTH);
			}

			// Electrode Extension
			hull() {
				translate([-COLUMN_X_WIDTH - COLUMN_WALL, -(COLUMN_Y_WIDTH/2) - COLUMN_WALL, CARRIAGE_MIN_Z])
				ChamferedCube([COLUMN_X_WIDTH + (COLUMN_WALL*2), COLUMN_Y_WIDTH+(COLUMN_WALL*2) + DRIVESCREW_OFFSET_Y, CARRIAGE_LENGTH], r=Inches(1/16));

				translate([BARREL_OFFSET_X, 0, CARRIAGE_MIN_Z])
				ChamferedCylinder(r1=Inches(0.375), r2=Inches(1/16), h=CARRIAGE_LENGTH);
			}
		}
		
		// Ender 3 compatible bolts head access hole
		translate([DRIVESCREW_OFFSET_X, DRIVESCREW_OFFSET_Y, CARRIAGE_MIN_Z])
		//rotate([180, 0, 0])
		for (R = [90: 180: 270])
		rotate(R)
		translate([Millimeters(18/2), 0, Millimeters(4)])
		cylinder(d=Millimeters(6), h=CARRIAGE_LENGTH - Millimeters(4));

		Column(cutter=true);
		translate([0,0,CARRIAGE_MIN_Z]) ColumnBottomChamfer();
		Electrode(clearance=0.005, cutter=true);
		DriveScrew(cutter=true);
		DriveNut(cutter=true);
	}
}
//

module Column(slots=[0,90,-90,180], cutter=false, clearance=0.005) {
	color("Silver") render()
	translate([-COLUMN_X_WIDTH/2, 0])
	if(cutter)
	extrusion5SeriesCrude(COLUMN_X_SEGMENTS, COLUMN_Y_SEGMENTS, COLUMN_LENGTH, clearance);
	else
	extrusion5Series(COLUMN_X_SEGMENTS, COLUMN_Y_SEGMENTS, COLUMN_LENGTH);
}
//

module ColumnBottomChamfer(bevel=Millimeters(2)) {
	bevel2 = bevel*2;
	tabLength = Millimeters(4);
	tabLength2 = tabLength*2;
	
	translate([-COLUMN_X_WIDTH,-COLUMN_Y_WIDTH/2,0])
	hull() {
		
		// Extension
		translate([tabLength,tabLength,0])
		cube([COLUMN_X_WIDTH-tabLength2, COLUMN_Y_WIDTH-tabLength2, bevel+tabLength]);
		
		// Base
		translate([-bevel, -bevel, 0])
		cube([COLUMN_X_WIDTH+bevel2, COLUMN_Y_WIDTH+bevel2, ManifoldGap()]);
	}
}
//

// Cutter
module Electrode(clearance=0.015, cutter=false) {
	
	color("Gold") RenderIf(!cutter)
	translate([BARREL_OFFSET_X,0,ELECTRODE_MIN_Z])
	cylinder(r=(ELECTRODE_DIAMETER/2) + (cutter?clearance:0), h=ELECTRODE_LENGTH);
	
	
	color("Goldenrod") RenderIf(!cutter)
	union()
	translate([BARREL_OFFSET_X,0,CARRIAGE_MIN_Z-ManifoldGap()]) {
		// Hole Cutter
		cylinder(d=0.332, h=0.625);
		
		// Hole Taper
		taperNPT("1/8");
		
		// Hex
		mirror([0,0,1])
		cylinder(d=0.5, h=0.1875, $fn=6);
	}
}
//

// Headstock Hardware
module HeadstockTap(clearance=0.015, cutter=false) {
  
	// Outlet Pipe Fitting
	color("LightGrey") RenderIf(!cutter)
	translate([WATER_TAP_OFFSET_X,WATER_TAP_OFFSET_Y,DRILLHEAD_Z_MAX]) {
		mirror([0,0,1]) taperNPT("1/8");
		mirror([0,0,1]) cylinder(d=0.332, h=0.625);
		
		cylinder(d=0.5, h=0.1875, $fn=6);
		
		HoseBarb(barbOuterMajorDiameter=Inches(0.4145),
                barbOuterMinorDiameter=Inches(0.3720),
                barbInnerDiameter=Inches(0.2285),
                barbBottomAngle=60,
                segments=3, segmentSpacing=0.125,
                extraTop=0.2, extraBottom=0.3125);
	}
  
	// Water passage to outlet pipe fitting
	if (cutter)
	translate([WATER_TAP_OFFSET_X,WATER_TAP_OFFSET_Y,BARREL_Z_MAX+0.125])
	cylinder(r1=TAP_RADIUS, d2=0.332, h=DRILLHEAD_HEIGHT);

	// Water passage
	color("LightBlue") RenderIf(!cutter)
	translate([0,0,BARREL_Z_MAX+0.25])
	hull()
	for (XY = [[WATER_TAP_OFFSET_X,WATER_TAP_OFFSET_Y], [BARREL_OFFSET_X,0]])
	translate([XY[0], XY[1],0]) {
		cylinder(r1=max(TAP_RADIUS, ELECTRODE_RADIUS), r2=0, h=TAP_RADIUS*sqrt(2));
		sphere(r=max(TAP_RADIUS, ELECTRODE_RADIUS));
	}
}
//

module HeadstockBolts(cutter=false) {
	clearance = cutter ? 0.01 : 0;

	color("SteelBlue") RenderIf(!cutter)
	translate([-Millimeters(10), -(COLUMN_Y_WIDTH/2)-COLUMN_WALL, DRILLHEAD_Z_MIN+Millimeters(15)])
	rotate([90,0,0])
	rotate(90)
	Bolt(bolt=BoltSpec("M5"), length=Millimeters(10), head="flat",
	     capHeightExtra=(cutter?COLUMN_WALL:0), capOrientation=true, teardrop=cutter, clearance=clearance);
}
//

module HeadstockORing(cutter=false) {
	// Electrode O-Ring
	color("DimGrey") RenderIf(!cutter)
	translate([BARREL_OFFSET_X,0,DRILLHEAD_Z_MAX-(ORING_WIDTH*sqrt(2))])
	ORing(innerDiameter=ELECTRODE_DIAMETER, section=ORING_WIDTH, clearance=(cutter?0.01:0), teardrop=cutter);

	// Barrel O-Ring
	color("DimGrey") RenderIf(!cutter)
	translate([BARREL_OFFSET_X,0,DRILLHEAD_Z_MIN+(1/8)])
	ORing(innerDiameter=BARREL_DIAMETER, section=1/8, clearance=(cutter?0.01:0), teardrop=cutter);
}
//

// Tailstock Hardware
module TailstockPins(cutter=false, clearance=Inches(0.005), height=Inches(3/4)) {
  // Legs
  color("Silver") RenderIf(!cutter)
  for (Y = [1,-1])
  translate([BARREL_OFFSET_X, Y*Inches(1), COLUMNFOOT_PLATE_HEIGHT-(height/2)])
  cylinder(r=TAILSTOCK_PIN_RADIUS+clearance, h=height);
}
//

// Leg Hardware
module LegBolts(cutter=false) {
	clear = cutter ? 0.01 : 0;

	color("SteelBlue")
//	for (Z = [0, 20/25.4])
//	translate([0,0,0.5+Z])
	translate([0, -COLUMN_Y_WIDTH/2, 0])
	rotate([0, 180, 0])
	for(Y = [Millimeters(10):Millimeters(20):Millimeters(20)*COLUMN_Y_SEGMENTS])
	for(X = [Millimeters(10):Millimeters(20):Millimeters(20)*COLUMN_X_SEGMENTS])
	translate([X, Y, 0])
	Bolt(bolt=BoltSpec("M5"), length=Millimeters(20), head="flat", capOrientation=true, teardrop=false, clearance=clear);
}
//

// Workpiece
module Barrel(clearance=Inches(0.015), cutter=false,alpha=_ALPHA_BARREL) {
	color("Silver", alpha)
	translate([BARREL_OFFSET_X,0,BARREL_Z_MIN])
	cylinder(r=(BARREL_DIAMETER/2)+(cutter?clearance:0), h=BARREL_LENGTH);
}
//

// **********
// * Prints *
// **********
module Headstock(debug=false, alpha=_ALPHA_HEADSTOCK) {
	color("Tan", alpha) render() Cutaway(enabled=debug)
	difference() {
		union() {

			// Column sleeve
			translate([0,0,DRILLHEAD_Z_MIN])
			translate([-COLUMN_X_WIDTH - COLUMN_WALL, -(COLUMN_WIDTH/2) - COLUMN_WALL, 0])
			ChamferedCube([COLUMN_X_WIDTH + (COLUMN_WALL*2), COLUMN_Y_WIDTH + (COLUMN_WALL*2), DRILLHEAD_HEIGHT], r=1/16);

			 // Column sleeve extended to barrel sleeve
			 translate([0, -(COLUMN_X_WIDTH/2)-COLUMN_WALL, DRILLHEAD_Z_MIN])
//			 ChamferedCube([BARREL_OFFSET_X+BARREL_RADIUS, COLUMN_Y_WIDTH+(COLUMN_WALL*2), DRILLHEAD_HEIGHT], r=1/16);
			 ChamferedCube([BARREL_OFFSET_X+BARREL_RADIUS, Millimeters(20)+(COLUMN_WALL*2), DRILLHEAD_HEIGHT], r=1/16);

			union() {
        
        // Barrel Sleeve
        translate([0, 0, DRILLHEAD_Z_MIN])
        translate([BARREL_OFFSET_X, 0, 0])
        ChamferedCylinder(r1=BARREL_RADIUS + ORING_WIDTH + COLUMN_WALL, r2=Inches(1/16), h=0.5625);

        // Water Tap Extension
        hull() {
          translate([WATER_TAP_OFFSET_X,WATER_TAP_OFFSET_Y,DRILLHEAD_Z_MIN])
          ChamferedCylinder(r1=Inches(0.5), r2=Inches(1/16), h=DRILLHEAD_HEIGHT);

          // Electrode entry hole
          translate([BARREL_OFFSET_X,0,DRILLHEAD_Z_MIN])
          ChamferedCylinder(r1=Inches(0.5), r2 = Inches(1/16), h=DRILLHEAD_HEIGHT);
        }

			}

			// Splash guard: Rotary motor
			translate([0, 0, DRILLHEAD_Z_MIN])
			translate([-COLUMN_X_WIDTH - COLUMN_WALL, Millimeters(10), 0])
			ChamferedCube([COLUMN_X_WIDTH + COLUMN_WALL + BARREL_OFFSET_X + ((COLUMN_X_WIDTH/2)+COLUMN_WALL) + Inches(0.25), COLUMN_WALL, DRILLHEAD_HEIGHT + Inches(0.25)], r=Inches(1/16));

			// Splash guard: Column
			translate([0,0,DRILLHEAD_Z_MIN])
			translate([-COLUMN_X_WIDTH-COLUMN_WALL, -(COLUMN_Y_WIDTH/2)-COLUMN_WALL, 0])
			ChamferedCube([COLUMN_X_WIDTH + (COLUMN_WALL*2), COLUMN_Y_WIDTH + (COLUMN_WALL*2), DRILLHEAD_HEIGHT + Inches(0.25)], r=Inches(1/16));

			// Linear Motor Mount
			hull() {
				// Linear Motor Mount
				translate([DRIVESCREW_OFFSET_X, DRIVESCREW_OFFSET_Y, DRILLHEAD_Z_MIN])
				translate([-Inches(1.66/2), -Inches(1.66/2), 0])
				ChamferedCube([Inches(1.66), Inches(1.66), Inches(0.5625)], r=Inches(1/16));

				// Column sleeve
				translate([0, 0, DRILLHEAD_Z_MIN])
				translate([-COLUMN_X_WIDTH - COLUMN_WALL, -(COLUMN_Y_WIDTH/2) - COLUMN_WALL, 0])
				ChamferedCube([COLUMN_WALL, COLUMN_Y_WIDTH + (COLUMN_WALL*2), Inches(0.5625)], r=Inches(1/16));
			}

			// Rotary motor mount
			hull() {
				// Mounting plate, same size as the gear
				translate([BARREL_OFFSET_X, 0, DRILLHEAD_Z_MIN])
				translate([0, driveGearPitchRadius + drivenGearPitchRadius,0])
				translate([-Inches(1.66/2), -Inches(1.66/2), 0])
				ChamferedCube([Inches(1.66), Inches(1.66), Inches(0.5625)], r=Inches(1/16));

				// Hull to barrel area
				translate([BARREL_OFFSET_X,0,DRILLHEAD_Z_MIN])
				ChamferedCylinder(r1=Inches(1.66/2), r2=Inches(1/16), h=Inches(0.5625));
			}
		}

		translate([0,0,-ManifoldGap()])
		LinearStepper(cutter=true);

		translate([0,0,ManifoldGap()])
		RotaryStepper(cutter=true);

		HeadstockTap(cutter=true);
		HeadstockBolts(cutter=true);
		HeadstockORing(cutter=true);

		Column(slots=[0, 90,-90], cutter=true);
		translate([0,0,DRILLHEAD_Z_MIN]) ColumnBottomChamfer();
		Barrel(cutter=true);
		Electrode(clearance=ELECTRODE_RADIUS, cutter=true);
		DriveScrew(cutter=true);

		// Barrel taper
		translate([BARREL_OFFSET_X, 0, BARREL_Z_MAX-ManifoldGap()])
		cylinder(r1=(BARREL_DIAMETER + 0.03)/2, r2=0, h=(BARREL_DIAMETER/2));

		// Coupler Set-Screw Access Hole
		translate([DRIVESCREW_OFFSET_X, DRIVESCREW_OFFSET_Y, DRILLHEAD_Z_MIN-ManifoldGap()])
		translate([-Inches(1.66), -Inches(0.5/2), 0])
		cube([Inches(1.66), Inches(0.5), Inches(0.5625) + ManifoldGap(2)]);

		// Drive-Gear Set-Screw Access Hole
		translate([BARREL_OFFSET_X, 0, DRILLHEAD_Z_MIN - ManifoldGap()])
		translate([0, driveGearPitchRadius + drivenGearPitchRadius, 0])
		translate([-Inches(0.25/2), 0, 0])
		cube([Inches(0.25), Inches(1.66), Inches(0.5625) + ManifoldGap(2)]);
	}
}
//

module Tailstock(debug=false, alpha=_ALPHA_TAILSTOCK) {
  CR = Inches(1/32);
	color("Tan", alpha) render() Cutaway(enabled=debug)
	difference() {
		hull() {
      
			// Barrel Sleeve
			translate([BARREL_OFFSET_X, 0, COLUMNFOOT_PLATE_HEIGHT])
			ChamferedCylinder(r1=BARREL_RADIUS + ORING_WIDTH + COLUMN_WALL, r2=CR,
                        h=TAILSTOCK_HEIGHT);
      
			// Tailstock Pin Supports
      for (Y = [1,-1])
			translate([BARREL_OFFSET_X, Y*Inches(1), COLUMNFOOT_PLATE_HEIGHT])
			ChamferedCylinder(r1=TAILSTOCK_PIN_RADIUS*4, r2=CR,
                        h=TAILSTOCK_HEIGHT);
		}

	TailstockPins(cutter=true);
	Column(slots=[0,90,-90], cutter=true);
	Barrel(cutter=true, clearance=Inches(0.005));

	translate([0,0,-BARREL_LENGTH + Inches(0.125)])
	Electrode(clearance=0.05, cutter=true);
	}
}
//

module DripTray(alpha=_ALPHA_DRIP_TRAY) {
	wall = DRIP_TRAY_WALL;
	wall2 = wall*2;
	
	color("Tan") render()
	difference() {
		union() {
			
			// Drip Tray
			translate([COLUMN_WALL-wall, -DRIP_TRAY_WIDTH/2, 0])
			ChamferedCube([DRIP_TRAY_LENGTH,
										 DRIP_TRAY_WIDTH,
										 DRIP_TRAY_DEPTH], r=Inches(1/32));
			
			// Column sleeve
			translate([-COLUMN_X_WIDTH, -(COLUMN_Y_WIDTH/2) - COLUMN_WALL, 0])
			ChamferedCube([COLUMN_X_WIDTH + COLUMN_WALL,
			               COLUMN_Y_WIDTH + (COLUMN_WALL*2),
			               DRIP_TRAY_DEPTH], r=Inches(1/16));
		}
		
		// Hollow out the drip tray
		translate([COLUMN_WALL, -(DRIP_TRAY_WIDTH/2)+wall, DRIP_TRAY_BASE])
		ChamferedCube([DRIP_TRAY_LENGTH-wall2,
									 DRIP_TRAY_WIDTH-wall2,
									 DRIP_TRAY_DEPTH], r=Inches(1/32));
		
		Column(slots=[0,-90,90], cutter=true);
	}
}

module Legs(alpha=1, debug=false) {
	extension=COLUMNFOOT_EXTENSION;
	padWidth=COLUMNFOOT_PAD_WIDTH;
	
	color("Tan", alpha) render() Cutaway(enabled=debug)
	difference() {
		union() {

			// Column sleeve
			translate([-COLUMN_X_WIDTH-COLUMN_WALL, -(COLUMN_Y_WIDTH/2) - COLUMN_WALL, 0])
			ChamferedCube([COLUMN_WALL, COLUMN_Y_WIDTH + (COLUMN_WALL*2), COLUMNFOOT_HEIGHT], r=Inches(1/16));

			// Legs
      for (Y = [1,-1])
			translate([-COLUMN_X_WIDTH-COLUMN_WALL, Y*((COLUMN_Y_WIDTH/2)+COLUMN_WALL), 0])
			mirror([1,0,0])
			rotate(Y*45)
			union() {
				
				// Leg
				hull() {
					
					// Round top
					ChamferedCylinder(r1=COLUMN_WALL, r2=Inches(1/32), h=COLUMNFOOT_HEIGHT);

					// Square tip
					translate([0,-(padWidth/4),0])
					ChamferedCube([padWidth+extension, padWidth/2, Inches(0.1875)],
												r=Inches(1/32));
				}

				// Foot Pad
				translate([extension,-(padWidth/2),0])
				ChamferedCube([padWidth, padWidth, Inches(0.125)],
											r=Inches(1/32));
			}
		}

		LegBolts(cutter=true);
    TailstockPins(cutter=true);
		Column(slots=[0,-90,90], cutter=true);
	}
}
//

module BarrelContact(pivotDiameter=Inches(0.125), clearance=0.008, cutter=false) {
	pivotRadius = pivotDiameter/2;

	clear = cutter ? clearance : 0;
	clear2 = clear*2;

	color("Gold")
	translate([BARREL_CONTACT_X, BARREL_CONTACT_Y, 0])
	rotate(-90)
	union() {
		cylinder(r=pivotRadius+clear, h=DRILLBASE_HEIGHT + Inches(0.75));

		translate([-pivotRadius - Inches(0.0625),-Inches(0.125),DRILLBASE_HEIGHT + ManifoldGap()])
		cube([BARREL_DIAMETER + Inches(0.25), Inches(0.25), Inches(0.75)]);
	}
}
//

/*************
 * Rendering *
 *************/
ScaleToMillimeters()
if ($preview) {

  if (_SHOW_COLUMN && _SHOW_HARDWARE)
	Column();

	if (_SHOW_LINEAR_AXIS && _SHOW_HARDWARE) {
		DriveScrew();
		DriveNut();
    LinearStepper();
	}

	translate([0,0,-BARREL_LENGTH*$t]) {
		if (_SHOW_ELECTROLYTE && _SHOW_HARDWARE)
		Electrode();
    
    if (_SHOW_LINEAR_AXIS && _SHOW_CARRIAGE)
		Carriage();
	}

	BarrelContact();
	
  Barrel();

		rotations=3;

  if (_SHOW_ROTARY_AXIS) {
		if (_SHOW_HARDWARE)
		RotaryStepper();
		
		translate([BARREL_OFFSET_X,0,DRILLHEAD_Z_MIN-gearThickness])
		mirror([0,0,1])
		translate([0,gearDistance,0])
		mirror([0,0,1])
		rotate(rotations*360*$t)
		rotate(360/driveGearTeeth*0.45)
		DriveGear();

		translate([BARREL_OFFSET_X,0,DRILLHEAD_Z_MIN])
		mirror([0,0,1])
		rotate(-rotations*360*$t*(driveGearTeeth/drivenGearTeeth))
		DrivenGear();
	}
  
  if (_SHOW_HEADSTOCK) {
		if (_SHOW_ELECTROLYTE && _SHOW_HARDWARE) {
			HeadstockORing();
			HeadstockTap();
		}
  
		if (_SHOW_HARDWARE)
    HeadstockBolts();
		
		if (_SHOW_PRINTS)
    Headstock();
  }
    
  if (_SHOW_TAILSTOCK) {
		if (_SHOW_HARDWARE)
		TailstockPins();
		
		if (_SHOW_PRINTS)
		Tailstock();
	}
	
	if (_SHOW_DRIP_TRAY && _SHOW_PRINTS)
	DripTray();

  if (_SHOW_COLUMNFOOT) {
		if (_SHOW_HARDWARE)
    LegBolts();
		
		if (_SHOW_PRINTS)
    Legs();
  }

} else {

	if (_RENDER == "DrivenGear")
	DrivenGear();

	if (_RENDER == "DriveGear")
	DriveGear();

	if (_RENDER == "Legs")
	Legs();

	if (_RENDER == "Tailstock")
	Tailstock();

	if (_RENDER == "Headstock")
	translate([0,0,-DRILLHEAD_Z_MIN])
	Headstock();

	if (_RENDER == "Carriage")
	translate([0,0,-CARRIAGE_MIN_Z])
	Carriage();

	if (_RENDER == "ToolHolder")
	translate([0,0,-CARRIAGE_MIN_Z])
	ToolHolder();
}
