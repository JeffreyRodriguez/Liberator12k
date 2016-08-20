//$t=0.8;
use <Components/Manifold.scad>;
use <Components/Semicircle.scad>;
use <Components/Debug.scad>;
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
function GripPinY(pin) = GripPins()[pin][2];
function GripPinZ(pin) = GripPins()[pin][1];

// XZY
function GripPins() = [

   // Front-Bottom
   [BreechFrontX(),GripFloorZ()-GripTriggerFingerSlotDiameter()+0.125, 0],
   
   // Behind Trigger Finger Slot
   [TriggerBoltX(),TriggerBoltZ(), 0],
   
   // Handle Bottom-Rear
   [GripHandleOffsetX()-ReceiverOR()-1.75,GripFloorZ()-2.4, 0],
   
   // Handle Bottom-Front
   [GripHandleOffsetX()-ReceiverOR()-0.5,GripFloorZ()-2.9, 0]
];



// TODO: Find/make a public domain metric screw library.

/* M3: radius=0.115/2, capRadius=0.212/2, nutRadius=0.247/2, nutHeight=0.096
   M8: radius=0.3,     capRadius=0.29,    nutRadius=0.29,  nutHeight=0.3,
*/
module GripMX(length=24/25.4,
              radius=(0.115/2)+0.02, radiusExtra=0,
              capEnabled=true,
              capRadius=(0.212/2)+0.01, capRadiusExtra=0.001,
              capHeight=0.123, capHeightExtra=0,
              nutEnabled=true,
              nutRadius=0.247/2, nutRadiusExtra=0.002,
              nutHeight=0.096, nutHeightExtra=0,
              $fn=8) {
  union() {
    // Screw Body
    cylinder(r=radius+radiusExtra, h=length, $fn=$fn);
    
    // Cap
    if (capEnabled)
    translate([0,0,-capHeight-capHeightExtra])
    cylinder(r=capRadius+capRadiusExtra, h=capHeight+capHeightExtra+ManifoldGap(), $fn=12);
    
    // Nut
    if (nutEnabled)
    translate([0,0,length-nutHeight])
    cylinder(r=nutRadius+nutRadiusExtra, h=nutHeight+nutHeightExtra, $fn=6);
  }
  
}

module GripBodyScrews(boltSpec=TriggerBoltSpec(), length=24/25.4, cutter=1) {
  *for (xzy = GripPins())
  translate([xzy[0],xzy[2],xzy[1]])
  translate([0,-(GripWidth()/2)+0.055,0])
  rotate([-90,0,0])
  GripMX(nutHeightExtra=GripWidth(), capHeightExtra=GripWidth());
  
  //translate([TriggerBoltX(), GripWidth()/2, TriggerBoltZ()])
  color("SteelBlue")
  for (xzy = GripPins())
  translate([xzy[0],xzy[2],xzy[1]])
  translate([0,(GripWidth()/2),0])
  rotate([90,0,0])
  color("SteelBlue")
  NutAndBolt(bolt=TriggerBoltSpec(), boltLength=length, clearance=true,
              capHeightExtra=cutter, nutHeightExtra=cutter);
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
      intersection() {
        hull() {
        
          // Main block
          translate([-ReceiverOR(), -GripWidth()/2,
                     -ReceiverCenter()-height])
          cube([ReceiverOR()+BreechFrontX()+0.25,
                GripWidth(),
                height]);
        }
    
        // Bottom curve cutter
        translate([0,0,-ReceiverCenter()-height+0.125])
        rotate([0,90,0])
        linear_extrude(height=ReceiverLength()*2, center=true)
        hull() {
          for (i = [-1, 1])
          translate([0,((GripWidth()/2)-0.09)*i])
          circle(r=0.1, $fn=Resolution(12,24));
          
          translate([-height-0.125,(-GripWidth()/2)-ManifoldGap()])
          square([height,GripWidth()+ManifoldGap(2)]);
        }
      }
      
      // Front grip tab support (block)
      hull() {
        
        // Front cube
        translate([BreechFrontX()-1.25,-0.625,-ReceiverCenter()-GripFloor()])
        cube([1.5, 1.25, GripFloor()]);
        
        // Rear cube
        translate([0.25,-0.5,-ReceiverCenter()-GripFloor()-GripTriggerFingerSlotRadius()])
        cube([BreechFrontX(), 1, GripFloor()+GripTriggerFingerSlotRadius()]);
      }
      
      // Rear Grip Tab Bolt Support
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
    
    GripTabFront(clearance=0.005);
    GripTabRear(clearance=0.005);

    GripBodyScrews(ReceiverTee());
    
    GripTabBoltHoles();
    
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

module GripMiddle() {
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

module Grip(showGripTabBolts=true,
            showTrigger=true, showTriggerLeft=true, showTriggerRight=true,
            showMiddle=true, showLeft=true, showRight=true) {
              
  if (showGripTabBolts)
  GripTabBoltHoles(capHeightExtra=0, nutHeightExtra=0, clearance=false);

  
  // Trigger Guard Center
  color("White")
  render()
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
Grip(showTrigger=false,
        showLeft=true,
      showMiddle=false,
       showRight=false);

// Middle-side plater
*!scale(25.4)
rotate([90,0,0])
Grip(showTrigger=false,
        showLeft=false,
      showMiddle=true,
       showRight=false);

// Right-side plater
*!scale(25.4)
rotate([-90,0,0])
Grip(showTrigger=false,
        showLeft=false,
      showMiddle=false,
       showRight=true);