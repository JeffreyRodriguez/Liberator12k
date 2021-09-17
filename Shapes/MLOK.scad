use <../Meta/Units.scad>;
use <../Meta/Manifold.scad>;
use <../Meta/Resolution.scad>;
use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;

// Picatinny rail mounts on top of receiver w/ M-LOK
MLOK_BOLT           = "#8-32";   // ["M4", "#8-32", "#10-24", "1/4\"-20"]

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

function MlokBolt() = BoltSpec(MLOK_BOLT);
assert(MlokBolt(), "MlokBolt() is undefined. Unknown MLOK_BOLT?");


function MlokSlotLength() = UnitsMetric(32);
function MlokSlotSpacing() = UnitsMetric(8);
function MlokSlotDepth() = 0.125;
function MlokBackWidth() = (0.45)+0.01;
function MlokSlotWidth() = UnitsMetric(7)+0.01;


module MlokSlot(length=MlokSlotLength(), extension=UnitsMetric(20), center=true, clearance=0.005) {  
  translate([0, (center?-(MlokSlotWidth()/2):0),-MlokSlotDepth()])
  cube([length, MlokSlotWidth(), MlokSlotDepth()+ManifoldGap()]);
}


module MlokSlotBack(length=MlokSlotLength(), extension=UnitsMetric(4), center=true, clearance=0.005) {  
  translate([0,(center?-(MlokBackWidth()/2):-(MlokBackWidth()-MlokSlotWidth())/2),-MlokSlotDepth()-extension])
  cube([length, MlokBackWidth(), extension]);
}

MlokSlot();
MlokSlotBack();