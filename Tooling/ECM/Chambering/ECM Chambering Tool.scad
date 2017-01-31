use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Meta/Units.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Components/T Lug.scad>;
use <../../../Components/Printable Shaft Collar.scad>;

PIPE_SPEC = Spec_TubingOnePointOneTwoFive();

// Smoothbore 12ga stock (old test bits)
BARREL_OD = 1.125+0.025;
BARREL_ID = 0.813+0.01;

// Rifled 12ga stock
BARREL_OD = 1.125+0.025;
BARREL_ID = 0.75+0.008;

// .44 Spl stock
BARREL_OD = 0.765;
BARREL_ID = 0.375-0.003;
BARREL_ID = 0.402; // Pre-bored

function ECM_Chambering_Insert_Diameter(barrelInnerDiameter,
                                        wireDiameter,
                                        gapWidth)
    = barrelInnerDiameter
    - (wireDiameter*2)
    - (gapWidth*2);

module ECM_Chambering_Insert(terminalSpec=Spec_BoltM3(),
                             barrelOuterDiameter=BARREL_OD,
                             barrelInnerDiameter = BARREL_ID,
                             wireDiameter=0.015,
                             gapWidth=0.03,
                             chamberLength=1.285,
                             wall=0.5, topLength=0.5,
                             fluteWidth=0.1, fluteCount=3) {

  insertDiameter = ECM_Chambering_Insert_Diameter(
                               barrelInnerDiameter,
                               wireDiameter,
                               gapWidth);

  insertRadius = insertDiameter/2;

  render()
  difference() {
    
    // Insert
    union() {
      cylinder(r=insertRadius,
               h=chamberLength+wall, $fn=50);
      
      // Center the insert in the bore
      cylinder(r=barrelInnerDiameter/2,
               h=wall, $fn=50);
      
      // Top
      translate([0,0,wall+chamberLength])
      render()
      linear_extrude(height=topLength)
      difference() {
        intersection() {
          translate([-(insertDiameter/4), -insertRadius,0])
          square([insertRadius, insertDiameter]);
          
          circle(r=insertRadius, $fn=50);
        }
        
        for (m = [0:1])
        mirror([m,0,0])
        translate([wireDiameter,0])
        rotate(-45)
        square(insertRadius);
      }
    }
    
    // Bottom Water Cutouts
    for (r = [1:fluteCount])
    rotate(360/fluteCount*r)
    translate([insertRadius,
               -fluteWidth/2,
               -ManifoldGap()])
    cube([barrelInnerDiameter,
          fluteWidth,
          wall+wireDiameter+ManifoldGap(2)]);
    
    // Bottom 'installation' hex bit hole
    *translate([0,0,-ManifoldGap()])
    cylinder(r=1/16, h=0.375, $fn=6);
  }

}

module ECM_Chambering_Base(barrelOuterDiameter=BARREL_OD,
                             barrelInnerDiameter = BARREL_ID,
                             wireDiameter=0.025,
                             gapWidth=0.05,
                             clearance=0.06,
                             wall=0.125) {

  insertDiameter = ECM_Chambering_Insert_Diameter(
                               barrelInnerDiameter,
                               wireDiameter,
                               gapWidth)+0.01;


  insertRadius = insertDiameter/2;
  innerRadius = barrelInnerDiameter/2;
  outerRadius = barrelOuterDiameter/2;
                               
  render()
  difference() {
    
    // Insert
    union() {
      
      // Pipe cap
      cylinder(r=outerRadius+wall,
               h=wall*3,
             $fn=Resolution(20,60));
    }
      
    // Pipe
    translate([0,0,wall])
    cylinder(r=outerRadius,
              h=(wall*2)+ManifoldGap(),
            $fn=Resolution(20,60));
    
    // Insert Passthrough Hole
    translate([0,0,-ManifoldGap()])
    translate([-(insertRadius/2)-(clearance/2), -insertRadius-(clearance/2),0])
    cube([insertRadius+clearance, insertDiameter+clearance, wall+ManifoldGap(2)]);
    
    // Watering hole
    translate([0,0,-ManifoldGap()])
    translate([-outerRadius, -insertRadius/2,0])
    cube([barrelOuterDiameter, insertRadius, wall+ManifoldGap(2)]);
  }
}

scale(25.4) {
  ECM_Chambering_Insert();

  color("DimGrey", 0.5)
  translate([0,0,2.25])
  rotate([180.0,0])
  ECM_Chambering_Base();
}

// Plated insert
!scale(25.4) ECM_Chambering_Insert();

*!scale(25.4) ECM_Chambering_Base();