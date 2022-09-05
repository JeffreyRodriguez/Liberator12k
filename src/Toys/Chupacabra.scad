/* Note: This is a thought experiment.
 * Making one of these as configured here would be illegal.
 */

// Cocked position
//$t = 0.27;

// Full forward position
//$t = 0.30801;

// Recoiled position
//$t = 0.384617;

include <../Meta/Animation.scad>;
use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Shapes/Semicircle.scad>;
use <../Shapes/Teardrop.scad>;
use <../Shapes/Chamfer.scad>;
use <../Meta/Conditionals/RenderIf.scad>;
use <../Meta/Cutaway.scad>;
use <../Meta/Units.scad>;
use <../Meta/Manifold.scad>;
use <../Meta/Resolution.scad>;
use <../Vitamins/Magazine.scad>;

use <../Receiver/Receiver.scad>;
use <../Receiver/Lower.scad>;
use <../Receiver/Frame.scad>;
use <../Receiver/FCG.scad>;
use <../Receiver/Stock.scad>;

_RENDER = ""; // ["", ""]

_SHOW_PRINTS = true;
_SHOW_HARDWARE = true;
_SHOW_FCG = false;
_SHOW_RECEIVER = true;
_SHOW_STOCK = true;
_SHOW_LOWER = true;
_ALPHA_RECEIVER = 0.2;
_ALPHA_STOCK = 0.2;
_ALPHA_LOWER = 0.2;
_ALPHA_MAGWELL = 1;
_CUTAWAY_RECEIVER = false;

BOLT = BoltSpec("1/2\"-13");
MAGAZINE = MagazineSpec("Glock 9mm");

BRANDING_MODEL_NAME = "Chupacabra";

//BOLT_GUIDE_ROD = Spec_RodOneQuarterInch();
//BOLT_SEAR_ROD = Spec_RodOneQuarterInch();
//EJECTOR_PIVOT_ROD = Spec_RodOneEighthInch();


function SearRod() = Inches(0.25);
function RodDiameter(diameter) = diameter;
function RodRadius(diameter) = diameter/2;


// These could probably be calculated from the settings below,
// they're a percentage of the overall travel length
ANIMATION_SUBSTEP_CHARGE_EJECT_START = 0.52;
ANIMATION_SUBSTEP_CHARGE_EJECT_END = 0.64;
ANIMATION_SUBSTEP_CHARGE_EJECTORTRIP_START = 0.30;
ANIMATION_SUBSTEP_CHARGE_EJECTORTRIP_END = 0.42;
ANIMATION_SUBSTEP_FIRE_EJECTORTRIP_START = 0.2;
ANIMATION_SUBSTEP_FIRE_EJECTORTRIP_END = 0.35;

WALL = Inches(3/16);
WALL2= WALL*2;
CHAMFER = 0.0625;

function BarrelX() = -8.25;
function BarrelCollarDiameter() = 1.125;
function BarrelCollarRadius() = BarrelCollarDiameter()/2;
function BarrelLength() = 16;

function EjectionPortHeight() = 0.75;
function EjectionPortLength() = 1.5;
function EjectionPortMinX() = BarrelX()-EjectionPortLength();

function ShaftCollarWidth() = 9/16;
function ShaftCollarDiameter() = 1.25;
function ShaftCollarRadius() = ShaftCollarDiameter()/2;

function TrunnionLength() = 6-0.5;
function ForendMaxX() = TrunnionLength();

function EndcapExtension() = 0.5;

function BoltBodyLength() = MagazineLength(MAGAZINE)+RodDiameter(SearRod())+0.625;
function BoltRodExtension() = 0;//1.75;
function BoltRodLength() = 6;
function BoltWasherDiameter() = 1.5;
function BoltWasherRadius() = BoltWasherDiameter()/2;
function BoltWasherLength() = 2.75;
function BoltMaxX() = BarrelX()-BoltRodExtension();
function BoltBodyMinX() = BarrelX()-BoltRodExtension()-BoltBodyLength();
function BoltTravel() = MagwellLength(MAGAZINE)
                      + LowerMaxX()
                      + RodRadius(SearRod())
                      - BoltBodyLength(); //BarrelX()-BoltBodyLength()+RodRadius(SearRod())


function MagazineWallBack() = 0.25;
function MagazineWallFront() = 0.25;


function MagazineX() = BarrelX()
                     - MagazineOffsetX(MAGAZINE)
                     - MagazineLength(MAGAZINE);

module SpentCasing9mm() {
  color("Gold")
  cylinder(r1=0.39/2, r2=0.377/2, h=0.7475, $fn=Resolution(8,30));
}

module Chupacabra_Barrel(cutter=false, hollow=true) {
  color("SlateGray") render()
  union() {
    translate([BarrelX()+(cutter?-ManifoldGap():0),0,0])
    rotate([0,90,0])
    cylinder(r=9/16/2, h=BarrelLength(), $fn=Resolution(20,60));
  }
}

module Chupacabra_Magazine(doRender=false) {
  color("#333333") RenderIf(doRender)
  translate([MagazineX(),0,-MagwellDepth(MAGAZINE)])
  Magazine(MAGAZINE, taper=false);
}

module Chupacabra_Magwell(alpha=1) {
  wallSide=Inches(0.25);
  wallBack=MagazineWallBack();
  wallFront=MagazineWallFront();
  height=MagwellDepth(MAGAZINE)+ReceiverBottomZ();
  CR = Inches(1/16);

  color("Orange", alpha) render()
  difference() {
    union() {

      // Insert
      translate([MagazineX(),0,0])
      translate([-wallBack, -(1/2),ReceiverBottomZ()-(CR*2)])
      ChamferedCube([4,
                     1,
                     abs(ReceiverBottomZ())+(CR*2)-Inches(0.25)],
                    r=CR, teardropFlip=[true,true,true]);

      // Magwell
      hull() {

        // Top
        translate([MagazineX(),0,-MagwellDepth(MAGAZINE)])
        translate([-wallBack, -(MagazineWidth(MAGAZINE)/2)-wallSide,height-Inches(0.25)])
        ChamferedCube([MagwellLength(MAGAZINE)+wallBack+wallFront,
                       MagazineWidth(MAGAZINE)+(wallSide*2),
                       Inches(0.25)-ManifoldGap()],
                      r=CR, teardropFlip=[true,true,true]);

        // Bottom
        translate([MagazineX(),0,-MagwellDepth(MAGAZINE)])
        translate([-wallBack, -(MagazineWidth(MAGAZINE)/2)-wallSide, ManifoldGap()])
        ChamferedCube([MagazineLength(MAGAZINE)+wallBack+wallFront,
                       MagazineWidth(MAGAZINE)+(wallSide*2),
                       Inches(0.25)-ManifoldGap()],
                      r=CR, teardropFlip=[true,true,true]);
        }
      }

      // TODO: Magazine Catch
      //MagazineCatch(magHeight=MagwellDepth(MAGAZINE), extraRadius=0.1, extraY=wall+0.25);

    // TODO: Bolt Catch / Slide Stop
    //translate([MagazineLength(MAGAZINE)+MagazineOffsetX(MAGAZINE)-0.25,0,0]) cube([0.25, 0.25, 0.25]);

    translate([MagazineX(),0,-MagwellDepth(MAGAZINE)])
    Magazine(MAGAZINE);

    translate([MagazineX(),0,-MagwellDepth(MAGAZINE)])
    MagazineCatch(MAGAZINE);


    for (X = [1,4])
    translate([X,0,0])
    Stock_TakedownPin(cutter=true);
  }
}

module Chupacabra_Forend(cutaway=false, alpha=1) {
  ejectionPortLength = ForendMaxX()-LowerMaxX();
  CR = Inches(1/16);

  // Branding text
  color("DimGrey", alpha) render() Cutaway(cutaway) {

    fontSize = 0.375;

    // Right-side text
    translate([ForendMaxX()-0.5,-ReceiverOR(),-fontSize])
    rotate([90,0,0])
    linear_extrude(height=LogoTextDepth(), center=true)
    text(BRANDING_MODEL_NAME, size=fontSize, font="Impact", halign="right");

    // Left-side text
    translate([ForendMaxX()-0.5,ReceiverOR(),-fontSize])
    rotate([90,0,0])
    linear_extrude(height=LogoTextDepth(), center=true)
    mirror([1,0])
    text(BRANDING_MODEL_NAME, size=fontSize, font="Impact", halign="left");
  }

  color("Tan", alpha=alpha) render() Cutaway(cutaway)
  difference() {

    // Receiver extension
    hull() {
      translate([ForendMaxX(),0,0])
      Receiver_Segment(length=ForendMaxX(), highTop=false,
                       chamferFront=true, chamferBack=true);

      mirror([1,0,0])
      Receiver_Segment(length=CR*2, highTop=true,
                       chamferFront=true, chamferBack=true);
   }


    Chupacabra_Barrel(cutter=true, hollow=false);
  }
}

module Chupacabra(hardware=_SHOW_HARDWARE, prints=_SHOW_PRINTS,
                      cutaway=false) {

  Chupacabra_Magazine(doRender=true);

  *translate([BoltTravel()*Animate(ANIMATION_STEP_FIRE),0,0])
  translate([-BoltTravel()*Animate(ANIMATION_STEP_CHARGE),0,0])
  translate([-BoltTravel(),0,0]) {

    if (AnimationStep($t) == ANIMATION_STEP_CHARGE)
    translate([BoltMaxX(),
               (shellEjectionT*2),
               0
                 +(shellEjectionT*2)])
    rotate([0,90-(45*shellEjectionT),0])
    SpentCasing9mm();

    BoltVitamin();
    PipeBoltTail();
    PipeBoltWashers();

//    translate([0,0,0+5])
//    color("Green") render() DebugHalf(dimension=10, rotateArray=[0,0,180])
//    translate([0,0,-0-5])
    PipeBolt();
  }

  *ShaftCollar();
  Chupacabra_Barrel();
  Chupacabra_Forend();
  Chupacabra_Magwell(alpha=_ALPHA_MAGWELL);
}

//$t = AnimationDebug(step=ANIMATION_STEP_FIRE
//                    ,start=ANIMATION_SUBSTEP_FIRE_EJECTORTRIP_START-0.02
//                    ,end=ANIMATION_SUBSTEP_FIRE_EJECTORTRIP_END+0.02
//);
//$t = AnimationDebug(step=ANIMATION_STEP_CHARGE, T=round($t),
//                    start=ANIMATION_SUBSTEP_CHARGE_EJECT_START,
//                    end=ANIMATION_SUBSTEP_CHARGE_EJECT_END);


if ($preview) {

  Chupacabra(hardware=_SHOW_HARDWARE, prints=_SHOW_PRINTS,
                        cutaway=false);
  if (_SHOW_FCG)
    SimpleFireControlAssembly(hardware=false, prints=_SHOW_PRINTS,
                              actionRod=false);

  if (_SHOW_LOWER) {
    LowerMount(hardware=false, prints=_SHOW_PRINTS, alpha=_ALPHA_LOWER);
    Lower(hardware=false, prints=_SHOW_PRINTS, alpha=_ALPHA_LOWER);
  }

  if (_SHOW_RECEIVER)
  ReceiverAssembly(
    hardware=false, prints=_SHOW_PRINTS,
    cutaway=_CUTAWAY_RECEIVER, alpha=_ALPHA_RECEIVER);

  if (_SHOW_STOCK)
  StockAssembly(hardware=false, prints=_SHOW_PRINTS, alpha=_ALPHA_STOCK);
} else {


/****************
 * Plated Parts *
 ****************/

//
// Bolt
//
*!scale(25.4)
rotate([0,-90,0])
translate([-(BoltMaxX())+BoltBodyLength(),0,-0])
PipeBolt();

*!scale(25.4)
rotate([0,90,0])
translate([-(BoltMaxX()-BoltRodLength()-BoltHexHeight(BOLT)+1),
           0,
           -0])
PipeBoltTail();

//
// Trunnion and magwell
//
*!scale(25.4)
rotate([0,90,0])
translate([-LowerMaxX()-TrunnionLength(),0,-0])
Chupacabra_Trunnion();

*!scale(25.4)
rotate([0,90,0])
translate([-(BarrelX()+TrunnionExtension()+ShaftCollarWidth()+0.5),0,-0])
Chupacabra_TrunnionCap();

*!scale(25.4)
translate([-LowerMaxX(),0,0])
Chupacabra_Magwell();

}
