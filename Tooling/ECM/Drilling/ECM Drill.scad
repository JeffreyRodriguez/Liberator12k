use <../../../Meta/Animation.scad>;
use <../../../Meta/Cutaway.scad>;
use <../../../Meta/Cylinder Text.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Meta/Conditionals/RenderIf.scad>;
use <../../../Shapes/Chamfer.scad>;
use <../../../Shapes/Components/ORing.scad>;
use <../../../Shapes/Gear.scad>;
use <../../../Shapes/Teardrop.scad>;
use <../../../Vitamins/Stepper Motor.scad>;
use <../../../Vitamins/Nuts And Bolts.scad>;
include <Gears.scad>;

/* [Export] */

// Select a part, Render it (F6), then Export to STL (F7)
_RENDER = ""; // ["", "DrivenGear", "DriveGear", "ColumnFoot", "DrillBase", "DrillHead", "Carriage", "ToolHolder"]

/* [Transparency] */
_ALPHA_BARREL=0.5; // [0:0.1:1]
_ALPHA_DRILL_BASE=0.5; // [0:0.1:1]
_ALPHA_DRILL_HEAD=0.5; // [0:0.1:1]

/* [Vitamins] */
BARREL_DIAMETER = 0.75;
BARREL_LENGTH = 6;
ORING_WIDTH = 0.09375;
DRIVESCREW_DIAMETER=0.3125;
ELECTRODE_DIAMETER=0.125;

/* [Chosen Dimensions] */
BARREL_OFFSET_X = 1.25;
BARREL_INSET_BOTTOM = 0.5;
BARREL_INSET_TOP = 0.375; // Unused yet
BARREL_WALL = 0.25;

ELECTRODE_LENGTH=7;
COLUMNFOOT_HEIGHT=1.75;
DRILLBASE_HEIGHT = 0.75;
DRILLBASE_EXTENSION_HEIGHT = 1.5;
DRILLHEAD_HEIGHT = 1.125;
WATER_TAP_OFFSET_X = 0.5;
WATER_TAP_OFFSET_Y = 0;

INTERMEDIATE_SHAFT_DIAMETER=5/16;

COLUMN_LENGTH=17;
COLUMN_WIDTH=20/25.4;
COLUMN_WALL=0.25;
DRIVESCREW_MOUNT_HEIGHT = 1;
CARRIAGE_LENGTH=0.75;
DRIVE_ANGLE=0;


// Derived Values

BARREL_RADIUS = BARREL_DIAMETER/2;

DRIVESCREW_OFFSET_X = -(COLUMN_WIDTH/2);
DRIVESCREW_OFFSET_Y = (COLUMN_WIDTH/2)+COLUMN_WALL+Millimeters(21);

BARREL_CONTACT_X = BARREL_OFFSET_X-BARREL_RADIUS-0.25;
BARREL_CONTACT_Y = BARREL_RADIUS; //-(COLUMN_WIDTH/2)-COLUMN_WALL;

BARREL_Z_MIN = DRILLBASE_HEIGHT-BARREL_INSET_BOTTOM;
BARREL_Z_MAX = BARREL_Z_MIN+BARREL_LENGTH;
DRILLHEAD_Z_MIN = BARREL_Z_MAX-BARREL_INSET_TOP;
DRILLHEAD_Z_MAX = DRILLHEAD_Z_MIN+DRILLHEAD_HEIGHT;
CARRIAGE_MAX_X = BARREL_LENGTH+ELECTRODE_LENGTH;
CARRIAGE_MIN_X = CARRIAGE_MAX_X-CARRIAGE_LENGTH;

// Steppers
module RotaryStepperTop(cutter=false) {
  translate([BARREL_OFFSET_X, 0, DRILLHEAD_Z_MIN+0.5625])
  rotate(DRIVE_ANGLE) translate([0,driveGearPitchRadius+drivenGearPitchRadius,0])
  rotate(-DRIVE_ANGLE) {
    PlanetaryNEMA17(cutter=cutter);

    if (cutter)
    mirror([0,0,1])
    cylinder(r=0.375,h=1, $fn=30);
  }
}

module LinearStepper(cutter=false) {
  translate([DRIVESCREW_OFFSET_X,DRIVESCREW_OFFSET_Y,DRILLHEAD_Z_MIN])
  rotate([180,0,0])
  NEMA17(cutter=cutter);
}

// Core components
module Column(slots=[0,90,-90,180], cutter=false, clearance=0.01) {
  color("Silver") render()
  difference() {
    translate([-COLUMN_WIDTH-(cutter?clearance:0),
               -(COLUMN_WIDTH/2)-(cutter?clearance:0),
               0])
    cube([COLUMN_WIDTH+(cutter?clearance*2:0),
          COLUMN_WIDTH+(cutter?clearance*2:0),
          COLUMN_LENGTH]);

    translate([-COLUMN_WIDTH/2,0,0])
    for (R = slots) rotate(R)
    translate([(COLUMN_WIDTH/2)-0.15, -0.24/2, 0])
    cube([COLUMN_WIDTH,
           0.24,
           COLUMN_LENGTH]);
  }
}

module Barrel(clearance=0.015, cutter=false,alpha=1) {
  color("Silver", alpha)
  translate([BARREL_OFFSET_X,0,BARREL_Z_MIN])
  cylinder(r=(BARREL_DIAMETER/2)+(cutter?clearance:0),
           h=BARREL_LENGTH, $fn=50);
}

module DriveScrew(cutter=false) {

  // Screw
  color("SteelBlue")
  translate([DRIVESCREW_OFFSET_X,DRIVESCREW_OFFSET_Y,DRILLHEAD_Z_MAX])
  cylinder(r=(DRIVESCREW_DIAMETER/2)+(cutter?0.01:0),
           h=ELECTRODE_LENGTH+1.5, $fn=15);
}

module DriveNut(cutter=false) {
  translate([0,0,-Millimeters(3)]) {

    // T8 Nut Cap
    color("Gold")
    translate([DRIVESCREW_OFFSET_X,DRIVESCREW_OFFSET_Y, CARRIAGE_MAX_X+ManifoldGap()])
    cylinder(r=22/2/25.4, h=3.5/25.4, $fn=30);

    // T8 Nut Body
    color("Gold")
    translate([DRIVESCREW_OFFSET_X,DRIVESCREW_OFFSET_Y, CARRIAGE_MAX_X+ManifoldGap()-(10/25.4)])
    cylinder(r=11/2/25.4, h=15/25.4, $fn=50);

    // T8 Bolts
    color("DimGrey")
    translate([DRIVESCREW_OFFSET_X,DRIVESCREW_OFFSET_Y, CARRIAGE_MAX_X])
    for (R = [0:90:360]) rotate(R+45)
    translate([8/25.4, 0,-10/25.4])
    cylinder(r=3/64, h=15/25.4, $fn=20);
  }
}

module Electrode(clearance=0.015, cutter=false) {
  color("Brown")
  translate([BARREL_OFFSET_X,0,BARREL_LENGTH+BARREL_INSET_BOTTOM])
  cylinder(r=(ELECTRODE_DIAMETER/2)+(cutter?clearance:0),
           h=ELECTRODE_LENGTH, $fn=15);
}

// Drill Head
module DrillHeadTap(clearance=0.015, cutter=false) {

  // Outlet (3/16" tube)
  color("Gold") RenderIf(!cutter)
  translate([WATER_TAP_OFFSET_X,WATER_TAP_OFFSET_Y,BARREL_Z_MAX+0.25])
  cylinder(r=(0.14/2)+(cutter?clearance:0), h=DRILLHEAD_HEIGHT, $fn=15);

  // Water passage
  color("LightBlue") RenderIf(!cutter)
  translate([0,0,BARREL_Z_MAX+0.25])
  hull()
  for (XY = [[WATER_TAP_OFFSET_X,WATER_TAP_OFFSET_Y], [BARREL_OFFSET_X,0]])
  translate([XY[0], XY[1],0]) {
    cylinder(r1=1/8, r2=0, h=1/8*sqrt(2), $fn=30);
    sphere(r=1/8, $fn=30);
  }
}

module DrillHeadBolts(cutter=false) {
  clearance = cutter ? 0.01 : 0;

  color("SteelBlue") RenderIf(!cutter)
  for (Z = [0.5]) translate([0,0,Z+DRILLHEAD_Z_MIN]) {
    translate([-COLUMN_WIDTH-COLUMN_WALL,0,0])
    rotate([0,-90,0])
    Bolt(bolt=BoltSpec("M5"), length=Millimeters(10), head="flat",
         capOrientation=true,
         teardrop=cutter, clearance=clearance);

    translate([-(COLUMN_WIDTH/2),-(COLUMN_WIDTH/2)-COLUMN_WALL,0])
    rotate([90,0,0])
    rotate(90)
    Bolt(bolt=BoltSpec("M5"), length=Millimeters(10), head="flat",
         capOrientation=true,
         teardrop=cutter, clearance=clearance);
  }
}

module DrillHeadORing(cutter=false) {

  // Electrode O-Ring
  color("DimGrey") RenderIf(!cutter)
  translate([BARREL_OFFSET_X,0,DRILLHEAD_Z_MAX-(ORING_WIDTH*sqrt(2))])
  ORing(innerDiameter=ELECTRODE_DIAMETER, section=ORING_WIDTH, clearance=(cutter?0.01:0), teardrop=cutter, $fn=40);

  // Tap O-Ring
  color("DimGrey") RenderIf(!cutter)
  translate([WATER_TAP_OFFSET_X,WATER_TAP_OFFSET_Y,DRILLHEAD_Z_MAX-(ORING_WIDTH*sqrt(2))])
  ORing(innerDiameter=ELECTRODE_DIAMETER, section=ORING_WIDTH, clearance=(cutter?0.01:0), teardrop=cutter, $fn=40);

  // Barrel O-Ring
  color("DimGrey") RenderIf(!cutter)
  translate([BARREL_OFFSET_X,0,DRILLHEAD_Z_MIN+(1/8)])
  ORing(innerDiameter=BARREL_DIAMETER, section=1/8, clearance=(cutter?0.01:0), teardrop=cutter, $fn=40);
}

module DrillHead(debug=false, alpha=1) {
  color("Tan", alpha) render() Cutaway(enabled=debug)
  difference() {
    union() {

      hull() {

        // Column sleeve
        translate([0,0,DRILLHEAD_Z_MIN])
        translate([-COLUMN_WIDTH-COLUMN_WALL,
                   -(COLUMN_WIDTH/2)-COLUMN_WALL,
                   0])
        ChamferedCube([COLUMN_WIDTH+(COLUMN_WALL*2),
                       COLUMN_WIDTH+(COLUMN_WALL*2),
                       DRILLHEAD_HEIGHT], r=1/16,
                       $fn=40);

        // Barrel Sleeve
        translate([0,0,DRILLHEAD_Z_MIN])
        translate([BARREL_OFFSET_X,0,0])
        ChamferedCylinder(r1=(COLUMN_WIDTH/2)+COLUMN_WALL, r2=1/16,
                          h=DRILLHEAD_HEIGHT,
                          $fn=40);

        // Column sleeve
        translate([0,0,DRILLHEAD_Z_MIN])
        translate([-COLUMN_WIDTH-COLUMN_WALL,
                   0,
                   0])
        ChamferedCube([COLUMN_WIDTH+COLUMN_WALL+BARREL_OFFSET_X+((COLUMN_WIDTH/2)+COLUMN_WALL)+0.125,
                       ((COLUMN_WIDTH/2)+COLUMN_WALL),
                       DRILLHEAD_HEIGHT], r=1/16,
                       $fn=40);
      }

      // Splash barrier for motors
      translate([0,0,DRILLHEAD_Z_MIN])
      translate([-COLUMN_WIDTH-COLUMN_WALL,
                 (COLUMN_WIDTH/2),
                 0])
      ChamferedCube([COLUMN_WIDTH+COLUMN_WALL+BARREL_OFFSET_X+((COLUMN_WIDTH/2)+COLUMN_WALL)+0.25,
                     COLUMN_WALL,
                     DRILLHEAD_HEIGHT+0.25], r=1/16,
                     $fn=40);


      // Splash barrier for column
      translate([0,0,DRILLHEAD_Z_MIN])
      translate([-COLUMN_WIDTH-COLUMN_WALL,
                 -(COLUMN_WIDTH/2)-COLUMN_WALL,
                 0])
      ChamferedCube([COLUMN_WIDTH+(COLUMN_WALL*2),
                     COLUMN_WIDTH+(COLUMN_WALL*2),
                     DRILLHEAD_HEIGHT+0.25], r=1/16,
                     $fn=40);

      // Motor mounts
      difference() {
        hull() {

          // Linear Motor Mount
          translate([DRIVESCREW_OFFSET_X,DRIVESCREW_OFFSET_Y,DRILLHEAD_Z_MIN])
          translate([-1.66/2, -1.66/2,0])
          ChamferedCube([1.66, 1.66, 0.5625], r=1/16);

          // Mounting plate, same size as the gear
          translate([BARREL_OFFSET_X, 0, DRILLHEAD_Z_MIN])
          rotate(DRIVE_ANGLE)
          translate([0,driveGearPitchRadius+drivenGearPitchRadius,0])
          rotate(-DRIVE_ANGLE)
          ChamferedCylinder(r1=0.75, r2=1/16, h=0.5625, $fn=40);

          // Water tap
          translate([BARREL_OFFSET_X,0,DRILLHEAD_Z_MIN])
          ChamferedCylinder(r1=(COLUMN_WIDTH/2)+COLUMN_WALL, r2=1/16,
                            h=0.5625,
                            $fn=40);
        }

        // Drive-Gear Set-Screw Access Hole
        translate([BARREL_OFFSET_X, 0, DRILLHEAD_Z_MIN-ManifoldGap()])
        rotate(DRIVE_ANGLE)
        translate([0,driveGearPitchRadius+drivenGearPitchRadius,0])
        rotate(-DRIVE_ANGLE)
        translate([-0.25/2, 0, 0])
        cube([0.25, 1.66, 0.5625+ManifoldGap(2)]);

        // Linear-Motion-Coupler Set-Screw Access Hole
        translate([DRIVESCREW_OFFSET_X,DRIVESCREW_OFFSET_Y, DRILLHEAD_Z_MIN-ManifoldGap()])
        translate([-0.25/2, 0, 0])
        cube([0.25, 1.66, 0.5625+ManifoldGap(2)]);
      }
    }

    translate([0,0,-ManifoldGap()])
    LinearStepper(cutter=true);

    translate([0,0,ManifoldGap()])
    RotaryStepperTop(cutter=true);

    DrillHeadTap(cutter=true);
    DrillHeadBolts(cutter=true);
    DrillHeadORing(cutter=true);

    Column(slots=[0, 90,-90], cutter=true);
    Barrel(cutter=true);
    Electrode(clearance=0.025, cutter=true);
    DriveScrew(cutter=true);

    // Barrel taper
    translate([BARREL_OFFSET_X,0,BARREL_Z_MAX-ManifoldGap()])
    cylinder(r1=(BARREL_DIAMETER+0.03)/2, r2=0,  h=(BARREL_DIAMETER/2), $fn=50);
  }
}

// Drill Base
module DrillBaseBolts(cutter=false) {
  clear = cutter ? 0.01 : 0;

  color("SteelBlue")
  for (Z = [DRILLBASE_HEIGHT/2]) {

    translate([-COLUMN_WIDTH-COLUMN_WALL,0,Z])
    rotate([0,-90,0])
    Bolt(bolt=BoltSpec("M5"), length=Millimeters(10), head="flat",
         capOrientation=true,
         teardrop=cutter, clearance=clear);
  }
}

module DrillBaseORing(cutter=false) {

  // Barrel
  color("DimGrey")
  translate([BARREL_OFFSET_X,0,DRILLBASE_HEIGHT-BARREL_INSET_BOTTOM+0.25])
  ORing(innerDiameter=BARREL_DIAMETER, section=1/8, clearance=0.01, teardrop=cutter, $fn=40);

  // Electrode O-Ring
  color("DimGrey")
  translate([BARREL_OFFSET_X,0,DRILLBASE_HEIGHT-BARREL_INSET_BOTTOM-ORING_WIDTH])
  ORing(innerDiameter=ELECTRODE_DIAMETER, section=ORING_WIDTH,
        clearance=(cutter?0.01:0), teardrop=cutter, $fn=40);
}
module BarrelContact(pivotDiameter=0.125, clearance=0.008, cutter=false) {
  pivotRadius = pivotDiameter/2;

  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Gold")
  translate([BARREL_CONTACT_X,BARREL_CONTACT_Y,0])
  rotate(-90)
  union() {
    cylinder(r=pivotRadius+clear, h=DRILLBASE_HEIGHT+0.75, $fn=10);

    translate([-pivotRadius-0.0625,-0.125,DRILLBASE_HEIGHT+ManifoldGap()])
    cube([BARREL_DIAMETER+0.25, 0.25, 0.75]);
  }
}

module DrillBase(debug=false, alpha=1) {
  color("Tan", alpha) render() Cutaway(enabled=debug)
  difference() {
    union() {

      // Column sleeve
      translate([-COLUMN_WIDTH-COLUMN_WALL,-(COLUMN_WIDTH/2)-COLUMN_WALL,0])
      ChamferedCube([COLUMN_WIDTH+(COLUMN_WALL*2),
                     COLUMN_WIDTH+(COLUMN_WALL*2),
                     DRILLBASE_EXTENSION_HEIGHT], r=1/16,
                     $fn=10);

      // Contact supports
      translate([BARREL_CONTACT_X,BARREL_CONTACT_Y,0])
      ChamferedCylinder(r1=COLUMN_WALL, r2=1/16,
                        h=DRILLBASE_HEIGHT,
                        $fn=40);

      hull() {

        // Column sleeve
        translate([-COLUMN_WIDTH-COLUMN_WALL,-(COLUMN_WIDTH/2)-COLUMN_WALL,0])
        ChamferedCube([COLUMN_WIDTH+(COLUMN_WALL*2),
                       COLUMN_WIDTH+(COLUMN_WALL*2),
                       DRILLBASE_HEIGHT], r=1/16,
                       $fn=10);

        // Barrel Sleeve
        translate([BARREL_OFFSET_X,0,0])
        ChamferedCylinder(r1=(COLUMN_WIDTH/2)+COLUMN_WALL, r2=1/16,
                          h=DRILLBASE_HEIGHT,
                          $fn=60);
      }

    }

    BarrelContact(cutter=true);
    DrillBaseBolts(cutter=true);
    DrillBaseORing(cutter=true);
    Column(slots=[0,90,-90], cutter=true);
    Barrel(cutter=true);

    translate([0,0,-BARREL_LENGTH+0.125])
    Electrode(clearance=0.05, cutter=true);
  }
}

// Linear Motion
module ElectrodeSetScrew(threaded=false, clearance=true, cutter=false) {
  color("SteelBlue")
  translate([BARREL_OFFSET_X,0,CARRIAGE_MIN_X+(CARRIAGE_LENGTH/2)])
  rotate([0,90,0])
  Bolt(bolt=BoltSpec("M4"), head="none",
       teardrop=cutter, teardropAngle=180,
       clearance=(cutter&&clearance) ? 0.002 : 0, length=0.5);
}

module Carriage(extension=1, alpha=1) {
  color("Tomato", alpha) render()
  difference() {

    union() {

      // Drivenut Extension
      translate([-COLUMN_WIDTH-COLUMN_WALL,-(COLUMN_WIDTH/2)-COLUMN_WALL,CARRIAGE_MIN_X])
      ChamferedCube([COLUMN_WIDTH+(COLUMN_WALL*2),
                     COLUMN_WIDTH+(COLUMN_WALL*2)+DRIVESCREW_OFFSET_Y,
                     CARRIAGE_LENGTH], r=1/16,
                     $fn=10);

      // Electrode Extension
      translate([-COLUMN_WIDTH-COLUMN_WALL,-(COLUMN_WIDTH/2)-COLUMN_WALL,CARRIAGE_MIN_X])
      ChamferedCube([COLUMN_WIDTH+(COLUMN_WALL*2)+BARREL_OFFSET_X,
                     COLUMN_WIDTH+(COLUMN_WALL*2),
                     CARRIAGE_LENGTH], r=1/16,
                     $fn=10);

      translate([-COLUMN_WIDTH-COLUMN_WALL,-(COLUMN_WIDTH/2)-COLUMN_WALL,CARRIAGE_MIN_X])
      ChamferedCube([COLUMN_WIDTH+(COLUMN_WALL*2),
                     COLUMN_WIDTH+(COLUMN_WALL*2),
                     CARRIAGE_LENGTH+extension], r=1/16,
                     $fn=10);
    }

    Column(cutter=true);
    Electrode(clearance=0.005, cutter=true);
    ElectrodeSetScrew(threaded=true, cutter=true);
    DriveScrew(cutter=true);
    DriveNut(cutter=true);
  }
}

module ColumnFoot(extension=4, alpha=1, debug=false) {
  color("Tan", alpha) render() Cutaway(enabled=debug)
  difference() {
    union() {

      // Column sleeve
      translate([-COLUMN_WIDTH-COLUMN_WALL,-(COLUMN_WIDTH/2)-COLUMN_WALL,0])
      ChamferedCube([COLUMN_WIDTH+(COLUMN_WALL*2),
                     COLUMN_WIDTH+(COLUMN_WALL*2),
                     COLUMNFOOT_HEIGHT], r=1/16,
                     $fn=10);

      // Leg
      translate([-(COLUMN_WIDTH/2),0,0])
      rotate(45)
      for (R = [0:90:360]) rotate(R) {

        hull() {

          // Vertical segment
          translate([((COLUMN_WIDTH/2))+COLUMN_WALL,0,0])
          ChamferedCylinder(r1=COLUMN_WALL, r2=1/32, h=COLUMNFOOT_HEIGHT, $fn=20);

          // Horizontal segment
          translate([(COLUMN_WIDTH/2),-(0.25/2),0])
          ChamferedCube([COLUMN_WALL+extension,
                         0.25,
                         0.1875], r=1/32,
                         $fn=10);
        }

        // Foot
        translate([(COLUMN_WIDTH/2)+extension+COLUMN_WALL,-(0.8/2),0])
        mirror([1,0,0])
        ChamferedCube([0.8,
                       0.8,
                       0.125], r=1/32,
                       $fn=10);
      }

    }

    for (Z = [0, 20/25.4])
    translate([0,0,0.5+Z])
    translate([-COLUMN_WIDTH/2,0,0])
    rotate(180)
    translate([(COLUMN_WIDTH/2)+COLUMN_WALL,0,0])
    rotate([0,90,0])
    Bolt(bolt=BoltSpec("M5"), length=Millimeters(10), head="flat",
         capOrientation=true, teardrop=true, teardropAngle=180, clearance=0.008);

    Column(slots=[0,-90,90], cutter=true);
  }

}
ScaleToMillimeters()
if ($preview) {

  // Core Components
  Column();

  translate([0,0,COLUMNFOOT_HEIGHT])
  DriveScrew();

  translate([0,0,COLUMNFOOT_HEIGHT-BARREL_LENGTH*$t]) {
    Electrode();
    ElectrodeSetScrew();
    DriveNut();
    Carriage();
  }

  *BarrelContact();

  translate([0,0,COLUMNFOOT_HEIGHT]) {
    Barrel(alpha=_ALPHA_BARREL);

    rotations=3;

    // Barrel drive
    translate([BARREL_OFFSET_X,0,DRILLHEAD_Z_MIN-gearThickness])
    mirror([0,0,1])
    rotate(DRIVE_ANGLE) translate([0,gearDistance,0])
    mirror([0,0,1])
    rotate(rotations*360*$t)
    rotate(360/driveGearTeeth*0.45)
    DriveGear(id=5/16);

    translate([BARREL_OFFSET_X,0,DRILLHEAD_Z_MIN])
    mirror([0,0,1])
    rotate(-rotations*360*$t*(driveGearTeeth/drivenGearTeeth))
    DrivenGear();
    RotaryStepperTop();


    DrillBaseORing();
    DrillHeadORing();
    DrillHeadTap();

    DrillBaseBolts();
    DrillHeadBolts();

    LinearStepper();

    DrillBase(alpha=_ALPHA_DRILL_BASE);
    DrillHead(alpha=_ALPHA_DRILL_HEAD);
  }

  ColumnFoot();

} else {

  if (_RENDER == "DrivenGear")
  DrivenGear();

  if (_RENDER == "DriveGear")
  DriveGear();

  if (_RENDER == "ColumnFoot")
  ColumnFoot();

  if (_RENDER == "DrillBase")
  DrillBase();

  if (_RENDER == "DrillHead")
  translate([0,0,-DRILLHEAD_Z_MIN])
  DrillHead();

  if (_RENDER == "Carriage")
  translate([0,0,-CARRIAGE_MIN_X])
  Carriage();

  if (_RENDER == "ToolHolder")
  translate([0,0,-CARRIAGE_MIN_X])
  ToolHolder();
}
