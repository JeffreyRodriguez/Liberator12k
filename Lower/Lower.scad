//$t=0.6;
use <../Meta/Debug.scad>;
use <../Meta/Manifold.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Units.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;

use <../Reference.scad>;
use <Receiver Lugs.scad>;
use <Trigger.scad>;

function TriggerFingerSlotDiameter() = 0.9;
function TriggerFingerSlotRadius() = TriggerFingerSlotDiameter()/2;
function TriggerFingerSlotOffsetZ() = GripFloorZ() -TriggerFingerSlotRadius();
function TriggerFingerSlotWall() = 0.25;

module GuardBolt(boltSpec=TriggerBoltSpec(), length=UnitsMetric(25), clearance=true) {
  cutter = (clearance) ? 1 : 0;
  
  color("SteelBlue")
  translate([ReceiverLugBoltX(ReceiverLugBoltsArray()[0]),
             GripWidth()/2,
             GripFloorZ()-TriggerFingerSlotDiameter()+0.125])
  rotate([90,0,0])
  NutAndBolt(bolt=TriggerBoltSpec(), boltLength=length, clearance=clearance,
              capHeightExtra=cutter, nutBackset=0.02, nutHeightExtra=cutter);
}

module HandleBolts(boltSpec=TriggerBoltSpec(), length=UnitsMetric(25), clearance=true) {
  cutter = (clearance) ? 1 : 0;
  
  boltsXZ = [
  
     // Handle Bottom-Rear
     [-2.653,GripFloorZ()-2.4],

     // Handle Bottom-Front
     [-1.403,GripFloorZ()-2.9]
  ];

  color("SteelBlue")
  for (xz = boltsXZ)
  translate([xz[0],GripWidth()/2,xz[1]])
  rotate([90,0,0])
  NutAndBolt(bolt=TriggerBoltSpec(), boltLength=length, clearance=clearance,
              capHeightExtra=cutter, nutBackset=0.02, nutHeightExtra=cutter);
}

module TriggerFingerSlot(length=0.525, $fn=Resolution(12, 60)) {
  render()
  translate([0.65, 0, TriggerFingerSlotOffsetZ()])
  hull()
  for (i = [0,length])
  translate([i,0,0])
  rotate([90,0,0])
  cylinder(r=TriggerFingerSlotRadius(),
           h=2, $fn=$fn, center=true);
}

module GripHandle(angle=25, length=1.3, height=5.5) {
  handleOffsetZ = 1.3825-GripFloor();
  palmSwellOffsetZ=-3.0-GripFloor();
  fingerSwellOffsetZ=-2.4-GripFloor();

  render()
  difference() {
    

    union() {
      
      // Angled section of the grip
      translate([-0.125,0,handleOffsetZ])
      rotate([0,angle,0]) {

        // Grip Body
        translate([-length/2,0,-height])
        hull()
        for (i=[0,length])
        translate([i,0,0])
        cylinder(r=GripWidth()/2, h=height, $fn=Resolution(20, 60));

        // Palm swell
        translate([0,0,palmSwellOffsetZ])
        scale([2.5,1.7,4.5])
        sphere(r=0.45, $fn=Resolution(12, 60));

        // Finger swell
        translate([length/2,0,fingerSwellOffsetZ])
        scale([1,1.05,0.5])
        sphere(r=0.63, $fn=Resolution(12, 60));
      }

      // Backstrap to meet the web of the hand
      translate([-length-0.25, 0, -GripFloor()-TriggerFingerSlotDiameter()])
      rotate([0,-5,0])
      cylinder(r=GripWidth()/2, h=1.7, $fn=Resolution(20,60));
    }

    // Flatten the bottom
    translate([-4.5,-1,handleOffsetZ-6.5])
    rotate([0,5,0])
    cube([4, 2, 2]);

    // Flatten the top
    translate([-3,-2, -ManifoldGap()])
    cube([6, 4, 3]);
    
    HandleBolts(clearance=true);
  }
}

module TriggerGuard() {
  height = TriggerFingerSlotDiameter()+TriggerFingerSlotWall()+GripFloor();
  
  union() {
    difference() {

      // Main block
      translate([ReceiverLugRearMinX(), -GripWidth()/2, -height])
      cube([ReceiverLugFrontMaxX()+abs(ReceiverLugRearMinX())+0.5,
            GripWidth(),
            height]);

      // Bottom chamfer
      translate([0,0,-height+0.1])
      rotate([0,-90,0])
      linear_extrude(height=ReceiverLength()*2, center=true)
      difference() {
        translate([-height,-GripWidth()])
        square([height,GripWidth()*2]);

        hull()
        for (i = [-1, 1])
        translate([0,((GripWidth()/2)-0.09)*i])
        circle(r=0.1, $fn=Resolution(12,24));
      }
    }
    
    LowerReceiverSupports();
    GripHandle();
  }
}

module LowerReceiverSupports() {

  // Front grip tab support
  hull() {

    // Front cube
    translate([ReceiverLugFrontMaxX()+0.5,-0.625,-GripFloor()])
    mirror([1,0,0])
    cube([1.5, 1.25, GripFloor()]);

    // Rear cube
    translate([0.25,-0.5,-GripFloor()-TriggerFingerSlotRadius()])
    cube([ReceiverLugFrontMaxX()+0.25, 1, GripFloor()+TriggerFingerSlotRadius()]);
  }

  // Rear Grip Tab Support
  hull() {

    translate([ReceiverLugBoltX(ReceiverLugBoltsArray()[1])-0.5,-(GripWidth()/2)+0.05,0])
    mirror([0,0,1])
    cube([1, GripWidth()-0.1, 0.74]);

    translate([ReceiverLugBoltX(ReceiverLugBoltsArray()[1]),0,ReceiverLugBoltZ(ReceiverLugBoltsArray()[1])])
    rotate([90,0,0])
    cylinder(r=0.225, h=1.25, center=true, $fn=Resolution(12,24));
  }
}

module LowerCutouts() {
  ReceiverLugFront(clearance=0.008);
  ReceiverLugRear(clearance=0.008);

  GuardBolt(clearance=true);

  ReceiverLugBoltHoles();

  TriggerBolt(clearance=true);

  TriggerFingerSlot();

  SearCutter();

  // Text
  if (Resolution(false, true)) {
    translate([-0.25,
               (GripWidth()/2)-0.02,
               -0.45])
    rotate([90,0,180])
    linear_extrude(height=0.1) {
      difference() {
        circle(r=0.3, $fn=30);
        circle(r=0.25, $fn=30);
      }
      
      translate([-0.225,-0.18])
      text("A", font="Arial Black", size=0.4); // Anarchism A
    }

    translate([-0.25,
               -(GripWidth()/2)+0.02,
               -0.45])
    rotate([90,0,0])
    linear_extrude(height=0.1) {
      difference() {
        circle(r=0.3, $fn=30);
        circle(r=0.25, $fn=30);
      }
      
      translate([-0.225,-0.26])
      text("V", font="Arial Black", size=0.4); // Voluntaryism V
    }
  }
}
  

module GripSplitter(clearance=0) {
  translate([-10, -0.25 -clearance, -10])
  cube([20, 0.5+(clearance*2), 20]);
}

module LowerSidePlates(showLeft=true, showRight=true) {

  // Trigger Guard Sides
  color("DarkGrey", 0.75)
  render()
  difference() {

    TriggerGuard();

    GripSplitter(clearance=0.001);
    
    LowerCutouts();

    if (showLeft == false)
    translate([-10,0,-10])
    cube([20,2,20]);

    if (showRight == false)
    translate([-10,-2,-10])
    cube([20,2,20]);
  }

}

module LowerMiddle() {
  color("Gold")
  render()
  union() {
    difference() {
      intersection() {
        TriggerGuard();

        // Just the middle
        GripSplitter(clearance=0);
      }
    
      LowerCutouts();

      translate([0,-0.5, ManifoldGap()])
      mirror([0,0,1]) {
      
        // Tigger Body
        translate([ReceiverLugRearMinX(),0,0])
        cube([ReceiverLugFrontMinX()+abs(ReceiverLugRearMinX()), 1, TriggerHeight()]);

        // Trigger Front Extension Cutout
        cube([ReceiverLugFrontMaxX(), 1, TriggerHeight()-TriggerFingerSlotRadius()]);
      }

      // #L12K easter egg
      if (Resolution(false, true))
      translate([-1.05, 0.22, -1.85])
      rotate([0,-90+25,0])
      rotate([0,0,180])
      rotate([90,0,0])
      linear_extrude(height=0.25) {
        text("#", size=0.6);

        translate([0.6, 0.08])
        text("L12K", size=0.4);
      }
    }
  }
}

module Lower(showReceiverLugs=false, showReceiverLugBolts=false,
            showGuardBolt=false, showHandleBolts=false,
            showTrigger=false, showTriggerLeft=true, showTriggerRight=true,
            showMiddle=true, showLeft=true, showRight=true) {
  
  // Trigger Guard Center
  if (showMiddle)
  LowerMiddle();

  // Trigger
  if (showTrigger) {
    TriggerGroup(left=showTriggerLeft, right=showTriggerRight);
  }
  
  if (showReceiverLugs) {
    ReceiverLugFront();
    ReceiverLugRear();
  }

  if (showReceiverLugBolts)
  ReceiverLugBoltHoles(clearance=false);

  if (showGuardBolt)
  GuardBolt(clearance=false);
  
  if (showHandleBolts)
  HandleBolts(clearance=false);

  LowerSidePlates(showLeft=showLeft, showRight=showRight);
}

Lower(showReceiverLugs=true, showReceiverLugBolts=true,
      showGuardBolt=true,
      showHandleBolts=true,
      showTrigger=true, showTriggerLeft=true, showTriggerRight=true,
      showLeft=true,
      showMiddle=true,
      showRight=true);