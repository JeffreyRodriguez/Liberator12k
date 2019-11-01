use <../../../Meta/Animation.scad>;
use <../../../Meta/Debug.scad>;
use <../../../Meta/Cylinder Text.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Shapes/Chamfer.scad>;
use <../../../Shapes/Components/ORing.scad>;
use <../../../Shapes/Components/Gear.scad>;
use <ECM Drilling Cap.scad>;



scale(25.4) render()
DebugHalf()
ECM_DrillingCap();


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
