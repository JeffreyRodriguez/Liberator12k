include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;

use <../Shapes/Chamfer.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;

use <Firing Pin.scad>;

// Measured: Vitamins
function RecoilPlateThickness() = 1/4;
function RecoilPlateWidth() = 1.5;
function RecoilSpreaderThickness() = 0.5;

// Settings: Positions
function RecoilPlateRearX()  = -RecoilSpreaderThickness();
function FiringPinZ() = 0; //-0.12; // .22 Rimfire Offset

// Settings: Vitamins
function SquareRodFixingBolt() = Spec_BoltM3();

// Calculated: Positions
function FiringPinMinX() = RecoilPlateRearX()-FiringPinHousingLength();

module RecoilPlateFiringPinAssembly(cutter=false, debug=false) {
  translate([RecoilPlateRearX(),0,FiringPinZ()])
  rotate([0,-90,0])
  rotate(180)
  FiringPinAssembly(cutter=cutter, debug=debug);
}

module RecoilPlate(firingPinAngle=0, cutter=false, debug=false) {
  color("LightSteelBlue")
  DebugHalf(enabled=debug)
  difference() {
    translate([-RecoilPlateThickness(), -1-ManifoldGap(2), -RecoilPlateWidth()/2])
    ChamferedCube([RecoilPlateThickness()+(cutter?(1/8):0),
                   2+ManifoldGap(4),
                   RecoilPlateWidth()],
                  r=1/32,
                  chamferXYZ=[0,1,0],
                  teardropXYZ=[false, false, false],
                  teardropTopXYZ=[false, false, false]);

    if (!cutter)
    rotate([firingPinAngle,0,0])
    RecoilPlateFiringPinAssembly(cutter=true);
  }
}

module RecoilPlateHousing(firingPinAngle=0,
                          debug=false, alpha=1) {
  color("Tomato", alpha)
  DebugHalf(enabled=debug)
  difference() {
    union() {
      translate([RecoilPlateRearX(),0, 0])
      children();
    }

    RecoilPlate(cutter=true);

    rotate([firingPinAngle,0,0])
    RecoilPlateFiringPinAssembly(cutter=true);

  }
}

module RecoilPlateTemplate(clearance=0.005, height=0.25) {
  render()
  difference() {
    translate([-1,-1-0.25-ManifoldGap(),0])
    cube([2, 2+0.25, height]);

    translate([0,0,height])
    rotate([0,90,0])
    RecoilPlate(cutter=true);

    for(Y = [1,-1,0]) translate([0,FiringPinBoltOffsetY()*Y,-ManifoldGap()])
    cylinder(r=FiringPinRadius()+clearance,
             h=height+ManifoldGap(2),
            $fn=8);
  }
}


translate([-0.25-0.1,0,0])
rotate([0,90,0])
RecoilPlateTemplate();

RecoilPlateFiringPinAssembly();

RecoilPlate();

// Recoil Plate Drill Template
*!scale(25.4)
RecoilPlateTemplate();
