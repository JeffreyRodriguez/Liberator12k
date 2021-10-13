use <Shell Base.scad>;
use <Shell Topper.scad>;
use <Primer.scad>;
use <../Vitamins/Pipe.scad>;
use <../Meta/Cutaway.scad>;
use <../Meta/Manifold.scad>;
use <../Shapes/Chamfer.scad>;

CHAMBER_DIAMETER = 0.78;
PRIMER = Spec_Primer209();


module ShellShot(primer=Spec_Primer209(),
                 chamberDiameter=CHAMBER_DIAMETER,
                 height=1.5, taperHeight=0.5,
                 slug_diameter=0.52,
                 fins=false, wall=3/64,
                 chargeDiameter=0.68, chargeHeight=0.3125, wadHeight=0.25,
                 rimDiameter=0.87, rimHeight=0.09) {
                   
  chamberRadius = chamberDiameter/2;
  rimRadius     = rimDiameter/2;
  chargeRadius  = chargeDiameter/2;

  shellBaseHeight = PrimerHeight(primer) + chargeHeight + wadHeight;

  difference() {
    union() {
      echo("ShellBase Height: ", shellBaseHeight);
      ShellBase(primer=primer,
                chamberDiameter=chamberDiameter,
                chargeDiameter=chargeDiameter,
                chargeHeight=chargeHeight, wadHeight=wadHeight+1,
                rimDiameter=rimDiameter, rimHeight=rimHeight)
        
      *color("Orange")
      ShellTopper(chamberDiameter=chamberDiameter,
                  height=height,
                  taperHeight=0);
    }
    
    // SLA-friendly wadding
    for (A = [0:60:360])
    for (X = [2,4])
    translate([0,0,shellBaseHeight-wadHeight-ManifoldGap()])
    linear_extrude(height=wadHeight+ManifoldGap(2), twist=90, slices=10)
    rotate(A)
    translate([chargeRadius/X,0])
    circle(r=1/64, $fn=6);
    
    // Load Cutout
    for (A = [0:90:360])
    translate([0,0,shellBaseHeight-ManifoldGap()])
    ChamferedCylinder(r1=0.729/2, r2=1/16, h=2.75, $fn=40);
    
    *translate([0,0,shellBaseHeight])
    cylinder(r=(chamberRadius)-wall, h=height+ManifoldGap(), $fn=40);
  }
}


scale(25.4)
//render()
//Cutaway()
ShellShot();
