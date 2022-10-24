use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Cutaway.scad>;
use <../Meta/Conditionals/HullIf.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Conditionals/RenderIf.scad>;

use <../Shapes/Chamfer.scad>;
use <../Shapes/MLOK.scad>;
use <../Shapes/Semicircle.scad>;
use <../Shapes/Teardrop.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../Vitamins/Pipe.scad>;

/* [Export] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Prints/Receiver", "Prints/Receiver_Back", "Prints/Receiver_Projection", "Projections/ReceiverBottomSlotInterface"]

// Reorient the part for printing?
_RENDER_PRINT = true;

/* [Assembly] */
_SHOW_HARDWARE            = true;
_SHOW_PRINTS              = true;
_SHOW_RECEIVER            = true;
_SHOW_RECEIVER_RODS       = true;
_SHOW_RECEIVER_BACK       = true;

_ALPHA_RECEIVER = 1; // [0:0.1:1]

_CUTAWAY_RECEIVER = false;

/* [Vitamins] */

// Threaded rods that extend through the receiver and stock.
TENSION_BOLT           = "#8-32";   // ["M4", "#8-32", "#10-24", "1/4\"-20"]
TENSION_NUT_TYPE       = "heatset-long"; // ["none", "hex", "heatset", "heatset-long"]
TENSION_HEAD_TYPE      = "none"; // ["none", "hex", "socket", "flat"]
TENSION_BOLT_CLEARANCE = 0.015;
TENSION_BOLT_LENGTH    = 12;

// Picatinny rail mounts on top of receiver w/ M-LOK
MLOK_BOLT           = "#8-32";   // ["M4", "#8-32", "#10-24", "1/4\"-20"]

/* [Fine Tuning] */
RECEIVER_HIGH_TOP = true;
RECEIVER_MLOK = true;
RECEIVER_TAKEDOWN_PIN = true;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

// Settings: Vitamins
function TensionBolt() = BoltSpec(TENSION_BOLT);
assert(TensionBolt(), "TensionBolt() is undefined. Unknown TENSION_BOLT?");

function MlokBolt() = BoltSpec(MLOK_BOLT);
assert(MlokBolt(), "MlokBolt() is undefined. Unknown MLOK_BOLT?");


// Settings: Lengths
function ReceiverLength() = 5;
function ReceiverBackLength() = 0.5;

function ReceiverBottomSlotWidth() = 1;

function ReceiverTopSlotWidth() = 0.75;
function ReceiverTopSlotHeight() = 1.25;
function ReceiverTopSlotHorizontalWidth() = ReceiverTopSlotWidth()+0.25;
function ReceiverTopSlotHorizontalHeight() = 0.25;

function Receiver_SideSlotHeight() = 0.5;
function Receiver_SideSlotDepth() = 0.125;
function ReceiverSlotClearance() = 0.005;


// Settings: Diameters
function ReceiverOD()     = 2;
function ReceiverOR()     = ReceiverOD()/2;
function ReceiverID()     = 1.25;
function ReceiverIR()     = ReceiverID()/2;

// Settings: Walls
function WallTensionRod() = 0.25;

// Settings: Positions
function TensionBoltLength() = TENSION_BOLT_LENGTH;

function TensionRodBottomZ() = -7/8;
function TensionRodBottomOffsetSide() = 0.75;

function TensionRodTopZ() = 0.75;
function TensionRodTopOffsetSide() = 0.625;

function Receiver_TakedownPinX() = -ReceiverLength()+0.375;
function Receiver_TakedownPinZ() = TensionRodBottomZ()+WallTensionRod();

function ReceiverBottomZ() = TensionRodBottomZ()-WallTensionRod();
function ReceiverTopZ() = TensionRodTopZ()+WallTensionRod()+0.625;

function Receiver_MlokSideY() = 1.25;
function Receiver_MlokSideZ() = ReceiverBottomZ()+0.5;

// Misc. Common dimensions
function SpindleZ() = -1;
function LogoTextSize() = 11/32;
function LogoTextDepth() = 1/32;

mlokBoltHoles = [0,Millimeters(80),Millimeters(100)];

// ************
// * Vitamins *
// ************
module TensionBoltIterator() {
  for (M = [0,1]) mirror([0,M,0])
  for (xyz = [[0,TensionRodTopOffsetSide(),TensionRodTopZ(),0],
              [0,TensionRodBottomOffsetSide(),TensionRodBottomZ(),1]])
  translate([xyz[0],xyz[1],xyz[2]])
  mirror([0,0,xyz[3]])
  rotate([0,-90,0])
  children();
}
module Receiver_TensionBolts(bolt=TensionBolt(), headType=TENSION_HEAD_TYPE, nutType=TENSION_NUT_TYPE, length=12, cutter=false, clearance=TENSION_BOLT_CLEARANCE, teardrop=false, cutaway=false) {
  TensionBoltIterator()
  NutAndBolt(bolt=bolt,
             boltLength=length+ManifoldGap(2),
             head=headType, capHeightExtra=(cutter?0.375:0),
             nut=nutType,
             teardrop=cutter&&teardrop,
             clearance=cutter?clearance:0,
             doRender=!cutter);
}


module Receiver_MlokBolts(holes=mlokBoltHoles, headType="flat", nutType="heatset-long", length=0.5, cutter=false, clearance=0.005, teardrop=false, teardropAngle=180) {

  // Top Bolts
  for (X = holes)
  translate([-0.75-X,0,ReceiverTopSlotHeight()+ReceiverSlotClearance()])
  NutAndBolt(bolt=MlokBolt(),
             boltLength=length+ManifoldGap(2),
             head=headType,
             nut=nutType, nutHeightExtra=(cutter?1:0),
             teardrop=cutter&&teardrop, teardropAngle=teardropAngle,
             clearance=cutter?clearance:0,
             doRender=!cutter);
}
module Receiver_TakedownPin(cutter=false, clearance=0.005, alpha=1, cutaway=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  if (cutter) {
    translate([Receiver_TakedownPinX(), 0, Receiver_TakedownPinZ()])
    rotate([90,0,0])
    linear_extrude(ReceiverOD(), center=true)
    rotate(180)
    Teardrop(r=0.125+clear);
  } else {
    color("Silver") render() Cutaway(cutaway)
    translate([Receiver_TakedownPinX(), 0, Receiver_TakedownPinZ()])
    rotate([90,0,0])
    ChamferedCylinder(r1=0.125, r2=1/16, h=ReceiverOD(), center=true);
  }
}
///

// **********
// * Shapes *
// **********
module ReceiverMlokSlot(length=ReceiverLength(), width = Millimeters(7)+0.005, depth=0.0625) {
  translate([0, -width/2, ReceiverTopZ()+ManifoldGap()])
  mirror([0,0,1])
  mirror([1,0,0])
  cube([length, width, depth]);
}
module Receiver_RoundSlot(length=ReceiverLength(), clearance=ReceiverSlotClearance()) {

  // ID cutout
  rotate([0,-90,0])
  cylinder(r=ReceiverIR()+clearance, h=length);

  rotate([0,-90,0])
  HoleChamfer(r1=ReceiverIR(), r2=3/32, teardrop=true);

  translate([-length,0,0])
  rotate([0,90,0])
  HoleChamfer(r1=ReceiverIR(), r2=3/32, teardrop=true);
}
module ReceiverBottomSlot(length=ReceiverLength(), clearance=ReceiverSlotClearance(), chamferBottom=true) {

  // Wide Vertical slot
  translate([0,-(ReceiverBottomSlotWidth()/2)-clearance,0])
  mirror([0,0,1])
  rotate([0,-90,0])
  ChamferedSquareHole(sides=[abs(TensionRodBottomZ())+clearance,
                             ReceiverBottomSlotWidth()+(clearance*2)],
                       length=length,
                      chamferBottom=chamferBottom,
                      center=false, corners=false, chamferRadius=1/16);


  // Narrow Vertical slot
  translate([0,-(ReceiverBottomSlotWidth()/2)+0.125-clearance,0])
  mirror([0,0,1])
  rotate([0,-90,0])
  ChamferedSquareHole(sides=[abs(TensionRodBottomZ())+0.25+clearance,
                             ReceiverBottomSlotWidth()-0.25+(clearance*2)],
                       length=length,
                      chamferBottom=chamferBottom,
                      center=false, corners=false, chamferRadius=1/16);

  // Bottom edge curves
  translate([0,0,ReceiverBottomZ()])
  rotate([0,-90,0])
  linear_extrude(length)
  for (M = [0,1]) mirror([0,M])
  translate([0,(ReceiverBottomSlotWidth()/2)-0.125+clearance])
  rotate(-90)
  RoundedBoolean(r=1/16, edgeOffset=0);

  // Top edge curves
  translate([0,0,ReceiverBottomZ()+0.25-clearance])
  rotate([0,-90,0])
  linear_extrude(length)
  for (M = [0,1]) mirror([0,M])
  translate([0,(ReceiverBottomSlotWidth()/2)-0.125+clearance])
  RoundedBoolean(r=1/32, edgeOffset=0);
}

module ReceiverTopSlot(verticalSlot=true, length=ReceiverLength(), width=ReceiverTopSlotWidth(), height=ReceiverTopSlotHeight(), clearance=ReceiverSlotClearance()) {
  chamferRadius = 1/16;
  horizontalWidth = ReceiverTopSlotHorizontalWidth();
  horizontalHeight = ReceiverTopSlotHorizontalHeight();

  rotate([0,-90,0]) {

    // Vertical slot
		if (verticalSlot)
    translate([0,-(width/2)-clearance])
    ChamferedSquareHole(sides=[height+clearance,width+(clearance*2)], length=length,
                        center=false, corners=false, chamferRadius=chamferRadius);

    // Horizontal slot
    translate([TensionRodTopZ()+WallTensionRod(),
               -(horizontalWidth/2)-clearance])
    ChamferedSquareHole(sides=[horizontalHeight+clearance,horizontalWidth+(clearance*2)], length=length,
                        center=false, corners=false, chamferRadius=chamferRadius);
  }
}

module Receiver_SideSlot(length=ReceiverLength(), clearance=ReceiverSlotClearance()) {
  clear = clearance;
  clear2 = clear*2;

  width = (ReceiverIR()+Receiver_SideSlotDepth()+clear)*2;
  height = Receiver_SideSlotHeight()+clear2;

  translate([0,-width/2,-height/2])
  rotate([0,-90,0])
  ChamferedSquareHole(sides=[height,width], length=length,
                      center=false, corners=false, chamferRadius=1/16);
}
module ReceiverBottomSlotInterface(length=ReceiverLength(), height=abs(ReceiverBottomZ()), extension=0, clearance=0.005) {
  clear = clearance;
  clear2 = clear*2;

  translate([-length,-(1/2)+clear,-height+WallTensionRod()+clear])
  ChamferedCube([length, 1-clear2, height-WallTensionRod()], r=1/32, teardropFlip=[true,true,true]);

  translate([-length,-(0.75/2)+clear,-height-extension])
  ChamferedCube([length, 0.75-clear2, height+extension], r=1/32, teardropFlip=[true,true,true]);
}
module ReceiverTopSegment(length=ReceiverLength(), chamferFront=true, chamferBack=true, teardropFront=true, teardropBack=true) {
  CR = 1/4;

  for (Y = [1,-1])
  translate([0, Y*(TensionRodTopOffsetSide()-CR), ReceiverTopZ()-CR])
  rotate([0,-90,0])
  ChamferedCylinder(r1=CR, r2=1/16, h=length,
                    chamferBottom=chamferFront, chamferTop=chamferBack,
                    teardropBottom=teardropFront, teardropTop=teardropBack);
}

module Receiver_Segment(length=1, chamferFront=false, chamferBack=false, highTop=true) {
  hull() {

    // Around the stock tube
    rotate([0,-90,0])
    ChamferedCylinder(r1=ReceiverOR(), r2=1/16,h=length,
                      chamferBottom=chamferFront, chamferTop=chamferBack,
                      teardropTop=true);

    // Tension bolt supports
    TensionBoltIterator()
    ChamferedCylinder(r1=WallTensionRod(), r2=1/16, h=length,
                      chamferBottom=chamferFront, chamferTop=chamferBack,
                      teardropTop=true);

    // Top cover
    if (highTop)
    ReceiverTopSegment(length=length,
                       chamferFront=chamferFront, chamferBack=chamferBack);
  }

  // Flat bottom
  translate([-length, -TensionRodBottomOffsetSide(), -ReceiverOR()])
  rotate([90,0,90])
  linear_extrude(height=length)
  ChamferedSquare(xy=[(TensionRodBottomOffsetSide())*2,ReceiverOR()], r=1/16,
                  teardropBottom=false,
                  teardropTop=false);
}
///

// *****************
// * Printed Parts *
// *****************
module Receiver(receiverLength=ReceiverLength(), mlok=RECEIVER_MLOK, highTop=RECEIVER_HIGH_TOP, takedownPin=RECEIVER_TAKEDOWN_PIN, doRender=true, alpha=1, cutaway=false) {
  mlokSupportHeight=0.75;
  CHAMFER_RADIUS = 1/16;

  color("Tan", alpha) RenderIf(doRender)
  Cutaway(cutaway)
  difference() {
    union() {
      for (highChamfer = [true,false])
      Receiver_Segment(length=ReceiverLength(), highTop=(highTop&&highChamfer),
                      chamferFront=true, chamferBack=true);

      // M-LOK side slot support
      if (mlok)
      translate([0,-Receiver_MlokSideY(),Receiver_MlokSideZ()-(mlokSupportHeight/2)])
      mirror([1,0,0])
      ChamferedCube([Millimeters((32*2)+8)+1,
                     (Receiver_MlokSideY()*2),
                     mlokSupportHeight], r=1/16,
                     teardropFlip=[true,true,true]);


      // Fillet M-LOK-to-frame joint
      if (mlok)
      for (M = [0, 1]) mirror([0,M,0])
      translate([-CHAMFER_RADIUS,ReceiverOR()-0.001,Receiver_MlokSideZ()+(mlokSupportHeight/2)-ManifoldGap()])
      rotate([90,0,0]) rotate([0,-90,0])
      Fillet(h=Millimeters((32*2)+8)+1-(1/8), r=1/8);


      children();
    }

    // M-LOK Side slots
    if (mlok)
    for (M = [0,1]) mirror([0,M,0])
    for (X = [0,MlokSlotLength()+MlokSlotSpacing()]) translate([-X,0,0])
    mirror([1,0,0])
    translate([0.5,Receiver_MlokSideY(),Receiver_MlokSideZ()])
    rotate([-90,0,0]) {
      MlokSlot();
      MlokSlotBack();
    }

    ReceiverMlokSlot();
    Receiver_MlokBolts(cutter=true, teardrop=true);

    translate([-0.5,0,0])
    ReceiverBottomSlot(length=ReceiverLength()-0.5, chamferBottom=false);
    Receiver_RoundSlot();
    Receiver_SideSlot();
		
		if (highTop)
    ReceiverTopSlot();

		if (takedownPin)
    Receiver_TakedownPin(cutter=true);
		
    Receiver_TensionBolts(cutter=true);
  }
}

module ReceiverBackSegment(length=ReceiverBackLength()) {
  color("Chocolate") render()
  difference() {
    translate([-ReceiverLength(),0,0])
    Receiver_Segment(highTop=false, length=length, chamferBack=true);

    Receiver_TensionBolts(nutType="none", headType="none", cutter=true);

    translate([-ReceiverLength(),0,0])
    rotate([0,-90,0])
    ChamferedCircularHole(r1=0.25, r2=1/16, h=length);
  }
}

///

// **************
// * Assemblies *
// **************
module ReceiverAssembly(hardware=_SHOW_HARDWARE, prints=_SHOW_PRINTS, tensionRods=_SHOW_RECEIVER_RODS, mlokBolts=true, cutaway=false, alpha=_ALPHA_RECEIVER) {
  if (hardware && tensionRods)
  Receiver_TensionBolts(cutaway=cutaway);

  if (hardware && mlokBolts)
  Receiver_MlokBolts();

  if (prints && _SHOW_RECEIVER)
  Receiver(alpha=alpha, cutaway=cutaway)
  children();
}
///

ScaleToMillimeters() if ($preview) {
  if (_SHOW_RECEIVER_BACK)
  ReceiverBackSegment();

  ReceiverAssembly(cutaway=_CUTAWAY_RECEIVER);
} else {

  // *****************
  // * Printed Parts *
  // *****************
  if (_RENDER == "Prints/Receiver")
    if (!_RENDER_PRINT)
      Receiver();
    else
      rotate([0,90,0])
      Receiver();

  if (_RENDER == "Prints/Receiver_Back")
    if (!_RENDER_PRINT)
      ReceiverBackSegment();
    else
    rotate([0,-90,0])
    translate([ReceiverLength()+ReceiverBackLength(),0,0])
    ReceiverBackSegment();

  if (_RENDER == "Projections/ReceiverBottomSlotInterface")
  projection()
  rotate([0,90,0])
  ReceiverBottomSlotInterface();

  if (_RENDER == "Projections/Receiver")
  projection()
  rotate([0,90,0])
  difference() {
    Receiver_Segment(highTop=false);

    Receiver_RoundSlot();
    Receiver_SideSlot();
    Receiver_TensionBolts(cutter=true, bolt=Spec_BoltTemplate());
  }

  // ************
  // * Hardware *
  // ************
  if (_RENDER == "Hardware/Receiver_MlokBolts")
    Receiver_MlokBolts();
  if (_RENDER == "Hardware/Receiver_TakedownPin")
    Receiver_TakedownPin();
  if (_RENDER == "Hardware/Receiver_TensionBolts")
    Receiver_TensionBolts();
}
