use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Resolution.scad>;

use <../../Shapes/Components/T Lug.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;


/* [Vitamins] */
RECEIVER_LUG_BOLTS = "M4"; // ["#8-32", "M4"]
RECEIVER_LUG_BOLTS_CLEARANCE = 0.005;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

function GripWidth() = 1;
function GripCeiling() = 0.75;
function GripCeilingZ() = -GripCeiling();

function LowerMaxWidth() = GripWidth()+0.25;
function LowerMaxY() = (GripWidth()/2)+0.125;

function ReceiverLugWidth() = 1;

function ReceiverLugFrontLength() = 0.75;
function ReceiverLugFrontMaxX() = 1.6;
function ReceiverLugFrontMinX() = ReceiverLugFrontMaxX()-ReceiverLugFrontLength();
function ReceiverLugFrontZ() = -0.5;

function ReceiverLugRearLength() = 0.75;
function ReceiverLugRearMinX() = -1.625;
function ReceiverLugRearMaxX() = ReceiverLugRearMinX()+ReceiverLugRearLength();
function ReceiverLugRearZ() = -1;


function ReceiverLugBoltRadius() = 0.0775;

function ReceiverLugBoltX(bolt) = bolt[0];
function ReceiverLugBoltZ(bolt) = bolt[1];

// XYZ
function ReceiverLugBoltsArray() = [

   // Front-Top
   [ReceiverLugFrontMaxX()+0.25,
    -0.375],

   // Back-Top
   [ReceiverLugRearMinX()+(ReceiverLugRearLength()/2),
    -0.375]
];

module ReceiverLugBolts(boltSpec=BoltSpec(RECEIVER_LUG_BOLTS),
                            length=UnitsMetric(30),
                            head="socket", nut="hex",
                            cutter=false,
                            clearance=RECEIVER_LUG_BOLTS_CLEARANCE,
                            teardrop=false,
                            teardropAngle=90) {

  color("Silver")
  for (bolt = ReceiverLugBoltsArray())
  translate([ReceiverLugBoltX(bolt), -length/2, ReceiverLugBoltZ(bolt)])
  rotate([90,0,0])
  rotate(90)
  NutAndBolt(bolt=boltSpec, boltLength=length,
             head=head, nut=nut,
             teardrop=teardrop, teardropAngle=teardropAngle,
             clearance=(cutter?clearance:0), capOrientation=true,
             capHeightExtra=cutter ? 1 : 0,
             nutHeightExtra=cutter ? 1 : 0);
}

module ReceiverLugRear(width=UnitsImperial(0.5), extraTop=ManifoldGap(),
                       cutter=false, clearance=UnitsImperial(0.002), clearVertical=false,
                       chamferCutterHorizontal=false,
                       teardrop=true, teardropAngle=90, hole=true) {

  color("DarkOrange")
  render()
  difference() {
    translate([ReceiverLugRearMinX(),0,ReceiverLugRearZ()])
    T_Lug(width=width, length=ReceiverLugRearLength(),
          height=abs(ReceiverLugRearZ())+extraTop,
          cutter=cutter, clearance=clearance, clearVertical=clearVertical,
          chamferCutterHorizontal=chamferCutterHorizontal);

    // Grip Bolt Hole
    if (hole)
    ReceiverLugBolts(teardrop=teardrop, teardropAngle=teardropAngle,
                         cutter=true);
  }
}

module ReceiverLugFront(width=UnitsImperial(0.5), extraTop=ManifoldGap(),
                        cutter=false, clearance=UnitsImperial(0.002), clearVertical=false,
                        chamferCutterHorizontal=false,) {
  color("DarkOrange")
  render()
  translate([ReceiverLugFrontMaxX(),0,ReceiverLugFrontZ()])
  mirror([1,0,0])
  T_Lug(width=width, length=ReceiverLugFrontLength(), tabWidth=1.25,
        height=abs(ReceiverLugFrontZ())+extraTop,
        cutter=cutter, clearance=clearance, clearVertical=clearVertical,
        chamferCutterHorizontal=chamferCutterHorizontal);
}

ReceiverLugRear(cutter=false);

ReceiverLugFront();

ReceiverLugBolts();
