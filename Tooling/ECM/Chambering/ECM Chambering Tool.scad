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
BARREL_OD = 0.751;
BARREL_ID = 0.375-0.003;

function ECM_Chambering_Insert_Diameter(barrelInnerDiameter,
                                        wireDiameter,
                                        gapWidth)
    = barrelInnerDiameter
    - (wireDiameter*2)
    - (gapWidth*2);

module ECM_Chambering_Insert(terminalSpec=Spec_BoltM3(),
                             barrelOuterDiameter=BARREL_OD,
                             barrelInnerDiameter = BARREL_ID,
                             wireDiameter=0.025, wireGuide=0.05,
                             gapWidth=0.02,
                             chamberLength=1.285,
                             wall=0.5, topLength=0.5,
                             fluteWidth=0.1, fluteCount=3) {

  insertDiameter = ECM_Chambering_Insert_Diameter(
                               barrelInnerDiameter,
                               wireDiameter,
                               gapWidth);


  render()
  difference() {
    
    // Insert
    union() {
      cylinder(r=insertDiameter/2,
               h=chamberLength+wall, $fn=50);
      
      // Center the insert in the bore
      cylinder(r=barrelInnerDiameter/2,
               h=wall, $fn=50);
      
      // Top
      translate([0,0,wall+chamberLength])
      intersection() {
        translate([-insertDiameter/4, -insertDiameter/2,0])
        cube([insertDiameter/2, insertDiameter, topLength]);
        
        cylinder(r=insertDiameter/2,
                 h=topLength, $fn=50);
      }
    }
    
    // Bottom Water Cutouts
    for (r = [1:fluteCount])
    rotate(360/fluteCount*r)
    translate([(insertDiameter/2),
               -fluteWidth/2,
               -ManifoldGap()])
    cube([barrelInnerDiameter,
          fluteWidth,
          wall+wireDiameter+ManifoldGap(2)]);
    
    // Wire Cutouts
    *for (Z = [wall+(wireGuide/2), wall+chamberLength])
    translate([0,0,Z])
    rotate([45,0,0])
    cube([insertDiameter+wireGuide,
          wireGuide,
          wireGuide], center=true);
    
    // Bottom 'installation' hex bit hole
    *translate([0,0,-ManifoldGap()])
    cylinder(r=1/16, h=0.375, $fn=6);
    
    // Negative terminal bolt
    translate([0,0,wall+chamberLength])
    rotate(90)
    for (m = [0,1]) mirror([0,m,0])
    *NutAndBolt(bolt=terminalSpec,
                nutRadiusExtra=0.05,
                nutSideExtra=1,
                nutBackset=0.1, nutHeightExtra=0.1);
  }

}

module ECM_Chambering_Base(barrelOuterDiameter=BARREL_OD,
                             barrelInnerDiameter = BARREL_ID,
                             wireDiameter=0.025,
                             gapWidth=0.05,
                             wall=0.25) {

  insertDiameter = ECM_Chambering_Insert_Diameter(
                               barrelInnerDiameter,
                               wireDiameter,
                               gapWidth)+0.01;

  render()
  difference() {
    
    // Insert
    union() {
      
      // Pipe cap
      cylinder(r=(barrelOuterDiameter/2)+wall,
               h=wall*3,
             $fn=Resolution(20,60));
    }
      
    // Pipe
    translate([0,0,wall])
    cylinder(r=barrelOuterDiameter/2,
              h=(wall*2)+ManifoldGap(),
            $fn=Resolution(20,60));
    
    // Insert Passthrough Hole
    translate([0,0,-ManifoldGap()])
    translate([-insertDiameter/4, -insertDiameter/2,0])
    cube([insertDiameter/2, insertDiameter, wall+ManifoldGap()]);
    
    // Watering hole
    translate([0,0,-ManifoldGap()])
    intersection() {
      rotate(45)
      translate([-barrelInnerDiameter/2, -barrelInnerDiameter/2,0])
      cube([barrelInnerDiameter, barrelInnerDiameter, wall+ManifoldGap(2)]);
      
      translate([-barrelInnerDiameter/2, -insertDiameter/4,0])
      cube([barrelInnerDiameter, insertDiameter/2, wall+ManifoldGap(2)]);
    }
    
  }

}

scale(25.4) {
  ECM_Chambering_Insert();

  color("DimGrey", 0.5)
  translate([0,0,3.75])
  rotate([180.0,0])
  ECM_Chambering_Base();
}

// Plated insert
!scale(25.4) ECM_Chambering_Insert();

*!scale(25.4) ECM_Chambering_Base();