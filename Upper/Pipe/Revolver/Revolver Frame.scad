include <../../../Meta/Animation.scad>;

use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Debug.scad>;
use <../../../Meta/Resolution.scad>;

use <../../../Components/Cylinder Redux.scad>;
use <../../../Components/Pipe/Lugs.scad>;

use <../../../Lower/Lower.scad>;
use <../../../Lower/Trigger.scad>;

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

use <../Pipe Upper.scad>;
use <../Frame.scad>;
use <../Frame - Upper.scad>;
use <../Linear Hammer.scad>;
use <../Recoil Plate.scad>;
use <../Charging Pump.scad>;

module RevolverFrameLower(debug=false) {
  color("OliveDrab") DebugHalf(enabled=debug)
  difference() {
    LowerPipeFrame();
    
    // Cutout for the spindle
    translate([LowerMaxX(),-BoltCapRadius(CylinderBolt(), true), LowerOffsetZ()-ManifoldGap()])
    ChamferedSquareHole(sides=[FrameExtension()+ManifoldGap(),BoltCapDiameter(CylinderBolt())],
                        length=ReceiverCenter(), chamferRadius=1/16,
                        corners=false, center=false,
                        teardropTop=true, teardropBottom=true,
                        $fn=20);
  }
}

module RevolverFrameUpper(debug=false) {
  length = FrameUpperRearExtension()+RecoilPlateRearX();
  
  color("Olive")
  DebugHalf(enabled=debug)
  difference() {

    union() {
      
      // Bolt wall
      translate([RecoilPlateRearX(),0,0])
      mirror([1,0,0])
      hull()
      FrameUpperBoltSupport(length=length);
      
      // Join bolt wall and pipe
      translate([RecoilPlateRearX(),-(2/2),ReceiverIR()/2])
      mirror([1,0,0])
      ChamferedCube([length,
                     2,
                     FrameUpperBoltOffsetZ()-(ReceiverIR()/2)],
                    r=1/16);
    }

    PipeLugPipe(cutter=true);

    translate([RecoilPlateRearX(),0,0])
    FrameUpperBolts(cutter=true);
    
    // Charger Cutout
    translate([RecoilPlateRearX()+ManifoldGap(),-(0.52/2),ReceiverIR()/2])
    mirror([1,0,0])
    cube([ChargerTowerLength()+ChargerTravel()+ManifoldGap(),0.52,2]);
  }
}

module RevolverFrameAssembly(receiverLength=12, debug=false) {
  
  translate([FiringPinMinX()-LinearHammerTravel(),0,0])
  LinearHammerAssembly();
                                 
  translate([RecoilPlateRearX()-LowerMaxX()-FrameExtension(),0,0])
  RevolverFrameLower();
  
  RevolverFrameUpper(debug=debug);

  FrameUpperBolts(extraLength=FrameUpperBoltExtension(), cutter=false);
}

RevolverFrameAssembly(debug=false);

translate([RecoilPlateRearX(),0,0])
PipeUpperAssembly(pipeAlpha=0.3,
                  receiverLength=12,
                  frame=false,
                  stock=true, tailcap=false,
                  debug=false);


//$t=AnimationDebug(ANIMATION_STEP_CHARGE, T=180*sin($t));
//$t=AnimationDebug(ANIMATION_STEP_CHARGE, T=0);
//$t=AnimationDebug(ANIMATION_STEP_UNLOAD, T=0);
//$t=0;



/*
 * Platers
 */


// Revolver Frame - Lower
*!scale(25.4) translate([0,0,-LowerOffsetZ()])
RevolverFrameLower();

// Revolver Frame Upper
*!scale(25.4)
translate([-ReceiverOR(),0,RecoilPlateRearX()])
rotate([0,-90,0])
RevolverFrameUpper();