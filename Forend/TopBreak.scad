include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Cutaway.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Conditionals/RenderIf.scad>;
use <../Meta/Conditionals/MirrorIf.scad>;

use <../Shapes/Bearing Surface.scad>;
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
use <../Receiver/Stock.scad>;use <../Shapes/Bearing Surface.scad>;

/* [Export] */

// Select a part, Render it (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Prints/ReceiverFront", "Prints/Forend", "Prints/Cluster", "Prints/BarrelCollar", "Prints/Extractor", "Prints/LatchTab", "Prints/Foregrip", "Prints/VerticalForegrip", "Prints/Sightpost","Fixtures/Trunnion", "Fixtures/ExtractorGang_Bottom", "Fixtures/ExtractorGang_Top"]

// Reorient the part for printing?
_RENDER_PRINT = true;

/* [Assembly] */
_SHOW_PRINTS = true;
_SHOW_HARDWARE = true;
_SHOW_RECEIVER = true;
_SHOW_RECEIVER_HARDWARE = false;
_SHOW_STOCK = true;
_SHOW_STOCK_HARDWARE = false;
_SHOW_FCG = false;
_SHOW_FCG_HARDWARE = false;
_SHOW_LOWER = true;
_SHOW_LOWER_HARDWARE = true;
_SHOW_TENSION_RODS = false;

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
_SHOW_VERTICAL_GRIP = true;
_SHOW_GRIP_HARDWARE=true;
_SHOW_SIGHTPOST = true;
_SHOW_HANDGUARD_BOLTS = true;

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
_ALPHA_SIGHTPOST = 1; // [0:0.1:1]
_ALPHA_FOREGRIP = 1; // [0:0.1:1]
_ALPHA_VERTICAL_FOREGRIP = 1; // [0:0.1:1]

/* [Cutaway] */
_CUTAWAY_RECEIVER = false;
_CUTAWAY_LOWER = false;
_CUTAWAY_BARREL = false;
_CUTAWAY_FOREND = false;
_CUTAWAY_COLLAR = false;
_CUTAWAY_CLUSTER = false;
_CUTAWAY_EXTRACTOR = false;
_CUTAWAY_LATCH = false;
_CUTAWAY_SIGHTPOST = false;

/* [Vitamins] */
GP_BOLT = "#8-32"; // ["M4", "#8-32"]
GP_BOLT_CLEARANCE = 0.015;

BARREL_COLLAR_BOLT  = "#8-32"; // ["M4", "#8-32"]
BARREL_COLLAR_BOLT_NUT = "none"; // ["none", "heatset"]
BARREL_COLLAR_BOLT_CLEARANCE = 0.015;

BARREL_SET_SCREW = "#8-32"; // ["M4", "#8-32"]
BARREL_SET_SCREW_CLEARANCE = -0.05;

CLUSTER_BOLT = "#8-32"; // ["M4", "#8-32"]
CLUSTER_BOLT_CLEARANCE = 0.015;
CLUSTER_BOLT_HEAD = "flat"; // ["flat", "socket"]
CLUSTER_BOLT_NUT = "none"; // ["none", "heatset"]

FOREND_BOLT = "#8-32"; // ["M4", "#8-32"]
FOREND_BOLT_CLEARANCE = -0.05;

HANDGUARD_BOLT = "#8-32"; // ["#8-32", "M4"]
HANDGUARD_BOLT_CLEARANCE = -0.05;

GRIP_BOLT = "1/4\"-20"; // ["M6", "1/4\"-20"]
GRIP_BOLT_CLEARANCE = -0.05;

EXTRACTOR_RETAINER_LENGTH = 0.7501;
EXTRACTOR_RETAINER_DIAMETER = 0.2501;
EXTRACTOR_RETAINER_CLEARANCE = 0.008;

EXTRACTOR_EXTRA_OFFSET = 0;

LATCH_WIDTH = 0.25;
LATCH_CLEARANCE = 0.006;

BARREL_SLEEVE_DIAMETER = 1.2501;
BARREL_OUTSIDE_DIAMETER = 1.0001;
BARREL_INSIDE_DIAMETER = 0.8131;
BARREL_CLEARANCE = 0.008;
BARREL_LENGTH = 19;
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
LATCH_TAB_GAP = 0.0625;
FOREGRIP_RADIUS = 1.0001;

FOREND_BOLT_OFFSET_Y = -0.12501;
FOREND_BOLT_ANGLE_Y = 0;
FOREND_BOLT_ANGLE_Z = -5;

/* [Branding] */
BRANDING_MODEL_NAME = "CAFE";

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();
//$t = AnimationDebug(ANIMATION_STEP_EXTRACT, start=0.5);


// Settings: Vitamins
function GripBolt() = BoltSpec(GRIP_BOLT);
assert(GripBolt(), "GripBolt() is undefined. Unknown GRIP_BOLT?");

function GPBolt() = BoltSpec(GP_BOLT);
assert(GPBolt(), "GPBolt() is undefined. Unknown GP_BOLT?");

function BarrelCollarBolt() = BoltSpec(BARREL_COLLAR_BOLT);
assert(BarrelCollarBolt(), "BarrelCollarBolt() is undefined. Unknown BARREL_COLLAR_BOLT?");

function ForendBolt() = BoltSpec(FOREND_BOLT);
assert(ForendBolt(), "ForendBolt() is undefined. Unknown FOREND_BOLT?");

function HandguardBolt() = BoltSpec(HANDGUARD_BOLT);
assert(HandguardBolt(), "HandguardBolt() is undefined. Unknown HANDGUARD_BOLT?");

function ClusterBolt() = BoltSpec(CLUSTER_BOLT);
assert(ClusterBolt(), "ClusterBolt() is undefined. Unknown CLUSTER_BOLT?");

function TrunnionRadius(clearance=0)
    = TrunnionDiameter(clearance*2)/2;

function TrunnionDiameter(clearance=0)
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
function TrunnionWall() = (TrunnionDiameter() - BarrelDiameter())/2;

// Measured: Vitamins
function TopBreak_FrameBoltLength() = FRAME_BOLT_LENGTH;
function TopBreak_ExtractorRetainerRadius() = EXTRACTOR_RETAINER_DIAMETER/2;

function TopBreak_LatchLength() = Inches(3);
function TopBreak_LatchWidth() = LATCH_WIDTH;
function TopBreak_LatchHeight() = LATCH_WIDTH;

function TopBreak_LatchScrewLength() = 1;
function TopBreak_LatchTabHeight() = 0.625;


// Settings: Dimensions
function BarrelZ() = BARREL_Z; // -0.11 for .22LR rimfire
function BarrelLength() = BARREL_LENGTH;
function TrunnionLength() = 8;
function WallBarrel() = WALL_BARREL;
function ClusterForwardExtension() = Inches(1);
function ClusterMaxX() = TrunnionLength()+ClusterForwardExtension();
function SightpostPinRadius() = Millimeters(2.5)/2;
function TopBreak_MinRadius() = max(1.325/2, TrunnionRadius()); // Enable cross-compatibility by setting a size floor.

function TopBreak_LatchExtension() = 0.25;
function TopBreak_LatchTabGap() = Inches(0.0625);

// Calculated: Positions
function WallPivot() = 0.25;
function PivotAngleBack() = -25;
function PivotAngle() = PIVOT_ANGLE;
function PivotX() = PIVOT_X;
function PivotZ() = BarrelZ()-TopBreak_MinRadius(); // Use 1" sch40 as the floor and everything smaller can use the same forend. Anything bigger will need a custom forend.
function PivotWidth() = PIVOT_WIDTH;
function PivotRadius() = PIVOT_RADIUS;
function PivotDiameter() = PivotRadius()*2;
function PivotClearance() = 0.01;
function PivotOuterRadius() = abs(PivotZ())+FrameBoltZ();

function TopBreak_ReceiverFrontLength() = 0.5;
function FrameBackLength() = 0.75+0.5;
function ForendLength() = FrameExtension(length=TopBreak_FrameBoltLength())
                        - 0.375
                        -TopBreak_ReceiverFrontLength();

function ChargerTravel() = 1.75;

// Calculated: Lengths
function TopBreak_ForegripOffsetX() = 6+ChargerTravel();
function TopBreak_ForegripLength() = 4.625;
function TopBreak_ForegripMlokOffset() = (TrunnionRadius()+Inches(0.4375));
function TopBreak_ForegripMlokOffsetZ() = Inches(0.375);
function TopBreak_ForendBoltY() = FrameBoltY();
function TopBreak_HandguardBoltOffsetY() = TrunnionRadius()+0.1875;
function ClusterRearLength() = Inches(2);

// Calculated: Springs
function ExtractorSpringSpec() = [
  ["SpringSpec", "Extractor Spring"],

  ["SpringOuterDiameter", Inches(0.625)],
  ["SpringPitch", Inches(0.35)],

  ["SpringFreeLength", Inches(3.5)],
  ["SpringSolidHeight", Inches(1.75)],

  ["SpringWireDiameter", Inches(0.055)]
];
function LatchSpringSpec() = [
  ["SpringSpec", "Latch Spring"],

  ["SpringOuterDiameter", Inches(0.25)],
  ["SpringPitch", Inches(0.115)],

  ["SpringFreeLength", Inches(1)],
  ["SpringSolidHeight", Inches(0.375)],

  ["SpringWireDiameter", Inches(0.02)]
];

// Calculated: Positions
//function ActionRodZ() = FrameBoltZ()-WallFrameBolt()-(ActionRodWidth()/2);
function BarrelOffsetZ() = 0; // -0.11 for .22LR rimfire

function TopBreak_ExtractorAngle() = 155;
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

function TopBreak_ExtractorCutDepth() = (1/8);

function TopBreak_ExtractorBitZ() = BarrelZ()
                                  - BarrelInsideRadius()
                                  + 0.03;

function TopBreak_ExtractorZ() = BarrelZ()
                               - TrunnionRadius()
                               - TopBreak_ExtractorHeight()
                               - max(TopBreak_ExtractorWall(),0.1875)
                               - EXTRACTOR_EXTRA_OFFSET;

function TopBreak_ExtractorHousingWidth() = TopBreak_ExtractorWidth()
                                          + (TopBreak_ExtractorWall()*2);
function TopBreak_BarrelCollarBottomZ() = TopBreak_ExtractorZ()
                                        - TopBreak_ExtractorWallBottom();

function TopBreak_LatchTravel() = 0.5;
function TopBreak_LatchWall() = 0.125;

function TopBreak_LatchTabGap() = LATCH_TAB_GAP;


function TopBreak_LatchZ() = -1.625;
function TopBreak_LatchY() = (TopBreak_ExtractorHousingWidth()/2)
                           + (TopBreak_LatchWidth()/2);

function TopBreak_SightpostX() = ClusterMaxX()+PumpGripLength();
function TopBreak_VerticalForegripRadius() = 0.625;
function TopBreak_VerticalForegripX() = TrunnionLength()+Inches(0.25);

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
  rotate([0,TopBreak_ExtractorAngle(),0])
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

module TopBreak_ExtractorRetainer(radius=TopBreak_ExtractorRetainerRadius(), cutaway=false, cutter=false, teardrop=false, clearance=EXTRACTOR_RETAINER_CLEARANCE) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  // Secure the TopBreak_Latch block to the TopBreak_Latch rod
  color("Silver") RenderIf(!cutter)
  translate([TopBreak_ExtractorWidth()+TopBreak_ExtractorTravel()+0.5,
             0,
             -TrunnionRadius()-EXTRACTOR_RETAINER_LENGTH-clear2])
  cylinder(r=radius+clear, h=EXTRACTOR_RETAINER_LENGTH+clear2+(cutter?BarrelRadius():0));
}

module TopBreak_ExtractorSpring() {
  color("Silver") render()
  translate([PivotX()-PivotRadius()-WallPivot(),0,TopBreak_ExtractorZ()+SpringOuterRadius(spring=ExtractorSpringSpec())])
  rotate([0,-90,0])
  Spring(spring=ExtractorSpringSpec(), compressed=true);
}

module TopBreak_LatchBars(doMirror=true, cutaway=false, cutter=false, clearance=LATCH_CLEARANCE, alpha=1) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  // Latch
  color("Silver", alpha) RenderIf(!cutter) Cutaway(cutaway)
  MirrorIf(doMirror, [0,1,0], true)
  difference() {

    // Latch Body
    translate([-0.25+(cutter?-0.5:0)-clear,
               TopBreak_LatchY()-(TopBreak_LatchWidth()/2)-clear,
               TopBreak_LatchZ()-clear])
    cube([TopBreak_LatchLength()+(cutter?+0.5+TopBreak_LatchTravel()+0.5+clear:0),
          TopBreak_LatchWidth()+clear2,
          TopBreak_LatchHeight()+clear2]);

    if (!cutter)
    translate([0,0,0.1])
    TopBreak_LatchScrews(cutter=true, clearance=-0.02);
  }
}

module TopBreak_LatchSpring(compress=0, doMirror=true, cutter=false, clearance=0.015, alpha=1) {
  clear = cutter?clearance:0;

  color("Silver", alpha) RenderIf(!cutter)
  MirrorIf(doMirror, [0,1,0], both=true)
  translate([-0.25+TopBreak_LatchLength()+SpringFreeLength(LatchSpringSpec())+clear, TopBreak_LatchY(), TopBreak_LatchZ()+(TopBreak_LatchHeight()/2)])
  rotate([0,-90,0])
  Spring(spring=LatchSpringSpec(), compressed=false, custom_compression_ratio=-1, cutter=cutter);
}

module TopBreak_LatchScrews(head="flat", doMirror=true, cutaway=false, cutter=false, clearance=0.01) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  // Secure the TopBreak_Latch block to the TopBreak_Latch rod
  color("Silver") RenderIf(!cutter)
  MirrorIf(doMirror, [0,1,0], both=true)
  translate([0.75,TopBreak_LatchY(),TopBreak_LatchZ()-TopBreak_LatchWall()-TopBreak_LatchTabHeight()-TopBreak_LatchTabGap()])
  rotate([0,180,0])
  Bolt(bolt=GPBolt(),
       length=TopBreak_LatchScrewLength()+ManifoldGap(), clearance=clear,
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

      // Trunnion
      if (sleeve)
      rotate([0,90,0])
      cylinder(r=TrunnionRadius()+clear, h=TrunnionLength()+(1/16)+clear);
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
      cube([TrunnionDiameter(), TrunnionRadius(), TopBreak_ExtractorBitWidth()]);
    }
  }
}

module TopBreak_BarrelCollarBolts(headType="flat", nutType=BARREL_COLLAR_BOLT_NUT, length=0.5, cutter=false, clearance=0.005, teardrop=false) {

  // Top Bolts
  for (X = [0.5,1.5,2.5])
  translate([X,0,BarrelRadius()])
  NutAndBolt(bolt=BarrelCollarBolt(),
             boltLength=length+ManifoldGap(2),
             head="socket", capHeightExtra=(cutter?1:0),
             nut=nutType, nutHeightExtra=(cutter?BarrelRadius():0),
             teardrop=false, teardropAngle=180,
             clearance=cutter?clearance:0, doRender=!cutter);
}

module TopBreak_ForendBolts(headType="flat", nutType="none", length=Inches(3), cutter=false, clearance=0.005, teardrop=false) {
  theAngles = [0,90+25,FOREND_BOLT_ANGLE_Z];
  theOffsets = [0,FOREND_BOLT_OFFSET_Y,-0.125];

  for (Y = [1,0]) mirror([0,Y,0])
  translate([PivotX()+PivotRadius(),(TopBreak_ForendBoltY()+theOffsets.y),PivotZ()+theOffsets.z])
  rotate(theAngles.z)
  rotate([0,theAngles.y,0])
  NutAndBolt(bolt=ForendBolt(),
             boltLength=length+ManifoldGap(2),
             head=headType, capHeightExtra=(cutter?1:0),
             nut=nutType, nutHeightExtra=(cutter?BarrelRadius():0),
             teardrop=false, teardropAngle=180, capOrientation=true,
             clearance=cutter?clearance:0, doRender=!cutter);
}

module TopBreak_ClusterBolts(bolt=ClusterBolt(), headType=CLUSTER_BOLT_HEAD, nutType=CLUSTER_BOLT_NUT, length=0.5, cutter=false, clearance=0.005, teardrop=false) {
  color("Silver") RenderIf(!cutter)
  for (X = [-0.5,-1.5])
  translate([TrunnionLength()+X,0,BarrelRadius()])
  NutAndBolt(bolt=bolt,
             boltLength=length+ManifoldGap(2),
             head=headType, capHeightExtra=(cutter?BarrelRadius():0),
             nut=nutType, nutHeightExtra=(cutter?BarrelRadius():0),
             teardrop=cutter, teardropAngle=180,
             clearance=cutter?clearance:0,
             doRender=!cutter);
}

module TopBreak_HandguardBolts(headType="flat", nutType="heatset", length=11.75, cutter=false, clearance=0.005, teardrop=false) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  for (Y = [1,-1])
  translate([TrunnionLength()-ClusterRearLength()+length,Y*TopBreak_HandguardBoltOffsetY(),0])
  rotate([0,90,0])
  NutAndBolt(bolt=HandguardBolt(),
             boltLength=length+ManifoldGap(2),
             head="hex", capHeightExtra=(cutter?1:0),
             nut=nutType, nutHeightExtra=(cutter?BarrelRadius():0),
             teardrop=false, teardropAngle=180, capOrientation=true,
             clearance=cutter?clearance:0, doRender=!cutter);
}

module TopBreak_GripBolt(bolt=GripBolt(), headType="flat", nutType="heatset", length=3.5, cutter=false, clearance=0.005, teardrop=true) {
  translate([TopBreak_VerticalForegripX(),0,-BarrelRadius()-length])
  mirror([0,0,1])
  NutAndBolt(bolt=bolt, boltLength=length+ManifoldGap(2),
             capOrientation=true,
             head=headType, capHeightExtra=(cutter?1:0),
             nut=nutType, nutHeightExtra=(cutter?0.5:0),
             teardrop=cutter && teardrop, teardropAngle=180,
             clearance=cutter?clearance:0,
             doRender=!cutter);
}

module TopBreak_GripPin(r=SightpostPinRadius(), length=Inches(0.5), cutter=false, clearance=0.005, teardrop=true) {
  clear = cutter ? clearance : 0;

  color("Silver") RenderIf(!cutter)
  translate([TopBreak_VerticalForegripX()+Inches(0.375),0,-BarrelRadius()-length])
  mirror([0,0,1])
  cylinder(r=r+clear, h=length);
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
    hull() {

      // Pivot support
      translate([PivotX(), 0, PivotZ()])
      rotate([90,0,0])
      ChamferedCylinder(r1=PivotRadius()-0.01, r2=1/4, h=3,
                        teardropTop=false, teardropBottom=false, center=true);

      // Front face
      translate([ForendLength(), 0,0])
      mirror([1,0,0])
      Frame_Support(length=1/8,
                   extraBottom=FrameBottomZ()+(TrunnionRadius()*(sqrt(2)/2)),
                   chamferFront=true, teardropFront=true);

      // Extended section
      translate([ForendLength(), 0,0])
      mirror([1,0,0])
      Frame_Support(length=ForendLength(),
                    chamferFront=true, teardropFront=true);
    }

    // Cutout the pivot track for the barrel collar to pass
    translate([PivotX(), 0, PivotZ()])
    rotate([0,180,0]) rotate([90,0,0])
    linear_extrude(TrunnionDiameter()+(WallBarrel()*2)+(clearance*2), center=true)
    semidonut(major=PivotX()*3, minor=abs(PivotZ())*2, angle=PivotAngle());

    // Cut a path through the full range of motion (Barrel)
    for (flip = [1,-1])
    hull() for (A = [0, PivotAngle()])
    Pivot(pivotX=PivotX(), pivotZ=PivotZ(), angle=A, factor=1)
    translate([PivotX(),0,0])
    rotate([0,90*flip,0])
    cylinder(r=TopBreak_MinRadius()+BARREL_CLEARANCE,
             h=ForendLength()-PivotX());

    // Cut a path through the full range of motion (Collar)
    for (A = [0, PivotAngle(), PivotAngle()/2, PivotAngleBack(), PivotAngleBack()/2])
    Pivot(pivotX=PivotX(), pivotZ=PivotZ(), angle=A, factor=1)
    TopBreak_BarrelCollar(rearExtension=2, cutter=true);

    // Printability chamfer
    translate([ForendLength(),0,BarrelZ()])
    rotate([0,-90,0])
    HoleChamfer(r1=TrunnionRadius(BARREL_CLEARANCE), r2=1/16,
                teardrop=true);

    Frame_Bolts(cutter=true);

    TopBreak_ForendBolts(cutter=true);
  }
}

module TopBreak_BarrelCollar(rearExtension=0, cutter=false, clearance=0.005, cutaway=false, alpha=1) {
  clear = cutter?clearance:0;
  clear2 = clear*2;
  clearRear = 1/16;
  CR = 1/16;

  color("Chocolate", alpha) RenderIf(!cutter) Cutaway(cutaway)
  difference() {
    union() {
      PivotOuterBearing(cutter=cutter);

      PivotClearanceCut(cut=!cutter,
                        width=(TopBreak_MinRadius()+WallBarrel())*2) {

        hull() {

          // Around the trunnion
          translate([clearRear-rearExtension,0,BarrelZ()])
          rotate([0,90,0])
          ChamferedCylinder(r1=TopBreak_MinRadius()+WallBarrel()+clear,
                            h=PivotX()-clearRear+rearExtension,
                            teardropTop=true,
                            r2=1/16);

          // Trunnion bolt support
          translate([clearRear,-0.375,0])
          ChamferedCube([3,0.75, TopBreak_MinRadius()+0.5],
                         r=1/16,teardropFlip=[true,true,true]);
        }

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
                   -((TopBreak_MinRadius()+WallBarrel()))-clear,
                   TopBreak_LatchZ()-TopBreak_LatchWall()-clear])
        ChamferedCube([PivotX()-(sqrt(2)/2*PivotRadius())-clearRear+rearExtension+clear2,
                       (TopBreak_MinRadius()+WallBarrel())*2+clear2,
                       abs(TopBreak_LatchZ())+TopBreak_LatchWall()+CR+clear2], r=1/16, teardropFlip=[false,true,true]);
      }
    }

    PivotInnerBearing(cutter=true, clearance=(cutter?0:clearance));

    if (!cutter) {

      TopBreak_LatchBars(cutter=true);
      TopBreak_LatchTab(cutter=true);

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

      // Extractor retainer travel
      hull()
      for (X = [0,-TopBreak_ExtractorTravel()])
      translate([X,0,0])
      TopBreak_ExtractorRetainer(cutter=true, teardrop=true);

      // Extractor retainer removal punch hole
      translate([0,0,-0.5])
      TopBreak_ExtractorRetainer(radius=Millimeters(2), cutter=true);

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

      // Extractor retainer removal punch hole
      translate([0,0,-0.5])
      TopBreak_ExtractorRetainer(radius=Millimeters(2), cutter=true);

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

  gap = 1/16;
  width = (TopBreak_MinRadius()+WallBarrel())*2;
  bottomZ = TopBreak_LatchZ()-TopBreak_LatchWall()-TopBreak_LatchTabHeight()-TopBreak_LatchTabGap();
  height = abs(bottomZ) - abs(TopBreak_BarrelCollarBottomZ()) - gap; // abs(TopBreak_BarrelCollarBottomZ())+clearance
  towerHeight = abs(bottomZ) - abs(TopBreak_LatchZ()) + (cutter?clearCR/2:0); //(TopBreak_LatchWall()+TopBreak_LatchTabHeight()+0.06)

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
                 bottomZ])
      ChamferedCube([1+(cutter?TopBreak_LatchTravel():0),
                     TopBreak_LatchWidth()+clear2,
                     towerHeight+clear],
                     r=1/16);
    }

    // Cut off the sharp tip, it tends to catch on things
    if (!cutter)
    translate([-0.3125,0, TopBreak_LatchZ()-TopBreak_LatchWall()-clearance])
    rotate([90,0,0])
    linear_extrude((TopBreak_MinRadius()+WallBarrel()+ManifoldGap())*2, center=true) {
      RoundedBoolean(r=0.0625, teardrop=false, angle=180);

      translate([-0.1875,-1])
      square([0.1875, 1]);
    }

    if (!cutter)
    TopBreak_LatchScrews(cutter=true);
  }
}

module TopBreak_VerticalForegrip(cutaway=false, alpha=1) {
  CR = 1/16;

  color("Tan", alpha) render()
  difference() {
    translate([TrunnionLength()+0.25,0,-BarrelRadius()-0.75])
    mirror([0,0,1])
    rotate(360/6/2)
    PumpGrip(r=TopBreak_VerticalForegripRadius(), h=3, channelRadius=0.125);

    TopBreak_GripBolt(cutter=true, teardrop=false);
    TopBreak_GripPin(cutter=true, teardrop=false);
  }
}

module TopBreak_Cluster(cutaway=false, alpha=1) {
  topExtension = Inches(0.5);
  lowerExtension = Inches(0.75);
  width = Inches(7/16);
  mlokOffset = TopBreak_ForegripMlokOffset();
  length = ClusterRearLength()+ClusterForwardExtension();
  clusterMinX = TrunnionLength()-ClusterRearLength();
  CR = Inches(1/16);

  color("Tan", alpha) render() Cutaway(cutaway)
  difference() {
    union() {

      // Extension
      hull() {

        // Forward Extension
        translate([TrunnionLength(),0,0])
        rotate([0,90,0])
        ChamferedCylinder(r1=BarrelRadius()+WallBarrel(), r2=CR,
                           h=ClusterForwardExtension(), teardropTop=true);

        // Rear Extension
        translate([TrunnionLength(),0,0])
        rotate([0,-90,0])
        ChamferedCylinder(r1=TrunnionRadius()+WallBarrel(), r2=CR,
                           h=ClusterRearLength());
      }

      // Index pin support
      for (R = [0,180]) rotate([R,0,0])
      translate([TrunnionLength(),BarrelRadius()+WallBarrel(),0])
      rotate([0,90,0])
      ChamferedCylinder(r1=SightpostPinRadius()+Inches(0.125), r2=CR, h=ClusterForwardExtension(),
                        teardropTop=true);

      // Top bolt support
      hull() {

        // Forward Extension
        translate([TrunnionLength(),0,0])
        rotate([0,90,0])
        ChamferedCylinder(r1=BarrelRadius(), r2=CR,
                           h=ClusterForwardExtension(), teardropTop=true);

        // Rear Extension
        translate([TrunnionLength(),0,0])
        rotate([0,-90,0])
        ChamferedCylinder(r1=TrunnionRadius(), r2=CR,
                           h=ClusterRearLength());

        // Flat block on top
        translate([TrunnionLength()-ClusterRearLength(),-(width/2),BarrelRadius()])
        ChamferedCube([ClusterRearLength(), width, topExtension], r=CR);
      }

      // MLOK Slot Support
      hull() {

          // Side Bolt support
          for (Y = [1,-1])
          translate([clusterMinX,Y*TopBreak_HandguardBoltOffsetY(),0])
          rotate([0,90,0])
          ChamferedCylinder(r1=0.25, r2=CR,
                   h=length, teardropTop=true);

          // MLOK slot support
          for (M = [0,1]) mirror([0,M,0])
          translate([clusterMinX,-mlokOffset,TopBreak_ForegripMlokOffsetZ()-0.375])
          ChamferedCube([length, mlokOffset, 0.75],
                        r=CR, teardropFlip=[true,true,true]);

      }

      // Vertical foregrip support
      hull() {

          // Forward Extension
          translate([TrunnionLength(),0,0])
          rotate([0,90,0])
          ChamferedCylinder(r1=BarrelRadius()+WallBarrel(), r2=CR,
                             h=ClusterForwardExtension(), teardropTop=true);

          // Rear Extension
          translate([TrunnionLength(),0,0])
          rotate([0,-90,0])
          ChamferedCylinder(r1=TrunnionRadius(), r2=CR,
                             h=ClusterRearLength());

          // Lower vertical extension
          translate([TrunnionLength()+0.25,0,-BarrelRadius()-lowerExtension])
          ChamferedCylinder(r1=TopBreak_VerticalForegripRadius()+CR, r2=CR,
                             h=CR*2);

          // Flat front for lower extension (printability)
          translate([TrunnionLength()+ClusterForwardExtension(),-(TopBreak_VerticalForegripRadius()+CR)*(0.705/2),-BarrelRadius()-lowerExtension])
          mirror([1,0,0])
          ChamferedCube([0.25, (TopBreak_VerticalForegripRadius()+CR)*0.705, lowerExtension], r=0.125,
                        teardropFlip=[false,true,true]);
      }
    }

    // Bearing surface
    translate([clusterMinX,0,0])
    rotate([0,90,0])
    rotate(360/6/2)
    BearingSurface(r=BarrelRadius()+BARREL_CLEARANCE,
                   length=length, center=false,
                   depth=0.03125, segments=6, taperDepth=0.03125);

    // MLOK slots
    for (M = [0,1]) mirror([0,M,0])
    translate([clusterMinX+0.25, -mlokOffset, TopBreak_ForegripMlokOffsetZ()])
    rotate([90,0,0]) {
      MlokSlot(length-0.5);
      MlokSlotBack(length-0.5);
    }

    TopBreak_Barrel(cutter=true);
    TopBreak_ClusterBolts(cutter=true);
    TopBreak_HandguardBolts(cutter=true);
    TopBreak_GripBolt(cutter=true, teardrop=true);
    TopBreak_GripPin(cutter=true, teardrop=true);
  }
}

module TopBreak_Foregrip(length=PumpGripLength(), cutaway=false, alpha=1) {
  color("Tan", alpha) render() Cutaway(cutaway)
  difference() {
    union() {

      // Body around the barrel
      translate([ClusterMaxX(),0,0])
      rotate([0,90,0])
      PumpGrip(r=FOREGRIP_RADIUS, h=length);

      hull() {

        // MLOK slot support
        for (M = [0,1]) mirror([0,M,0])
        translate([ClusterMaxX(),-TopBreak_ForegripMlokOffset(),TopBreak_ForegripMlokOffsetZ()-0.375])
        ChamferedCube([length, TopBreak_ForegripMlokOffset(), Inches(0.75)],
                      r=CR());

        // Side Bolt support
        for (Y = [1,-1])
        translate([ClusterMaxX(),Y*TopBreak_HandguardBoltOffsetY(),0])
        rotate([0,90,0])
        ChamferedCylinder(r1=0.25, r2=CR(),
                 h=length, teardropTop=true);
       }
    }

    translate([ClusterMaxX(),0,0])
    rotate([0,90,0])
    rotate(360/6/2)
    BearingSurface(r=BarrelRadius()+BARREL_CLEARANCE,
                   length=length, center=false,
                   depth=0.03125, segments=6, taperDepth=0.03125);

    TopBreak_HandguardBolts(cutter=true);

    // MLOK slots
    for (M = [0,1]) mirror([0,M,0])
    translate([ClusterMaxX()+0.25, -TopBreak_ForegripMlokOffset(), TopBreak_ForegripMlokOffsetZ()])
    rotate([90,0,0]) {
      MlokSlot(length-0.5);
      MlokSlotBack(length-0.5);
    }
  }
}

module TopBreak_Sightpost(alpha=_ALPHA_SIGHTPOST, cutaway=_CUTAWAY_SIGHTPOST) {
  CR = Inches(1/16);
  mlokOffset = TopBreak_ForegripMlokOffset();

  color("Tan", alpha) render() Cutaway(cutaway)
  difference() {
    union() {

      // Sightpost
      translate([TopBreak_SightpostX()+SightpostLength(),0,0])
      rotate([0,-90,0])
      Sightpost(radius=BarrelRadius()) {

        // Around barrel
        ChamferedCylinder(r1=BarrelRadius(), r2=CR,
                           h=SightpostLength(), teardropTop=true);

        // Side MLOK Slots
        hull() {

            // MLOK slot support
            for (M = [0,1]) mirror([0,M,0])
            translate([TopBreak_ForegripMlokOffsetZ()-0.375,0,0])
            ChamferedCube([Inches(0.75), mlokOffset, SightpostLength()], r=CR);

            // Side Bolt support
            for (Y = [1,-1])
            translate([0,Y*TopBreak_HandguardBoltOffsetY(),0])
            ChamferedCylinder(r1=0.25, r2=CR,
                     h=SightpostLength(), teardropTop=true);
        }

        // Bottom MLOK Slot
        hull() {

            // Around barrel
            ChamferedCylinder(r1=BarrelRadius(), r2=CR,
                               h=SightpostLength(), teardropTop=true);

            // MLOK slot support
            translate([-BarrelRadius(),-Inches(0.375),0])
            mirror([1,0,0])
            ChamferedCube([Inches(0.5), Inches(0.75), SightpostLength()], r=CR);
        }
      }
    }

    // Side MLOK slots
    for (M = [0,1]) mirror([0,M,0])
    translate([TopBreak_SightpostX()+Inches(0.25), -mlokOffset, TopBreak_ForegripMlokOffsetZ()])
    rotate([90,0,0]) {
      MlokSlot(SightpostLength()-Inches(0.5));
      MlokSlotBack(SightpostLength()-Inches(0.5));
    }

    // Bottom mlok slot
    translate([TopBreak_SightpostX()+Inches(0.25), 0, -mlokOffset])
    rotate([180,0,0]) {
      MlokSlot(SightpostLength()-Inches(0.5));
      MlokSlotBack(SightpostLength()-Inches(0.5));
    }

    // Bearing surface
    translate([TopBreak_SightpostX(),0,0])
    rotate([0,90,0])
    BearingSurface(r=BarrelRadius()+BARREL_CLEARANCE,
                   length=SightpostLength(), center=false,
                   depth=0.03125, segments=6, taperDepth=0.03125);

    TopBreak_Barrel(cutter=true);
    TopBreak_HandguardBolts(cutter=true);
  }
}

// Fixtures
module TopBreak_Fixture_Trunnion() {
  wall = 0.125;
  guideExtra=0.25;
  guideWidth = 0.375;
  flatWidth = 3/4;
  width = TrunnionDiameter()+(wall*2);
  holeDepth = (width/2)+guideExtra;

  difference() {

    // Tube body
    union() {
      ChamferedCylinder(r1=TrunnionRadius()+wall, r2=CR(), h=TrunnionLength());

      // Top Guide
      translate([-(width/2), -(guideWidth/2),0])
      ChamferedCube([width+guideExtra, guideWidth, TrunnionLength()], r=CR());

      // Bottom Flat
      translate([-(width/2), -(flatWidth/2),0])
      ChamferedCube([width/2, flatWidth, TrunnionLength()], r=CR());

      // Side flats
      translate([-(flatWidth/2),-(width/2), 0])
      ChamferedCube([flatWidth, width, TrunnionLength()], r=CR());
    }

    // Main trunnion hole
    ChamferedCircularHole(r1=TrunnionRadius(BARREL_CLEARANCE),
                          r2=1/16,
                          h=TrunnionLength());

    // Holes
    for (Z = [0.5:0.5:TrunnionLength()-0.5])
    translate([0,0,Z])
    rotate([0,90,0])
    cylinder(r=1/8/2, h=holeDepth);

  }
}

module TopBreak_Fixture_Extractor(top=false, bottom=false, clearance=Inches(0.003)) {
  clear = clearance;
  clear2 = clearance*2;

  base = 0.25;
  height=0.75;
  topHeight=0.5;
  width = 1;
  length = 4;
  mountingBlockX = abs(TopBreak_ExtractorBitZ())+0.125;
  offsetY = -width/2;
  offsetZ = 0.5;
  bitWidth = (TopBreak_ExtractorBitWidth()/cos(30));
  gangAngle = 45;

  module TSlotBolts(cutter=false) {
    for (R = [0,90]) rotate(R)
    for (X = [0,3]) translate([-1.5+X,0,base+0.01])
    NutAndBolt(bolt=BoltSpec(GP_BOLT), boltLength=1, capOrientation=true,
               head="flat");
  }

  module Bolts(cutter=false) {
    for (R = [0:gangAngle:360]) rotate((R*gangAngle)+(gangAngle/2))
    translate([abs(TopBreak_ExtractorBitZ())+0.125+0.5,0,0.01])
    NutAndBolt(bolt=BoltSpec(GP_BOLT), boltLength=1,
               head="flat", nut="heatset-long",
               nutHeightExtra=(cutter?1:0),
               clearance=(cutter?clear2:0));
  }

  module Bits(cutter=false) {
    for (R = [0:gangAngle:360]) rotate(R)
    translate([0,0,base+offsetZ])
    rotate(180)
    rotate([0,90,0])
    TopBreak_ExtractorBit(cutter=cutter);
  };

  %Bits();
  %Bolts();
  %TSlotBolts();

  // Top plate
  if (top)
  color("Tan") render()
  difference() {
    union() {

      // Mounting block
      hull()
      for (R = [0:gangAngle:360]) rotate(R)
      translate([mountingBlockX+0.25,offsetY,(base+offsetZ-0.25)])
      ChamferedCube([0.5, width, topHeight], r=1/16);

      // Clamping tab
      for (R = [0:gangAngle:360]) rotate(R)
      translate([mountingBlockX+0.25,-(1/8/2),base])
      ChamferedCube([0.5, (1/8), topHeight], r=1/32);
    }

    Bolts(cutter=true);

    // Extractor bit
    for (R = [0:gangAngle:360]) rotate(R)
    translate([0,0,base+offsetZ-clearance])
    rotate(180)
    rotate([0,90,0]) {

      TopBreak_ExtractorBit(cutter=true, clearance=0.001);

      // Flat sides
      translate([RIM_WIDTH,0,0])
      translate([TopBreak_ExtractorBitWidth()/8,0,TopBreak_ExtractorBitZ()])
      rotate([0,TopBreak_ExtractorAngle(),0])
      translate([-(TopBreak_ExtractorBitWidth()+clear2),-(bitWidth/2)-clear,0])
      cube([TopBreak_ExtractorBitWidth()+clear2, bitWidth+clear2, TopBreak_ExtractorBitLength()]);
    }

    // Cutout access
    translate([0,0,base])
    cylinder(r=mountingBlockX+0.125, h=base+height+topHeight);
  }

  // Bottom plate
  if (bottom)
  color("Tan") render()
  difference() {
    union() {

      // Baseplate
      hull()
      for (R = [0,90,-90,180]) rotate(R)
      translate([1.5,0,0])
      ChamferedCylinder(r1=0.25, r2=CR(), h=base);

      // Mounting block
      hull()
      for (R = [0:gangAngle:360]) rotate(R)
      translate([mountingBlockX,offsetY,0])
      ChamferedCube([0.825, width, base+offsetZ-0.25], r=1/16);
    }

    // Extractor bit
    for (R = [0:gangAngle:360]) rotate(R)
    translate([0,0,base+offsetZ])
    rotate(180)
    rotate([0,90,0]) {

      TopBreak_ExtractorBit(cutter=true, clearance=clearance);

      // Flat sides
      translate([RIM_WIDTH,0,0])
      translate([TopBreak_ExtractorBitWidth()/8,0,TopBreak_ExtractorBitZ()])
      rotate([0,TopBreak_ExtractorAngle(),0])
      translate([0,-(bitWidth/2)-clear,0])
      cube([TopBreak_ExtractorBitWidth()+clear2, bitWidth+clear2, TopBreak_ExtractorBitLength()]);
    }

    // T-slot bolts
    TSlotBolts(cutter=true);

    Bolts(cutter=true);

    // Index pin
    translate([0,0,0])
    cylinder(r=Inches(3/32/2)+clearance, h=base+height);

    // Cutout access
    translate([0,0,base+height])
    cylinder(r=mountingBlockX, h=base+height);
  }
}

// Assembly
module TopBreak_Assembly(receiverLength=12, pipeAlpha=1, TopBreak_ReceiverFrontAlpha=1, pivotFactor=0, extractFactor=0, chargeFactor=0, lockFactor=0, fcg=_SHOW_FCG, stock=true, tailcap=false, cutaway=undef, hardware=_SHOW_HARDWARE, prints=_SHOW_PRINTS) {

  if (hardware)
  TopBreak_ForendBolts();

  if (fcg)
  translate([-TopBreak_ReceiverFrontLength(),0,0]) {
    SimpleFireControlAssembly(hardware=hardware && _SHOW_FCG_HARDWARE, prints=prints, actionRod=false,
                              recoilPlateLength=RECOIL_PLATE_LENGTH, alpha=_ALPHA_FCG);
  }

  if (prints && _SHOW_RECEIVER_FRONT)
  TopBreak_ReceiverFront(cutaway=cutaway==true,
                         alpha=_ALPHA_RECEIVER_FRONT);

  // Everything that pivots with the break
  BreakActionPivot(factor=pivotFactor) {

    if (hardware && _SHOW_BARREL)
    TopBreak_Barrel(cutaway=cutaway == true || _CUTAWAY_BARREL);

    if (hardware && _SHOW_HANDGUARD_BOLTS) {
      TopBreak_HandguardBolts();
    }

    if (_SHOW_SIGHTPOST) {

      if (hardware)
      translate([TopBreak_SightpostX()+SightpostLength(),0,0])
      rotate([0,-90,0])
      SightpostBolts(radius=BarrelRadius()+BARREL_CLEARANCE);

      if (prints)
      TopBreak_Sightpost();
    }

    // TopBreak_Extractor Spring
    if (hardware && _SHOW_EXTRACTOR_HARDWARE)
    TopBreak_ExtractorSpring();

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
      TopBreak_LatchTab(cutaway=cutaway == true || _CUTAWAY_LATCH,
                        alpha=_ALPHA_LATCH);
    }

    if (hardware && _SHOW_COLLAR_HARDWARE)
    TopBreak_BarrelCollarBolts();

    if (prints && _SHOW_COLLAR)
    TopBreak_BarrelCollar(cutaway=cutaway == true || _CUTAWAY_COLLAR, alpha=_ALPHA_COLLAR);

    if (hardware && _SHOW_CLUSTER_BOLTS)
    TopBreak_ClusterBolts();

    if (hardware && _SHOW_GRIP_HARDWARE) {
      TopBreak_GripBolt();
      TopBreak_GripPin();
    }

    if (prints && _SHOW_CLUSTER)
    TopBreak_Cluster(cutaway=_CUTAWAY_CLUSTER, alpha=_ALPHA_CLUSTER);

    if (prints && _SHOW_FOREGRIP)
    TopBreak_Foregrip(alpha=_ALPHA_FOREGRIP);

    if (prints && _SHOW_VERTICAL_GRIP)
    TopBreak_VerticalForegrip(alpha=_ALPHA_VERTICAL_FOREGRIP);

    children();

  }

  if (prints && _SHOW_FOREND)
  TopBreak_Forend(cutaway=cutaway == true || _CUTAWAY_FOREND, alpha=_ALPHA_FOREND);
}
//

ScaleToMillimeters()
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
    Lower(bolts=_SHOW_LOWER_HARDWARE, showLeft=!_CUTAWAY_LOWER, alpha=_ALPHA_LOWER);
    LowerMount(hardware=_SHOW_LOWER_HARDWARE, cutaway=_CUTAWAY_LOWER, alpha=_ALPHA_LOWER);
  }

  translate([-TopBreak_ReceiverFrontLength(),0,0]) {

    if(_SHOW_TENSION_RODS)
    Receiver_TensionBolts();

    if (_SHOW_RECEIVER)
    Frame_ReceiverAssembly(
      hardware=_SHOW_RECEIVER_HARDWARE,
      length=TopBreak_FrameBoltLength()-0.5,
      cutaway=_CUTAWAY_RECEIVER,
      alpha=_ALPHA_RECEIVER);
  }

  if (_SHOW_STOCK)
  translate([-TopBreak_ReceiverFrontLength(),0,0])
  StockAssembly(hardware=_SHOW_STOCK_HARDWARE, alpha=_ALPHA_STOCK);
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
      translate([-ClusterMaxX(),0,0])
      TopBreak_Cluster();

  if (_RENDER == "Prints/VerticalForegrip")
    if (!_RENDER_PRINT)
      TopBreak_VerticalForegrip();
    else
      mirror([0,0,1])
      translate([-(TrunnionLength()+0.25),0,-(-BarrelRadius()-0.75)])
      TopBreak_VerticalForegrip();

  if (_RENDER  == "Prints/Foregrip")
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

  if (_RENDER == "Prints/LatchTab")
    if (!_RENDER_PRINT)
      TopBreak_LatchTab();
    else
      translate([0,0,-TopBreak_LatchZ()])
      TopBreak_LatchTab();

  if (_RENDER == "Prints/Sightpost")
    if (!_RENDER_PRINT)
      TopBreak_Sightpost();
    else
      rotate([0,90,0])
      translate([-(TopBreak_SightpostX()+SightpostLength()),0,0])
      TopBreak_Sightpost();

  // ***********
  // * Fixures *
  // ***********
  if (_RENDER == "Fixtures/Trunnion")
    if (!_RENDER_PRINT)
      TopBreak_Fixture_Trunnion();
    else
      TopBreak_Fixture_Trunnion();

  if (_RENDER == "Fixtures/ExtractorGang_Bottom")
    if (!_RENDER_PRINT)
      TopBreak_Fixture_Extractor(bottom=true);
    else
      TopBreak_Fixture_Extractor(bottom=true);

  if (_RENDER == "Fixtures/ExtractorGang_Top")
    if (!_RENDER_PRINT)
      TopBreak_Fixture_Extractor(top=true);
    else
      translate([0,0,1])
      rotate([180,0,0])
      TopBreak_Fixture_Extractor(top=true);

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

  if (_RENDER == "Hardware/ForendBolts")
  TopBreak_HandguardBolts();

  if (_RENDER == "Hardware/HandguardBolts")
  TopBreak_HandguardBolts();

  if (_RENDER == "Hardware/SightpostBolts")
  translate([TopBreak_SightpostX()+SightpostLength(),0,0])
  rotate([0,-90,0])
  SightpostBolts(radius=BarrelRadius());
}
