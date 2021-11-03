use <../../../Meta/Animation.scad>;
use <../../../Meta/Debug.scad>;
use <../../../Meta/Cylinder Text.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Shapes/Chamfer.scad>;
use <../../../Shapes/Components/ORing.scad>;
use <../../../Shapes/Components/Gear.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Nuts And Bolts.scad>;
use <ECM Drilling Cap.scad>;


PIPE = Spec_TubingZeroPointSevenFive();
//PIPE = Spec_TubingOnePointZero();

barrelOD = PipeOuterDiameter(PIPE);

driveGearToothCount = 12;
drivenGearToothCount = 24;
gearClearance=0.01;

//all meshing gears need the same mm_per_tooth
units_per_tooth = 0.25;
thickness    = 7/16;
d1 =pitch_radius(units_per_tooth,driveGearToothCount);
d2 =pitch_radius(units_per_tooth,drivenGearToothCount);
echo("Pitch Radii: ", pitch_radius(units_per_tooth,driveGearToothCount)
                     +pitch_radius(units_per_tooth,drivenGearToothCount));


GEARBOX_MOTOR_LENGTH = 2.2585;
GEARBOX_MOTOR_DIAMETER = 1.104;
GEARBOX_MOTOR_SHAFT_LENGTH = 0.548;
GEARBOX_MOTOR_SHAFT_DIAMETER = 0.155;
motorMountHeight=1.25;
motorMountBoltHeight=0.1;
motorMountBoltGap = 0.05;

module MotorMount() {
  render()
  difference() {
    
    hull() {
      // Motor mount shell
      translate([d1+d2,0,0])
      cylinder(r=(GEARBOX_MOTOR_DIAMETER/2)+0.125, h=motorMountHeight, $fn=30);
      
      cylinder(r=0.5, h=motorMountHeight, $fn=30);
    }
    
    // Motor
    translate([d1+d2,0,0])
    translate([0,0,-ManifoldGap()])
    cylinder(r=(GEARBOX_MOTOR_DIAMETER/2)+0.02, h=motorMountHeight-motorMountBoltHeight, $fn=30);
    
    
    // Bolt holes
    translate([d1+d2,0,0])
    for (r = [0,180]) rotate(r)
    translate([Millimeters(10),0,motorMountHeight-motorMountBoltHeight-ManifoldGap(2)])
    Bolt(bolt=Spec_BoltM4(), clearance=true, length=thickness);
    
    // Shaft Hole
    translate([d1+d2,0,motorMountHeight])
    mirror([0,0,1])
    cylinder(r=3/16, h=motorMountBoltHeight+ManifoldGap(2), $fn=15);
    
    // Fitting
    translate([0,0,-ManifoldGap()])
    cylinder(r=0.646, h=motorMountHeight+ManifoldGap(2), $fn=60);
    
  }
  
}

module GearboxMotor() {
  translate([d1+d2,0,0])
  union() {
    
    // Motor
    cylinder(r=GEARBOX_MOTOR_DIAMETER/2, h=GEARBOX_MOTOR_LENGTH, $fn=20);
    
    // Shaft
    translate([0,0,GEARBOX_MOTOR_LENGTH])
    cylinder(r=GEARBOX_MOTOR_SHAFT_DIAMETER/2, h=GEARBOX_MOTOR_SHAFT_LENGTH, $fn=10);
    
    // Bolts
    for (r = [0,180]) rotate(r)
    translate([Millimeters(10),0,GEARBOX_MOTOR_LENGTH])
    *%Bolt(bolt=Spec_BoltM4(), clearance=false, length=thickness);
    
    // Drive gear
    translate([0,0,GEARBOX_MOTOR_LENGTH+motorMountBoltHeight+motorMountBoltGap])
    DriveGear();
  
  }

  // Driven Gear
  translate([0,0,GEARBOX_MOTOR_LENGTH+motorMountBoltHeight+motorMountBoltGap])
  rotate(360/drivenGearToothCount/2)
  DrivenGear();
  
}

module DriveGear() {
  translate([0,0,thickness/2])
  difference() {
    gear(units_per_tooth,driveGearToothCount,thickness,GEARBOX_MOTOR_SHAFT_DIAMETER+0.02,
         clearance=gearClearance);
    
    for (r = [0:3]) rotate((90*r)+(1/driveGearToothCount*360/2))
    rotate([0,-90,0])
    Bolt(bolt=Spec_BoltM4(), teardrop=true, clearance=false, length=2);
  }
}


module DrivenGear() {
  translate([0,0,thickness/2])
  difference() {
    gear(units_per_tooth,drivenGearToothCount,thickness,barrelOD, ,
         clearance=gearClearance);
    
    for (r = [0:3]) rotate((90*r)+(1/drivenGearToothCount*360/2))
    rotate([0,90,0])
    Bolt(bolt=Spec_BoltM4(), teardrop=true, teardropAngle=180, clearance=false, length=2);
  }
}

//mirror([0,0,1])
*scale(25.4) {
  ECM_DrillingCap();
  
  translate([0,0,.64]) {
    GearboxMotor();
    
    color("Red", alpha=0.5)  
    translate([0,0,GEARBOX_MOTOR_LENGTH-motorMountHeight+0.1])
    MotorMount();
  }
  
    
  %translate([0,0,3])
  cylinder(r=(barrelOD/2),h=4, $fn=50);
}

scale(25.4)
translate([0,d2*2,0])
DrivenGear();

scale(25.4)
DriveGear();

scale(25.4)
translate([0,0,motorMountHeight])
rotate([180,0,0])
MotorMount();