use <../../../Meta/Animation.scad>;
use <../../../Meta/Debug.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Meta/Units.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../../../Finishing/Chamfer.scad>;
use <../../../Components/Teardrop.scad>;
use <../../../Components/ORing.scad>;
use <../../../Components/Pipe Cap.scad>;
use <../../../Components/HoseBarbExtension.scad>;
use <../../../Components/FemaleExtensionNPT.scad>;
use <../../../Components/Printable Shaft Collar.scad>;

use <ECM Boring Cap.scad>;

module ECM_BoringCap_FemaleNPT(
                     pipeDiameter=1,
                     pipeORingSection=1/8,
                     rodDiameter=3/16,
                     rodORingSection=1/8,
                     inletDiameter=0.28,
                     inletOffsetExtra=0.375,
                     wall=0.125,
                     extension=0.25,
                     bottomWall=0.1875,
                     speedHoles=true,
                     clearance=0.01,
                     brandingTextSweep=250,
                     sizeTextSweep=120,
                     letterSpacing=1/25.4) {
  
  rodRadius  = rodDiameter/2;
  pipeRadius = pipeDiameter/2;

  base        = BoringCapBase(bottomWall,
                              rodORingSection,
                              wall,
                              inletDiameter);

  inletRadius = inletDiameter/2;
  inletHeight = bottomWall+rodORingSection+wall+inletRadius;

  render()

  // Main water feed part
  union() {
    ECM_BoringCap(pipeDiameter=pipeDiameter,
                  rodDiameter=rodDiameter,
                  inletDiameter=inletDiameter,
                  speedHoles=speedHoles,
                  clearance=clearance,
                  brandingTextSweep=brandingTextSweep,
                  sizeTextSweep=sizeTextSweep,
                  letterSpacing=letterSpacing,
                  $fn=floor(pipeDiameter*25.4)*2);
    
    translate([pipeRadius,0,0])
    difference() {
      FemaleExtensionNPT(length=pipeORingSection+wall+inletOffsetExtra,
                         wall=wall,
                         innerDiameter=inletDiameter,
                         inletHeight=inletHeight,
                         height=base,
                         cutter=false);
  
      FemaleExtensionNPT(length=pipeORingSection+wall+inletOffsetExtra,
                         wall=wall,
                         innerDiameter=inletDiameter,
                         inletHeight=inletHeight,
                         height=base,
                         cutter=true);
    }
  }
}

// Uncomment a preset, or customize
!scale(25.4)
ECM_BoringCap_FemaleNPT(pipeDiameter=0.750, rodDiameter=0.1875,
  sizeTextSweep=200);

scale(25.4)
ECM_BoringCap_FemaleNPT(pipeDiameter=1.000, rodDiameter=0.1875);

scale(25.4)
ECM_BoringCap_FemaleNPT(pipeDiameter=1.125, rodDiameter=0.500);

scale(25.4)
ECM_BoringCap_FemaleNPT(pipeDiameter=1.628, rodDiameter=0.500,
  brandingTextSweep=200, sizeTextSweep=90);

scale(25.4)
ECM_BoringCap_FemaleNPT(pipeDiameter=1.750, rodDiameter=0.500,
  brandingTextSweep=200, sizeTextSweep=90);

scale(25.4)
ECM_BoringCap_FemaleNPT(pipeDiameter=2.000, rodDiameter=0.500,
  brandingTextSweep=120, sizeTextSweep=70);

scale(25.4)
ECM_BoringCap_FemaleNPT(pipeDiameter=3.000, rodDiameter=0.500,
  brandingTextSweep=90, sizeTextSweep=50, letterSpacing=0.15);
