use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;

use <../Vitamins/Nuts And Bolts.scad>;


function GripWidth() = 1;
function GripFloor() = 0.6;
function GripFloorZ() = -GripFloor();


function ReceiverLugWidth() = 1;

function ReceiverLugFrontLength() = 0.75;
function ReceiverLugFrontMaxX() = 1.6;
function ReceiverLugFrontMinX() = ReceiverLugFrontMaxX()-ReceiverLugFrontLength();

function ReceiverLugRearLength() = 0.75;
function ReceiverLugRearMinX() = -1.625;
function ReceiverLugRearMaxX() = ReceiverLugRearMinX()+ReceiverLugRearLength();


function ReceiverLugBoltRadius() = 0.0775;

function ReceiverLugBoltX(bolt) = bolt[0];
function ReceiverLugBoltY(bolt) = bolt[1];
function ReceiverLugBoltZ(bolt) = bolt[2];

// XYZ
function ReceiverLugBoltsArray() = [

   // Front-Top
   [ReceiverLugFrontMaxX()+0.25,(GripWidth()/2)+0.125,GripFloorZ()+(GripFloor()/2)],

   // Back-Top
   [ReceiverLugRearMinX()+(ReceiverLugRearLength()/2), (GripWidth()/2)+0.125, GripFloorZ()+0.375]
];

module ReceiverLugBoltHoles(boltSpec=Spec_BoltM3(), length=UnitsMetric(30),
                        clearance=true, $fn=8) {

  capHeightExtra = clearance ? 1 : 0;
  nutHeightExtra = clearance ? 1 : 0;

  color("SteelBlue")
  for (bolt = ReceiverLugBoltsArray())
  translate([ReceiverLugBoltX(bolt), ReceiverLugBoltY(bolt), ReceiverLugBoltZ(bolt)])
  rotate([90,0,0])
  rotate(90)
  NutAndBolt(bolt=boltSpec, boltLength=length, clearance=clearance,
              capHeightExtra=capHeightExtra,
              nutHeightExtra=nutHeightExtra, nutBackset=0.02);
}



module ReceiverLug(length=1, width=0.5, height=0.75, extraTop=ManifoldGap(),
               tabHeight=0.25, tabWidth=ReceiverLugWidth(), hole=false,
               clearance=0.007) {
  render()
  difference() {

    // Grip Tab
    union() {

      // Vertical
      translate([-clearance,-width/2,-height])
      cube([length+(clearance*2), width, height+extraTop]);

      // Horizontal
      translate([-clearance,-(tabWidth/2)-clearance,-height-clearance])
      cube([length+(clearance*2), tabWidth+(clearance*2), tabHeight+(clearance*2)]);
    }

    // Cut off the top (yes, this is ugly)
    translate([-clearance,-width,0])
    cube([length+(clearance*2), width*2, height+extraTop]);

    // Grip Bolt Hole
    if (hole)
    translate([length/2,0,-0.225])
    rotate([90,0,0])
    cylinder(r=ReceiverLugBoltRadius(), h=width*2, center=true, $fn=8);
  }
}

module ReceiverLugRear(clearance=0, height=1, extraTop=ManifoldGap(), hole=true) {
  color("LightGreen")
  translate([ReceiverLugRearMinX(),0,0])
  ReceiverLug(length=ReceiverLugRearLength(),
          height=height, extraTop=extraTop,
          hole=hole, clearance=clearance);
}

module ReceiverLugFront(clearance=0, extraTop=ManifoldGap()) {
  color("Orange")
  translate([ReceiverLugFrontMaxX(),0,0])
  mirror([1,0,0])
  ReceiverLug(length=ReceiverLugFrontLength(), tabWidth=1.25,
          height=0.5, extraTop=extraTop,
         clearance=clearance);
}

ReceiverLugRear();

ReceiverLugFront();

ReceiverLugBoltHoles(clearance=false);
