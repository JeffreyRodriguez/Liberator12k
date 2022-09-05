use <../Shapes/Teardrop.scad>;
use <../Shapes/Chamfer.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Vitamins/Nuts And Bolts.scad>;

AR15_BARREL_DIAMETER = UnitsImperial(0.98);
AR15_BARREL_RADIUS = AR15_BARREL_DIAMETER/2;

AR15_BARRELNUT_DIAMETER = UnitsImperial(1.363);
AR15_BARRELNUT_RADIUS = AR15_BARRELNUT_DIAMETER/2;
AR15_BARRELNUT_LENGTH = UnitsImperial(0.852);
AR15_BARRELNUT_TOOTHED_DIAMETER = UnitsImperial(1.556);
AR15_BARRELNUT_TOOTHED_RADIUS = AR15_BARRELNUT_TOOTHED_DIAMETER/2;
AR15_BARRELNUT_TOOTHED_LENGTH = UnitsImperial(0.128);
AR15_GAS_CHANNEL_LENGTH = UnitsImperial(4.334);
AR15_GAS_CHANNEL_WIDTH = UnitsImperial(0.42+0.1625);
AR15_GAS_CHANNEL_HEIGHT = UnitsImperial(0.5+0.1);

GAS_PORT_RADIUS =UnitsImperial(.2);
barrelNutWall= UnitsImperial(0.25);

module BoltPositions() {
  
  // Barrel nut bolt support
  for (Y = [0,1]) mirror([0,Y,0])
  translate([UnitsMetric(15),AR15_BARRELNUT_RADIUS+UnitsMetric(4),AR15_BARRELNUT_LENGTH/2])
  rotate([0,-90,0])
  children();
  
  // Barrel bolt support
  for (Y = [0,1]) mirror([0,Y,0])
  translate([UnitsMetric(15),AR15_BARREL_RADIUS+UnitsMetric(4),AR15_GAS_CHANNEL_LENGTH-UnitsMetric(20)])
  rotate([0,-90,0])
  children();
  
}

$fn= 40;

scale(25.4)
render()
//DebugHalf(dimension=300) rotate(90)
difference() {
  hull()
  union() {
    ChamferedCylinder(r1=AR15_BARRELNUT_RADIUS+barrelNutWall,
                      r2=UnitsImperial(0.1),
                       h=AR15_BARRELNUT_LENGTH,
                     $fn=40);
    
    
    ChamferedCylinder(r1=AR15_BARREL_RADIUS+barrelNutWall,
                      r2=UnitsImperial(0.1),
                       h=AR15_GAS_CHANNEL_LENGTH,
                     $fn=40);
    
    // Gas tube cover
    translate([0,-UnitsImperial(0.834)/2,0])
    ChamferedCube([AR15_BARRELNUT_RADIUS+UnitsImperial(0.8),
                   UnitsImperial(0.834),
                   AR15_GAS_CHANNEL_LENGTH],
                   r=UnitsMetric(2));
    
    // AFG balls
    for (Y = [0,1]) mirror([0,Y,0])
    translate([-AR15_BARRELNUT_RADIUS-barrelNutWall-UnitsMetric(6),
               AR15_BARRELNUT_RADIUS/2,
               AR15_BARRELNUT_LENGTH+UnitsMetric(10)])
    sphere(r=UnitsMetric(12));
    
    BoltPositions()
    cylinder(r=UnitsMetric(5), h=UnitsMetric(30));
  }
  
  // Barrel nut
  cylinder(r=AR15_BARRELNUT_RADIUS, h=AR15_BARRELNUT_LENGTH);
  
  // Barrel
  translate([0,0,AR15_BARRELNUT_LENGTH])
  cylinder(r=AR15_BARREL_RADIUS, h=AR15_GAS_CHANNEL_LENGTH);
  
  // Toothed section
  translate([0,0,AR15_BARRELNUT_LENGTH])
  mirror([0,0,1])
  cylinder(r=AR15_BARRELNUT_TOOTHED_RADIUS, h=AR15_BARRELNUT_TOOTHED_LENGTH);
  
  // Transition from toothed to barrel, printability taper
  translate([0,0,AR15_BARRELNUT_LENGTH-AR15_BARRELNUT_TOOTHED_LENGTH])
  cylinder(r1=AR15_BARRELNUT_TOOTHED_RADIUS,
           r2=AR15_BARREL_RADIUS,
            h=AR15_GAS_CHANNEL_LENGTH-AR15_BARRELNUT_LENGTH);
  
  // Gas channel
  translate([0,-AR15_GAS_CHANNEL_WIDTH/2,0])
  ChamferedCube([AR15_BARRELNUT_RADIUS+AR15_GAS_CHANNEL_HEIGHT,
                 AR15_GAS_CHANNEL_WIDTH,
                 AR15_GAS_CHANNEL_LENGTH+AR15_BARRELNUT_LENGTH],
                 r=UnitsMetric(4), chamferXYZ=[0,0,1]);
  
  
  BoltPositions()
  FlatHeadBolt(diameter=0.118, headDiameter=0.32, length=3, extraHead=1, cutter=true);
  
  // Gas ports
  for (Z = [0:floor(AR15_GAS_CHANNEL_LENGTH-2)])
  translate([0,0,AR15_BARRELNUT_LENGTH+GAS_PORT_RADIUS+Z])
  rotate([0,-90,180])
  linear_extrude(height=UnitsImperial(4), center=true)
  Teardrop(r=GAS_PORT_RADIUS);
}
