use <../Meta/Cutaway.scad>;
use <../Meta/Units.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Conditionals.scad>;
use <../Shapes/Chamfer.scad>;
use <../Shapes/Semicircle.scad>;
use <../Shapes/Teardrop.scad>;
use <../Shapes/TeardropTorus.scad>;
use <Primer.scad>;



/* [Print] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = "Smoke"; // ["", "Prints/Base", "Prints/Flare", "Prints/Whistle", "Prints/Smoke_Tail", "Prints/Smoke_Tip"]

/* [Assembly] */
_SHOW_BASE = true;
_SHOW_INSERT = true;
_SHOW_PROJECTILE = true;
_CUTAWAY_BASE = true;
_CUTAWAY_INSERT=true;
_CUTAWAY_PROJECTILE = true;
_ALPHA_BASE = 1; // [0:0.1:1]
_ALPHA_INSERT = 1; // [0:0.1:1]
_ALPHA_PROJECTILE = 1; // [0:0.1:1]

_PROJECTILE_TYPE = "Paint"; // ["", "Flare", "Whistle"]
PAT_LOAD = "PAT22"; // ["PAT22", "PAT27"]

/* [Dimensions] */
BASE_HEIGHT = 1.125;
BASE_THICKNESS = 0.375;
RIM_WIDTH = 0.0972;
RIM_DIAMETER = 1.625;
CHAMBER_DIAMETER = 1.5;// 1.508;
INNER_DIAMETER = 1.3125;
CLEARANCE = 0.006;
OFFSET_22PAT = 0.125;
OFFSET_27PAT = 0.16625;


chamberRadius = CHAMBER_DIAMETER/2;
innerRadius  = INNER_DIAMETER/2;
rimRadius     = RIM_DIAMETER/2;
PAT_Insert_Radius = Inches(0.375);
PAT_Insert_Height = 0.625;
retainerRingRadius = Inches(1/32);
retainerRingZ = Inches(1);
insertRetainerZ = Inches(0.25);

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

// ************
// * Vitamins *
// ************
module PAT22(cutter=false, clearance=0.005) {
  clear = cutter ? clearance : 0;

  rimDiameter = 0.275;
  rimRadius = rimDiameter/2;
  rimHeight = 0.036;
  bodyRadius1 = 0.2240/2;

  color("Gold") RenderIf(!cutter)
  union() {

    // Rim
    cylinder(r=rimRadius+clear,
             h=rimHeight);

    // Rim Taper
    translate([0,0,rimHeight])
    cylinder(r1=rimRadius-(1/64),
             r2=0,
             h=(rimRadius/2));

    // Smaller top portion
    cylinder(r=(0.201/2)+clear,
             h=(cutter?PAT_Insert_Height:0.5940));

    // Larger bottom portion
    translate([0,0,rimHeight])
    cylinder(r1=bodyRadius1+clear,
             r2=(0.2200/2)+clear, h=0.353-rimHeight);
  }
}

module PAT27(cutter=false, clearance=0.005) {
  clear = cutter ? clearance : 0;

  rimDiameter = 0.3;
  rimRadius = rimDiameter/2;
  rimHeight = 0.036;
  bodyDiameter = 0.27;

  color("Gold") RenderIf(!cutter)
  union() {

    // Rim
    cylinder(r=rimRadius+clear,
             h=rimHeight);

    // Larger bottom portion
    cylinder(r1=(0.2240/2)+clear,
             r2=(0.2200/2)+clear, h=0.353);
  }
}
///

// **********
// * Shapes *
// **********
module PAT_Insert(alpha=1, cutaway=_CUTAWAY_INSERT, cutter=false, clearance=Inches(0.005)) {
  clear = cutter ? clearance : 0;
  CR = Inches(1/32);

  color("CornflowerBlue", alpha) RenderIf(!cutter)
  Cutaway(cutaway)
  difference() {
    if (cutter) {
      ChamferedCircularHole(r1=PAT_Insert_Radius+clear,
                            r2=CR,
                            h=PAT_Insert_Height);
    } else {
      ChamferedCylinder(r1=PAT_Insert_Radius,
                        r2=CR,
                         h=PAT_Insert_Height,
                        teardropTop=true);
    }
    
    // Retainer Ring
    translate([0,0,insertRetainerZ])
    rotate_extrude()
    translate([PAT_Insert_Radius+clear,0])
    rotate(-90)
    Teardrop(r=retainerRingRadius);
    
    // Cut away any plastic that might impede a plain round firing pin
    if (!cutter)
    cylinder(r=0.125/2, h=0.036);
    
    children();
  }
}
///

// **********
// * Prints *
// **********
module PAT37_Base(BASE_HEIGHT=BASE_HEIGHT, rimHeight=RIM_WIDTH, primerOffset=0, clearance=CLEARANCE, cutaway=false, alpha=1, $fn=60) {

  baseTorusRadius = 1/16;
  CR = 1/32;

  color("Chocolate", alpha) render()
  Cutaway(cutaway)
  difference() {

    // Base and rim
    union() {

      // Body
      ChamferedCylinder(r1=chamberRadius, r2=CR,
                        h=BASE_HEIGHT);

      // Rim/body fillet
      translate([0,0,rimHeight])
      HoleChamfer(r1=chamberRadius, r2=1/64);

      // Rim
      ChamferedCylinder(r1=rimRadius, r2=CR, h=rimHeight);
    }
    
    // ID Cutout
    difference() {
      translate([0,0,BASE_THICKNESS+CR])
      ChamferedCircularHole(r1=innerRadius,
                            r2=CR,
                            h=BASE_HEIGHT-BASE_THICKNESS-CR,
                            chamferBottom=false);
      
      // Retainer Ring
      translate([0,0,retainerRingZ])
      rotate_extrude()
      translate([innerRadius,0])
      rotate(-90)
      Teardrop(r=retainerRingRadius);
    }

    // Rounded blast base
    translate([0,0,BASE_THICKNESS])
    rotate_extrude()
    translate([innerRadius-baseTorusRadius,0])
    rotate(-90)
    Teardrop(r=baseTorusRadius, truncated=true);

    
      translate([OFFSET_22PAT,0,0])
      PAT22(cutter=true);
    
    // PAT Module Hole
    PAT_Insert(cutter=true);
  }
}
///

ScaleToMillimeters()
if ($preview) {
  if (PAT_LOAD == "PAT22") {
    translate([OFFSET_22PAT,0,0])
    PAT22();
  } else if (PAT_LOAD == "PAT27") {
    translate([OFFSET_27PAT,0,0])
    PAT27();
  }
  
  if (_SHOW_INSERT)
    PAT_Insert(alpha=_ALPHA_INSERT) translate([OFFSET_22PAT,0,0]) PAT22(cutter=true);
  
  if (_SHOW_BASE)
    PAT37_Base(cutaway=_CUTAWAY_BASE, alpha=_ALPHA_BASE);

} else {
  if (_RENDER == "Prints/Base")
  PAT37_Base();

  if (_RENDER == "Prints/Flare")
  translate([0,0,-BASE_HEIGHT])
  PAT37_Flare();
}
