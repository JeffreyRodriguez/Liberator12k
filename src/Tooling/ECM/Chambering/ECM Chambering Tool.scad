use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Meta/Units.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Shapes/Semicircle.scad>;
use <../../../Shapes/Chamfer.scad>;


PIPE_SPEC = Spec_TubingZeroPointSevenFive();

// Smoothbore 12ga stock (old test bits)
BARREL_ID = 0.813+0.01;

// Rifled 12ga stock
BARREL_ID = 0.75+0.008;

// .12ga stock
BARREL_ID = 0.75-0.003;
BARREL_ID = 0.787; // Pre-bored

// .44 Spl stock
BARREL_ID = 0.402; // Pre-bored

// .45ACP
BARREL_ID = 0.44;

function ECM_Chambering_Insert_Diameter(barrelInnerDiameter,
                                        fluteDepth)
    = barrelInnerDiameter
    - (fluteDepth*2);

module ECM_Chambering_Insert(barrelInnerDiameter = BARREL_ID,
                             rodMajorRadius = 0.2/2, rodMinorRadius = 0.1517/2,
                             rodWall=0.125, rodTop=0.25,
                             length=1.285, bottomWall=0.125, wall=0.125,
                             fluteCount=6,
                             $fn=50) {

  insertDiameter = barrelInnerDiameter;
  insertRadius = insertDiameter/2;
  
  fluteWidth=min(insertDiameter*3.14/fluteCount/2, rodMajorRadius);
  fluteDepth=(insertRadius-rodMajorRadius)-wall;

  render()
  difference() {
    
    // Centering guide
    union() {
      
      // Body
      cylinder(r=insertRadius,
               h=length);
      
      // Taper
      translate([0,0,length])
      cylinder(r1=barrelInnerDiameter/2, r2=rodMajorRadius,
               h=rodTop);
      
      // Cylinder top
      translate([0,0,length])
      cylinder(r=rodMajorRadius+rodWall, h=rodTop);
    }
    
    // Chamfer the bottom
    CylinderChamfer(r1=insertRadius, r2=0.05, teardrop=true);
    
    // Chamfer the top
    translate([0,0,length+rodTop])
    mirror([0,0,1])
    CylinderChamfer(r1=rodMajorRadius+rodWall, r2=0.02, teardrop=false);
    
    // Rod hole
    translate([0,0,wall])
    cylinder(r1=rodMajorRadius,
             r2=rodMinorRadius,
             h=length+bottomWall+rodTop,
             $fn=20);
    
    // Water Flutes
    translate([0, 0, -ManifoldGap()])
    for (r = [1:fluteCount])
    rotate(360/fluteCount*r)
    linear_extrude(height=length+bottomWall+ManifoldGap(2),
                   twist=(length+bottomWall)*90,
                   slices=(length+bottomWall)*80)
    translate([insertRadius-fluteDepth, -fluteWidth/2])
    square([insertRadius, fluteWidth]);
  }

}

ScaleToMillimeters() {
  ECM_Chambering_Insert(barrelInnerDiameter=0.44,
                        length=1.285,
                        rodWall=0.0625,
                        wall=0.0625);
}

// Plated insert
*!ScaleToMillimeters() ECM_Chambering_Insert();
