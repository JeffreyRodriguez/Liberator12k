include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Finishing/Chamfer.scad>;
use <../../Components/Firing Pin.scad>;
use <../../Components/Pipe/Lugs.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <Frame.scad>;
use <Pipe Upper.scad>;

// Measured: Vitamins
function RecoilPlateThickness() = 1/4;
function RecoilPlateWidth() = 1.5;

// Settings: Positions
function RecoilPlateRearX()  = -0.5;
//function FiringPinOffset() = -0.12; // .22 Rimfire Offset
function FiringPinOffset() = 0;

// Settings: Vitamins
function SquareRodFixingBolt() = Spec_BoltM3();

// Calculated: Positions
function FiringPinMinX() = RecoilPlateRearX()-FiringPinBodyLength();

module RecoilPlateFiringPinAssembly(template=false, cutter=false, debug=false) {
  translate([RecoilPlateRearX(),0,FiringPinOffset()])
  rotate([0,-90,0])
  FiringPinAssembly(cutter=cutter, debug=debug, template=template);
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

module RecoilPlateHousing(topHeight=ReceiverOR(),
                          bottomHeight=ReceiverOR(),
                          width=2, firingPinAngle=0,
                          debug=false, alpha=1) {
  color("Tomato", alpha)
  DebugHalf(enabled=debug)
  difference() {
    union() {
      translate([RecoilPlateRearX(),-width/2, -bottomHeight])
      ChamferedCube([-RecoilPlateRearX(),
                     width,
                     topHeight+bottomHeight],
                    r=1/16);

      children();
    }
    
    RecoilPlate(cutter=true);

    rotate([firingPinAngle,0,0])
    RecoilPlateFiringPinAssembly(cutter=true);

  }
}

module RecoilPlateAssembly(firingPinAngle=0,
                           topHeight=ReceiverOR(), bottomHeight=ReceiverOR(),
                           showFiringPin=true, showRecoilPlate=true,
                           debug=false) {
  
  if (showFiringPin)
  rotate([firingPinAngle,0,0])
  RecoilPlateFiringPinAssembly(debug=debug);
  
  RecoilPlateHousing(topHeight=topHeight, bottomHeight=bottomHeight,
                     firingPinAngle=firingPinAngle, debug=debug);
  
  if (showRecoilPlate)
  RecoilPlate(firingPinAngle=firingPinAngle, debug=debug)
  children();
}

module RecoilPlateTemplate() {
  difference() {
    translate([-1,-1-0.25-ManifoldGap(),-0.25])
    cube([2, 2+0.25, 0.25]);
    
    rotate([0,90,0])
    RecoilPlate(cutter=true);
    
    rotate([0,-90,0])
    RecoilPlateFiringPinAssembly(template=true);
  }
}

RecoilPlateAssembly(topHeight=ReceiverOR(),
                    bottomHeight=-LowerOffsetZ(),
                    width=2,
                    firingPinAngle=0,
                    debug=false);

translate([RecoilPlateRearX(),0,0])
PipeUpperAssembly(receiverLength=12,
                  chargingHandle=false,
                  stock=true, tailcap=false,
                  debug=true);

// Recoil Plate Drill Template
*!scale(25.4)
RecoilPlateTemplate();