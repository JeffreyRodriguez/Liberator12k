include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Cutaway.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Conditionals/RenderIf.scad>;
use <../Meta/Conditionals/MirrorIf.scad>;

use <../Shapes/Chamfer.scad>;
use <../Shapes/MLOK.scad>;
use <../Shapes/Teardrop.scad>;
use <../Shapes/TeardropTorus.scad>;
use <../Shapes/Semicircle.scad>;
use <../Shapes/ZigZag.scad>;

use <../Shapes/Components/Pivot.scad>;
use <../Shapes/Components/Pump Grip.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Springs/Springs.scad>;
use <../Vitamins/Springs/SpringSpec.scad>;

use <../Receiver/Components/Sightpost.scad>;

use <../Receiver/FCG.scad>;
use <../Receiver/Frame.scad>;
use <../Receiver/Lower.scad>;
use <../Receiver/Receiver.scad>;
use <../Receiver/Stock.scad>;

/* [Export] */

// Select a part, Render it (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Prints/ReceiverFront", "Prints/Forend", "Prints/Cluster", "Prints/BarrelCollar", "Prints/Extractor", "Prints/LatchTab", "Prints/VerticalForegrip", "Prints/Sightpost","Prints/BarrelSleeveFixture"]

// Reorient the part for printing?
_RENDER_PRINT = true;

/* [Assembly] */
_SHOW_PRINTS = true;
_SHOW_HARDWARE = true;
_SHOW_RECEIVER = true;
_SHOW_TENSION_RODS = false;
_SHOW_STOCK = true;
_SHOW_FCG = false;
_SHOW_LOWER = true;
_SHOW_SIGHTPOST = true;

_SHOW_RECEIVER_FRONT = true;
_SHOW_FOREND = true;
_SHOW_COLLAR = true;
_SHOW_COLLAR_HARDWARE = true;
_SHOW_EXTRACTOR = true;
_SHOW_EXTRACTOR_HARDWARE = true;
_SHOW_LATCH = true;
_SHOW_LATCH_HARDWARE = true;
_SHOW_BARREL = true;
_SHOW_CLUSTER = true;
_SHOW_CLUSTER_BOLTS = true;
_SHOW_FOREGRIP = true;
_SHOW_GRIP_BOLT=true;

/* [Transparency] */
_ALPHA_RECEIVER_FRONT=1; // [0:0.1:1]
_ALPHA_FOREND = 1;  // [0:0.1:1]
_ALPHA_COLLAR = 1; // [0:0.1:1]
_ALPHA_CLUSTER = 1; // [0:0.1:1]
_ALPHA_EXTRACTOR = 1; // [0:0.1:1]
_ALPHA_LATCH = 1; // [0:0.1:1]
_ALPHA_RECEIVER = 0.15; // [0:0.1:1]
_ALPHA_LOWER = 0.15; // [0:0.1:1]
_ALPHA_STOCK = 0.15; // [0:0.1:1]
_ALPHA_FCG = 0.15; // [0:0.1:1]

/* [Cutaway] */
_CUTAWAY_RECEIVER = false;
_CUTAWAY_LOWER = false;
_CUTAWAY_BARREL = false;
_CUTAWAY_FOREND = false;
_CUTAWAY_COLLAR = false;
_CUTAWAY_CLUSTER = false;
_CUTAWAY_EXTRACTOR = false;
_CUTAWAY_LATCH = false;

/* [Vitamins] */
GP_BOLT = "#8-32"; // ["M4", "#8-32"]
GP_BOLT_CLEARANCE = 0.015;

BARREL_COLLAR_BOLT  = "#8-32"; // ["M4", "#8-32"]
BARREL_COLLAR_BOLT_CLEARANCE = 0.015;

BARREL_SET_SCREW = "#8-32"; // ["M4", "#8-32"]
BARREL_SET_SCREW_CLEARANCE = -0.05;

CLUSTER_BOLT = "#8-32"; // ["M4", "#8-32"]
CLUSTER_BOLT_CLEARANCE = 0.015;
CLUSTER_BOLT_HEAD = "flat"; // ["flat", "socket"]
CLUSTER_BOLT_NUT = "none"; // ["none", "heatset"]

GRIP_BOLT = "1/4\"-20"; // ["M6", "1/4\"-20"]
GRIP_BOLT_CLEARANCE = -0.05;

EXTRACTOR_RETAINER_DIAMETER = 0.2501;
EXTRACTOR_RETAINER_CLEARANCE = 0.008;

LATCH_WIDTH = 0.25;
LATCH_CLEARANCE = 0.003;

BARREL_SLEEVE_DIAMETER = 1.2501;
BARREL_OUTSIDE_DIAMETER = 1.0001;
BARREL_INSIDE_DIAMETER = 0.8131;
BARREL_CLEARANCE = 0.008;
BARREL_LENGTH = 18;
BARREL_Z = 0.0001;
RIM_WIDTH = 0.0301;
RIM_DIAMETER = 0.8875;

RECOIL_PLATE_LENGTH = 0.25;

/* [Fine Tuning] */
PIVOT_X = 4.501;
PIVOT_RADIUS = 0.501;
PIVOT_ANGLE = 30;
PIVOT_WIDTH = 2;
FRAME_BOLT_LENGTH = 10;
WALL_BARREL = 0.1875;

/* [Branding] */
BRANDING_MODEL_NAME = "CAFE12+";

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();
//$t = AnimationDebug(ANIMATION_STEP_EXTRACT, start=0.5);


// Settings: Vitamins
function BarrelSetScrew() = BoltSpec(BARREL_SET_SCREW);
assert(BarrelSetScrew(), "BarrelSetScrew() is undefined. Unknown BARREL_SET_SCERW?");

function GripBolt() = BoltSpec(GRIP_BOLT);
assert(GripBolt(), "GripBolt() is undefined. Unknown GRIP_BOLT?");

function GPBolt() = BoltSpec(GP_BOLT);
assert(GPBolt(), "GPBolt() is undefined. Unknown GP_BOLT?");

function BarrelCollarBolt() = BoltSpec(BARREL_COLLAR_BOLT);
assert(BarrelCollarBolt(), "BarrelCollarBolt() is undefined. Unknown BARREL_COLLAR_BOLT?");

function ClusterBolt() = BoltSpec(CLUSTER_BOLT);
assert(ClusterBolt(), "ClusterBolt() is undefined. Unknown CLUSTER_BOLT?");

function BarrelSleeveRadius(clearance=0)
    = BarrelSleeveDiameter(clearance*2)/2;

function BarrelSleeveDiameter(clearance=0)
    = BARREL_SLEEVE_DIAMETER+clearance;

function BarrelInsideRadius(clearance=0)
    = BarrelInsideDiameter(clearance*2)/2;

function BarrelInsideDiameter(clearance=0)
    = BARREL_INSIDE_DIAMETER+clearance;

function BarrelRadius(clearance=0)
    = BarrelDiameter(clearance*2)/2;

function BarrelDiameter(clearance=0)
    = BARREL_OUTSIDE_DIAMETER+clearance;

function BarrelWall() = (BarrelDiameter() - BARREL_INSIDE_DIAMETER)/2;
function BarrelSleeveWall() = (BarrelSleeveDiameter() - BarrelDiameter())/2;


function TopBreak_ExtractorRetainerRadius() = EXTRACTOR_RETAINER_DIAMETER/2;

// Calculated: Positions
//function ActionRodZ() = FrameBoltZ()-WallFrameBolt()-(ActionRodWidth()/2);
function BarrelZ() = BARREL_Z; // -0.11 for .22LR rimfire

// Settings: Dimensions
function BarrelLength() = BARREL_LENGTH;
function BarrelSleeveLength() = 8;
function WallBarrel() = WALL_BARREL;

function WallPivot() = 0.25;
function PivotAngleBack() = -25;
function PivotAngle() = PIVOT_ANGLE;
function PivotX() = PIVOT_X;
function PivotZ() = BarrelZ()-max(1.325/2, BarrelSleeveRadius()); // Use 1" sch40 as the floor and everything smaller can use the same forend. Anything bigger will need a custom forend.
function PivotWidth() = PIVOT_WIDTH;
function PivotRadius() = PIVOT_RADIUS;
function PivotDiameter() = PivotRadius()*2;
function PivotClearance() = 0.01;
function PivotOuterRadius() = abs(PivotZ())+FrameBoltZ();

function ActionRodLength() = 10;
function FrameBoltLength() = FRAME_BOLT_LENGTH;

function TopBreak_ReceiverFrontLength() = 0.5;
function FrameBackLength() = 0.75+0.5;
function ForendLength() = FrameExtension(length=FRAME_BOLT_LENGTH)
                        - 0.5
                        -TopBreak_ReceiverFrontLength();

function ChargerTravel() = 1.75;

// Calculated: Lengths
function TopBreak_ForegripOffsetX() = 6+ChargerTravel();
function TopBreak_ForegripLength() = 4.625;

// Calculated: Springs
function ExtractorSpringSpec() = [
        ["SpringSpec", "Extractor Spring"],

        ["SpringOuterDiameter", UnitsImperial(0.625)],
        ["SpringPitch", UnitsImperial(0.35)],

        ["SpringFreeLength", UnitsImperial(3.5)],
        ["SpringSolidHeight", UnitsImperial(1.75)],

        ["SpringWireDiameter", UnitsImperial(0.055)]
    ];

// Calculated: Positions
//function ActionRodZ() = FrameBoltZ()-WallFrameBolt()-(ActionRodWidth()/2);
function BarrelOffsetZ() = 0; // -0.11 for .22LR rimfire

function TopBreak_ExtractorWall() = 0.125;
function TopBreak_ExtractorWallBottom() = 0.1875;
function TopBreak_ExtractorWidth() = 0.65;
function TopBreak_ExtractorHeight() = 0.65;
function TopBreak_ExtractorTravel() = 0.3125;
function TopBreak_ExtractorBitWidth() = (1/4);
function TopBreak_ExtractorBitLength() = 1;
function TopBreak_ExtractorLength() = (PivotX()-PivotRadius())
                                      - SpringSolidHeight(spring=ExtractorSpringSpec())
                                      - WallPivot();

function TopBreak_ExtractorBitZ() = BarrelZ()
                                  - BarrelInsideRadius()
                                  + 0.03;

function TopBreak_ExtractorZ() = BarrelZ()
                               - BarrelSleeveRadius()
                               - TopBreak_ExtractorHeight()
                               - max(TopBreak_ExtractorWall(),0.1875);

function TopBreak_ExtractorHousingWidth() = TopBreak_ExtractorWidth()
                                          + (TopBreak_ExtractorWall()*2);
function TopBreak_BarrelCollarBottomZ() = TopBreak_ExtractorZ()
                                        - TopBreak_ExtractorWallBottom();

function TopBreak_LatchTravel() = 0.5;
function TopBreak_LatchWall() = 0.125;

function TopBreak_LatchLength() = 3;
function TopBreak_LatchWidth() = LATCH_WIDTH;
function TopBreak_LatchHeight() = LATCH_WIDTH;
function TopBreak_LatchTabHeight() = 0.625;


function TopBreak_LatchExtension() = 0.25;

function TopBreak_LatchSpringLength() = 1;
function TopBreak_LatchSpringRadius() = 0.25/2;

function TopBreak_LatchZ() = -1.625;
function TopBreak_LatchY() = (TopBreak_ExtractorHousingWidth()/2)
                           + (TopBreak_LatchWidth()/2);

function VerticalForegripRadius() = 0.625;

// Pivot modules
module PivotClearanceCut(offsetX=0, cut=true, width=PivotWidth(),
                         clearance=0.005) {
  difference() {
    children();

    // Trim off anything that won't clear the pivot
    if (cut)
    difference() {
      translate([PivotX()+offsetX, 0, PivotZ()])
      rotate([90,0,0])
      linear_extrude(height=width*2, center=true)
      rotate(180) mirror([0,1])
      semicircle(od=PivotX()*3, angle=90);

      translate([PivotX()+offsetX, 0, PivotZ()])
      rotate([90,0,0])
      ChamferedCylinder(r1=(PivotX()-clearance), r2=1/16,
                        h=width, center=true);
    }
  }
}

module PivotOuterBearing(intersect=true, cutter=false, clearance=0.002) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  intersection() {

    // Pivot radius
    translate([PivotX(), (PivotWidth()/2)+clear, PivotZ()])
    rotate([90,0,0])
    ChamferedCylinder(r1=PivotOuterRadius()+clear,
                      r2=PivotWidth()/2,
                      teardropTop=true, teardropBottom=true,
                      h=PivotWidth()+clear2);

    // Square off front and bottom edges
    if (intersect)
    translate([0, -(PivotWidth()/2)-clear, PivotZ()-(sqrt(2)/2*PivotRadius())])
    ChamferedCube([PivotX(),
                   PivotWidth()+clear2,
                   PivotOuterRadius()+(sqrt(2)/2*PivotRadius())+clear],
                   r=1/16);
  }
}
module PivotInnerBearing(cutter=false, clearance=0.002, widthClearance=0.005) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  // Inner pivot surface
  translate([PivotX(),-(PivotWidth()/2)-widthClearance, PivotZ()])
  rotate([-90,0,0])
  ChamferedCircularHole(r1=PivotRadius()+clear,
                        r2=1/8,
                        h=PivotWidth()+(widthClearance*2),
                        teardropTop=false, teardropBottom=false);
}

module BreakActionPivot(factor=0) {
  Pivot2(xyz=[PivotX(),0,PivotZ()],
         angle=[0,PivotAngle(),0],
         factor=factor)
  children();
}

// Vitamins
module TopBreak_ExtractorBit(cutter=false, clearance=0.003) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  color("DimGrey") RenderIf(!cutter)
  translate([RIM_WIDTH,0,0])
  translate([TopBreak_ExtractorBitWidth()/8,0,TopBreak_ExtractorBitZ()])
  rotate([0,155,0])
  difference() {
    rotate(30)
    cylinder(r=((TopBreak_ExtractorBitWidth()/2)/cos(30))+clear,
             h=TopBreak_ExtractorBitLength(), $fn=6);

    // Cut the flattened tip
    if (!cutter)
    for (M = [0,1]) mirror([M,0,0])
    hull() for (Z = [0,TopBreak_ExtractorBitWidth()/2])
    translate([TopBreak_ExtractorBitWidth()*0.7,0,Z])
    scale([1,1,1.75])
    rotate([90,0,0])
    cylinder(r=TopBreak_ExtractorBitWidth()/2,
             h=TopBreak_ExtractorBitWidth()*(1+cos(30)),
             center=true);
  }
}

module TopBreak_ExtractorRetainer(cutaway=false, cutter=false, teardrop=false, clearance=EXTRACTOR_RETAINER_CLEARANCE) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  // Secure the TopBreak_Latch block to the TopBreak_Latch rod
  color("Silver") RenderIf(!cutter)
  translate([TopBreak_ExtractorWidth()+TopBreak_ExtractorTravel()+0.5,
             0,
             -BarrelSleeveRadius()-1-clear2])
  cylinder(r=TopBreak_ExtractorRetainerRadius()+clear, h=1+clear2);
}

module TopBreak_LatchBars(doMirror=true, cutaway=false, cutter=false, clearance=LATCH_CLEARANCE, alpha=1) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  // Latch
  color("Silver", alpha) RenderIf(!cutter) Cutaway(cutaway)
  MirrorIf(doMirror, [0,1,0], true)
  difference() {

    // Latch Body
    translate([-0.25-(cutter?0.5:0)-clear,
               TopBreak_LatchY()-(TopBreak_LatchWidth()/2)-clear,
               TopBreak_LatchZ()-clear])
    cube([TopBreak_LatchLength()+(cutter?TopBreak_LatchTravel()+0.5+clear:0),
          TopBreak_LatchWidth()+clear2,
          TopBreak_LatchHeight()+clear2]);

    if (!cutter)
    translate([0,0,0.1])
    TopBreak_LatchScrews(cutter=true, clearance=-0.02);
  }
}

module TopBreak_LatchSpring(length=TopBreak_LatchSpringLength(), compress=0, doMirror=true, cutter=false, clearance=0.015, alpha=1) {
  clear = cutter?clearance:0;

  color("Silver", alpha) RenderIf(!cutter)
  MirrorIf(doMirror, [0,1,0], both=true)
  translate([-0.25+TopBreak_LatchLength()+TopBreak_LatchSpringLength()+clear, TopBreak_LatchY(), TopBreak_LatchZ()+(TopBreak_LatchHeight()/2)])
  rotate([0,-90,0])
  cylinder(r=TopBreak_LatchSpringRadius()+clear,
           h=length-compress);
}

module TopBreak_LatchScrews(head="flat", doMirror=true, cutaway=false, cutter=false, clearance=0.01) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  // Secure the TopBreak_Latch block to the TopBreak_Latch rod
  color("Silver") RenderIf(!cutter)
  MirrorIf(doMirror, [0,1,0], both=true)
  translate([0.75,TopBreak_LatchY(),TopBreak_LatchZ()-TopBreak_LatchWall()-TopBreak_LatchTabHeight()-0.01])
  rotate([0,180,0])
  Bolt(bolt=GPBolt(),
       length=1+ManifoldGap(), clearance=clear,
       head=head, capHeightExtra=(cutter?1:0), capOrientation=true);

}

module TopBreak_Barrel(od=BARREL_OUTSIDE_DIAMETER, id=BARREL_INSIDE_DIAMETER, length=BarrelLength(), clearance=BARREL_CLEARANCE, sleeve=true, cutter=false, alpha=1, cutaway=false) {

  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") RenderIf(!cutter) Cutaway(cutaway)
  translate([0,0,BarrelZ()])
  difference() {
    union() {

      // Barrel
      rotate([0,90,0])
      cylinder(r=(od/2)+clear, h=BarrelLength());

      // Barrel Sleeve
      rotate([0,90,0])
      cylinder(r=BarrelSleeveRadius()+clear, h=BarrelSleeveLength()+(1/16)+clear);
    }

    if (!cutter) {

      // Hollow inside
      rotate([0,90,0])
      cylinder(r=(id/2)+clear, h=length);

      // Extractor notch
      *#rotate([90,0,0])
      translate([0,-0.813*0.5,0])
      rotate(40)
      translate([TopBreak_ExtractorBitWidth()/4,0.813*0.5*0.1,-TopBreak_ExtractorBitWidth()/2])
      mirror([1,1,0])
      cube([BarrelSleeveDiameter(), BarrelSleeveRadius(), TopBreak_ExtractorBitWidth()]);
    }
  }
}

module TopBreak_BarrelCollarBolts(headType="flat", nutType="heatset", length=0.5, cutter=false, clearance=0.005, teardrop=false) {

  // Top Bolts
  color("Silver") RenderIf(!cutter)
  for (X = [0.5,1.5,2.5])
  translate([X,0,BarrelRadius()])
  NutAndBolt(bolt=BarrelCollarBolt(),
             boltLength=length+ManifoldGap(2),
             head="socket", capHeightExtra=(cutter?1:0),
             nut="none",
             teardrop=false, teardropAngle=180,
             clearance=cutter?clearance:0);
}

module TopBreak_ClusterBolts(bolt=ClusterBolt(), headType=CLUSTER_BOLT_HEAD, nutType=CLUSTER_BOLT_NUT, length=0.5, cutter=false, clearance=0.005, teardrop=false) {
  color("Silver") RenderIf(!cutter)
  for (X = [-0.5,-1.5])
  translate([BarrelSleeveLength()+X,0,BarrelRadius()])
  NutAndBolt(bolt=bolt,
             boltLength=length+ManifoldGap(2),
             head=headType, capHeightExtra=(cutter?BarrelRadius():0),
             nut=nutType, nutHeightExtra=(cutter?BarrelRadius():0),
             teardrop=cutter, teardropAngle=180,
             clearance=cutter?clearance:0,
             doRender=!cutter);
}

module TopBreak_GripBolt(bolt=GripBolt(), headType="flat", nutType="heatset", length=3.5, cutter=false, clearance=0.005, teardrop=true) {
  translate([BarrelSleeveLength()+0.25,0,-BarrelRadius()-length])
  mirror([0,0,1])
  NutAndBolt(bolt=bolt, boltLength=length+ManifoldGap(2),
             capOrientation=true,
             head=headType, capHeightExtra=(cutter?1:0),
             nut=nutType, nutHeightExtra=(cutter?0.5:0),
             teardrop=cutter && teardrop, teardropAngle=180,
             clearance=cutter?clearance:0,
             doRender=!cutter);
}


// Printed Parts
module TopBreak_ReceiverFront(cutaway=false, alpha=1) {
  color("Tan", alpha) render() Cutaway(cutaway)
  difference() {

    translate([-TopBreak_ReceiverFrontLength(),0,0]) {
      hull() {
        mirror([1,0,0])
        ReceiverTopSegment(length=1/8);

        Frame_Support(length=TopBreak_ReceiverFrontLength(),
                     chamferFront=true, teardropFront=true);
      }

      hull() {

        // Recoil plate backing
        translate([0,-(RecoilPlateWidth()/2)-0.25,RecoilPlateTopZ()])
        mirror([0,0,1])
        ChamferedCube([TopBreak_ReceiverFrontLength(),
                       RecoilPlateWidth()+0.5,
                       RecoilPlateHeight()-0.5],
                      r=1/8, teardropFlip=[true,true,true]);

        // Round off the bottom
        translate([0,0,-1])
        rotate([0,90,0])
        ChamferedCylinder(r1=0.625, r2=1/8, h=0.5);

        // Latch Support
        translate([0,
                   -((TopBreak_LatchY()+(TopBreak_LatchWidth()/2)+TopBreak_LatchWall())),
                   TopBreak_LatchZ()-TopBreak_LatchWall()])
        ChamferedCube([0.5,
                       (TopBreak_LatchY()+(TopBreak_LatchWidth()/2)+TopBreak_LatchWall())*2,
                       TopBreak_LatchHeight()+TopBreak_LatchWall()],
                      r=1/16, teardropFlip=[false,true,true]);

      }
    }

    Frame_Bolts(cutter=true);
    TopBreak_LatchBars(cutter=true);

    translate([-TopBreak_ReceiverFrontLength(),0,0]) {
      RecoilPlate(length=RECOIL_PLATE_LENGTH, cutter=true);
      RecoilPlateBolts(cutter=true);
      FiringPin(cutter=true);
      FiringPinSpring(cutter=true);
    }
  }
}

module TopBreak_Forend(clearance=0.005, doRender=true, cutaway=false, alpha=1) {

  // Branding text
  color("DimGrey", alpha)
  RenderIf(doRender) Cutaway(cutaway) {

    fontSize = 0.375;

    // Right-side text
    translate([ForendLength()-0.375,-FrameWidth()/2,FrameBoltZ()-(fontSize/2)])
    rotate([90,0,0])
    linear_extrude(height=LogoTextDepth(), center=true)
    text(BRANDING_MODEL_NAME, size=fontSize, font="Impact", halign="right");

    // Left-side text
    translate([ForendLength()-0.375,FrameWidth()/2,FrameBoltZ()-(fontSize/2)])
    rotate([90,0,0])
    linear_extrude(height=LogoTextDepth(), center=true)
    mirror([1,0])
    text(BRANDING_MODEL_NAME, size=fontSize, font="Impact", halign="left");
  }

  color("Tan", alpha)
  RenderIf(doRender) Cutaway(cutaway)
  difference() {
    union() {
      Frame_Support(length=ForendLength(),
                   chamferBack=true, teardropBack=true);

      hull() {
        translate([PivotX(), 0, PivotZ()])
        rotate([90,0,0])
        ChamferedCylinder(r1=PivotRadius()-0.01, r2=1/4, h=3,
                          teardropTop=false, teardropBottom=false, center=true);

        // Front face
        translate([ForendLength(), 0,0])
        mirror([1,0,0])
        Frame_Support(length=1/8,
                     extraBottom=FrameBottomZ()+abs(PivotZ()),
                     chamferFront=true, teardropFront=true);

        translate([ForendLength(), 0,0])
        mirror([1,0,0])
        Frame_Support(length=PivotRadius()+(ForendLength()-PivotX())+abs(PivotZ())+FrameTopZ(),
                     chamferFront=true, teardropFront=true);
      }
    }

    // Cutout the pivot track for the barrel collar to pass
    translate([PivotX(), 0, PivotZ()])
    rotate([0,180,0]) rotate([90,0,0])
    linear_extrude(BarrelSleeveDiameter()+(WallBarrel()*2)+(clearance*2), center=true)
    semidonut(major=PivotX()*3, minor=abs(PivotZ())*2, angle=PivotAngle());

    // Cut a path through the full range of motion (Barrel)
    for (flip = [1,-1])
    hull() for (A = [0, PivotAngle()])
    Pivot(pivotX=PivotX(), pivotZ=PivotZ(), angle=A, factor=1)
    translate([PivotX(),0,0])
    rotate([0,90*flip,0])
    cylinder(r=BarrelSleeveRadius()+BARREL_CLEARANCE,
             h=ForendLength()-PivotX());

    // Cut a path through the full range of motion (Collar)
    for (A = [0, PivotAngle()])
    Pivot(pivotX=PivotX(), pivotZ=PivotZ(), angle=A, factor=1)
    TopBreak_BarrelCollar(rearExtension=2, cutter=true);

    // Printability chamfer
    translate([ForendLength(),0,BarrelZ()])
    rotate([0,-90,0])
    HoleChamfer(r1=BarrelSleeveRadius(BARREL_CLEARANCE), r2=1/16,
                teardrop=true);

    Frame_Bolts(cutter=true);
  }
}

module TopBreak_BarrelCollar(rearExtension=0, cutter=false, clearance=0.005, cutaway=false, alpha=1) {
  clear = cutter?clearance:0;
  clear2 = clear*2;
  clearRear = 1/16;

  color("Chocolate", alpha) RenderIf(!cutter) Cutaway(cutaway)
  difference() {
    union() {
      PivotOuterBearing(cutter=cutter);

      PivotClearanceCut(cut=!cutter,
                        width=(BarrelSleeveRadius()+WallBarrel())*2) {

        // Around the barrel
        translate([clearRear,0,BarrelZ()])
        rotate([0,90,0])
        ChamferedCylinder(r1=BarrelSleeveRadius()+WallBarrel()+clear,
                          h=PivotX()-clearRear+clear,
                          teardropTop=true,
                          r2=1/16);

        // Extractor support
        translate([clearRear-rearExtension,
                   -(TopBreak_ExtractorHousingWidth()/2),
                   TopBreak_BarrelCollarBottomZ()])
        ChamferedCube([PivotX()-(sqrt(2)/2*PivotRadius())-clearRear+rearExtension,
                       TopBreak_ExtractorHousingWidth(),
                       abs(TopBreak_BarrelCollarBottomZ())],
                       r=1/16, teardropFlip=[false,true,true]);

        // Latch support
        translate([clearRear-rearExtension-clear,
                   -((BarrelSleeveRadius()+WallBarrel()))-clear,
                   TopBreak_LatchZ()-TopBreak_LatchWall()-clear])
        ChamferedCube([PivotX()-(sqrt(2)/2*PivotRadius())-clearRear+rearExtension+clear2,
                       (BarrelSleeveRadius()+WallBarrel())*2+clear2,
                       abs(TopBreak_LatchZ())+clear2], r=1/16, teardropFlip=[false,true,true]);
      }

      // Optics Rail Support
      hull() {
        translate([clearRear,-0.375,0])
        ChamferedCube([3,0.75, ReceiverTopZ()],
                       r=1/16,teardropFlip=[true,true,true]);

        translate([clearRear,-BarrelSleeveRadius(),0])
        ChamferedCube([1,BarrelSleeveDiameter(), BarrelSleeveRadius()],
                       r=1/16,teardropFlip=[true,true,true]);
      }
    }

    PivotInnerBearing(cutter=true, clearance=(cutter?0:clearance));

    if (!cutter) {

      TopBreak_LatchBars(cutter=true);
      TopBreak_LatchTab(cutter=true);
      TopBreak_LatchSpring(cutter=true);

      for (M = [0,1]) mirror([0,M,0])
      hull()
      for (X = [-clearance,TopBreak_LatchTravel()+clearance])
      translate([X,0,0])
      TopBreak_LatchScrews(cutter=true, head="none", doMirror=false);

      TopBreak_BarrelCollarBolts(cutter=true);

      translate([0.25,0,ReceiverTopZ()]) {
        MlokSlot(length=2.5);
        MlokSlotBack(length=2.5);
      }

      // Angled cut for supportless printability
      *translate([0,-(PivotWidth()/2),PivotZ()])
      rotate([0,90+45,0])
      cube([3, PivotWidth(), 3]);

      for (X = [0,-TopBreak_ExtractorTravel()])
      translate([X,0,0])
      TopBreak_Extractor(cutter=true);

      hull()
      for (X = [0,-TopBreak_ExtractorTravel()])
      translate([X,0,0])
      TopBreak_ExtractorRetainer(cutter=true, teardrop=true);

      TopBreak_Barrel(cutter=true);
    }
  }
}

module TopBreak_Extractor(cutter=false, clearance=0.005, chamferRadius=1/16, cutaway=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Olive", alpha)
  RenderIf(!cutter) Cutaway(cutaway)
  difference() {
    PivotClearanceCut(cut=!cutter, clearance=0) {

      // Long lower section
      translate([clear,
                 -(TopBreak_ExtractorWidth()/2)-clear,
                 TopBreak_ExtractorZ()-clear])
      ChamferedCube([TopBreak_ExtractorLength()+(cutter?SpringSolidHeight(spring=ExtractorSpringSpec())+clear:0),
                     TopBreak_ExtractorWidth()+clear2,
                     TopBreak_ExtractorHeight()+clear2], r=chamferRadius);

      // Tall portion to hold the retainer
      hull() {

        // Wide section
        translate([clear,
                   -(TopBreak_ExtractorWidth()/2)-clear,
                   TopBreak_ExtractorZ()])
        ChamferedCube([TopBreak_ExtractorBitWidth()+clear,
                       TopBreak_ExtractorWidth()+clear2,
                       abs(TopBreak_ExtractorZ())],
                      r=chamferRadius);

        // Narrow section
        translate([clear,
                   -(TopBreak_ExtractorBitWidth()/2)-clear,
                   TopBreak_ExtractorZ()])
        ChamferedCube([0.75+clear,
                       TopBreak_ExtractorBitWidth()+clear2,
                       abs(TopBreak_ExtractorZ())],
                      r=chamferRadius*2);
      }
    }

    if (!cutter) {

      // Cartridge rim
      rotate([0,90,0])
      cylinder(r=RIM_DIAMETER/2, h=RIM_WIDTH+clearance);

      TopBreak_Barrel(cutter=true);

      TopBreak_ExtractorBit(cutter=true);
      TopBreak_ExtractorRetainer(cutter=true);

      // Chamfer the back edge for smooth operation
      translate([0, 0, TopBreak_ExtractorZ()])
      rotate([90,0,0])
      linear_extrude(height=TopBreak_ExtractorWidth()+ManifoldGap(2), center=true)
      mirror([1,0])
      RoundedBoolean(edgeOffset=0, r=0.5, teardrop=true);
    }
  }
}

module TopBreak_LatchTab(cutaway=false, cutter=false, clearance=0.01, alpha=1) {
  CR = 1/16;
  clear = cutter?clearance:0;
  clear2 = clear*2;
  clearCR = cutter?CR:0;

  width = (BarrelSleeveRadius()+WallBarrel())*2;
  bottomZ = TopBreak_LatchZ()-TopBreak_LatchWall()-TopBreak_LatchTabHeight()-clearance;

  color("Olive", alpha) RenderIf(!cutter) Cutaway(cutaway)
  difference() {
    union() {

      // Latch Tab Body
      if (!cutter)
      PivotClearanceCut(offsetX=-TopBreak_LatchTravel(),
                        clearance=0.01, cut=true,
                        width=width)
      translate([-0.5, -(width/2), bottomZ])
      ChamferedCube([1.5+TopBreak_LatchTravel(),
                     width,
                     TopBreak_LatchTabHeight()], r=1/16);

      // Latch Tab Towers
      for (M = [0,1]) mirror([0,M,0])
      translate([0.5-clear,
                 TopBreak_LatchY()-(TopBreak_LatchWidth()/2)-clear,
                 TopBreak_LatchZ()-(TopBreak_LatchWall()+TopBreak_LatchTabHeight())-clear])
      ChamferedCube([1+(cutter?TopBreak_LatchTravel():0),
                     TopBreak_LatchWidth()+clear2,
                     (TopBreak_LatchWall()+TopBreak_LatchTabHeight()+0.06)+clear2],
                     r=1/16);
    }

    // Cut off the sharp tip, it tends to catch on things
    if (!cutter)
    translate([-0.3125,0, TopBreak_LatchZ()-TopBreak_LatchWall()-clearance])
    rotate([90,0,0])
    linear_extrude((BarrelSleeveRadius()+WallBarrel()+ManifoldGap())*2, center=true) {
      RoundedBoolean(r=0.0625, teardrop=false, angle=180);

      translate([-0.1875,-1])
      square([0.1875, 1]);
    }

    // Extractor support clearance
    translate([-0.5-clearance,
               -(TopBreak_ExtractorHousingWidth()/2)-clearance,
               TopBreak_BarrelCollarBottomZ()-clearance])
    ChamferedCube([PivotX()-(sqrt(2)/2*PivotRadius())+(clearance*2),
                   TopBreak_ExtractorHousingWidth()+(clearance*2),
                   abs(TopBreak_BarrelCollarBottomZ())+clearance],
                   r=1/16, teardropFlip=[false,true,true]);

    if (!cutter)
    TopBreak_LatchScrews(cutter=true);
  }
}

module TopBreak_VerticalForegrip(cutaway=false, alpha=1) {
  color("Tan", alpha) render()
  difference() {
    translate([BarrelSleeveLength()+0.25,0,-BarrelRadius()-0.75])
    mirror([0,0,1])
    PumpGrip(r=VerticalForegripRadius(), h=3, channelRadius=0.125);

    TopBreak_GripBolt(cutter=true, teardrop=false);
  }
}
module TopBreak_Cluster(cutaway=false, alpha=1) {
  topExtension = 0.5;
  forwardExtension = 1.5;
  rearExtension = 2;
  lowerExtension = 0.75;
  width = (7/16);
  mlokOffset = (BarrelSleeveRadius()+0.3125);

  color("Tan", alpha) render() Cutaway(cutaway)
  difference() {
    union() {

      // Extension
      hull() {

        // Forward Extension
        translate([BarrelSleeveLength(),0,0])
        rotate([0,90,0])
        ChamferedCylinder(r1=BarrelRadius()+WallBarrel(), r2=1/16,
                           h=forwardExtension, teardropTop=true);

        // Rear Extension
        translate([BarrelSleeveLength(),0,0])
        rotate([0,-90,0])
        ChamferedCylinder(r1=BarrelSleeveRadius()+WallBarrel(), r2=1/16,
                           h=rearExtension);
      }

      // Bolt cap
      hull() {

        // Forward Extension
        translate([BarrelSleeveLength(),0,0])
        rotate([0,90,0])
        ChamferedCylinder(r1=BarrelRadius(), r2=1/16,
                           h=forwardExtension, teardropTop=true);

        // Rear Extension
        translate([BarrelSleeveLength(),0,0])
        rotate([0,-90,0])
        ChamferedCylinder(r1=BarrelSleeveRadius(), r2=1/16,
                           h=rearExtension);

        // Bolt cap
        translate([BarrelSleeveLength()-2,-(width/2),BarrelRadius()])
        ChamferedCube([rearExtension, width, topExtension], r=1/16);
      }

      // MLOK Slots
      hull() {

          // Forward Extension
          translate([BarrelSleeveLength(),0,0])
          rotate([0,90,0])
          ChamferedCylinder(r1=BarrelRadius(), r2=1/16,
                             h=forwardExtension, teardropTop=true);

          // Rear Extension
          translate([BarrelSleeveLength(),0,0])
          rotate([0,-90,0])
          ChamferedCylinder(r1=BarrelSleeveRadius(), r2=1/16,
                             h=rearExtension);

          // MLOK slot support
          translate([BarrelSleeveLength()-1,-mlokOffset,-0.375])
          ChamferedCube([2, mlokOffset*2, 0.75], r=1/16);
      }

      // Grip Support
      hull() {

          // Forward Extension
          translate([BarrelSleeveLength(),0,0])
          rotate([0,90,0])
          ChamferedCylinder(r1=BarrelRadius(), r2=1/16,
                             h=forwardExtension, teardropTop=true);

          // Rear Extension
          translate([BarrelSleeveLength(),0,0])
          rotate([0,-90,0])
          ChamferedCylinder(r1=BarrelSleeveRadius(), r2=1/16,
                             h=rearExtension);

          // Lower vertical extension
          translate([BarrelSleeveLength()+0.25,0,-BarrelRadius()-lowerExtension])
          ChamferedCylinder(r1=VerticalForegripRadius(), r2=1/16,
                             h=lowerExtension);
      }
    }

    // MLOK slots
    for (M = [0,1]) mirror([0,M,0])
    translate([BarrelSleeveLength()-1+0.25, -mlokOffset, 0])
    rotate([90,0,0]) {
      MlokSlot(1.5);
      MlokSlotBack(1.5);
    }

    TopBreak_Barrel(cutter=true);
    TopBreak_ClusterBolts(cutter=true);
    TopBreak_GripBolt(cutter=true, teardrop=true);
  }
}
module TopBreak_Foregrip(length=TopBreak_ForegripLength(), cutaway=false, alpha=1) {
  color("Tan",alpha) render() Cutaway(cutaway)
  difference() {
    translate([TopBreak_ForegripOffsetX()+ChargerTravel(),0,0])
    rotate([0,90,0])
    PumpGrip(length=length);

    TopBreak_Barrel(cutter=true);
  }
}

// Fixtures
module TopBreak_Fixture_BarrelSleeve() {
  wall = 0.1875;
  guideExtra= 1-wall;
  guideWidth = 0.5;
  width = BarrelSleeveDiameter()+(wall*2);
  holeDepth = (width/2)+guideExtra;


  difference() {

    union() {

      // Tube body
      translate([-(width/2), -(width/2),0])
      ChamferedCube([width, width, BarrelSleeveLength()], r=1/16);

      // Drill/Tap guide
      translate([0, -(guideWidth/2),0])
      ChamferedCube([(width/2)+guideExtra, guideWidth, BarrelSleeveLength()], r=1/16);

      // Fillets
      for (M = [0,1]) mirror([0,M,0])
      translate([(width/2)-ManifoldGap(), (guideWidth/2)-ManifoldGap(), 0.25])
      rotate(-90)
      Fillet(r=1/8, h=BarrelSleeveLength()-0.5);
    }

    ChamferedCircularHole(r1=BarrelSleeveRadius(BARREL_CLEARANCE),
                          r2=1/16,
                          h=BarrelSleeveLength());

    // Stand the barrel up
    rotate([0,-90,0])
    TopBreak_Barrel(cutter=true);

    // Holes
    for (Z = [0.5:0.5:BarrelSleeveLength()-0.5])
    translate([0,0,Z])
    rotate([0,90,0])
    cylinder(r=1/8/2, h=holeDepth);

  }
}

// Assembly
module TopBreak_Assembly(receiverLength=12, pipeAlpha=1, TopBreak_ReceiverFrontAlpha=1, pivotFactor=0, extractFactor=0, chargeFactor=0, lockFactor=0, fcg=_SHOW_FCG, stock=true, tailcap=false, cutaway=undef, hardware=_SHOW_HARDWARE, prints=_SHOW_PRINTS) {

  if (fcg)
  translate([-TopBreak_ReceiverFrontLength(),0,0]) {
    SimpleFireControlAssembly(hardware=hardware, prints=prints, actionRod=false, alpha=_ALPHA_FCG);
  }

  if (prints && _SHOW_RECEIVER_FRONT)
  TopBreak_ReceiverFront(cutaway=cutaway==true,
                         alpha=_ALPHA_RECEIVER_FRONT);

  // Pivoting barrel assembly
  BreakActionPivot(factor=pivotFactor) {

    if (hardware && _SHOW_BARREL)
    TopBreak_Barrel(cutaway=cutaway == true || _CUTAWAY_BARREL);

    if (_SHOW_SIGHTPOST)
    translate([BarrelLength()-1,0,0])
    rotate([0,-90,0]) {
      if (prints)
      Sightpost(radius=BarrelRadius()+BARREL_CLEARANCE);
      
      if (hardware)
      SightpostBolts(radius=BarrelRadius()+BARREL_CLEARANCE);
    }

    // TopBreak_Extractor Spring
    if (hardware && _SHOW_EXTRACTOR_HARDWARE)
    %translate([PivotX()-PivotRadius()-WallPivot(),0,TopBreak_ExtractorZ()+SpringOuterRadius(spring=ExtractorSpringSpec())])
    rotate([0,-90,0])
    Spring(spring=ExtractorSpringSpec(), compressed=true);

    translate([-TopBreak_ExtractorTravel()*extractFactor,0,0]) {

      if (hardware && _SHOW_EXTRACTOR_HARDWARE)
      TopBreak_ExtractorBit();

      if (hardware && _SHOW_EXTRACTOR_HARDWARE)
      TopBreak_ExtractorRetainer();

      if (prints && _SHOW_EXTRACTOR)
      TopBreak_Extractor(cutaway=cutaway == true || _CUTAWAY_EXTRACTOR,
                         alpha=_ALPHA_EXTRACTOR);
    }

    translate([-TopBreak_ExtractorTravel()*extractFactor,0,0]) {

      if (hardware && _SHOW_LATCH_HARDWARE)
      TopBreak_LatchScrews(cutaway=cutaway == true || _CUTAWAY_LATCH);
      
      if (hardware && _SHOW_LATCH_HARDWARE)
      TopBreak_LatchBars(cutaway=cutaway == true || _CUTAWAY_LATCH);

      if (hardware && _SHOW_LATCH_HARDWARE)
      TopBreak_LatchSpring();
      
      if (prints && _SHOW_LATCH)
      TopBreak_LatchTab(cutaway=cutaway == true || _CUTAWAY_LATCH);
    } 

    if (hardware && _SHOW_COLLAR_HARDWARE)
    TopBreak_BarrelCollarBolts();

    if (prints && _SHOW_COLLAR)
    TopBreak_BarrelCollar(cutaway=cutaway == true || _CUTAWAY_COLLAR, alpha=_ALPHA_COLLAR);

    if (hardware && _SHOW_CLUSTER_BOLTS)
    TopBreak_ClusterBolts();

    if (hardware && _SHOW_GRIP_BOLT)
    TopBreak_GripBolt();

    if (prints && _SHOW_CLUSTER)
    TopBreak_Cluster(cutaway=_CUTAWAY_CLUSTER, alpha=_ALPHA_CLUSTER);

    if (prints && _SHOW_FOREGRIP)
    TopBreak_VerticalForegrip();

    children();

  }

  if (prints && _SHOW_FOREND)
  TopBreak_Forend(cutaway=cutaway == true || _CUTAWAY_FOREND, alpha=_ALPHA_FOREND);

}
//

scale(25.4)
if ($preview) {

  TopBreak_Assembly(pivotFactor=Animate(ANIMATION_STEP_UNLOAD)
                                 -Animate(ANIMATION_STEP_LOAD),
                      chargeFactor=Animate(ANIMATION_STEP_CHARGE)
                                 -Animate(ANIMATION_STEP_CHARGER_RESET),
                      lockFactor=Animate(ANIMATION_STEP_UNLOCK)
                                 -Animate(ANIMATION_STEP_LOCK),
                      extractFactor=Animate(ANIMATION_STEP_UNLOAD)
                                 -SubAnimate(ANIMATION_STEP_LOAD, end=0.25));
  
  translate([-TopBreak_ReceiverFrontLength(),0,0])
  if (_SHOW_LOWER) {
    Lower(bolts=false, showLeft=!_CUTAWAY_LOWER, alpha=_ALPHA_LOWER);
    LowerMount(hardware=false, cutaway=_CUTAWAY_LOWER, alpha=_ALPHA_LOWER);
  }

  translate([-TopBreak_ReceiverFrontLength(),0,0]) {
  
    if(_SHOW_TENSION_RODS)
    Receiver_TensionBolts();
    
    if (_SHOW_RECEIVER)
    Frame_ReceiverAssembly(
      length=FRAME_BOLT_LENGTH-0.5,
      cutaway=_CUTAWAY_RECEIVER,
      alpha=_ALPHA_RECEIVER);
  }
  
  if (_SHOW_STOCK)
  translate([-TopBreak_ReceiverFrontLength(),0,0])
  StockAssembly(hardware=false, alpha=_ALPHA_STOCK);
} else {

  echo("Part: ", _RENDER);
  echo("Orientation: ", (_RENDER_PRINT ? "Print" : "Assembly"));

  // *****************
  // * Printed Parts *
  // *****************
  if (_RENDER == "Prints/BarrelCollar")
    if (!_RENDER_PRINT)
      TopBreak_BarrelCollar();
    else
      translate([0,0,PivotX()])
      rotate([0,90,0])
      TopBreak_BarrelCollar();

  if (_RENDER == "Prints/ReceiverFront")
    if (!_RENDER_PRINT)
      TopBreak_ReceiverFront();
    else
      rotate([0,-90,0])
      translate([--TopBreak_ReceiverFrontLength(),0,0])
      TopBreak_ReceiverFront();

  if (_RENDER == "Prints/Forend")
    if (!_RENDER_PRINT)
      TopBreak_Forend(doRender=false);
    else
      rotate([0,90,0])
      translate([-ForendLength(),0,0])
      TopBreak_Forend(doRender=false);

  if (_RENDER == "Prints/Cluster")
    if (!_RENDER_PRINT)
      TopBreak_Cluster();
    else
      rotate([0,90,0])
      translate([-BarrelSleeveLength()-1.5,0,0])
      TopBreak_Cluster();

  if (_RENDER == "Prints/VerticalForegrip")
    if (!_RENDER_PRINT)
      TopBreak_VerticalForegrip();
    else
      mirror([0,0,1])
      translate([-(BarrelSleeveLength()+0.25),0,-(-BarrelRadius()-0.75)])
      TopBreak_VerticalForegrip();

  if (_RENDER  == "Foregrip")
    if (!_RENDER_PRINT)
      TopBreak_Foregrip();
    else
      rotate([0,90,0])
      translate([-TopBreak_ForegripLength(),0,0])
      translate([-(TopBreak_ForegripOffsetX()+ChargerTravel()),0,0])
      TopBreak_Foregrip();

  if (_RENDER == "Prints/Extractor")
    if (!_RENDER_PRINT)
      TopBreak_Extractor();
    else
      translate([0,0,-TopBreak_ExtractorZ()])
      TopBreak_Extractor();

  if (_RENDER == "Prints/Latch")
    if (!_RENDER_PRINT)
      TopBreak_LatchBars();
    else
      translate([0,0,-TopBreak_LatchZ()])
      TopBreak_LatchBars(doMirror=false);

  if (_RENDER == "Prints/LatchTab")
    if (!_RENDER_PRINT)
      TopBreak_LatchTab();
    else
      translate([0,0,-TopBreak_LatchZ()])
      TopBreak_LatchTab();

  if (_RENDER == "Prints/Sightpost")
    if (!_RENDER_PRINT)
      translate([BarrelLength()-1,0,0])
      rotate([0,-90,0])
      Sightpost(radius=BarrelRadius()+BARREL_CLEARANCE);
    else
      //translate([-BARREL_LENGTH+2,0,0])
      Sightpost(radius=BarrelRadius()+BARREL_CLEARANCE);

  // ********************
  // * Fixures and Jigs *
  // ********************
  if (_RENDER == "Fixtures/BarrelSleeveFixture")
    if (!_RENDER_PRINT)
      TopBreak_Fixture_BarrelSleeve();
    else
      TopBreak_Fixture_BarrelSleeve();

  // ************
  // * Hardware *
  // ************
  if (_RENDER == "Hardware/Barrel")
  TopBreak_Barrel();

  if (_RENDER == "Hardware/ExtractorBit")
  TopBreak_ExtractorBit();

  if (_RENDER == "Hardware/ExtractorRetainer")
  TopBreak_ExtractorRetainer();

  if (_RENDER == "Hardware/BarrelCollarBolts")
  TopBreak_BarrelCollarBolts();

  if (_RENDER == "Hardware/ClusterBolts")
  TopBreak_ClusterBolts();

  if (_RENDER == "Hardware/LatchBars")
  TopBreak_LatchBars();

  if (_RENDER == "Hardware/LatchScrews")
  TopBreak_LatchScrews();

  if (_RENDER == "Hardware/SightpostBolts")
  translate([BarrelLength()-1,0,0])
  rotate([0,-90,0])
  SightpostBolts(radius=BarrelRadius());
}
