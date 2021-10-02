use <../../Meta/Debug.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Shapes/Components/Bipod.scad>;
use <../../Shapes/Components/T Lug.scad>;
use <../../Shapes/Chamfer.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Square Tube.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/AR15/Barrel.scad>;
use <../../Vitamins/AR15/Bolt.scad>;

use <../../Receiver/Lower/Lower.scad>;
use <../../Receiver/Lower/Lugs.scad>;
use <../../Receiver/Lower/LowerMount.scad>;
use <../../Receiver/Receiver.scad>;
use <../../Receiver/Frame.scad>;
use <../../Receiver/Stock.scad>;

use <../../Receiver/Components/AR15 Trunnion.scad>;
use <../../Receiver/Magwells/AR15 Magwell.scad>;

/* [Export] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "BARBB_Forend", "BARBB_BoltCarrier"]

// Reorient the part for printing?
_RENDER_PRINT = true;

/* [Assembly] */
_SHOW_RECEIVER = true;
_SHOW_FOREND = true;
_SHOW_BUTTPAD = true;
_SHOW_MAGWELL = true;
_SHOW_BARREL = true;
_SHOW_BOLT = true;
_SHOW_BOLT_CARRIER = true;
_SHOW_FCG = true;

_CUTAWAY_RECEIVER = false;
_CUTAWAY_FOREND = false;
_CUTAWAY_MAGWELL = false;

_ALPHA_FOREND = 1; // [0:0.1:1])
_ALPHA_MAGWELL = 1; // [0:0.1:1]

/* [Vitamins] */

/* [Fine Tuning] */
barrelLength=24;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

// Bullpup AR Barrel Bolt-action (BARBB)
BARREL_PIPE = Spec_TubingZeroPointSevenFive();
RECEIVER_PIPE = Spec_OnePointFiveSch40ABS();
BOLT = BoltSpec("1-2\"-13");;

// Configured Values
tubeWall = 0.25;
barrelWall = 0.25;
barrelOffset = 1;
barrelExtensionLandingHeight = 0.3;
chamferRadius = 0.1;

barrelX = 0; // To the back of the barrel extension
stockWall = 0;


// Measured Values
hammerWidth = (5/16)+0.02;
tube_width =1.015;// 0.75;
tubeInnerWidth = 1-(1/8);
springRadius = 0.75/2;
springLength = 3;
gasShaftCollarWidth = 9/16;
gasShaftCollarOD    = 1.25;


magwellX = -2.675;
magwellZ = -0.4375;
magwellWallFront = 0.125;
magwellWallBack = 0.25;

// Calculated Values
boltCarrierRadius   = ReceiverIR()-0.01;


tubeCenterZ = tubeWall+(tube_width/2);
boltLockedMinX = barrelX-AR15_BoltLockedLength();
boltLockedMaxX = barrelX+AR15_BoltLockLengthDiff();


lowerLength = LowerMaxX()+abs(ReceiverLugRearMinX())+0.25;
lowerX = -ReceiverLugFrontMinX()+AR15BarrelGasLength()+gasShaftCollarWidth;
                
camPinLockedMaxX = boltLockedMaxX -AR15_CamPinOffset();
camPinLockedMinX = camPinLockedMaxX -AR15_CamPinDiameter();

forendLength = AR15BarrelExtensionLength()+abs(magwellX)+magwellWallFront; //+abs(camPinLockedMaxX)+AR15BarrelExtensionLipLength()-0.01
forendMinX = -forendLength+AR15BarrelExtensionLength()+AR15BarrelExtensionLipLength();
forendMaxX = forendMinX+forendLength;

firingPinMinX  = boltLockedMinX -AR15_FiringPin_Extension();
hammerMaxX = firingPinMinX;
hammerMinX = firingPinMinX;

stockMinX = hammerMinX-stockWall;
stockLength=abs(hammerMinX)+forendMinX+stockWall;

boltCarrierLength = stockLength
                + barrelExtensionLandingHeight;
handleLength=abs(hammerMinX-hammerMaxX)+AR15_FiringPin_Extension();
handleMinX = stockMinX;//+stockWall;

function AR15_CamPinAngleExtra() = 0;

module BARBB_CamPinCutout(clearance=0.01, chamferBack=false) {
  clear2 = clearance*2;
  camPinSquareArc = 360/(PI*2*(AR15BarrelExtensionRadius()+barrelWall)/AR15_CamPinSquareWidth());
  
  // Cam Pin cutout
  render()
  rotate(AR15_CamPinAngleExtra())
  translate([0,0,AR15_CamPinOffset()])
  union() {
    
    // Cam pin linear travel
    translate([0,-(AR15_CamPinSquareWidth()/2)-clearance,ManifoldGap()])
    cube([AR15_CamPinSquareOffset()+AR15_CamPinSquareHeight()+clearance,
          AR15_CamPinSquareWidth()+clear2,
          abs(stockMinX-camPinLockedMaxX)+ManifoldGap()]);
    
    // Cam pin rotation arc
    translate([0,0,-clearance-ManifoldGap()])
    linear_extrude(height=AR15_CamPinDiameter()+AR15_CamPinShelfLength()+clear2+ManifoldGap(2)) {
      rotate(camPinSquareArc/2)
      semicircle(od=(AR15_CamPinSquareOffset()
                    +AR15_CamPinSquareHeight()
                    +barrelWall)*3,
                 angle=AR15_CamPinAngle()+AR15_CamPinAngleExtra()+camPinSquareArc);
      
      // Cam Pin Square, locked position
      rotate(-AR15_CamPinAngleExtra()-AR15_CamPinAngle())
      translate([0,-(AR15_CamPinSquareWidth()/2)-0.01])
      square([AR15_CamPinSquareOffset()+AR15_CamPinSquareHeight()+barrelWall, AR15_CamPinSquareWidth()+0.02]);
      
      // Cam Pin Square, Unlocked position
      translate([0,-(AR15_CamPinSquareWidth()/2)-0.01])
      square([AR15_CamPinSquareOffset()+AR15_CamPinSquareHeight()+barrelWall, AR15_CamPinSquareWidth()+0.02]);
    }
  }
}

module BARBB_HammerCutOut(extraX=0) {
  
  // X-Zero on the firing pin's back face
  translate([hammerMinX,-hammerWidth/2,tubeCenterZ-(hammerWidth/2)]) {
    
    // Hammer linear track
    cube([abs(hammerMaxX-hammerMinX)+extraX,
          hammerWidth,
          abs(-tubeCenterZ+(hammerWidth/2)+AR15_FiringPin_ShoulderRadius())]);
    
    
    // Hammer rotary track
    rotate([0,90,0])
    linear_extrude(height=hammerWidth)
    rotate(-90)
    semicircle(od=abs((-tubeCenterZ+(hammerWidth/2)+AR15_FiringPin_ShoulderRadius())*2), angle=90);
    
    // Hammer rotary track, rounded inside corner)
    translate([hammerWidth,0,0])
    linear_extrude(height=-tubeCenterZ+(hammerWidth/2)+AR15_FiringPin_ShoulderRadius())
    rotate(180)
    RoundedBoolean(edgeOffset=0, edgeSign=-1, r=hammerWidth);
  }
}


module BARBB_Forend(clearance=0.01, debug=false, alpha=1) {
  color("Tan", alpha) render()
  DebugHalf(enabled=debug)
  difference() {
    translate([AR15_TrunnionLength(),0,0])
    Receiver_Segment(length=forendLength);
    
    // Barrel center axis
    translate([forendMinX,0,0]) {
    
      // Bolt Head Passage
      rotate([0,90,0])
      cylinder(r=AR15_BoltHeadRadius()+clearance, h=forendLength+ManifoldGap(2));
    
      // Bolt Sleeve  Passage
      translate([-ManifoldGap(),0,0])
      rotate([0,90,0])
      cylinder(r=boltCarrierRadius+clearance,
               h=barrelExtensionLandingHeight+ManifoldGap(2));
      
      // Chamfer the bolt passage inside diameter
      rotate([0,90,0])
      HoleChamfer(r1=boltCarrierRadius+clearance, r2=chamferRadius, teardrop=true);
      
      // Barrel Extension Rear Support Cone
      translate([barrelExtensionLandingHeight,0,0])
      rotate([0,90,0])
      cylinder(r1=boltCarrierRadius+clearance, r2=AR15_BoltHeadRadius()+0.008,
               h=boltCarrierRadius/3);
    }
    
    // Bolt Track
    translate([stockMinX-ManifoldGap(),0,0])
    rotate([0,90,0])
    ChamferedCircularHole(r1=boltCarrierRadius+(clearance*2), r2=chamferRadius,
                           h=stockLength+ManifoldGap(2));
    
    BARBB_HammerCutOut(extraX=1);
    
    translate([magwellX,0,magwellZ])
    AR15_MagwellInsert(extraTop=abs(magwellZ));
    
    rotate([0,90,0])
    rotate(180)
    AR15_Barrel(clearance=0.005);
  }
}

module BARBB_Magwell(alpha=1, debug=false) {
  color("Chocolate", alpha=alpha) render()
  DebugHalf(enabled=debug)
  difference() {
    
    translate([magwellX,0,magwellZ])
    AR15_Magwell(wallFront=magwellWallFront, wallBack=magwellWallBack, cut=false);
    
    // Cutout the central hole
    rotate([0,-90,0])
    cylinder(r=ReceiverIR(), h=abs(magwellX)+magwellWallFront+magwellWallBack);
    
    translate([magwellX,0,magwellZ])
    AR15_MagwellInsert();
  }
}


module BARBB_BoltCarrier(clearance=0.01) {
  chamferClearance = 0.01;
  
  echo("boltCarrierLength", boltCarrierLength);
  
  render()
  difference() {
    
    translate([stockMinX,0,0])
    rotate([0,90,0])
    union() {
      
      // Body
      ChamferedCylinder(r1=boltCarrierRadius,
                        r2=chamferRadius,
                        h=boltCarrierLength);
      
      // Cam Pin Shelf
      // This keeps the bolt forward while we rotate across several lug positions
      // while also allowing a longer opening for ejection.
      if (AR15_CamPinShelfLength()+clearance > clearance)
      rotate(90+AR15_CamPinAngle()+AR15_CamPinAngleExtra())
      translate([0,-AR15_CamPinSquareWidth()/2,
                 boltCarrierLength
                 +barrelExtensionLandingHeight
                 +AR15_BoltLockLengthDiff()
                 -AR15_CamPinOffset()-AR15_CamPinDiameter()-AR15_CamPinShelfLength()])
      ChamferedCube([boltCarrierRadius+AR15_CamPinSquareHeight()-clearance,
                     AR15_CamPinSquareWidth(),
                     AR15_CamPinShelfLength()-clearance], r=AR15_CamPinSquareHeight()/3);
    }
     
    #translate([boltLockedMaxX,0,0])
    rotate([0,-90,0]) {
      AR15_Bolt(camPin=false, teardrop=false, firingPinRetainer=false);
      
      BARBB_CamPinCutout(chamferBack=false);
    }
    
    // Hammer Safety Catch
    translate([hammerMinX,0,tubeCenterZ+hammerWidth])
    mirror([0,0,1])
    cube([hammerWidth, 10, tubeCenterZ]);
    
    // Firing Pin Rear Hole Chamfer
    translate([stockMinX,0,0])
    rotate([0,90,0])
    HoleChamfer(r1=AR15_FiringPin_ShoulderRadius()+(clearance*2), r2=chamferRadius, teardrop=true);
    
    translate([boltLockedMaxX,0,0])
    rotate([0,-90,0])
    AR15_Bolt(firingPinRetainer=false);
    
    // Hammer Track
    translate([hammerMinX,0,0])
    rotate([0,90,0]) {
    
      // Hammer Pin Cocking Ramp
      intersection() {
        
        linear_extrude(height=hammerWidth,
                        twist=(AR15_CamPinAngleExtra()),
                       slices=$fn*2)
        rotate(AR15_CamPinAngleExtra())
        translate([0,-hammerWidth*3.5])
        square([barrelOffset, hammerWidth*4]);
      
        linear_extrude(height=(hammerWidth*2))
        rotate(180)
        semicircle(od=(AR15_FiringPin_ShoulderRadius())*2, angle=90);
      }
    
      // Hammer travel
      translate([0,-(hammerWidth/2),0])
      cube([barrelOffset, hammerWidth, hammerWidth]);
    }
  }
}


module BARBB_Assembly() {
  rotate([0,90,0]) {
    rotate(180)
    if (_SHOW_BARREL)
    AR15_Barrel(length=barrelLength);
      
    color("LightGrey") {
      
      // Gas block shaft collar
      translate([0,0,AR15BarrelGasLength()+ManifoldGap(2)])
      cylinder(r=gasShaftCollarOD/2, h=gasShaftCollarWidth);
      
      // Suppressor
      *translate([0,0,barrelLength-0.5])
      ChamferedCylinder(r1=(1.625/2), r2=chamferRadius, h=9);
    }
  }

  if (_SHOW_BOLT)
  color("DimGrey")
  translate([boltLockedMaxX,0,0])
  rotate([0,-90,0])
  AR15_Bolt(teardrop=false, firingPinRetainer=false);
  
  if (_SHOW_BOLT_CARRIER)
  color("Olive")
  BARBB_BoltCarrier();
  
  if (_SHOW_FOREND)
  BARBB_Forend(debug=_CUTAWAY_FOREND, alpha=_ALPHA_FOREND);
  
  if (_SHOW_RECEIVER)
  translate([forendMinX,0,0])
  Receiver(debug=_CUTAWAY_RECEIVER, doRender=true);
  
  if (_SHOW_BUTTPAD)
  translate([magwellX-ReceiverLength()+StockLength(),0,0])
  Stock_Buttpad();
  
  if (_SHOW_MAGWELL)
  BARBB_Magwell(alpha=_ALPHA_MAGWELL, debug=_CUTAWAY_MAGWELL);
  
  *translate([AR15BarrelGasLength()+2,0,0]) {
    translate([-3,0,0]) {
      ChargingRod(length=18, minX=-8.5);
      ChargingPump();
    }
    
  }
}


if ($preview) {
  BARBB_Assembly();
} else scale(25.4) {

  // *****************
  // * Printed Parts *
  // *****************
  if (_RENDER == "BARBB_Forend")
    if (!_RENDER_PRINT)
      BARBB_Forend();
    else
      rotate([0,-90,0])
      BARBB_Forend();
  
  if (_RENDER == "BARBB_UpperReceiver")
    if (!_RENDER_PRINT)
      BARBB_UpperReceiver();
    else
      rotate([0,-90,0])
      BARBB_UpperReceiver();

  if (_RENDER == "BARBB_BoltCarrier")
    if (!_RENDER_PRINT)
      BARBB_BoltCarrier();
    else
      rotate([0,-90,0])
      BARBB_BoltCarrier();
  
}