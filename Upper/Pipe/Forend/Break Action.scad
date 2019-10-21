include <../../../Meta/Animation.scad>;

use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Debug.scad>;
use <../../../Meta/Resolution.scad>;

use <../../../Components/Cylinder Redux.scad>;
use <../../../Components/Pivot.scad>;

use <../../../Lower/Lower.scad>;

use <../../../Finishing/Chamfer.scad>;

use <../../../Shapes/Bearing Surface.scad>;
use <../../../Shapes/Teardrop.scad>;
use <../../../Shapes/TeardropTorus.scad>;
use <../../../Shapes/Semicircle.scad>;
use <../../../Shapes/ZigZag.scad>;

use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;

use <../../../Ammo/Shell Slug.scad>;

use <../Lugs.scad>;
use <../Pipe Upper.scad>;
use <../Linear Hammer.scad>;
use <../Recoil Plate.scad>;
use <../Charging Pump.scad>;


$fs = UnitsFs()*0.5;

// Settings: Vitamins
function BarrelPipe() = Spec_PipeThreeQuarterInch();
function BarrelSleevePipe() = Spec_PipeOneInch();
function SquareRodFixingBolt() = Spec_BoltM3();

// Settings: Lengths
function BarrelLength() = 18;
function BarrelSleeveLength() = 5;
function WallBarrel() = 0.25;
function WallPivot() = 0.5;

// Shorthand: Measurements
function PivotDiameter() = 5/16;
function PivotRadius() = PivotDiameter()/2;

function BarrelRadius(clearance=undef)
    = PipeOuterRadius(BarrelPipe(), clearance);

function BarrelDiameter(clearance=undef)
    = PipeOuterDiameter(BarrelPipe(), clearance);

function BarrelSleeveRadius(clearance=undef)
    = PipeOuterRadius(BarrelSleevePipe(), clearance);

function BarrelSleeveDiameter(clearance=undef)
    = PipeOuterDiameter(BarrelSleevePipe(), clearance);

// Calculated: Lengths
function ForendFrontLength() = 1.5;
function ReceiverTopZ() = ReceiverOR();

// Calculated: Positions
function ForendFrontX() = FrameUpperBoltExtension();
function PivotX() = BarrelSleeveLength();
function PivotZ() = BarrelSleeveRadius();
function PivotZ() = FrameUpperBoltOffsetZ()-FrameUpperBoltRadius()-PivotRadius();
function PivotAngle() = -40;

module RenderIf(test=true) {
  if (test) {
    render() children();
  } else {
    children();
  }
}

module BreakActionRecoilPlateHousing(debug=false) {
  color("MediumSlateBlue")
  DebugHalf(enabled=debug) render()
  difference() {
    RecoilPlateHousing(topHeight=FrameUpperBoltOffsetZ(),
                       bottomHeight=-LowerOffsetZ(),
                       debug=false) {
      
      // Frame upper support
      translate([RecoilPlateRearX(),0,0])
      hull()
      FrameUpperBoltSupport(length=-RecoilPlateRearX());
    }

    FrameUpperBolts(cutter=true);

    translate([RecoilPlateRearX()-LowerMaxX(),0,0])
    FrameBolts(cutter=true, teardrop=false);

    translate([RecoilPlateThickness(),0,0])
    ChargingRod(clearance=RodClearanceSnug(), cutter=true);
  }
}

module BreakActionPivot(factor=0) {
  Pivot2(xyz=[PivotX(),0,PivotZ()],
         angle=[0,PivotAngle(),0],
         factor=factor)
  children();
}

module BarrelSleeve(clearance=undef, cutter=false, debug=false) {
  color("Silver") DebugHalf(enabled=!cutter&&debug)
  rotate([0,90,0])
  Pipe(pipe=BarrelSleevePipe(), taperTop=true,
       length=BarrelSleeveLength(),
       hollow=!cutter, clearance=clearance);

}

module Barrel(barrel=BarrelPipe(), length=BarrelLength(), clearance=undef, cutter=false, alpha=1, debug=false) {
  color("SteelBlue", alpha) DebugHalf(enabled=!cutter&&debug) RenderIf(!cutter)
  rotate([0,90,0])
  Pipe(pipe=barrel, clearance=clearance,
       hollow=!cutter, length=length);
}


module BarrelPivotCollar(length=1.75, debug=false, alpha=1, cutter=false) {
  color("Tomato", alpha) DebugHalf(enabled=!cutter&&debug) RenderIf(!cutter)
  difference() {
    union() {
      translate([PivotX()+PivotRadius()+WallPivot(), 0, 0])
      rotate([0,-90,0])
      ChamferedCylinder(r1=BarrelSleeveRadius()+WallBarrel(), r2=1/16,
               h=length,
               $fn=60);
      hull() {
  
        translate([PivotX(), -1.25/2, PivotZ()])
        rotate([-90,0,0])
        ChamferedCylinder(r1=PivotRadius()+WallPivot(), r2=1/16, h=1.25);
  
        translate([PivotX()-length+PivotRadius()+WallPivot(), -1.25/2, 0])
        ChamferedCube([length, 1.25, BarrelSleeveRadius()+WallBarrel()], r=1/16);
      }
    }
    
    // Pivot
    translate([PivotX(), 0, PivotZ()])
    rotate([90,0,0])
    cylinder(r=PivotRadius(), h=3, center=true);
    
    if (!cutter) {
      Barrel(clearance=PipeClearanceLoose(), cutter=true);
      BarrelSleeve(clearance=PipeClearanceSnug(), cutter=true);
    }
  }
  
}

module BarrelAssembly(pivotFactor=0, cutter=false, debug=false) {
  BreakActionPivot(factor=pivotFactor) {
    
    if (!cutter)
    %translate([PivotX(), 0, PivotZ()])
    rotate([90,0,0])
    cylinder(r=5/16/2, h=3, center=true);
           
    Barrel(cutter=cutter, debug=debug);
    
    BarrelSleeve(cutter=cutter, debug=debug);
    
    BarrelPivotCollar(cutter=cutter, debug=debug);
  }
}

module BreakActionForend(debug=false, alpha=1) {
  
  // Forward plate
  color("Tan", alpha)
  DebugHalf(enabled=debug) render()
  difference() {
    union() {
      
      // Top strap/bolt wall
      hull()
      FrameUpperBoltSupport(length=FrameUpperBoltExtension());
    
      // Pivot support
      hull() {
        
        translate([ForendFrontX(), 0, 0])
        mirror([1,0,0])
        FrameUpperBoltSupport(length=ForendFrontLength());
        
        translate([PivotX(), 0, PivotZ()])
        rotate([90,0,0])
        translate([0,0,-FrameUpperBoltOffsetY()-FrameUpperBoltRadius()-WallFrameUpperBolt()])
        ChamferedCylinder(r1=0.5, r2=1/16,
                 h=(FrameUpperBoltOffsetY()+FrameUpperBoltRadius()+WallFrameUpperBolt())*2,
                 $fn=Resolution(20,60));
        
        translate([ForendFrontX(),
                   -(FrameUpperBoltOffsetY()+FrameUpperBoltRadius()+WallFrameUpperBolt()),
                   FrameUpperBoltOffsetZ()])
        mirror([1,0,0])
        mirror([0,0,1])
        ChamferedCube([ForendFrontLength(),
                       (FrameUpperBoltOffsetY()+FrameUpperBoltRadius()+WallFrameUpperBolt())*2,
                       FrameUpperBoltRadius()+WallFrameUpperBolt()], r=1/16);
      }
    }
    
    for (PF = [0,1])
    BreakActionPivot(factor=PF) {
      Barrel(cutter=true);
      BarrelSleeve(cutter=true);
    }
    
    for (PF = [0,1])
    BreakActionPivot(factor=PF) {
      BarrelPivotCollar(cutter=true);
    }
    
    // Pivot rod
    translate([PivotX(), 0, PivotZ()])
    rotate([90,0,0])
    cylinder(r=PivotRadius()+0.01, h=4, center=true);
    
    // Cutout for a picatinny rail insert
    translate([-ManifoldGap(), -UnitsMetric(15.6/2), FrameUpperBoltOffsetZ()+FrameUpperBoltRadius()+WallFrameUpperBolt()-0.125])
    cube([FrameUpperBoltExtension()+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

    FrameUpperBolts(cutter=true);

    *ChargingRod(length=ChargingRodLength(),
                cutter=true);
  }
}

  triggerAnimationFactor = Animate(ANIMATION_STEP_TRIGGER)
                             - Animate(ANIMATION_STEP_TRIGGER_RESET);
module BreakActionAssembly(receiverLength=12, pipeAlpha=1,
                           pivotFactor=0,
                           stock=true, tailcap=false,
                           debug=false) {

  BreakActionRecoilPlateHousing();
  RecoilPlateFiringPinAssembly(); 
  RecoilPlate(debug=debug);
                                 
  *ChargingPumpAssembly(debug=debug);
  
  BarrelAssembly(pivotFactor=pivotFactor, debug=debug);

  BreakActionForend(debug=debug, alpha=0.5);
}
 
chargingRodAnimationFactor = Animate(ANIMATION_STEP_CHARGE)
                           - Animate(ANIMATION_STEP_CHARGER_RESET);

//AnimateSpin()translate([-2.5,0,0])
//for (R = [-1,1]) rotate([60*R,0,0]) translate([0,0,- SpindleOffset()])
BreakActionAssembly(pivotFactor=chargingRodAnimationFactor,
                    debug=false);

PipeUpperAssembly(pipeAlpha=1,
                  receiverLength=12,
                  stock=true, frameUpperBolts=true,
                  triggerAnimationFactor=triggerAnimationFactor,
                  debug=false);


//$t=AnimationDebug(ANIMATION_STEP_CHARGE, T=180*sin($t));
//$t=AnimationDebug(ANIMATION_STEP_CHARGE, T=0);
//$t=0;



/*
 * Platers
 */

// Printed breech (quick 'n dirty)
*!scale(25.4) rotate([0,-90,0])
BreakActionRecoilPlateHousing();

// Revolver Frame - Lower
*!scale(25.4) translate([0,0,-LowerOffsetZ()])
BreakActionFrameLower();

// Revolver Forend Rear
*!scale(25.4)
rotate([0,90,0])
translate([-FrameUpperBoltExtension(),0,0])
BreakActionForend();