include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Math/Circles.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/RenderIf.scad>;

use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Helix.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/AR15/Barrel.scad>;
use <../../Vitamins/AR15/Bolt.scad>;

use <../Components/AR15 Trunnion.scad>;
use <../Magwells/AR15 Magwell.scad>;

use <../Buttstock.scad>;
use <../Receiver.scad>;
use <../Lower/Lower.scad>;
use <../Lower/Mount.scad>;
use <../Frame.scad>;
use <../Charging Pump.scad>;

/* [What to Render] */

// Assembly is not for printing.
_RENDER = "Assembly"; // ["Assembly", "Forend", "Bolt Carrier", "Bolt Carrier Track"]

SHOW_BOLT_CARRIER = true;

// Cut assembly view in half
_DEBUG_ASSEMBLY = false;

// Show receiver cutters
_DEBUG_CUTTERS = false;

function ReceiverFrontLength() = 0.5;

// Measured: Vitamins
function BarrelCollarDiameter() = 1.75;
function BarrelCollarDiameter() = 1.25;
function BarrelCollarRadius() = BarrelCollarDiameter()/2;
function BarrelCollarWidth() = 5/8;

// Settings: Vitamins
function ReceiverPipe()  = Spec_OnePointFiveSch40ABS();
function ReceiverPipe()  = Spec_OnePointSevenFivePCTube();
function ActuatorRod() = Spec_RodOneQuarterInch();
function ChargingRod() = Spec_RodOneHalfInch();
function ChargingExtensionRod() = Spec_RodOneHalfInch();
function IndexLockRod() = Spec_RodOneQuarterInch();

function BarrelExtraOffset() = AR15_MagazineRearTabLength()+0.125+0.1+0.375;
function BarrelLength() = 16;
function BarrelMinX() = AR15_BoltLockedLength()+BarrelExtraOffset();
function WallBarrel() = 0.25;
function MagazineMinX() = BarrelMinX()-0.125
                        - AR15_MagazineBaseLength()
                        - AR15_MagazineRearTabLength();

// Calculated: Positions
function ActionRodZ() = 0.75+(1/32);
function FrameFrontMinX() = BreechFrontX()+3;

function ForendMinX() = 0;
function ForendLength() = BarrelMinX()
             + AR15BarrelExtensionLipLength()
             + AR15BarrelExtensionLength()
             - ForendMinX();

chamferClearance = 0.01;
barrelRearWall = 0;
boltCarrierDiameter = AR15BarrelExtensionDiameter();
boltCarrierRadius = boltCarrierDiameter/2;
boltCarrierRearWall=0.1875;
boltCarrierRearExtension=0;
boltCarrierTrackRadius = boltCarrierRadius+AR15_CamPinSquareHeight()+0.05;

boltCarrierLength = AR15_BoltLockedLength()
                  - barrelRearWall
                  + AR15_FiringPinExtension()
                  + boltCarrierRearExtension;

boltCarrierMinX = BarrelMinX()
                - barrelRearWall
                - AR15_BoltLockedLength()
                - AR15_FiringPinExtension()
                - boltCarrierRearExtension;
                
helixBottom = 0.1875;
                
camPinLockedX = BarrelMinX()-AR15_CamPinOffset()-0.5;

// ************
// * Vitamins *
// ************
module ActionRod(width=0.25, length=12, cutter=false, clearance=0.005) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  translate([0,-(width/2)-clear, -(width/2)-clear])
  cube([length, width+clear2, width+clear2]);
}

module BarrelCollar(clearance=0.002, cutter=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") DebugHalf(enabled=debug)
  difference() {
    translate([BarrelMinX()+ManifoldGap(),0,0])
    rotate([0,90,0])
    cylinder(r=BarrelCollarRadius()+clear,
             h=BarrelCollarWidth()*3, $fn=40);

    Barrel(hollow=false, cutter=true);
  }
}

module Barrel(barrelLength=BarrelLength(), hollow=true,
              cutter=false, clearance=undef,
              alpha=1, debug=false) {
  
  color("DimGrey") RenderIf(!cutter)
  translate([BarrelMinX(),0,0])
  rotate([0,90,0])
  rotate(180)
  AR15_Barrel(cutter=cutter);
}
module Bolt(cutter=false, clearance=0.005) {
  translate([BarrelMinX()+AR15_BoltLockLengthDiff(),0,0])
  rotate([0,-90,0])
  color("DimGrey") render()
  AR15_Bolt(teardrop=cutter,
            firingPinRetainer=false,
            extraFiringPin=0,            
            extraCamPinSquareHeight=(cutter?1:0),
            extraCamPinSquareLength=cutter?1:0,
            clearance=(cutter?clearance:0));
}



// ***********
// * Cutters *
// ***********
module BoltCarrierMagazineTrack(length=boltCarrierLength, clearance=0, clearanceAngle=0) {
    translate([boltCarrierMinX,0,0])
    rotate([0,90,0])
    linear_extrude(height=length+ManifoldGap(2))
    rotate(45+AR15_CamPinAngle()+(clearanceAngle/2))
    semidonut(major=ReceiverID(),
              minor=(AR15_BoltFrontRadius()+(1/16)+clearance)*2,
              angle=95+AR15_CamPinAngle()+clearanceAngle, $fn=50);
}
    
  


module ReceiverBoltTrack(length=2.5, alpha=1) {

  color("OliveDrab", alpha) render()
  difference() {
    translate([ForendMinX(),0,0])
    difference() {
      *translate([ForendMinX(),0,0])
      mirror([1,0,0])
      ReceiverSegment(length=length);
    
      translate([ForendMinX()+0.25,-(ReceiverBottomSlotWidth()/2),0])
      mirror([1,0,0])
      ChamferedCube([length+0.25, ReceiverBottomSlotWidth(), (7/8)+0.01], r=1/16);

      translate([ForendMinX(),0,0])
      rotate([0,-90,0])
      ChamferedCylinder(r1=ReceiverIR()-0.005, r2=1/32,
                         h=length,
                        teardropTop=true,
                        $fn=Resolution(30,60));
    }
    
    ReceiverCutters();
  }
}

module ReceiverCutters() {
    
  FrameBolts(cutter=true);
  
  color("Silver")
  union() {
    // Action rod main hole
    translate([0,0,ActionRodZ()])
    ActionRod(cutter=true);
    
    // Action rod pin travel slot
    hull() for (Z = [0, ActionRodZ()]) translate([0,0,Z])
    translate([-FrameReceiverLength(),0,0])
    ActionRod(length=2+FrameReceiverLength(), cutter=true);
  }
  
  color("LightGreen")
  union() {
    
    // Bolt Carrier Locked
    rotate([-22.5,0,0])
    BoltCarrier(cutter=true);
    
    // Bolt Carrier (unlocked+travel)
    union() for (X = [0:-1:-3]) translate([X,0,0])
    BoltCarrier(cutter=true);
  }
  
  Barrel(cutter=true);

  color("LightBlue")  
  union() {
    
    // Ejection slot
    rotate([-AR15_CamPinAngle(),0,0])
    mirror([0,1,0])
    translate([ReceiverFrontLength(),0,-0.5/2])
    ChamferedCube([BarrelMinX()-ReceiverFrontLength(),
                   AR15BarrelExtensionLipRadius()+WallBarrel()+1,
                   0.5], r=1/16);
                   
    // Ejection slot forward bevel
    rotate([-AR15_CamPinAngle(),0,0])
    translate([BarrelMinX()-0.25,
                -AR15_BoltHeadRadius(),
                -0.5/2])
    mirror([0,1,0])
    rotate(40)
    ChamferedCube([BarrelMinX()-barrelRearWall,
                   AR15BarrelExtensionLipRadius()+WallBarrel()+1,
                   0.5], r=1/16);
  }

  color("Orange")
  translate([MagazineMinX(),0,-0.5-0.25])
  AR15_MagwellInsert(catch=true,
                     extraTop=0.75);
  
  mirror([1,0,0])
  TensionBolts(cutter=true, nutType="none", length=12);
}


// **********
// * Shapes *
// **********
module BoltCarrierCamTrackSupport(cutter=false, clearance=0.008) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  trackRadius = boltCarrierTrackRadius;
  trackLength = boltCarrierLength
              - AR15_CamPinOffset()
              + AR15_BoltLockLengthDiff()
              + AR15_CamPinDiameter();
  
  translate([boltCarrierMinX,0,0])
  rotate([0,90,0])
  intersection() {
    linear_extrude(height=trackLength)
    hull() {
      rotate(180+11.25)
      semicircle(od=(boltCarrierTrackRadius+clear)*2,
                angle=90-AR15_CamPinAngle() +(cutter?1:0), center=true, $fn=50);
      
      circle(r=ArcLength(90-AR15_CamPinAngle(),
                         (boltCarrierDiameter/2)+AR15_CamPinSquareHeight())/2,
           $fn=50);
    }
    
    ChamferedCylinder(r1=boltCarrierTrackRadius+clear,
                      r2=boltCarrierTrackRadius/2,
                       h=trackLength,
                      teardropTop=true, chamferBottom=false, $fn=50);
  }
}


// *****************
// * Printed Parts *
// *****************
module BoltCarrier(cutter=false, clearance=0.01, chamferRadius=1/16, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Tan", alpha) RenderIf(!cutter)
  difference() {
    
    union() {
      translate([boltCarrierMinX,0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=boltCarrierRadius+clear,
                        r2=AR15BarrelExtensionDiameter()-AR15_BoltHeadDiameter(),
                        h=boltCarrierLength,
                        teardropTop=true, chamferBottom=false,
                        $fn=50);
      
      BoltCarrierCamTrackSupport(clearance=clear);
    }
    
    translate([-ManifoldGap(),0,0])
    BoltCarrierMagazineTrack(clearance=clear);
    
    if (!cutter) {
      
      Bolt(cutter=true);
      
      translate([camPinLockedX,0,0]) 
      rotate([0,-90,0])
      rotate(-AR15_CamPinAngle())
      *HelixSegment(radius=boltCarrierTrackRadius,
                    width=ActionRodWidth()+0.02, depth=0.1875,
                    top=0, bottom=helixBottom,
                    angle=-AR15_CamPinAngle());
    }
  }
}

module BoltCarrier_print() {
  rotate([0,-90,0])
  BoltCarrier();
}


module AR15Forend(debug=false, alpha=1) {
  length = ForendLength();
  
  color("MediumSlateBlue", alpha)
  DebugHalf(enabled=debug) render()
  difference() {
    union() {
      translate([ForendMinX(),0,0])
      mirror([1,0,0])
      ReceiverSegment(length=length);
      
      translate([MagazineMinX(),0,-0.5])
      AR15_Magwell(cut=false,
                   height=AR15_MagwellDepth()+0.125,
                   wallFront=0, wallBack=0.375+AR15_MagazineRearTabLength(),
                   wall=0.125);
    }
    
    ReceiverCutters();
  }
}
module AR15ForendCap(debug=false, alpha=1) {
  length = 7.5;
  
  color("SlateBlue", alpha)
  DebugHalf(enabled=debug) render()
  difference() {
    union() {
      translate([ForendMinX()+ForendLength(),0,0])
      mirror([1,0,0])
      ReceiverSegment(length=length);
    }
    
    ReceiverCutters();
  }
}

if (_RENDER == "Assembly") {
  
  if (_DEBUG_CUTTERS)
  ReceiverCutters();

  translate([-1-2,0,0])
  *HammerAssembly(insertRadius=0.75, alpha=1);

  Barrel();
  BarrelCollar();

  animate_unlock1 = SubAnimate(ANIMATION_STEP_UNLOCK, end=0.25)
                 - SubAnimate(ANIMATION_STEP_LOCK, start=0.75);

  animate_unlock2 = SubAnimate(ANIMATION_STEP_UNLOCK, start=0.25)
                 - SubAnimate(ANIMATION_STEP_LOCK, end=0.75);

  // Motion-coupled: Bolt carrier and action rod
  if (SHOW_BOLT_CARRIER)
  translate([(-BarrelMinX()-0.5)*animate_unlock2,0,0]) {
    
    translate([-0.875*animate_unlock1,0,ActionRodZ()]) {
      translate([boltCarrierMinX,0,0])
      ActionRod(length=10);

      *translate([camPinLockedX+helixBottom,0,0])
      ActionRodBolt(angle=180,
                   length=ActionRodZ()
                         -(ActionRodWidth()/2)
                         -AR15_BoltHeadRadius()
                         -AR15_CamPinSquareOffset()
                         +AR15_CamPinSquareHeight()+0.1875);

      *ChargingPump();
    }

    rotate([-AR15_CamPinAngle()*(1-animate_unlock1),0,0]) {
      Bolt();
      
      BoltCarrier(alpha=1);
    }
  }

  ReceiverBoltTrack(alpha=0.25);

  AR15Forend();
  AR15ForendCap();

  ReceiverAssembly();
  StockAssembly();
  
  translate([-LowerMaxX(),0,LowerOffsetZ()])
  Lower();
  LowerMount();

}

scale(25.4) {
  if (_RENDER == "Bolt Carrier")
    BoltCarrier_print();

  if (_RENDER == "Forend")
    rotate([0,-90,0])
    AR15Forend();
  
  if (_RENDER == "Bolt Carrier Track")
  rotate([0,90,0])
  ReceiverBoltTrack();
}


