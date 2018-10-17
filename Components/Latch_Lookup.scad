use <../Meta/Units.scad>;
use <../Vitamins/Nuts And Bolts.scad>;

LatchWidth          = 0;
LatchHeight         = 1;
LatchTravel         = 2;
LatchSpringLength   = 3;
LatchHandleWidth    = 4;
LatchBoltOffset     = 5;
LatchBoltLength     = 6;

DEFAULT_LATCH_BOLT = Spec_BoltM4();

DEFAULT_LATCH = [
  [LatchWidth,        UnitsImperial(0.75)],
  [LatchHeight,       UnitsImperial(0.25)],
  [LatchTravel,       UnitsImperial(0.375)],
  [LatchSpringLength, UnitsImperial(0.875)],
  [LatchHandleWidth,  UnitsImperial(0.5)],
  [LatchBoltOffset,   UnitsImperial(0.625)],
  [LatchBoltLength,   UnitsMetric(25)]
];

function LatchWidth(spec=DEFAULT_LATCH)  = lookup(LatchWidth, spec);
function LatchHeight(spec=DEFAULT_LATCH) = lookup(LatchHeight, spec);
function LatchTravel(spec=DEFAULT_LATCH) = lookup(LatchTravel, spec);
function LatchSpringLength(spec=DEFAULT_LATCH) = lookup(LatchWidth, spec);
function LatchHandleWidth(spec=DEFAULT_LATCH)  = lookup(LatchHandleWidth, spec);
function LatchBoltOffset(spec=DEFAULT_LATCH) = lookup(LatchBoltOffset,spec);
function LatchBoltLength(spec=DEFAULT_LATCH) = lookup(LatchBoltLength, spec);

function LatchLength(spec=DEFAULT_LATCH) = LatchBoltOffset(spec)
                                         + (LatchHandleWidth(spec)/2)
                                         + (LatchTravel(spec)*1.25)
                                         + LatchSpringLength(spec);

function LatchHandleLength(spec=DEFAULT_LATCH) = LatchBoltLength(spec)
                                               - LatchHeight(spec);