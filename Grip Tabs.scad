use <Components/Manifold.scad>;
use <Vitamins/Nuts And Bolts.scad>;
use <Reference.scad>;


function GripWidth() = 1;
function GripFloor() = 0.6;
function GripOffsetZ() = -ReceiverCenter();
function GripFloorZ() = -GripFloor()+GripOffsetZ();


function GripTabWidth() = 1;
function GripTabRearLength() = 1;
function GripTabFrontLength() = 0.75;

function GripTabRearMinX() = -ReceiverCenter()-WallFrameBack();
function GripTabRearMaxX() = GripTabRearMinX()+GripTabRearLength();

function GripTabFrontMaxX() = ReceiverCenter()+WallFrameFront();
function GripTabFrontMinX() = GripTabFrontMaxX()-GripTabFrontLength();


function GripTabBoltRadius() = 0.0775;

function GripTabBoltX(bolt) = bolt[0];
function GripTabBoltY(bolt) = bolt[1];
function GripTabBoltZ(bolt) = bolt[2];

// XYZ
function GripTabBoltsArray() = [
   
   // Front-Top
   [BreechFrontX(),(GripWidth()/2)+0.125,GripFloorZ()+(GripFloor()/2)],
   
   // Back-Top
   [GripTabRearMinX()+(GripTabRearLength()/2), (GripWidth()/2)+0.125, GripFloorZ()+0.375]
];

module GripTabBoltHoles(boltSpec=Spec_BoltM3(),
                        capHeightExtra=1, nutHeightExtra=1,
                        length=30/25.4, $fn=8) {
  color("SteelBlue")
  for (bolt = GripTabBoltsArray())
  translate([GripTabBoltX(bolt), GripTabBoltY(bolt), GripTabBoltZ(bolt)])
  rotate([90,0,0])
  rotate(90)
  NutAndBolt(bolt=boltSpec, boltLength=length, clearance=true,
              capHeightExtra=capHeightExtra, nutHeightExtra=nutHeightExtra);
}



module GripTab(length=1, width=0.5, height=0.75, extraTop=ManifoldGap(),
               tabHeight=0.25, tabWidth=GripTabWidth(), hole=false,
               clearance=0.007) {
  render()
  translate([0,0,GripOffsetZ()])
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
      
    // Grip Bolt Hole
    if (hole)
    translate([length/2,0,-0.225])
    rotate([90,0,0])
    cylinder(r=GripTabBoltRadius(), h=width*2, center=true, $fn=8);
  }
}

module GripTabRear(clearance=0, height=.75, extraTop=ManifoldGap(), hole=true) {
  color("LightGreen")
  translate([GripTabRearMinX(),0,0])
  GripTab(length=GripTabRearLength(),
          height=height, extraTop=extraTop,
          hole=hole, clearance=clearance);
}

module GripTabFront(clearance=0, extraTop=ManifoldGap()) {
  color("Orange")
  translate([GripTabFrontMaxX(),0,0])
  mirror([1,0,0])
  GripTab(length=GripTabFrontLength(), tabWidth=1.25,
          height=0.5, extraTop=extraTop,
         clearance=clearance);
}

GripTabRear();

GripTabFront();

GripTabBoltHoles(capHeightExtra=0, nutHeightExtra=0, clearance=false);