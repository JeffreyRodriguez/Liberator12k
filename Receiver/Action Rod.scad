include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;

use <../Shapes/Components/Cylinder Redux.scad>;
use <../Shapes/Components/Pump Grip.scad>;

use <Lower/Lower.scad>;
use <Lower/Trigger.scad>;

use <../Shapes/Chamfer.scad>;

use <../Shapes/Bearing Surface.scad>;
use <../Shapes/Teardrop.scad>;
use <../Shapes/TeardropTorus.scad>;
use <../Shapes/Semicircle.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;

use <../Ammo/Shell Slug.scad>;

use <Lugs.scad>;

// Settings: Vitamins
function ActionRod() = Spec_RodOneQuarterInch();
function ActionRodBolt() = Spec_BoltM4();

// Settings: Lengths
function ActionRodLength() = 12;
function ActionRodTravel() = 3; // Rough default

/* How far does the stationary portion of the square rod
 extend into the part that holds it? */
function ActionRodStaticLength() = 0.5;

function ActionRodOffset() =  0.875+RodRadius(ActionRod());

// Settings: Walls
function WallActionRod() = 1/8;

function ActionRodWidth() = 0.25;
function ActionRodMinX() = -1;
function ActionRodMaxX() = ActionRodMinX()+ActionRodLength();


module ActionRodBolt(angle=0,
                     length=WallActionRod(),
                     cutter=false, clearance=0.005,
                     teardrop=false, teardropAngle=0) {
  clear = cutter?clearance:0;

  color("SteelBlue")
  translate([ActionRodMinX()+(WallActionRod()*2),
             0,
             ActionRodOffset()])
  rotate([angle,0,0])
  translate([0, 0, -(ActionRodWidth()/2)-ManifoldGap()])
  Bolt(bolt=ActionRodBolt(), head="socket",
       capOrientation=false, length=ActionRodWidth()+ManifoldGap()+length,
       clearance=clear,
       teardrop=cutter, teardropAngle=teardropAngle);


}

module ActionRod(length=ActionRodLength(),
                 travel=ActionRodTravel(),
                 clearance=0.005, cutter=false,
                 debug=false) {
  clear = cutter?clearance:0;
  clear2= clear*2;

  color("Silver")
  translate([ActionRodMinX(),0,ActionRodOffset()])
  translate([0,-(ActionRodWidth()/2)-clear,-(ActionRodWidth()/2)-clear])
  cube([length, ActionRodWidth()+clear2, ActionRodWidth()+clear2]);
}

module ActionRodAssembly(animate=0,
                        length=ActionRodLength(),
                        travel=ActionRodTravel(),
                        pipeAlpha=1, debug=false) {
  translate([-ActionRodTravel()*animate,0,0]) {

    color("Silver")
    ActionRodBolt();

    ActionRod(length=length, travel=travel, debug=debug);
  }
}

ActionRodAssembly(debug=false);
