use <Trigger Guard.scad>;
use <Reference.scad>;
use <Components/Manifold.scad>;


function GripTabBoltX(bolt) = bolt[0];
function GripTabBoltY(bolt) = bolt[1];
function GripTabBoltZ(bolt) = bolt[2];

// XYZ
function GripTabBoltsArray() = [
   
   // Behind front grip tab
   [ReceiverOR(),0,GripFloorZ()+0.375],
   
   // Front-Top
   [BreechFrontX(),0,-ReceiverCenter()-(GripFloor()/2)],
   
   // Back-Top
   [-ReceiverCenter()-WallFrameBack()+0.5, 0, GripFloorZ()+0.375]
];

module GripTabBoltHoles(radius=0.0775, length=2, $fn=8) {
  for (bolt = GripTabBoltsArray())
  translate([GripTabBoltX(bolt), GripTabBoltY(bolt), GripTabBoltZ(bolt)])
  rotate([90,0,0])
  cylinder(r=radius, h=length, center=true);
}


function GripTabWidth() = 1;

module GripTab(length=1, width=0.5, height=.75,
               tabHeight=0.25, tabWidth=GripTabWidth(),
               clearance=0.005) {
  
  // Vertical
  translate([0,-width/2,-ReceiverCenter()-height])
  cube([length, width, height+ManifoldGap()]);
  
  // Horizontal
  translate([-clearance,-(tabWidth/2)-clearance,-ReceiverCenter()-height-clearance])
  cube([length+(clearance*2), tabWidth+(clearance*2), tabHeight+(clearance*2)]);
}

function GripTabRearLength() = 1;
function GripTabRearMinX() = -ReceiverCenter()-WallFrameBack();
function GripTabRearMaxX() = GripTabRearMinX()+GripTabRearLength();

module GripTabRear(clearance=0) {
  translate([GripTabRearMinX(),0,0])
  GripTab(length=GripTabRearLength(), clearance=clearance);
}

function GripTabFrontLength() = 0.75;
function GripTabFrontMaxX() = ReceiverCenter()+WallFrameFront();
function GripTabFrontMinX() = GripTabFrontMaxX()-GripTabFrontLength();

module GripTabFront(clearance=0) {
  translate([ReceiverCenter()+WallFrameFront(),0,0])
  mirror([1,0,0])
  GripTab(length=GripTabFrontLength(), tabWidth=1.25, height=0.5, clearance=clearance);
}

color("LightGreen")
GripTabRear();

color("Orange")
GripTabFront();

color("Red")
GripTabBoltHoles();