use <../../../Meta/Debug.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../../../Shapes/Components/Hose Barb.scad>;
use <../../../Shapes/Components/HoseBarbExtension.scad>;
use <../../../Shapes/Semicircle.scad>;
use <../../../Shapes/Teardrop.scad>;
use <../../../Shapes/TeardropTorus.scad>;
use <../../../Shapes/Components/ORing.scad>;
use <../../../Shapes/Components/Printable Shaft Collar.scad>;

function SlotAngle(pipeSpec, width) = (pipeSpec==undef ? 0 : 2*asin(width/PipeOuterDiameter(pipeSpec)));

module PipeSlotDrillingJig(pipeSpec=Spec_TubingZeroPointSevenFive(),
                           setScrewSpec=Spec_BoltM4(),
                           
                           holeDiameter=0.09, channelDiameter=0.25,
                           
                           barbMajorDiameter=3/8*1.1,
                           barbMinorDiameter=3/8*0.9,
                           barbWall=0.125,
                           
                           oRingWidth=0.125,
                           topWall=1.125, wall=0.25,
                           length=1, width=0.5) {

  bottomWall=oRingWidth+(wall*2);
                             
  holeRadius = holeDiameter/2;
  channelRadius = channelDiameter/2;

  wideAngle = SlotAngle(pipeSpec, width);
  drillingAngle = SlotAngle(pipeSpec, width-holeDiameter);  // account for the drill bit's width
  
  OAL = bottomWall+length+topWall;
                             
  hoseBarbLength = PipeOuterRadius(pipeSpec)+(wall*2)+(barbMajorDiameter/2);

  render()
  difference() {

    render()
    union() {
      rotate(-90)
      PrintableShaftCollar(pipeSpec=pipeSpec,
                           wall=wall,
                           height=OAL,
                           setScrewSpec=setScrewSpec,
                           screwOffsetZ=OAL-NutHexRadius(setScrewSpec)-wall);
      
      HoseBarbExtension(length=hoseBarbLength+(wall*2)+(barbMajorDiameter/2),
                          wall=barbWall,
                   heightExtra=bottomWall-barbWall,
                   majorDiameter=barbMajorDiameter,
                   minorDiameter=barbMinorDiameter,
                   innerDiameter=channelDiameter,
                        cutter=false);
      
      HoseBarbExtension(length=hoseBarbLength,
                          wall=barbWall,
                   heightExtra=bottomWall-channelDiameter-barbWall+length,
                   majorDiameter=barbMajorDiameter,
                   minorDiameter=barbMinorDiameter,
                   innerDiameter=channelDiameter,
                        cutter=false);
    }

    render() {
      
      // Index indicator
      translate([-PipeOuterRadius(pipeSpec)-wall,-0.02, OAL-0.02])
      cube([wall*2,0.02, 0.02+ManifoldGap()]);
      
      rotate(-90)
      translate([0,0,-ManifoldGap()])
      Pipe(pipe=pipeSpec,
         length=OAL+ManifoldGap(2),
      clearance=PipeClearanceLoose());
      
      HoseBarbExtension(length=hoseBarbLength+(wall*2)+(barbMajorDiameter/2),
                          wall=barbWall,
                   heightExtra=bottomWall-barbWall,
                   majorDiameter=barbMajorDiameter,
                   minorDiameter=barbMinorDiameter,
                   innerDiameter=channelDiameter,
                        cutter=true);
      
      HoseBarbExtension(length=hoseBarbLength,
                          wall=barbWall,
                   heightExtra=bottomWall-channelDiameter-barbWall+length,
                   majorDiameter=barbMajorDiameter,
                   minorDiameter=barbMinorDiameter,
                   innerDiameter=channelDiameter,
                        cutter=true);
        
      // Orings
      for (Z = [bottomWall-oRingWidth-wall, bottomWall+length+oRingWidth+wall])
      translate([0,0,Z])
      ORing(innerDiameter=PipeOuterDiameter(pipeSpec),
            section=oRingWidth, $fn=PipeFn(pipeSpec));

      // Water Channels
      translate([0,0,bottomWall]) {
        hull()
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
        
          // Wiring holes
        rotate(drillingAngle/2)
        for (a = [0,drillingAngle])
        rotate([0,0,-a])          
        for (l = [0, length])
        translate([0,0,l]) 
        rotate([0,90,0])
        linear_extrude(height=PipeOuterRadius(pipeSpec)+(wall*2))
        Teardrop(r=holeDiameter/2,
          rotation=180,
         truncated=false);
      }
    }
  }
}


ScaleToMillimeters()
PipeSlotDrillingJig(pipeSpec=Spec_TubingOnePointSixTwoEight(),length=3.5, width=1);
//PipeSlotDrillingJig(pipeSpec=Spec_TubingOnePointOneTwoFive());
//PipeSlotDrillingJig(pipeSpec=Spec_TubingZeroPointSevenFive());
//PipeSlotDrillingJig(pipeSpec=Spec_PipeThreeQuarterInch());
//PipeSlotDrillingJig(pipeSpec=Spec_PipeOneInch());
