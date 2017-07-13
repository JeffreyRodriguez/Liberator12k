use <../../Meta/Animation.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Units.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Finishing/Chamfer.scad>;
use <../../Components/Teardrop.scad>;
use <../../Components/ORing.scad>;
use <../../Components/Pipe Cap.scad>;
use <../../Components/HoseBarbExtension.scad>;
use <../../Components/FemaleExtensionNPT.scad>;
use <../../Components/Printable Shaft Collar.scad>;


PIPE_SPEC = Spec_TubingZeroPointSevenFive();
ROD_SPEC = Spec_RodThreeSixteenthInch();
//ROD_SPEC = Spec_RodOneQuarterInch();

//PIPE_SPEC = Spec_TubingOnePointZero();
//ROD_SPEC = Spec_RodThreeSixteenthInch();
//ROD_SPEC = Spec_RodOneQuarterInch();
//ROD_SPEC = Spec_RodOneHalfInch();

//PIPE_SPEC = Spec_TubingOnePointOneTwoFive();
//ROD_SPEC = Spec_RodThreeSixteenthInch();
//ROD_SPEC = Spec_RodOneQuarterInch();
//ROD_SPEC = Spec_RodOneHalfInch();
//ROD_SPEC = Spec_RodThreeQuarterInch();

//PIPE_SPEC = Spec_TubingOnePointSixTwoEight();
//ROD_SPEC = Spec_RodThreeQuarterInch();

function BoringCapBase(bottomWall,
                       rodORingSection,
                       wall,
                       inletDiameter
                       ) = bottomWall
                         + rodORingSection
                         + wall
                         + inletDiameter
                         + wall;

module ECM_BoringCap(pipeSpec=PIPE_SPEC, rodSpec=ROD_SPEC,
                     bottomWall=0.1875, wall=0.125,
                     extension=0.25,

                     pipeORingSection=1/8,
                     rodORingSection=1/8,
                     
                     inletDiameter=0.25,
                     
                     $fn=Resolution(40,80)) {
  pipeRadius    = PipeOuterRadius(pipeSpec);

  pipeCapRadius = pipeRadius
                + pipeORingSection
                + wall;

  inletRadius = inletDiameter/2;

  base        = BoringCapBase(bottomWall,
                              rodORingSection,
                              wall,
                              inletDiameter);
  
  inletOffsetZ = bottomWall+rodORingSection+wall+inletRadius;
  
  pipeCapExtension = extension
                   + wall
                   + pipeORingSection
                   + wall;

  // Main water feed part
  render()
  difference() {
    PipeCap(pipeSpec=pipeSpec,
            pipeClearance=PipeClearanceLoose(),
            base=base,
            oRingSection=pipeORingSection,
            wall=wall+pipeORingSection,
            extension=pipeCapExtension+ManifoldGap());

    // Big cone to allow water to flow around the rod
    translate([0,0,bottomWall+rodORingSection])
    cylinder(r1=RodRadius(rodSpec)+(rodORingSection/4),
              r2=pipeRadius*0.9,
              h=base-bottomWall-rodORingSection+ManifoldGap(), $fn=20);

    // Rod Hole
    translate([0,0,-ManifoldGap()])
    Rod(rod=rodSpec,
        clearance=RodClearanceLoose(),
        length=base);

    // Rod O-Ring
    translate([0,0,bottomWall])
    ORing(innerDiameter=RodDiameter(rodSpec),
                section=rodORingSection,
                $fn=RodFn(rod=rodSpec, $fn=undef)*2);

    // Pipe O-Ring
    translate([0,0,base+wall+pipeORingSection])
    ORing(innerDiameter=PipeOuterDiameter(pipeSpec),
                section=pipeORingSection,
                $fn=PipeFn(pipeSpec, $fn=undef));
                
    // Water Inlet
    translate([-ManifoldGap(),0,inletOffsetZ])
    rotate([0,90,0])
    linear_extrude(height=pipeCapRadius+ManifoldGap(2))
    Teardrop(r=inletRadius,
             rotation=180,
             truncated=true);
  }
}

module ECM_BarbedBoringCap(pipeSpec=PIPE_SPEC, rodSpec=ROD_SPEC,
                     bottomWall=0.1875, wall=0.125, extension=0.25,

                     pipeORingSection=1/8,
                     rodORingSection=1/8,

                     femaleInnerDiameter=0.28,
                     
                     barbOffset=0.5,
                     barbMinorDiameter=3/8*0.9,
                     barbMajorDiameter=3/8*1.15,
                     barbInnerDiameter=0.125,
                     barbWall=0.1625,
                     
                     $fn=Resolution(40,80)) {

  inletDiameter = barbInnerDiameter;
  inletRadius = inletDiameter/2;

  base2       = inletDiameter+wall;
  base        = bottomWall + rodORingSection + base2;

  inletOffset = (PipeOuterRadius(pipeSpec)+wall)
              + (barbMajorDiameter/2) + wall
              + barbOffset;
                       
  pipeCapExtension = extension+(wall*2)+pipeORingSection;
  pipeCapRadius = PipeOuterRadius(pipeSpec)+pipeORingSection+wall;

  render()

  // Main water feed part
  difference() {
    union() {
      intersection() {
        PipeCap(pipeSpec=pipeSpec,
                pipeClearance=PipeClearanceLoose(),
                base=base,
                oRingSection=pipeORingSection,
                wall=wall+pipeORingSection,
           extension=pipeCapExtension+ManifoldGap());
        
        // Shave off the bottom of the pipe cap
        // that's a lot of material otherwise
        translate([0,0,-ManifoldGap()])
        cylinder(r1=PipeOuterRadius(pipeSpec),
                  r2=(PipeOuterDiameter(pipeSpec)+wall),
                  h=base+(wall*2)+extension+pipeORingSection+ManifoldGap(2));
      }
      
      HoseBarbExtension(length=inletOffset, wall=wall,
                        heightExtra=rodORingSection,
                        majorDiameter=barbMajorDiameter,
                        minorDiameter=barbMinorDiameter,
                        innerDiameter=barbInnerDiameter,
                        cutter=false);
    }

    // Big cone to allow water to flow around the rod
    translate([0,0,wall+(pipeORingSection/2)])
    cylinder(r1=RodRadius(rodSpec)+(rodORingSection/4),
              r2=PipeInnerRadius(pipeSpec)
                + (PipeWall(pipeSpec)/2),
              h=base-wall-(pipeORingSection/2)+ManifoldGap(), $fn=20);
    
    HoseBarbExtension(length=inletOffset, wall=wall,
                      heightExtra=rodORingSection,
                      majorDiameter=barbMajorDiameter,
                      minorDiameter=barbMinorDiameter,
                      innerDiameter=barbInnerDiameter,
                      cutter=true);

    // Rod Hole
    translate([0,0,-ManifoldGap()])
    Rod(rod=rodSpec,
        clearance=RodClearanceLoose(),
        length=base);

    // Rod O-Ring
    translate([0,0,bottomWall])
    ORing(innerDiameter=RodDiameter(rodSpec),
                section=rodORingSection,
                $fn=RodFn(rod=rodSpec, $fn=undef)*2);

    // Pipe O-Ring
    translate([0,0,base+wall+pipeORingSection])
    ORing(innerDiameter=PipeOuterDiameter(pipeSpec),
                section=pipeORingSection,
                $fn=PipeFn(pipeSpec, $fn=undef));
  }
}

module ECM_FemaleBoringCap(pipeSpec=PIPE_SPEC, rodSpec=ROD_SPEC,
                     bottomWall=0.1875, wall=0.125, extension=0.25,

                     pipeORingSection=1/8,
                     rodORingSection=1/8,

                     inletDiameter=0.28,
                     
                     $fn=Resolution(40,80)) {

  
  base        = BoringCapBase(bottomWall,
                              rodORingSection,
                              wall,
                              inletDiameter);
  pipeRadius  = PipeOuterRadius(pipeSpec);
  inletRadius = inletDiameter/2;
  inletHeight = bottomWall+rodORingSection+wall+inletRadius;

  render()

  // Main water feed part
  union() {
    ECM_BoringCap(pipeSpec=pipeSpec, rodSpec=rodSpec,
                  inletDiameter=inletDiameter);
    
    translate([pipeRadius,0,0])
    difference() {
      FemaleExtensionNPT(length=pipeRadius+pipeORingSection+wall,
                         wall=wall,
                         innerDiameter=inletDiameter,
                         inletHeight=inletHeight,
                         height=base,
                         cutter=false);
  
      FemaleExtensionNPT(length=pipeRadius+pipeORingSection+wall,
                         wall=wall,
                         innerDiameter=inletDiameter,
                         inletHeight=inletHeight,
                         height=base,
                         cutter=true);
    }
  }
}



module ECM_BoringCapCutouts(r=1,
                            base=0.5,
                            wall=0.1875,
                            height=1,
                            start=0) {

    circumference = r*2*3.14;
    segmentsUnrounded = floor(circumference/wall/4);
    
    // Round down to the nearest multiple of 3
    segments = segmentsUnrounded - (segmentsUnrounded%3); 
  
    // Grip / Material Saving Cutouts
    for (Z = [base-wall, height])
    for (R = [start:segments-1])
    rotate(360/segments * R)
    translate([r+(wall),0,Z])
    sphere(r=(wall*2), $fn=Resolution(20,60));
}


module ECM_MultiBoringCap(pipeSpec=Spec_TubingOnePointSixTwoEight(),
                          rodSpecs = [
                                Spec_RodThreeSixteenthInch(),
                                Spec_RodOneQuarterInch(),
                                Spec_RodOneHalfInch(),
                                Spec_RodThreeQuarterInch(),
                                Spec_RodOnePointZeroInch(),
                                Spec_RodOnePointOneTwoFiveInch()
                                ],
                          bottomWall=0.125, wall=0.0625, extension=0.25,
                          pipeORingSection=1/8,
                          rodOrings=true, rodORingSection=1/8,
                          rodHeightExtra=1/4,
                          $fn=Resolution(20,40)) {

  rodHeight   = rodORingSection+(wall*2)+rodHeightExtra;
  base        = bottomWall+(len(rodSpecs)*rodHeight);
  pipeCapExtension = extension+(wall*2)+pipeORingSection;
  pipeCapRadius = PipeOuterRadius(pipeSpec)+pipeORingSection+wall;
  totalHeight = base+pipeCapExtension;

  render()

  // Main water feed part
  difference() {
    PipeCap(pipeSpec=pipeSpec,
            pipeClearance=PipeClearanceSnug(),
            base=base,
            oRingSection=pipeORingSection,
            wall=wall+pipeORingSection,
       extension=pipeCapExtension+ManifoldGap());
    
    // Taper the bottom
    difference() {
      translate([0,0,-ManifoldGap()])
      cylinder(r=pipeCapRadius+wall, h=base+ManifoldGap());
    
      cylinder(r1=RodRadius(rodSpecs[0])+rodORingSection+wall,
               r2=pipeCapRadius,
               h=base+ManifoldGap());
    }
    
    render()
    ECM_BoringCapCutouts(r=pipeCapRadius,
                         base=base,
                         wall=wall,
                         height=totalHeight);

    // Pipe O-Ring
    translate([0,0,base+extension+pipeORingSection])
    ORing(innerDiameter=PipeOuterDiameter(pipeSpec),
                section=pipeORingSection,
                $fn=PipeFn(pipeSpec, $fn=undef));

    // Rod Holes
    render()
    for (idx = [0:len(rodSpecs)-1])
    translate([0,0,bottomWall+(idx*rodHeight)-ManifoldGap()]) {
      Rod(rod=rodSpecs[idx],
          clearance=RodClearanceSnug(),
          length=base+ManifoldGap(2));
      
      if (rodOrings)
      translate([0,0,wall+rodHeightExtra])
      ORing(innerDiameter=RodDiameter(rodSpecs[idx]),
                  section=rodORingSection,
                  $fn=RodFn(rodSpecs[idx], $fn=undef)*2);
        
    
      // Teardropped water channels
      translate([0,0,(wall*1.5)+rodORingSection+rodHeightExtra])
      for (r = [0:5])
      rotate(r*60)
      translate([0,RodRadius(rodSpecs[idx])-(wall/2),0])
      rotate([0,-90,0])
      linear_extrude(height=pipeCapRadius+wall)
      Teardrop(r=wall/2);
    }
  }
}

//Spec_RodOneQuarterInch(),
//Spec_RodOneHalfInch(),
//Spec_RodThreeQuarterInch(),
//Spec_RodOnePointZeroInch(),
//Spec_RodOnePointOneTwoFiveInch()

ECM_PAIRS = [
  [Spec_TubingZeroPointSevenFive(),Spec_RodThreeSixteenthInch(), 2.25],
  [Spec_TubingOnePointOneTwoFive(),Spec_RodThreeSixteenthInch(), 2.25],
  [Spec_TubingOnePointSixTwoEight(),Spec_RodThreeQuarterInch(), 2.25]
];

scale(25.4)
//AnimateSpin()
//render() DebugHalf(dimension=10)
for (i = [2 ]) {
  PRZ = ECM_PAIRS[i];

  translate([0,0,PRZ[2]])
  rotate([180,0,0])
  *ECM_MultiBoringCap(pipeSpec=PRZ[0],
                     rodSpecs = [PRZ[1]],
                     rodOrings=false, rodHeightExtra=0,
                     bottomWall=0.0625, wall=0.09375);
  
  
  ECM_FemaleBoringCap(pipeSpec=PRZ[0], rodSpec=PRZ[1]);
}
