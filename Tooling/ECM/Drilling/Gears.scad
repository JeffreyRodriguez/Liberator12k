use <../../../Meta/Animation.scad>;
use <../../../Meta/Debug.scad>;
use <../../../Meta/Cylinder Text.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Shapes/Chamfer.scad>;
use <../../../Shapes/Components/ORing.scad>;
use <../../../Shapes/Components/Pipe/Cap.scad>;
use <../../../Shapes/Gear.scad>;
use <../../../Shapes/Teardrop.scad>;
use <../../../Vitamins/Bearing.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Stepper Motor.scad>;
use <../../../Vitamins/Nuts And Bolts.scad>;
use <ECM Drilling Cap.scad>;

//all meshing gears need the same mm_per_tooth
units_per_tooth = 0.1875;

// Gears from barrel -> motor
drivenGearTeeth = 31;
drivenGearPitchRadius =pitch_radius(units_per_tooth,drivenGearTeeth);

driveGearTeeth = 20;
driveGearPitchRadius =pitch_radius(units_per_tooth,driveGearTeeth);

gearClearance=0.015;
gearThickness    = 1/2;
gearDistance = driveGearPitchRadius+drivenGearPitchRadius;

echo("Drive Gear Pitch Radius: ", pitch_radius(units_per_tooth,driveGearTeeth));
echo("Driven Gear Pitch Radius: ", pitch_radius(units_per_tooth,drivenGearTeeth));
echo("Driven:Drive ratio ", drivenGearTeeth/driveGearTeeth);


// Gears
module DrivenGear(id=0.75+0.02, extension=0.375) {
  color("OliveDrab")
  render()
  difference() {
    render()
    union() {
      intersection() {
        ChamferedCylinder(r1=drivenGearPitchRadius+(units_per_tooth/3), r2=1/16, h=gearThickness, $fn=60);
        
        translate([0,0,gearThickness/2])
        gear(units_per_tooth,drivenGearTeeth,gearThickness,0,
             clearance=gearClearance);
      }
      
      ChamferedCylinder(r1=0.75, r2=1/16, h=gearThickness+extension, $fn=50);
    }
    
    ChamferedCircularHole(r1=id/2,
                          r2=1/32,
                           h=gearThickness+extension, $fn=40);

    translate([0,0,gearThickness+0.125])
    for (r = [0, 120, -120]) rotate(r)
    rotate([0,90,0])
    Bolt(bolt=Spec_BoltM4(), teardrop=true, teardropAngle=180, clearance=false, length=2);
  }
}
module DriveGear(id=5/16, extension=0.375, flipZ=false) {
  translate([0,0,flipZ?gearThickness+extension:0]) mirror([0,0,flipZ?1:0])
  color("DarkCyan") render()
  difference() {
    union() {
      intersection() {
        ChamferedCylinder(r1=driveGearPitchRadius+(units_per_tooth/3), r2=1/16,
                          h=gearThickness, $fn=60);
        
        translate([0,0,(gearThickness/2)])
        gear(units_per_tooth,driveGearTeeth,gearThickness,0,
             clearance=gearClearance);
      }
      
      ChamferedCylinder(r1=0.36, r2=1/16,
                        chamferBottom=false, h=gearThickness+extension, $fn=50);
    }
    
    ChamferedCircularHole(r1=(id/2)+0.005,
                          r2=1/32,
                           h=gearThickness+extension, $fn=40);

    translate([0,0,gearThickness+0.125])
    for (r = [0, 120, -120]) rotate(r)
    rotate([0,90,0])
    Bolt(bolt=Spec_BoltM4(), teardrop=true, teardropAngle=180, clearance=false, length=2);
  }
}

/*
rotate(360/driveGearTeeth/2)
DriveGear(flipZ=false, id=5/16);

translate([gearDistance,0,0])
DrivenGear();
*/
*!scale(25.4)
DrivenGear();

*!scale(25.4)
DriveGear();