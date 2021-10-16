use <../Meta/Cutaway.scad>;
use <../Meta/Conditionals/RenderIf.scad>;
use <../Shapes/Chamfer.scad>;
use <../Shapes/Semicircle.scad>;
use <../Shapes/Teardrop.scad>;
use <../Shapes/TeardropTorus.scad>;
use <Primer.scad>;



/* [Print] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = "Smoke"; // ["", "Base", "Flare", "Whistle", "Smoke_Tail", "Smoke_Tip"]

/* [Assembly] */
_SHOW_BASE = true;
_SHOW_PROJECTILE = true;
_CUTAWAY_BASE = true;
_CUTAWAY_PROJECTILE = true;
_ALPHA_BASE = 1; // [0:0.1:1]
_ALPHA_PROJECTILE = 1; // [0:0.1:1]

_PROJECTILE_TYPE = "Smoke"; // ["", "Base", "Flare", "Whistle", "Smoke"]
_SPIGOT_TYPE = "22PAT"; // ["22PAT", "209"]

/* [Dimensions] */
BASE_HEIGHT = 1.5;
BASE_THICKNESS = 0.5;
RIM_WIDTH = 0.0972;
RIM_DIAMETER = 1.689;
CHAMBER_DIAMETER = 1.538;// 1.508;
INSERT_DIAMETER = 1.25;
SPIGOT_DIAMETER = 0.281; // 9/32 Brass Tube
SPIGOT_CLEARANCE = 0.003;
SPIGOT_LENGTH = 1;
SPIGOT_BASE_LENGTH = 0.8;
CLEARANCE = 0.006;
WHISTLE_RADIUS = 0.1875;
SMOKE_OD = 1.2;
SMOKE_ID = 0.86;
SMOKE_HEIGHT=4.93;
OFFSET_22PAT = 0.125;


spigotRadius = SPIGOT_DIAMETER/2;
chamberRadius = CHAMBER_DIAMETER/2;
insertRadius  = INSERT_DIAMETER/2;
rimRadius     = RIM_DIAMETER/2;

// ************
// * Vitamins *
// ************
module SPAT37_Spigot(SPIGOT_LENGTH=SPIGOT_LENGTH, cutter=false, clearance=CLEARANCE, $fn=30) {
  clear = cutter ? clearance : 0;
  
  color("Gold") RenderIf(!cutter)
  difference() {
    cylinder(r=spigotRadius+clear, h=SPIGOT_LENGTH);
    
    if (!cutter)
    cylinder(r=spigotRadius-(1/64), h=SPIGOT_LENGTH);
  }
}
module SPAT37_PAT22(cutter=false, clearance=0.005, $fn=20) {
  primer = Spec_Primer22PAT();
  
  clear = cutter ? clearance : 0;
  
  rimDiameter = 0.275;
  rimRadius = rimDiameter/2;
  rimHeight = 0.036;
  
  render()
  union() {

    // Rim
    cylinder(r=rimRadius+clear,
             h=rimHeight);

    // Rim Taper
    translate([0,0,rimHeight])
    cylinder(r1=rimRadius+clear,
             r2=0,
             h=rimRadius+clear);

    // Smaller top portion
    cylinder(r=(0.201/2)+clear,
             h=0.5940);
    
    // Larger bottom portion
    cylinder(r1=(0.2240/2)+clear,
             r2=(0.2200/2)+clear, h=0.353);
  }
}



module SPAT37_SmokePyro(cutter=false) {
  // TNT-brand "Ammo Smoke"
  // UPC 027736010950
  translate([0,0,BASE_HEIGHT+0.1875])
  cylinder(r=SMOKE_OD/2, h=SMOKE_HEIGHT, $fn=60);
}

// **********
// * Shapes *
// **********
module SPAT37_SpinChamber(clearance=0.01) {
  radius = spigotRadius+0.125;
  
  // Expansion Chamber
  translate([0,0,SPIGOT_LENGTH])
  ChamferedCylinder(r1=radius,
                    r2=radius-clearance,
                    h=BASE_HEIGHT-SPIGOT_LENGTH,
                    teardropTop=true);
    
  // Spin ports
  for (R = [0:120:360]) rotate(R)
  multmatrix([[1,0,0,0],
              [0.5,1,0,0],
              [1,0,1,0]])
  translate([-insertRadius,0,SPIGOT_BASE_LENGTH+0.25+(1/8)])
  rotate_extrude(angle=180)
  translate([insertRadius,0])
  rotate(90)
  circle(r=1/8);
  
  // Spigot chamfer
  translate([0,0,SPIGOT_BASE_LENGTH])
  HoleChamfer(r1=spigotRadius+clearance, r2=1/16, teardrop=true);
}

// **********
// * Prints *
// **********
module SPAT37_Base(BASE_HEIGHT=BASE_HEIGHT, rimHeight=RIM_WIDTH, spigotBaseLength=SPIGOT_BASE_LENGTH, primerOffset=0, clearance=CLEARANCE, cutaway=false, alpha=1, $fn=60) {

  baseTorusRadius = 2/16;
  
  color("Chocolate", alpha) render()
  Cutaway(cutaway)
  difference() {
    
    // Base and rim
    union() {
      
      // Body
      ChamferedCylinder(r1=chamberRadius, r2=1/16,
                        h=BASE_HEIGHT);
      
      // Rim/body fillet
      translate([0,0,rimHeight])
      HoleChamfer(r1=chamberRadius, r2=1/64);
      
      // Rim
      ChamferedCylinder(r1=rimRadius, r2=1/32, h=rimHeight);
    }
    
    // Insert pocket
    difference() {
      translate([0,0,BASE_THICKNESS+baseTorusRadius])
      cylinder(r=insertRadius, h=BASE_HEIGHT);
      
      ChamferedCylinder(r1=insertRadius-(baseTorusRadius*2),
                        r2=1/8, h=SPIGOT_BASE_LENGTH);
    }
    
    // Rounded blast base
    translate([0,0,BASE_THICKNESS+baseTorusRadius])
    rotate_extrude()
    translate([insertRadius-baseTorusRadius,0])
    circle(r=baseTorusRadius);
    
    if (_SPIGOT_TYPE == "209") {
      SPAT37_Spigot(cutter=true);
    } else if (_SPIGOT_TYPE == "22PAT") {
      translate([OFFSET_22PAT,0,0])
      SPAT37_PAT22(cutter=true);
      
      // Wide mouth
      hull() {
        
        // Narrow side
        translate([OFFSET_22PAT,0,0.594])
        cylinder(r=0.21/2, h=0.01, $fn=20);
      
        // Wide side
        translate([0,0,SPIGOT_BASE_LENGTH])
        cylinder(r=(SPIGOT_DIAMETER/2)+0.11, h=0.01, $fn=40);
      }
      
      // Cut away any plastic that might impede a plain round firing pin
      cylinder(r=0.125/2, h=0.036, $fn=20);
    }
  }
}

module SPAT37_Flare(BASE_HEIGHT=BASE_HEIGHT, rimHeight=RIM_WIDTH, spigotDiameterSPIGOT_LENGTH=SPIGOT_LENGTH, spigotBaseLength=SPIGOT_BASE_LENGTH, clearance=CLEARANCE, primerOffset=0, cutaway=false, alpha=1, $fn=60) {

  color("Olive", alpha) render()
  Cutaway(cutaway)
  difference() {
    union() {
      
      // Body
      translate([0,0,BASE_HEIGHT])
      ChamferedCylinder(r1=chamberRadius, r2=1/4,
                        teardropTop=true, h=BASE_HEIGHT-spigotBaseLength);
      
      // Insert
      translate([0,0,spigotBaseLength])
      ChamferedCylinder(r1=insertRadius-clearance, r2=1/16,
                        h=BASE_HEIGHT);
    }
    
    SPAT37_Spigot(cutter=true);
    
    cylinder(r=(0.25+0.006)/2, h=BASE_HEIGHT+0.75);
    
    // Expansion Chamber
    translate([0,0,SPIGOT_LENGTH])
    mirror([0,0,1])
    ChamferedCylinder(r1=spigotRadius+0.125,
                      r2=spigotRadius+(1/16),
                      h=SPIGOT_LENGTH-spigotBaseLength-0.25,
                      teardropTop=true);
    
    // Spin ports
    for (R = [0:90:360]) rotate(R)
    multmatrix([[1,0,0,0],
                [0.5,1,0,0],
                [1,0,1,0]])
    translate([-insertRadius,0,spigotBaseLength+0.25+(1/8)])
    rotate_extrude(angle=180)
    translate([insertRadius,0])
    rotate(90)
    circle(r=1/8);
  }
}

module SPAT37_SmokeTail(BASE_HEIGHT=BASE_HEIGHT, rimHeight=RIM_WIDTH, SPIGOT_LENGTH=SPIGOT_LENGTH, spigotBaseLength=SPIGOT_BASE_LENGTH, clearance=CLEARANCE, primerOffset=0, cutaway=false, alpha=1, $fn=60) {
  color("Olive", alpha) render()
  Cutaway(cutaway)
  difference() {
    union() {
    
      // Insert
      translate([0,0,spigotBaseLength])
      ChamferedCylinder(r1=insertRadius-clearance, r2=1/16,
                        h=BASE_HEIGHT-spigotBaseLength+0.1875);
      
      translate([0,0,BASE_HEIGHT])
      ChamferedCylinder(r1=chamberRadius, r2=1/16,
                        teardropTop=true, h=0.1875);
    }
    
    // Fuse hole
    cylinder(r=0.125/2, h=BASE_HEIGHT+chamberRadius);
    
    SPAT37_SmokePyro(cutter=true);
    SPAT37_Spigot(cutter=true);
    SPAT37_SpinChamber();
  }
}
module SPAT37_SmokeTip(BASE_HEIGHT=BASE_HEIGHT, rimHeight=RIM_WIDTH, SPIGOT_LENGTH=SPIGOT_LENGTH, spigotBaseLength=SPIGOT_BASE_LENGTH, clearance=CLEARANCE, primerOffset=0, cutaway=false, alpha=1, $fn=60) {
  color("Olive", alpha) render()
  Cutaway(cutaway)
  difference() {
    union() {
    
      translate([0,0,BASE_HEIGHT+SMOKE_HEIGHT])
      intersection() {
        hull() {
          
          // Flared
          ChamferedCylinder(r1=chamberRadius, r2=1/16,
                            teardropBottom=false, h=0.5);
          
          // Tip
          ChamferedCylinder(r1=chamberRadius/2, r2=1/4,
                            teardropTop=true, h=1.5);
        }
        
        for (R = [0:120:360]) rotate(R)
        linear_extrude(1.5, twist=90, slices=25, scale=0.5)
        hull() {
          circle(r=SMOKE_OD/2);
          
          semidonut(major=chamberRadius*2, minor=SMOKE_OD, angle=30);
        }
      }
      
      // Insert
      translate([0,0,BASE_HEIGHT+SMOKE_HEIGHT-0.25])
      ChamferedCylinder(r1=(SMOKE_ID/2)-clearance, r2=1/16,
                        h=0.5);
    }
  }
}



module SPAT37_Whistle(clearance=CLEARANCE, primerOffset=0, cutaway=false, alpha=1, $fn=60) {

  color("Olive", alpha) render()
  Cutaway(cutaway)
  difference() {
    union() {
      hull() {
        
        // Tip
        translate([0,0,BASE_HEIGHT+chamberRadius])
        sphere(r=chamberRadius);
      
        // Body
        translate([0,0,BASE_HEIGHT])
        ChamferedCylinder(r1=chamberRadius, r2=1/4,
                          teardropTop=true, h=BASE_HEIGHT-spigotBaseLength);
      }
      
      // Insert
      translate([0,0,spigotBaseLength])
      ChamferedCylinder(r1=insertRadius-clearance, r2=1/16,
                        h=BASE_HEIGHT);
    }
    
    // Fuse hole
    cylinder(r=0.125/2, h=BASE_HEIGHT+chamberRadius);
    
    // Whistles
    pocketOffsetX = insertRadius-WHISTLE_RADIUS;
    pocketOffsetZ = BASE_HEIGHT+chamberRadius;
    for (R = [0:120:360]) rotate (R) {
      
      // Air channel
      difference() {
        translate([insertRadius,-WHISTLE_RADIUS,BASE_HEIGHT])
        cube([0.375, WHISTLE_RADIUS*2, BASE_HEIGHT+chamberRadius+chamberRadius]);
      
        // Proud lip
        translate([pocketOffsetX,0,pocketOffsetZ])
        rotate([0,-90,90])
        sphere(r=WHISTLE_RADIUS+(chamberRadius-insertRadius));
      }
      
      // Air pocket
      translate([pocketOffsetX,0,pocketOffsetZ])
      rotate([0,-90,90])
      sphere(r=WHISTLE_RADIUS+(chamberRadius-insertRadius)-0.03125);
      
      // Air port
      translate([insertRadius,0,pocketOffsetZ])
      translate([0,-WHISTLE_RADIUS,0])
      cube([chamberRadius,(WHISTLE_RADIUS*2),WHISTLE_RADIUS*2]);
    }
    
    SPAT37_Spigot(cutter=true);
    SPAT37_SpinChamber();
  }
}

scale(25.4)
if ($preview) {
  if (_SPIGOT_TYPE == "209") {
    SPAT37_Spigot();
  } else if (_SPIGOT_TYPE == "22PAT") {
    translate([OFFSET_22PAT,0,0])
    SPAT37_PAT22();
  }
  
  if (_SHOW_BASE)
  SPAT37_Base(cutaway=_CUTAWAY_BASE, alpha=_ALPHA_BASE);
  
  if (_PROJECTILE_TYPE == "Flare")
    SPAT37_Flare(cutaway=_CUTAWAY_PROJECTILE, alpha=_ALPHA_PROJECTILE);
  
  else if (_PROJECTILE_TYPE == "Whistle")
    SPAT37_Whistle(cutaway=_CUTAWAY_PROJECTILE, alpha=_ALPHA_PROJECTILE);
  
  else if (_PROJECTILE_TYPE == "Smoke") {
    SPAT37_SmokePyro();
    SPAT37_SmokeTip(cutaway=_CUTAWAY_PROJECTILE, alpha=_ALPHA_PROJECTILE);
    SPAT37_SmokeTail(cutaway=_CUTAWAY_PROJECTILE, alpha=_ALPHA_PROJECTILE);
  }
  
} else {
  if (_RENDER == "Prints/Base")
  SPAT37_Base();
  
  if (_RENDER == "Prints/Flare")
  translate([0,0,-SPIGOT_BASE_LENGTH])
  SPAT37_Flare();
  
  if (_RENDER == "Prints/Smoke_Tail")
  translate([0,0,-SPIGOT_BASE_LENGTH])
  SPAT37_SmokeTail();
  
  if (_RENDER == "Prints/Smoke_Tip")
  rotate([180,0,0])
  translate([0,0,-BASE_HEIGHT-SMOKE_HEIGHT])
  SPAT37_SmokeTip();
  
  if (_RENDER == "Prints/Whistle")
  translate([0,0,-SPIGOT_BASE_LENGTH])
  SPAT37_Whistle();
}