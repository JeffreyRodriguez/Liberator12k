use <../../../Meta/Animation.scad>;
use <../../../Meta/Debug.scad>;
use <../../../Meta/Cylinder Text.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Shapes/Chamfer.scad>;
use <../../../Shapes/Teardrop.scad>;
use <../../../Shapes/Components/ORing.scad>;
use <../../../Shapes/Components/Pipe/Cap.scad>;
use <../../../Shapes/Components/FemaleExtensionNPT.scad>;
use <../Boring/ECM Boring Cap.scad>;

module ECM_DrillingCap(pipeDiameter=0.75, topExtension=0.25, bottomExtension=0.25, ) {
  ECM_BoringCap(pipeDiameter=pipeDiameter, rodDiameter=0.2, clearance=0.04,
                bottomWall=bottomExtension, extension=topExtension,
                brandingText=false, sizeText=false,
                speedHoles=false, inletEnabled=false,
                $fn=40);
}

render() DebugHalf()
ECM_DrillingCap();
