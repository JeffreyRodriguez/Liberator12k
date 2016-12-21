use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;

use <../Components/T Lug.scad>;
use <../Vitamins/Nuts And Bolts.scad>;


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
function ReceiverLugBoltY(bolt) = bolt[1];
function ReceiverLugBoltZ(bolt) = bolt[2];

// XYZ
function ReceiverLugBoltsArray() = [

   // Front-Top
   [ReceiverLugFrontMaxX()+0.25,
    -LowerMaxY()+0.07,
    -0.375],

   // Back-Top
   [ReceiverLugRearMinX()+(ReceiverLugRearLength()/2),
    -LowerMaxY()+0.07,
    -0.375]
];

module ReceiverLugBoltHoles(boltSpec=Spec_BoltM4(),
                            length=UnitsMetric(30),
                            clearance=true,
                            teardrop=false,
                            teardropAngle=90, $fn=8) {

  capHeightExtra = clearance ? 1 : 0;
  nutHeightExtra = clearance ? 1 : 0;

  color("SteelBlue")
  for (bolt = ReceiverLugBoltsArray())
  translate([ReceiverLugBoltX(bolt), ReceiverLugBoltY(bolt), ReceiverLugBoltZ(bolt)])
  rotate([90,0,0])
  rotate(90)
  NutAndBolt(bolt=boltSpec, boltLength=length,
              teardrop=teardrop, teardropAngle=teardropAngle,
              clearance=clearance, capOrientation=true,
              capHeightExtra=capHeightExtra,
              nutHeightExtra=nutHeightExtra, nutBackset=0.05);
}

module ReceiverLugRear(extraTop=ManifoldGap(), cutter=false,
                       teardrop=true, teardropAngle=90, hole=true) {

  color("DarkOrange")
  render()
  difference() {
    translate([ReceiverLugRearMinX(),0,ReceiverLugRearZ()])
    T_Lug(length=ReceiverLugRearLength(),
            height=abs(ReceiverLugRearZ())+extraTop,
            cutter=cutter);

    // Grip Bolt Hole
    if (hole)
    ReceiverLugBoltHoles(teardrop=teardrop, teardropAngle=teardropAngle, clearance=true);
  }
}

module ReceiverLugFront(cutter=false, clearance=UnitsImperial(0.007), extraTop=ManifoldGap()) {
  color("DarkOrange")
  render()
  translate([ReceiverLugFrontMaxX(),0,ReceiverLugFrontZ()])
  mirror([1,0,0])
  T_Lug(length=ReceiverLugFrontLength(), tabWidth=1.25,
          height=abs(ReceiverLugFrontZ())+extraTop,
          clearance=clearance,
          cutter=cutter);
}

ReceiverLugRear();

ReceiverLugFront();

ReceiverLugBoltHoles(clearance=false);
