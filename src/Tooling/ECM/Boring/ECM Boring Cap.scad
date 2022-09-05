use <../../../Meta/Animation.scad>;
use <../../../Meta/Cylinder Text.scad>;
use <../../../Meta/Cutaway.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Shapes/Chamfer.scad>;
use <../../../Shapes/Teardrop.scad>;
use <../../../Shapes/Components/ORing.scad>;

function BoringCapBase(bottomWall,
                       rodORingSection,
                       wall,
                       inletDiameter
                       ) = bottomWall
                         + rodORingSection
                         + wall
                         + inletDiameter
                         + wall;


module ECM_BoringCapCutouts(r1=1, r2=0.125, start=0) {


    circumference = r1*2*3.14;
    segments = 6;

    for (R = [start:segments-1])
    rotate(360/segments * R)
    translate([r1,0,-ManifoldGap()])
    cylinder(r1=r2,
             r2=0,
             h=(r2*3),
             $fn=Resolution(10,30));
}

module ECM_BoringCap(
                     pipeDiameter=1,
                     pipeORingSection=1/8,
                     rodDiameter=3/16,
                     rodORingSection=1/8,
                     clearance=0.01,
                     inletDiameter=0.28,
                     wall=0.125,
                     extension=0.25,
                     bottomWall=0.1875,
                     speedHoles=false,
                     brandingText=true,
                     brandingTextSweep=250,
                     sizeText=true,
                     sizeTextSweep=120,
                     textDepth=0.025,
                     letterSpacing=0.03) {

  rodRadius = (rodDiameter+clearance)/2;
  pipeRadius = (pipeDiameter+clearance)/2;

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
    PrintablePipeCap(pipeDiameter=pipeDiameter+clearance,
            base=base,
            oRingSection=pipeORingSection,
            wall=wall+pipeORingSection,
            extension=pipeCapExtension+ManifoldGap(),
            $fn=$fn);

    // Big cone to allow water to flow around the rod
    translate([0,0,bottomWall+rodORingSection])
    cylinder(r1=rodRadius+(rodORingSection/4),
             r2=pipeRadius*0.9,
             h=base-bottomWall-rodORingSection+ManifoldGap(),
             $fn=$fn);

    // Rod Hole
    translate([0,0,-ManifoldGap()])
    cylinder(r=rodRadius, h=base);

    // Rod O-Ring
    translate([0,0,bottomWall])
    ORing(innerDiameter=rodDiameter,
                section=rodORingSection);

    // Pipe O-Ring
    translate([0,0,base+wall+pipeORingSection])
    ORing(innerDiameter=pipeDiameter,
                section=pipeORingSection);

    // Water Inlet
    translate([-ManifoldGap(),0,inletOffsetZ])
    rotate([0,90,0])
    linear_extrude(height=pipeCapRadius+ManifoldGap(2))
    Teardrop(r=inletRadius,
             rotation=180,
             truncated=true);

    if (speedHoles) {

      // Bottom cutouts
      ECM_BoringCapCutouts(r1 = pipeRadius
                              + pipeORingSection
                              + wall
                              + ManifoldGap(),
                           r2 = wall,
                           start=1);

      // Top cutouts
      translate([0,0,base+pipeCapExtension])
      mirror([0,0,1])
      rotate(180)
      ECM_BoringCapCutouts(r1 = pipeRadius
                              + pipeORingSection
                              + wall
                              + ManifoldGap(),
                           r2 = wall);
    }

    if (brandingText)
    rotate(-90)
    CylinderTextSweep("Liberator12k.com", pipeCapRadius,
                  depth=textDepth,
                  sweep=brandingTextSweep, center=true, centerZ=false,
                  offsetZ=wall*3.25,
                  letterSpacing=letterSpacing);


    if (sizeText)
    rotate(-90) {
      CylinderTextSweep(str(pipeDiameter,"\"x", rodDiameter, "\""), pipeCapRadius,
                    depth=textDepth,
                    sweep=sizeTextSweep, center=true, centerZ=false,
                    offsetZ=base,
                    letterSpacing=letterSpacing);
    }

  }
}

//Cutaway()
ECM_BoringCap(brandingText=true, speedHoles=true, $fn=20);
