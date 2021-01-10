include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/RenderIf.scad>;

use <../Shapes/Chamfer.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;

RECOIL_PLATE_BOLT = "#8-32"; // ["#8-32", "M4"])
RECOIL_PLATE_BOLT_CLEARANCE = 0.005;

// Measured: Vitamins
function RecoilPlateLength() = 1/4;
function RecoilPlateWidth() = 2;
function RecoilPlateHeight() = 1.5;

function RecoilPlateBolt() = BoltSpec(RECOIL_PLATE_BOLT);
function RecoilPlateBoltOffsetY() = 0.5;

module RecoilPlateBolts(bolt=RecoilPlateBolt(),
                        boltLength=0.5, head="flat",
                        cutter=false, clearance=RECOIL_PLATE_BOLT_CLEARANCE) {
  color("CornflowerBlue")
  for (M = [0,1]) mirror([0,M,0])
  translate([0,RecoilPlateBoltOffsetY(),0])
  rotate([0,-90,0])
  Bolt(bolt=bolt, capOrientation=true, head=head,
       clearance=cutter?clearance:0,
       length=boltLength+ManifoldGap(2));
}

module RecoilPlate(cutter=false, debug=false) {
  color("LightSteelBlue")
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    translate([0.25, -1-ManifoldGap(2), -RecoilPlateHeight()/2])
    ChamferedCube([RecoilPlateLength()+(cutter?(1/8):0),
                   RecoilPlateWidth()+ManifoldGap(4),
                   RecoilPlateHeight()],
                  r=1/32,
                  chamferXYZ=[0,1,0],
                  teardropXYZ=[false, false, false],
                  teardropTopXYZ=[false, false, false]);

    if (!cutter)
    RecoilPlateBolts(cutter=true);
  }
}

module RecoilPlateTemplate(firingPinRadius=1/32, clearance=0.005, extend=0.125) {
  render()
  difference() {
    translate([0,-(RecoilPlateWidth()/2)-extend,-(RecoilPlateHeight()/2)-extend])
    cube([RecoilPlateLength()+extend, RecoilPlateWidth()+extend, RecoilPlateHeight()+(+extend*2)]);

    RecoilPlate(cutter=true);
    
    
    RecoilPlateBolts(bolt=BoltSpec("Template"), head="none");
    
    rotate([0,90,0])
    cylinder(r=firingPinRadius+clearance,
             h=RecoilPlateLength()+extend+ManifoldGap(2),
            $fn=8);
  }
}


//translate([-0.25-0.1,0,0]) rotate([0,90,0])
RecoilPlateTemplate();

RecoilPlate();
RecoilPlateBolts();

// Recoil Plate Drill Template
*!scale(25.4)
RecoilPlateTemplate();
