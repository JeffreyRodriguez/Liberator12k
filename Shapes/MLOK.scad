use <../Meta/Units.scad>;
use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;

// Picatinny rail mounts on top of receiver w/ M-LOK
MLOK_BOLT           = "#8-32";   // ["M4", "#8-32", "#10-24", "1/4\"-20"]

function MlokBolt() = BoltSpec(MLOK_BOLT);
assert(MlokBolt(), "MlokBolt() is undefined. Unknown MLOK_BOLT?");

function MlokSlotDepth() = (1/16);

module MlokSlot(length=1, width = UnitsMetric(7), depth=MlokSlotDepth(), clearance=0.005) {  
  translate([0, -(width/2)])
  cube([length, width, depth]);
}

MlokSlot();