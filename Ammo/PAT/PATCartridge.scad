use <../Primer.scad>;

use <../../Meta/Cutaway.scad>;
use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Shapes/TeardropTorus.scad>;
use <../../Vitamins/Pipe.scad>;

INNER_PIPE = Spec_FiveSixteenthInchBrakeLine();
//INNER_PIPE = Spec_PipeOneQuarterInch();
OUTER_PIPE = Spec_PipeThreeEighthsInch();
PRIMER = Spec_Primer27PAT();
//PRIMER = Spec_Primer22PAT();


//INNER_PIPE = Spec_PipeThreeEighthsInch();
//OUTER_PIPE = Spec_PipeOneHalfInch();



module PATCartridge(primer=PRIMER,
                 chamberDiameter=PipeInnerDiameter(OUTER_PIPE),
                 rimDiameter=PipeInnerDiameter(OUTER_PIPE)+0.125, rimHeight=0.1,
                 bulletDiameter=PipeInnerDiameter(INNER_PIPE),
                 bulletLength=0.3,
                 $fn=60) {

  bulletRadius  = bulletDiameter/2;
  chamberRadius = chamberDiameter/2;
  rimRadius     = rimDiameter/2;
  rimExtra = rimRadius-chamberRadius;

  shellBaseHeight = PrimerHeight(primer) + (bulletRadius*1.25);
  echo("Height: ", shellBaseHeight);

  render()
  union() {

    // Base and rim, minus charge pocket and primer hole
    difference() {
      union() {
        
        // Body
        color("Yellow")
        ChamferedCylinder(r1=chamberRadius, r2=PipeWall(INNER_PIPE)/2,
                          teardropTop=true,
                          h=shellBaseHeight);

        // Rim
        color("Blue")
        cylinder(r=rimRadius, h=rimHeight);
        

        // Rim Taper
        cylinder(r1=rimRadius, r2=chamberRadius, h=rimExtra);
      }
      
      
      // Primer
      Primer(primer=primer);
      
      // Bullet
      translate([0,0,PrimerHeight(primer)]) {
        translate([0,0,PipeInnerRadius(INNER_PIPE)])
        sphere(r=PipeInnerRadius(INNER_PIPE), $fn=PipeFn(INNER_PIPE));
        
        cylinder(r=(PrimerMinorDiameter(PRIMER)+PrimerClearance(PRIMER))/2, h=bulletRadius, $fn=PipeFn(INNER_PIPE));
      }
    }

    // Payload
    translate([0,0,shellBaseHeight])
    children();
  }
}


  
color("LightBlue")
  translate([0,0.001,0])
Cutaway()
difference() {
  translate([0,0,0.5125])
  Pipe(INNER_PIPE, length=3, hollow=true);
  PATCartridge();
}

color("SteelBlue")
Cutaway()
translate([0,0,0.1])
Pipe(OUTER_PIPE, length=2, hollow=true);


color("Gold")
render()
difference() {
  PATCartridge();
  cube(4);
}
      
// Bullet
color("DimGrey")
translate([0,0,PrimerHeight(PRIMER)]) {
  *cylinder(r=PipeInnerRadius(INNER_PIPE), h=0.3, $fn=PipeFn(INNER_PIPE));
  
  translate([0,0,PipeInnerRadius(INNER_PIPE)])
  sphere(r=PipeInnerRadius(INNER_PIPE), $fn=PipeFn(INNER_PIPE));
  
}

// Primer
color("Red")
Primer(primer=PRIMER);


*!scale([25.4, 25.4, 25.4])
PATCartridge();