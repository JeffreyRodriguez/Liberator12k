use <../../../Meta/Debug.scad>;
use <../../../Meta/Units.scad>;
use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../../../Components/Semicircle.scad>;
use <../../../Components/Teardrop.scad>;
use <../../../Components/TeardropTorus.scad>;
use <../../../Components/Printable Shaft Collar.scad>;

function SlotAngle(pipeSpec, width) = (pipeSpec==undef ? 0 : 2*asin(width/PipeOuterDiameter(pipeSpec)));

module PipeSlotDrillingJig(pipeSpec=Spec_TubingZeroPointSevenFive(),
                           setScrewSpec=Spec_BoltM4(),
                           
                           holeDiameter=0.0625, channelDiameter=0.0625,
                           
                           oRingWidth=0.125,
                           bottomWall=0.375, topWall=0.375, wall=0.25,
                           length=0.5, width=0.25) {

                             
  holeRadius = holeDiameter/2;
  channelRadius = channelDiameter/2;

  wideAngle = SlotAngle(pipeSpec, width);
  drillingAngle = SlotAngle(pipeSpec, width-holeDiameter);  // account for the drill bit's width

  render()
  difference() {

    rotate(-90)
    PrintableShaftCollar(pipeSpec=pipeSpec,
                         wall=wall,
                         height=length+bottomWall+topWall,
                         setScrewSpec=setScrewSpec,
                         screwOffsetZ=bottomWall+(length/2));

    // Orings
    for (Z = [bottomWall/2, bottomWall+length+(topWall/2)])
    translate([0,0,Z])
    TeardropTorus(majorRadius=PipeOuterRadius(pipeSpec)-(oRingWidth/2),
                  minorRadius=oRingWidth/2);

    translate([0,0,bottomWall]) {
      for (l = [0, length])
      translate([0,0,l]) {

        // Radial water channels
        intersection() {
          hull()
          TeardropTorus(majorRadius=PipeOuterRadius(pipeSpec)-channelRadius,
                        minorRadius=channelRadius);

          translate([0,0,-holeDiameter/2])
          linear_extrude(height=channelRadius*2*sqrt(2))
          semicircle(od=PipeOuterDiameter(pipeSpec)+(channelRadius*2),
                  angle=wideAngle,
                 center=true);
        }
      }
      
      // Vertical holes and channels
      rotate(drillingAngle/2)
      for (a = [0,drillingAngle])
      rotate([0,0,-a]) {
        
        // Wiring holes
        for (l = [0, length])
        translate([0,0,l]) 
        rotate([0,90,0])
        linear_extrude(height=PipeOuterRadius(pipeSpec)+(wall*2))
        Teardrop(r=holeDiameter/2,
          rotation=180);
        
        // Water channels
        linear_extrude(height=length)
        semicircle(od=PipeOuterDiameter(pipeSpec)+channelDiameter,
                    angle=SlotAngle(pipeSpec, holeDiameter),
                    center=true);
      }
    }
  }
}


scale(25.4)
PipeSlotDrillingJig(pipeSpec=Spec_TubingZeroPointSevenFive());
//PipeSlotDrillingJig(pipeSpec=Spec_PipeThreeQuarterInch());
//PipeSlotDrillingJig(pipeSpec=Spec_PipeOneInch());
