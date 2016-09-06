//$t=0.8;
use <Components/Manifold.scad>;
use <Components/Semicircle.scad>;
use <Components/Debug.scad>;
use <Components/Units.scad>;
use <Vitamins/Nuts And Bolts.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Frame.scad>;
use <Cylinder.scad>;
use <Trigger.scad>;
use <Striker.scad>;
use <Sear Guide.scad>
use <Reference.scad>;
use <Grip Tabs.scad>;
use <Reset Spring.scad>;

function GripHandleOffsetX() = -0.125;


function GripPinX(pin) = GripPins()[pin][0];
function GripPinY(pin) = 0;
function GripPinZ(pin) = GripPins()[pin][1];

// XZ
function GripPins() = [

   // Front-Bottom
   [BreechFrontX(),GripFloorZ()-GripTriggerFingerSlotDiameter()+0.125],
   
   // Handle Bottom-Rear
   [GripHandleOffsetX()-ReceiverOR()-1.75,GripFloorZ()-2.4],
   
   // Handle Bottom-Front
   [GripHandleOffsetX()-ReceiverOR()-0.5,GripFloorZ()-2.9]
];

module GripBodyScrews(boltSpec=TriggerBoltSpec(), length=UnitsMetric(25), clearance=true) {
  cutter = (clearance) ? 1 : 0;
  
  color("SteelBlue")
  for (xzy = GripPins())
  translate([xzy[0],0,xzy[1]])
  translate([0,(GripWidth()/2),0])
  rotate([90,0,0])
  color("SteelBlue")
  NutAndBolt(bolt=TriggerBoltSpec(), boltLength=length, clearance=clearance,
              capHeightExtra=cutter, nutBackset=0.02, nutHeightExtra=cutter);
}

module GripTriggerFingerSlot(receiver=ReceiverTee(), length=0.525, chamfer=false, $fn=Resolution(12, 60)) {
  render()
  union()
  translate([0.65,
             0,
             GripTriggerFingerSlotOffsetZ()]) {

    // Trigger guard hole
    hull()
    for (i = [0,length])
    translate([i,0,0])
    rotate([90,0,0])
    cylinder(r=GripTriggerFingerSlotRadius(),
             h=2, $fn=$fn, center=true);
    
    if (chamfer)
    for (side = [1, 0])
    mirror([0,side,0])
    hull()
    for (i = [0,length]) {

      translate([i,0.125 + (GripWidth()/2)])
      rotate([-90,0,0])
      cylinder(r=GripTriggerFingerSlotDiameter()*0.6,
               h=2, $fn=$fn);
      
      translate([i,0.125 + (GripWidth()/8)])
      rotate([-90,0,0])
      cylinder(r1=GripTriggerFingerSlotRadius(),
               r2=GripTriggerFingerSlotDiameter()*0.6,
               h=(GripWidth()/2)-0.125, $fn=$fn);
    }
  }
}

module GripHandle(receiver, angle=25, length=1.3, height=5.5) {
  handleOffsetZ = -GripFloor();
  palmSwellOffsetZ=-3.0-GripFloor();
  fingerSwellOffsetZ=-2.4-GripFloor();
  
  render()
  difference() {
    union() {
      
      // Main body of the grip
      translate([GripHandleOffsetX(),0,handleOffsetZ])
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
      
      // Backstrap
      translate([GripHandleOffsetX()-length-0.125,0,-ReceiverCenter()-GripFloor()-GripTriggerFingerSlotDiameter()])
      rotate([0,-5,0]) {
        cylinder(r=GripWidth()/2, h=1.7, $fn=Resolution(20,60));
        
        translate([0,-GripWidth()/2, 0])
        cube([1, GripWidth(), 1.7]);
      }
    }
    
    VerticalSearPinTrack();

    // Flatten the bottom
    translate([-4.5,-1,handleOffsetZ-6.5])
    rotate([0,5,0])
    cube([4, 2, 2]);
  }
}

module GripGuard(showHandle=true) {
  height = GripTriggerFingerSlotDiameter()+GripTriggerFingerSlotWall()+GripFloor();

  difference() {
    union() {
      difference() {
      
        // Main block
        translate([-ReceiverOR(), -GripWidth()/2,
                   -ReceiverCenter()-height])
        cube([ReceiverOR()+BreechFrontX()+0.25,
              GripWidth(),
              height]);
        
    
        // Bottom chamfer
        translate([0,0,-ReceiverCenter()-height+0.1])
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
      
      // Front grip tab support
      hull() {
        
        // Front cube
        translate([BreechFrontX()-1.25,-0.625,-ReceiverCenter()-GripFloor()])
        cube([1.5, 1.25, GripFloor()]);
        
        // Rear cube
        translate([0.25,-0.5,-ReceiverCenter()-GripFloor()-GripTriggerFingerSlotRadius()])
        cube([BreechFrontX(), 1, GripFloor()+GripTriggerFingerSlotRadius()]);
      }
      
      // Rear Grip Tab Support
      hull() {
        
        translate([GripTabBoltX(GripTabBoltsArray()[1])-0.5,-GripWidth()/2,-ReceiverCenter()-0.49]) 
        cube([1, GripWidth(), 0.49]);
        
        translate([GripTabBoltX(GripTabBoltsArray()[1]),0,GripTabBoltZ(GripTabBoltsArray()[1])]) 
        rotate([90,0,0])
        cylinder(r=0.225, h=1.25, center=true, $fn=Resolution(12,24));
      }

      if (showHandle)
      GripHandle(ReceiverTee());
    }
    
    // Flatten the top
    translate([-ReceiverLength(),-ReceiverOR(), -ReceiverCenter()-ManifoldGap()])
    cube([ReceiverLength()*2, ReceiverOD(), ReceiverCenter()]);
    
    GripTabFront(clearance=0.008);
    GripTabRear(clearance=0.008);

    GripBodyScrews(cutter=1);
    
    GripTabBoltHoles();
    
    TriggerBolt(clearance=true);
    
    GripTriggerFingerSlot();
    
    VerticalSearPinTrack();
    
    if (Resolution(false, true))
    GripText();
    
    Reference();
  }
}

module GripSplitter(clearance=0) {
  translate([-10, -0.25 -clearance, -10])
  cube([20, 0.5+(clearance*2), 20]);
}

module GripSides(showLeft=true, showRight=true) {

  // Trigger Guard Sides
  render()
  difference() {
    
    GripGuard(ReceiverTee());

    GripSplitter(ReceiverTee(), clearance=0.001);
    
    if (showLeft == false)
    translate([-10,0,-10])
    cube([20,2,20]);
    
    if (showRight == false)
    translate([-10,-2,-10])
    cube([20,2,20]);
  }

}

function GripAccessoryBossOffsets() = [-0.5,-GripTriggerFingerSlotDiameter()-GripTriggerFingerSlotWall()-GripFloor()];

module GripAccessoryBossBolts(boltSpec=Spec_BoltM3(), length=UnitsMetric(24), clearance=true) {
  color("SteelBlue")
  for (offsetZ = GripAccessoryBossOffsets())
  translate([GripTabFrontMaxX(),0, -ReceiverCenter()+offsetZ])
  translate([0.75,0.54,0.25])
  rotate([90,0,0])
  NutAndBolt(bolt=boltSpec, clearance=clearance);
}
module GripAccessoryBosses(holes=true, cutter=false) {
  clearance = cutter ? 0.005 : 0;
  
  for (offsetZ = GripAccessoryBossOffsets())
  difference() {
    translate([GripTabFrontMaxX()+0.5,-clearance, -ReceiverCenter()+offsetZ-clearance])
    translate([0,-0.25,0])
    cube([0.51+clearance, (GripWidth()/2)+(clearance*2)+ManifoldGap(), 0.5+(clearance*2)]);
  
    if (holes)
    GripAccessoryBossBolts(clearance=true);
  }
}

module GripMiddle() {
  color("White")
  render()
  union() {
    difference() {
      intersection() {
        GripGuard(ReceiverTee());

        // Just the middle
        GripSplitter(clearance=0);
      }

      // Tigger Body Cutout
      translate([GripTabRearMinX(),
                 -GripWidth()/2,-ReceiverCenter()])
      mirror([0,0,1])
      cube([GripTabFrontMaxX()+abs(GripTabRearMinX())-GripTriggerFingerSlotRadius(), GripWidth(), 1.50]);
      
      // Trigger Front Extension Cutout
      translate([0,-0.5, GripOffsetZ()+ManifoldGap()])
      mirror([0,0,1])
      cube([GripTabFrontMaxX(), 1, GripFloor()+GripTriggerFingerSlotRadius()]);
      
      // #L12K easter egg
      if (Resolution(false, true))
      translate([-1.05, 0.22, -3.25])
      rotate([0,-90+25,0])
      rotate([0,0,180])
      rotate([90,0,0])
      linear_extrude(height=0.25) {
        text("#", size=0.6);
        
        translate([0.6, 0.08])
        text("L12K", size=0.4);
      }
    }
    
    GripAccessoryBosses(holes=true);
  }
}

module GripText() {
  
  // Text
  translate([-0.25,
             (GripWidth()/2)-0.02,
             -ReceiverCenter()-0.45])
  rotate([90,0,180])
  linear_extrude(height=0.1)
  text("L", size=0.35);

  translate([-0.25,
             -(GripWidth()/2)+0.02,
             -ReceiverCenter()-0.45])
  rotate([90,0,0])
  linear_extrude(height=0.1)
  text("R", size=0.35);
}

module Grip(showGripTabBolts=true, showGripAccessoryBolts=true, showGripBodyBolts=true,
            showTrigger=true, showTriggerLeft=true, showTriggerRight=true,
            showMiddle=true, showLeft=true, showRight=true) {
              
  if (showGripTabBolts)
  GripTabBoltHoles(clearance=false);
  
  if (showGripAccessoryBolts)
  GripAccessoryBossBolts(clearance=false);
  
  if (showGripBodyBolts)
  GripBodyScrews(clearance=false);
  
  // Trigger Guard Center
  if (showMiddle)
  GripMiddle();

  // Trigger Guard Sides
  color("Khaki")
  GripSides(showLeft=showLeft, showRight=showRight);

  // Trigger
  //color("Black", 0.25)
  if (showTrigger) {
    TriggerGroup(left=showTriggerLeft, right=showTriggerRight);
  }
}


Grip(showTrigger=true, showTriggerLeft=true, showTriggerRight=true,
        showLeft=true,
      showMiddle=true,
       showRight=true);

*color("Black", 0.25)
render()
%Reference();

// Left-side plater
*!scale(25.4)
rotate([90,0,0])
Grip(showGripTabBolts=false,showGripAccessoryBolts=false,showGripBodyBolts=false,
     showTrigger=false,
        showLeft=true,
      showMiddle=false,
       showRight=false);

// Middle plater
*!scale(25.4)
rotate([90,0,0])
Grip(showGripTabBolts=false,showGripAccessoryBolts=false,showGripBodyBolts=false,
     showTrigger=false,
        showLeft=false,
      showMiddle=true,
       showRight=false);

// Right-side plater
*!scale(25.4)
rotate([-90,0,0])
Grip(showGripTabBolts=false,showGripAccessoryBolts=false,showGripBodyBolts=false,
     showTrigger=false,
        showLeft=false,
      showMiddle=false,
       showRight=true);