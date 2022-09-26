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
_CUTAWAY_RECEIVER = false;

BOLT = BoltSpec("1/2\"-13");
MAGAZINE = MagazineSpec("Glock 9mm");

BRANDING_MODEL_NAME = "Toro9";

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

function BarrelX() = -8;
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

function MagazineX() = BarrelX();

module SpentCasing9mm() {
  color("Gold")
  cylinder(r1=0.39/2, r2=0.377/2, h=0.7475, $fn=Resolution(8,30));
}
module ShaftCollarBoltCutter() {
  translate([ForendMaxX(),0,0])
  rotate([0,90,0])
  translate([0,0,(ShaftCollarWidth()/2)])
  rotate([0,90,0])
  linear_extrude(height=2)
  Teardrop(r=0.15, $fn=Resolution(12,20));
}

module ShaftCollar(cutter=false, clearance=0.02) {
  clear = cutter ? clearance : 0;

  color("SteelBlue") render()
  difference() {
  translate([ForendMaxX(),0,0])
  rotate([0,90,0])
    translate([0,0,-ManifoldGap()])
    cylinder(r=ShaftCollarRadius()+clear,
             h=ShaftCollarWidth()+clear+ManifoldGap(), $fn=60);

    ElToro_Barrel(cutter=true, hollow=false);
  }
}

module ElToro_Magazine(doRender=false) {
  color("#333333") RenderIf(doRender)
  translate([BarrelX()-MagazineOffsetX(MAGAZINE)-MagazineLength(MAGAZINE)+MagazineWallBack(),0,-MagwellDepth(MAGAZINE)])
  Magazine(MAGAZINE, taper=false);
}

module PipeBolt(cutter=false, alpha=1) {
  color("DarkGreen", alpha) render() {
    difference() {

      // Body
      translate([BoltBodyMinX(),0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=ReceiverIR(),
                        r2=CHAMFER,
                        h=BoltBodyLength(),
                        $fn=Resolution(30,80));

      if (!cutter)
      BoltVitamin(cutter=true);

      // Ejector Cutout
      if (!cutter)
      translate([0,0,0])
      rotate([0(),0,0])
      translate([BoltMaxX()+ManifoldGap(), 0,0])
      linear_extrude(height=EjectorHeight()+0.02, center=true) {
        polygon(points=[
          [-1.38,-PipeOuterRadius(RECEIVER_PIPE)],
          [ManifoldGap(),
           -PipeOuterRadius(RECEIVER_PIPE)],
          [ManifoldGap(),
           0],
          [-BoltHexHeight(BOLT)-ManifoldGap(),
           0],
          [-BoltHexHeight(BOLT)-ManifoldGap(),
           -BoltCapRadius(BOLT)],
          [-1.38,
           -BoltCapRadius(BOLT)],
        ]);

        hull() for (X = [0.1,-0.25])
        translate([-BoltBodyLength()+X,-PipeInnerRadius(RECEIVER_PIPE)])
        rotate(0)
        Teardrop(r=BoltCapRadius(BOLT), $fn=Resolution(12,40));
        //square([PipeInnerRadius(RECEIVER_PIPE),PipeInnerRadius(RECEIVER_PIPE)]);
      }

      if (!cutter)
      translate([BoltBodyMinX(),0,0])
      Sear(cutter=true, length=SearLength()+0+SearTravel(), crosspin=false);

      // Cutout for magazine and feedlips
      difference() {

        /* Magazine cutout that tapers towards the end.
         * Taper centers the bolt on the sear
         */
        hull() {
          union() {
            hull()
            for (X = [BoltTravel(),0])
            translate([X,0,0])
            ElToro_Magazine();

            translate([BoltBodyMinX()+(RodDiameter(SearRod())),0,0])
            Sear(cutter=true, length=SearLength()+0+SearTravel());
          }
        }

        /* Leave a chamfered cutout between the feedlips.
         * this rides over the top of the next round/follower.
         */
        translate([BoltMaxX()-BoltHexHeight(BOLT)-BoltBodyLength(),
                   0,
                   0-BoltRadius(BOLT)+ManifoldGap()])
        rotate([0,90,0])
        linear_extrude(height=BoltBodyLength())
        union() {
          translate([0,-0.125])
          square([BoltHexRadius(BOLT)-BoltRadius(BOLT)+ManifoldGap(),0.25]);

          for (m = [0,1]) mirror([0,m])
          translate([0,0.125])
          RoundedBoolean(edgeOffset=0, edgeSign=1, r=0.125);
        }
      }

      // Chamfer the magazine cutout
      for (M = [0,1]) mirror([0,M,0])
      translate([BoltMaxX(),0,0-ReceiverIR()])
      linear_extrude(height=ReceiverIR())
      rotate(90)
      RoundedBoolean(edgeOffset=(MagazineWidth(MAGAZINE)/2), edgeSign=1, angle=0,
                     r=0.1875, teardrop=true);
    }
  }
}

module PipeBoltTail() {
  color("Green") render()
  difference() {
    translate([BoltMaxX()-BoltRodLength()-BoltHexHeight(BOLT)+1,
               0,
               0])
    rotate([0,-90,0])
    hull() {
      *ChamferedCylinder(r1=NutHexRadius(BOLT, clearance=true),
                        r2=0.125,
                        h=0.75,
                        $fn=Resolution(30,80));

      //translate([0,0,1])
      ChamferedCylinder(r1=BoltRadius(BOLT, clearance=true)+0.0625,
                        r2=CHAMFER,
                        h=1,
                        $fn=Resolution(30,80));
    }

    BoltVitamin(cutter=true);
  }

}

module ElToro_Barrel(cutter=false, hollow=true) {
  color("SlateGray") render()
  union() {
    translate([BarrelX()+(cutter?-ManifoldGap():0),0,0])
    rotate([0,90,0])
    cylinder(r=0.75/2, h=BarrelLength(), $fn=Resolution(20,60));
  }
}

module ElToro_Forend(cutaway=false, alpha=1) {
  ejectionPortLength = ForendMaxX()-LowerMaxX();
  CR = Inches(1/16);

  // Branding text
  color("DimGrey", alpha) render()
  Cutaway(cutaway) {

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

  color("Tan", alpha=alpha) render()
  Cutaway(cutaway)
  difference() {

    union() {

      // Receiver extension
      translate([ForendMaxX(),0,0])
      Receiver_Segment(length=ForendMaxX(), highTop=false,
                       chamferFront=true, chamferBack=true);
    }

    ElToro_Barrel(cutter=true, hollow=false);

    // Ejection port
    translate([EjectionPortMinX(),0, -EjectionPortHeight()/2])
    cube([EjectionPortLength(), 2, EjectionPortHeight()]);

    *PipeBolt(cutter=true);

    ElToro_Magazine();

    *PipeBoltGuideTaper(cutter=true);
  }
}

module ElToro_Magwell(alpha=1) {
  color("Tan", alpha=alpha) render()
  translate([BarrelX()-MagazineOffsetX(MAGAZINE)-MagazineLength(MAGAZINE)+MagazineWallBack(),0,ReceiverBottomZ()])
      translate([MagazineWallBack(),0,-MagwellDepth(MAGAZINE)])
      Magwell(spec=MAGAZINE, doRender=false,
              wallBack=MagazineWallBack(), wallFront=MagazineWallFront());
}


module ElToro(hardware=_SHOW_HARDWARE, prints=_SHOW_PRINTS,
                      cutaway=false) {

  ElToro_Magazine(doRender=true);
  ElToro_Magwell();

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
  ElToro_Barrel();
  ElToro_Forend();
}

//$t = AnimationDebug(step=ANIMATION_STEP_FIRE
//                    ,start=ANIMATION_SUBSTEP_FIRE_EJECTORTRIP_START-0.02
//                    ,end=ANIMATION_SUBSTEP_FIRE_EJECTORTRIP_END+0.02
//);
//$t = AnimationDebug(step=ANIMATION_STEP_CHARGE, T=round($t),
//                    start=ANIMATION_SUBSTEP_CHARGE_EJECT_START,
//                    end=ANIMATION_SUBSTEP_CHARGE_EJECT_END);


if ($preview) {

  ElToro(hardware=_SHOW_HARDWARE, prints=_SHOW_PRINTS,
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
ElToro_Trunnion();

*!scale(25.4)
rotate([0,90,0])
translate([-(BarrelX()+TrunnionExtension()+ShaftCollarWidth()+0.5),0,-0])
ElToro_TrunnionCap();

*!scale(25.4)
translate([-LowerMaxX(),0,0])
ElToro_Magwell();

}
