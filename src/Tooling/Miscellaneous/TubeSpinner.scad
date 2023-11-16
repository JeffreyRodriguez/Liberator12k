use <../../Meta/Units.scad>;
use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Components/ORing.scad>;
use <../../Shapes/TeardropTorus.scad>;

CLEARANCE = 0.0041;
INNER_DIAMETER = 1.0001;
HOLE_DIAMETER = 0.25;
ORING_WIDTH = 0.1251;
CHAMFER_RADIUS = 0.0625;
HEIGHT=1.5;

ScaleToMillimeters()
render()
difference() {
  ChamferedCylinder(r1=(INNER_DIAMETER/2)-(ORING_WIDTH*0.25), r2=CHAMFER_RADIUS,
                     h=HEIGHT);

  // O-Ring
  for (Z = [(ORING_WIDTH*2),HEIGHT-(ORING_WIDTH*2)])
  translate([0,0,Z])
  TeardropTorus(majorRadius=(INNER_DIAMETER/2)-(ORING_WIDTH*0.25),
                minorRadius=(ORING_WIDTH*0.75)-CLEARANCE);
  
  // Center Hole
  ChamferedCircularHole(r1=(HOLE_DIAMETER/2)+CLEARANCE,
                        r2=CHAMFER_RADIUS,
                         h=HEIGHT);
}