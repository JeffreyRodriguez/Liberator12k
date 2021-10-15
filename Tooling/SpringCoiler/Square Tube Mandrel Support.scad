use <../../Shapes/Gear.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Meta/Math/Triangles.scad>;
use <../../Meta/Units.scad>;
use <../../Vitamins/Bearing.scad>;
use <../../Vitamins/Square Tube.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Shapes/Chamfer.scad>;

DEFAULT_BEARING =Spec_Bearing608();
DEFAULT_MANDREL=0.3125;
DEFAULT_DRIVESCREW=0.3125;
DEFAULT_TUBE=1;

_tube = 1;
_halfTube = _tube/2;

function RodDiameter(diameter) = diameter;
function RodRadius(diameter) = diameter/2;
module Rod(diameter=1, length=1) {
  cylinder(r=diameter/2, h=length);
}

chamferRadius=0.05;
wall = 0.25;
height=0.75;
mandrelOffset = RodRadius(DEFAULT_MANDREL)+0.25;
drivescrewOffset = BearingOuterRadius(DEFAULT_BEARING);

axelDistance = pyth_A_B(_tube+drivescrewOffset-wall,
                        _halfTube+mandrelOffset-wall);
echo ("Axel Distance: ", axelDistance);

totalTeeth = 54;
gearRatio  = 1/4;
n1 = floor(totalTeeth*gearRatio);
n2 = totalTeeth-n1;

//all meshing gears need the same mm_per_tooth
units_per_tooth = 0.2475;
thickness    = 0.25;
d1 =pitch_radius(units_per_tooth,n1);
echo("Pitch Radii: ", pitch_radius(units_per_tooth,n1)
                     +pitch_radius(units_per_tooth,n2));

module BearingSet(height=0.75, cutter=true) {
  for (Z = [0,height-BearingHeight(DEFAULT_BEARING)])
  translate([0,0,Z])
  Bearing(spec=DEFAULT_BEARING, solid=cutter);
}

module MandrelPosition() {
  translate([_tube+wall+(mandrelOffset),
             0,
             0])
  children();
}

module DrivescrewPosition() {
  translate([_halfTube+(wall),
             _tube+(wall*2)+(drivescrewOffset),0])
  children();
}

module IntermediatePosition() {
  translate([_tube+(wall)+(axelDistance/2),
             _tube+(wall)+(axelDistance/2),0])
  children();
}

module SpringWinderCarriage(height=1, $fn=20) {

  color("OliveDrab")
  render() {
    difference() {
      hull() {

        ChamferedCube([_tube+(wall*2),
                       _tube+(wall*2), height], r=chamferRadius);


        DrivescrewPosition()
        ChamferedCylinder(r1=RodRadius(DEFAULT_DRIVESCREW)+wall, r2=chamferRadius, h=height);

      }

      translate([wall,wall,0])
      ChamferedSquareHole(sides=[_tube+UnitsImperial(0.01),_tube+UnitsImperial(0.01)],
                          chamferRadius=chamferRadius,
                          cornerRadius=UnitsImperial(0.05),
                          length=height, center=false);

      // Driverod hole
      DrivescrewPosition()
      ChamferedCircularHole(r1=RodRadius(DEFAULT_DRIVESCREW)-0.02,
                            r2=chamferRadius, h=height);
    }
  }
}

module MandrelSupport($fn=20) {
  color("Tan")
  render() {

    difference() {
      hull() {

        ChamferedCube([_tube+(wall*2),
                       _tube+(wall*2), height], r=chamferRadius);

        // Mandrel support
        MandrelPosition()
        ChamferedCylinder(r1=RodRadius(DEFAULT_MANDREL)+wall,
                          r2=chamferRadius,
                           h=height);

        // Drivescrew support
        DrivescrewPosition()
        ChamferedCylinder(r1=BearingOuterRadius(DEFAULT_BEARING)+wall,
                          r2=chamferRadius,
                           h=height);
      }

      translate([wall,wall,0])
      ChamferedSquareHole(sides=[_tube,_tube],
                          chamferRadius=chamferRadius,
                          cornerRadius=UnitsImperial(0.05),
                          length=height, center=false);

      // Mandrel hole
      MandrelPosition()
      ChamferedCircularHole(r1=RodRadius(DEFAULT_MANDREL),
                            r2=chamferRadius,
                             h=height);

      // Drivescrew Hole
      DrivescrewPosition() {
        BearingSet();
        ChamferedCircularHole(r1=BearingRaceRadius(DEFAULT_BEARING),
                              r2=chamferRadius,
                               h=height);
      }

      // Set screw hole
      translate([wall+_halfTube,0,height/2])
      rotate([90,0,0])
      linear_extrude(height=wall*3, center=true)
      rotate(90)
      Teardrop(r=UnitsMetric(4/2));
    }
  }
}

module MandrelSupportGearbox($fn=20) {
  color("Gold")
  render() {

    difference() {
      hull() {

        ChamferedCube([_tube+(wall*2),
                       _tube+(wall*2), height], r=chamferRadius);

        MandrelPosition()
        ChamferedCylinder(r1=RodRadius(DEFAULT_MANDREL)+wall,
                          r2=chamferRadius,
                           h=height);

        DrivescrewPosition()
        ChamferedCylinder(r1=BearingOuterRadius(DEFAULT_BEARING)+wall,
                          r2=chamferRadius,
                           h=height);

        IntermediatePosition()
        ChamferedCylinder(r1=BearingOuterRadius(DEFAULT_BEARING)+wall,
                          r2=chamferRadius,
                           h=height);
      }

      translate([wall,wall,0])
      ChamferedSquareHole(sides=[_tube,_tube],
                          chamferRadius=chamferRadius,
                          cornerRadius=UnitsImperial(0.05),
                          length=height, center=false);

      MandrelPosition()
      ChamferedCircularHole(r1=RodRadius(DEFAULT_MANDREL),
                            r2=chamferRadius, h=height);

      DrivescrewPosition() {
        BearingSet();
        ChamferedCircularHole(r1=BearingRaceRadius(DEFAULT_BEARING),
                              r2=chamferRadius,
                               h=height);
      }

      IntermediatePosition() {
        BearingSet();
        ChamferedCircularHole(r1=BearingRaceRadius(DEFAULT_BEARING),
                              r2=chamferRadius,
                               h=height);
      }

      // Set screw hole
      for (X = [wall*2,_tube-wall])
      translate([X,0,height/2])
      rotate([90,0,0])
      linear_extrude(height=wall*3, center=true)
      rotate(90)
      Teardrop(r=UnitsMetric(4/2));
    }
  }
}


rotate([0,-90,0])
MandrelSupportGearbox();

translate([4,0,0])
rotate([0,-90,0])
MandrelSupport();

translate([1+($t*1/18/gearRatio),0,0])
rotate([0,-90,0])
SpringWinderCarriage();

translate([-UnitsMetric(3)-height, 0,0])
rotate([0,-90,0])
MandrelPosition()
rotate($t*360/n2)
gear(units_per_tooth,n2,thickness,RodDiameter(DEFAULT_MANDREL));

translate([-UnitsMetric(3)-height, 0,0])
rotate([0,-90,0])
DrivescrewPosition()
rotate(-$t*360/n1)
gear(units_per_tooth,n1,thickness,RodDiameter(DEFAULT_DRIVESCREW));


color("Silver", 0.5)
translate([4,0,0])
rotate([0,-90,0]){


  translate([0,0,6.5])
  MandrelPosition()
  rotate(360*$t)
  rotate([90,0,0])
  cylinder(r=0.2, h=2, $fn=20);

  MandrelPosition()
  cylinder(r=RodRadius(DEFAULT_MANDREL), h=height+4+2, $fn=40);


  DrivescrewPosition()
  cylinder(r=RodRadius(DEFAULT_MANDREL), h=height+4+0.25, $fn=40);


  translate([wall,wall,0])
  cube([_tube,_tube, height+4]);
}



module PlatedWinder() {
  *MandrelSupportGearbox();

  *MandrelSupport();

  *SpringWinderCarriage();

  *gear(units_per_tooth,n2,thickness,RodDiameter(DEFAULT_MANDREL));

  gear(units_per_tooth,n1,thickness,RodDiameter(DEFAULT_DRIVESCREW));
}

*!scale(25.4)
PlatedWinder();
