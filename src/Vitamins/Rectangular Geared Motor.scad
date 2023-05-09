use <Nuts And Bolts.scad>;
use <../Meta/Units.scad>;
use <../Meta/Resolution.scad>;

MOTOR_OFFSET_Z = Inches(-0.25);
MOTOR_DIAMETER = Inches(1.22);
MOTOR_LENGTH = Inches(2.224);

MOTOR_GEARBOX_WIDTH = Inches(1.586);
MOTOR_GEARBOX_LENGTH = Inches(2.292);
MOTOR_GEARBOX_HEIGHT = Inches(1.219);

MOTOR_SHAFT_LENGTH = Inches(0.578);
MOTOR_SHAFT_DIAMETER = Inches(5/16);
MOTOR_SHAFT_OFFSET_X =Inches(0.8);

MOTOR_BOSS_DIAMETER = Inches(0.75+0.02);
MOTOR_BOSS_HEIGHT = Inches(0.095);

MOTOR_BOLT_BOSS_HEIGHT = Inches(0.076);
MOTOR_BOLT_BOSS_DIAMETER = Inches(0.316);
MOTOR_BOLT_LENGTH = Inches(1.554);
MOTOR_BOLT_WIDTH = Inches(1.1);

MOTOR_BOLT_SPEC = BoltSpec("M4");
MOTOR_BOLT_OFFSET_X = (MOTOR_GEARBOX_LENGTH - MOTOR_BOLT_LENGTH)/2;
MOTOR_BOLT_OFFSET_Y = (MOTOR_GEARBOX_WIDTH - MOTOR_BOLT_WIDTH)/2;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

module RectangularGearedMotor(motor=true, boltLength=Inches(0.25), boltClearance=Inches(0)) {
  translate([-MOTOR_SHAFT_OFFSET_X,-MOTOR_GEARBOX_WIDTH/2,])
  union() {

    // Motor
    color("Black")
    translate([MOTOR_GEARBOX_LENGTH,(MOTOR_GEARBOX_WIDTH/2),(MOTOR_GEARBOX_HEIGHT/2)+MOTOR_OFFSET_Z])
    rotate([0,90,0])
    cylinder(d=MOTOR_DIAMETER, h=MOTOR_LENGTH);

    // Gearbox
    color("DimGrey")
    cube([MOTOR_GEARBOX_LENGTH, MOTOR_GEARBOX_WIDTH, MOTOR_GEARBOX_HEIGHT]);

    // Shaft and boss
    translate([MOTOR_SHAFT_OFFSET_X, MOTOR_GEARBOX_WIDTH/2, MOTOR_GEARBOX_HEIGHT]) {

      color("Silver")
      cylinder(r=MOTOR_SHAFT_DIAMETER/2, h=MOTOR_SHAFT_LENGTH);

      color("DimGrey")
      cylinder(r=MOTOR_BOSS_DIAMETER/2, h=MOTOR_BOSS_HEIGHT);
    }

    // Bolts & Bosses
    for (XY = [[0,0], [MOTOR_BOLT_LENGTH, MOTOR_BOLT_WIDTH],
               [MOTOR_BOLT_LENGTH, 0], [0, MOTOR_BOLT_WIDTH]])
    translate([XY[0], XY[1], MOTOR_GEARBOX_HEIGHT])
    translate([MOTOR_BOLT_OFFSET_X, MOTOR_BOLT_OFFSET_Y]) {
      // Bosses
      color("DimGrey")
      cylinder(d=MOTOR_BOLT_BOSS_DIAMETER, h=MOTOR_BOLT_BOSS_HEIGHT);

      // Bolts
      NutAndBolt(MOTOR_BOLT_SPEC, boltLength=boltLength, clearance=boltClearance);
    }
  }

}

RectangularGearedMotor();
