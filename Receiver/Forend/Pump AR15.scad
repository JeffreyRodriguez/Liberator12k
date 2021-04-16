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
use <../../Shapes/Teardrop.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/AR15/Barrel.scad>;
use <../../Vitamins/AR15/Bolt.scad>;

use <../Components/AR15 Trunnion.scad>;
use <../Magwells/AR15 Magwell.scad>;

use <../Buttstock.scad>;
use <../Receiver.scad>;
use <../Fire Control Group.scad>;
use <../Lower/Lower.scad>;
use <../Lower/Mount.scad>;
use <../Frame.scad>;
use <../Charging Pump.scad>;

/* [Print] */

// Assembly is not for printing.
_RENDER = ""; // ["", "Forend", "Bolt Carrier", "Handguard"]

/* [Preview] */
_SHOW_ACTION_ROD = true;
_SHOW_RECEIVER = true;
_SHOW_BARREL = true;
_SHOW_BOLT = true;
_SHOW_BOLT_CARRIER = true;
_SHOW_FCG = true;
_SHOW_FOREND = true;
_SHOW_HANDGUARD = true;
_SHOW_STOCK = true;
_SHOW_LOWER = true;
_CUTAWAY_RECEIVER = false;
_CUTAWAY_BOLT_CARRIER = false;
_CUTAWAY_FOREND = false;
_CUTAWAY_HANDGUARD = false;
_CUTAWAY_STOCK = false;
_ALPHA_RECIEVER = 1; // [0:0.1:1]
_ALPHA_BOLT_CARRIER = 1; // [0:0.1:1]
_ALPHA_FOREND = 1; // [0:0.1:1]
_ALPHA_HANDGUARD = 1; // [0:0.1:1]

// Cut assembly view in half
_DEBUG_ASSEMBLY = false;

/* [Vitamins] */

/* [Fine Tuning] */

/* [Branding] */


function ReceiverFrontLength() = 0.5;

// Measured: Vitamins
function BarrelCollarDiameter() = 1.75;
function BarrelCollarDiameter() = 1.25;
function BarrelCollarRadius() = BarrelCollarDiameter()/2;
function BarrelCollarWidth() = 5/8;

// Settings: Vitamins
function BarrelExtraOffset() = AR15_MagazineRearTabLength()+0.125+0.125;
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
             + AR15BarrelExtensionLength()
             - ForendMinX();

chamferClearance = 0.01;
boltCarrierClearance = 0.01;
boltCarrierRadius = ReceiverIR()-0.01;
boltCarrierChamferRadius = (ReceiverID()-AR15_BoltHeadDiameter())/2;
boltCarrierRearWall=0.1875;
boltCarrierRearExtension=0;
boltCarrierTrackRadius = boltCarrierRadius+AR15_CamPinSquareHeight()+0.05;

boltCarrierLength = AR15_BoltLockedLength()
                  + AR15_FiringPinExtension()
                  + boltCarrierRearExtension;

boltCarrierMinX = BarrelMinX()
                - AR15_BoltLockedLength()
                - AR15_FiringPinExtension()
                - boltCarrierRearExtension;

helixBottom = 0.1875;

// ************
// * Vitamins *
// ************
module ActionRod(width=0.25, length=12, cutter=false, clearance=0.005) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver") RenderIf(!cutter)
  translate([0,-(width/2)-clear, -(width/2)-clear])
  cube([length, width+clear2, width+clear2]);
}

module BarrelCollar(clearance=0.002, cutter=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
    
  // Gas block shaft collar
  color("Silver") DebugHalf(enabled=debug)
  translate([BarrelMinX()+AR15BarrelGasLength(),0,0])
  rotate([0,90,0])
  cylinder(r=BarrelCollarRadius()+clear, h=BarrelCollarWidth(), $fn=40);
}

module Barrel(barrelLength=BarrelLength(), cutter=false, clearance=0.005, alpha=1, debug=false) {
  
  color("DimGrey") RenderIf(!cutter)
  translate([BarrelMinX(),0,0])
  rotate([0,90,0])
  rotate(180)
  AR15_Barrel(cutter=cutter, clearance=clearance);
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

// **********
// * Shapes *
// **********
module MagazineFeedLips(length=boltCarrierLength, clearance=0, clearanceAngle=0) {
    translate([boltCarrierMinX,0,0])
    rotate([0,90,0])
    linear_extrude(height=length+ManifoldGap(2))
    rotate(45+(clearanceAngle/2))
    semidonut(major=ReceiverID()*2,
              minor=(AR15_BoltFrontRadius()+(1/16)+clearance)*2,
              angle=90+clearanceAngle, $fn=50);
}


// *****************
// * Printed Parts *
// *****************
module BoltCarrier(cutter=false, clearance=0.01, chamferRadius=1/16, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Olive", alpha) RenderIf(!cutter)
  DebugHalf(enabled=debug)
  difference() {
    
    union() {
      translate([boltCarrierMinX,0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=boltCarrierRadius+clear,
                        r2=boltCarrierChamferRadius,
                        h=boltCarrierLength,
                        teardropTop=true, chamferBottom=true,
                        $fn=70);
      
      // Wings
      intersection() {
        translate([boltCarrierMinX,0,0])
        mirror([1,0,0])
        ReceiverSideSlot(length=boltCarrierLength,
                         clearance=clear);
        
        hull() for (X = [0, boltCarrierLength-ReceiverIR()-0.0625])
        translate([boltCarrierMinX+X, 0, 0])
        linear_extrude(ReceiverIR(), center=true)
        Teardrop(r=ReceiverIR()+ReceiverSideSlotDepth()+clear,
                 truncated=true,
                 $fn=40);
      }
    }
    
    if (!cutter) {
      slotExtension = 0.125;
      
      rotate([-AR15_CamPinAngle(),0,0])
      Bolt(cutter=true);
    
      translate([-ManifoldGap(),0,0])
      MagazineFeedLips(clearance=clear, clearanceAngle=(cutter?0:2));
      
      // Helical section. Ugly, but it'll do... slowly.
      slices = 10;
      helixLength = 0.25;
      translate([AR15_BoltLockLengthDiff()-AR15_CamPinRadius()+slotExtension,0,0])
      rotate([180-AR15_CamPinAngle(),0,0])
      union()
      for (slice = [1:1:slices])
      hull() {
        
        translate([helixLength/slices*slice,0,0])
        rotate([0,90,0])
        rotate(AR15_CamPinAngle()/slices*slice)
        AR15_CamPin(rectangleTop=false, teardropAngle=180, teardropTruncate=true, clearance=0.005);
        
        translate([helixLength/slices*(slice-1),0,0])
        rotate([0,90,0])
        rotate(AR15_CamPinAngle()/slices*(slice-1))
        AR15_CamPin(rectangleTop=false, teardropAngle=180, teardropTruncate=true, clearance=0.005);
      }
      
      // Straight section
      translate([AR15_BoltLockLengthDiff()-AR15_CamPinRadius(),0,0])
      rotate([180-AR15_CamPinAngle(),0,0])
      rotate([0,90,0])
      hull() {
        AR15_CamPin(rectangleTop=false, clearance=0.005);
        
        translate([0,0,slotExtension])
        AR15_CamPin(rectangleTop=false, clearance=0.005);
      }
        
      
      // Rectangular portion rotation
      translate([-AR15_BoltLength()+AR15_CamPinOffset()-clearance-0.03,0,0])
      translate([BarrelMinX()+AR15_BoltLockLengthDiff(),0,0])
      //mirror([0,0,1])
      rotate([0,90,0])
      linear_extrude(height=2+AR15_CamPinDiameter()+(clearance*2))
      rotate(180-(AR15_CamPinAngle()/2))
      difference() {
        hull() {
          semicircle(od=(AR15_CamPinSquareOffset()
                        +AR15_CamPinSquareHeight()+0.05)*2,
                     angle=AR15_CamPinAngle()*2.67,
                     center=true, $fn=60);
          
          circle(r=AR15_CamPinSquareWidth()/2, $fn=30);
        }
        
        circle(r=(AR15_CamPinSquareOffset()-0.01), $fn=50);
      }
    }
  }
}

module BoltCarrier_print() {
  rotate([0,-90,0])
  BoltCarrier();
}


module AR15Forend(debug=false, alpha=1) {
  length = ForendLength();
  
  color("Tan", alpha) render()
  DebugHalf(enabled=debug)
  difference() {
    union() {
      translate([ForendMinX(),0,0])
      mirror([1,0,0])
      ReceiverSegment(length=length);
      
      translate([MagazineMinX(),0,-0.5])
      AR15_Magwell(cut=false,
                   height=AR15_MagwellDepth()+0.125,
                   wallFront=0.125, wallBack=AR15_MagazineRearTabLength(),
                   wall=0.125);
    }
    
    translate([BarrelMinX(),0,0])
    ReceiverTopSlot();
  
    Barrel(cutter=true);

    translate([MagazineMinX(),0,-0.5-0.25])
    AR15_MagwellInsert(catch=false,
                       extraTop=0.75);
    
    mirror([1,0,0])
    TensionBolts(cutter=true, nutType="none", length=12);
      
    // Action rod main hole
    translate([0,0,ActionRodZ()])
    ActionRod(cutter=true);
    
    // Action rod pin travel slot
    hull() for (Z = [0, ActionRodZ()]) translate([0,0,Z])
    translate([-FrameReceiverLength(),0,0])
    ActionRod(length=2+FrameReceiverLength(), cutter=true);
      
    // Bolt Carrier + Travel
    for (X = [0:-1:-3]) translate([X,0,0])
    BoltCarrier(cutter=true);

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
      ChamferedCube([BarrelMinX(),
                     AR15BarrelExtensionLipRadius()+WallBarrel()+1,
                     0.5], r=1/16);
    }
  }
}
module Handguard(debug=false, alpha=1) {
  length = 7.5;
  
  color("Tan", alpha) render()
  DebugHalf(enabled=debug)
  difference() {
    union() {
      translate([ForendMinX()+ForendLength(),0,0])
      mirror([1,0,0])
      ReceiverSegment(length=length);
    }
  }
}

if ($preview) {

  if (_SHOW_BARREL) {
    Barrel();
    BarrelCollar();
  }

  if (_SHOW_FCG)
  SimpleFireControlAssembly(recoilPlate=false);

  animate_unlock1 = SubAnimate(ANIMATION_STEP_UNLOCK, end=0.25)
                 - SubAnimate(ANIMATION_STEP_LOCK, start=0.75);

  animate_unlock2 = SubAnimate(ANIMATION_STEP_UNLOCK, start=0.25)
                 - SubAnimate(ANIMATION_STEP_LOCK, end=0.75);

  // Motion-coupled: Bolt carrier and action rod
  translate([(-BarrelMinX()-0.5)*animate_unlock2,0,0]) {
    
    translate([-0.875*animate_unlock1,0,ActionRodZ()]) {
      
      if (_SHOW_ACTION_ROD)
      translate([boltCarrierMinX,0,0])
      ActionRod(length=10);

      *ChargingPump();
    }

    if (_SHOW_BOLT)
    rotate([-AR15_CamPinAngle()*(1-animate_unlock1),0,0])
    Bolt();

    if (_SHOW_BOLT_CARRIER)
    BoltCarrier(debug=_CUTAWAY_BOLT_CARRIER, alpha=_ALPHA_BOLT_CARRIER);
  }

  if (_SHOW_FOREND)
  AR15Forend(debug=_CUTAWAY_FOREND, alpha=_ALPHA_FOREND);
  
  if (_SHOW_HANDGUARD)
  Handguard(debug=_CUTAWAY_HANDGUARD, alpha=_ALPHA_HANDGUARD);

  if (_SHOW_RECEIVER)
  ReceiverAssembly(debug=_CUTAWAY_RECEIVER);
  
  if (_SHOW_STOCK)
  StockAssembly(debug=_CUTAWAY_STOCK);
  
  if (_SHOW_LOWER) {
    translate([-LowerMaxX(),0,LowerOffsetZ()])
    Lower(showTrigger=true);
    LowerMount();
  }

} else scale(25.4) {
  if (_RENDER == "Bolt Carrier")
    BoltCarrier_print();

  if (_RENDER == "Forend")
    rotate([0,-90,0])
    AR15Forend();
  
  if (_RENDER == "Handguard")
  rotate([0,-90,0])
  translate([-ForendMinX()-ForendLength(),0,0])
  Handguard();
}


