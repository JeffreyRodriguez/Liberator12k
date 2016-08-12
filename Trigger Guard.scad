//$t=0.8;
use <Components/Semicircle.scad>;
use <Components/Debug.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Frame.scad>;
use <Cylinder.scad>;
use <Trigger.scad>;
use <Striker.scad>;
use <Sear.scad>
use <Reference.scad>;
use <Grip Tabs.scad>;
use <Reset Spring.scad>;

function GripHandleOffsetX() = -0.125;
function GripFloor() = 0.6;
function GripWidth() = 1;

function GripRodOffset() = TeeRimRadius(ReceiverTee())
                          + RodRadius(GripRod())
                          + WallTriggerGuardRod();

function GripFloorZ() = -ReceiverCenter()-GripFloor();

function TeeHousingBottomExtension() = 0.27;

function GripTriggerFingerSlotDiameter() = 0.9;
function GripTriggerFingerSlotRadius() = GripTriggerFingerSlotDiameter()/2;
function GripTriggerFingerSlotOffsetZ() = -ReceiverCenter() -GripFloor() -GripTriggerFingerSlotRadius();
function GripTriggerFingerSlotWall() = 0.25;

function GripPinX(pin) = GripPins()[pin][0];
function GripPinY(pin) = GripPins()[pin][2];
function GripPinZ(pin) = GripPins()[pin][1];


// XZY
function GripPins() = [
     
     // Behind front grip tab
     //[ReceiverOR(),GripFloorZ()+0.375, 0],
     
     // Front-Top
     [BreechFrontX(),-ReceiverCenter()-(GripFloor()/2), 0],
     
     // Front-Bottom
     [BreechFrontX(),GripFloorZ()-GripTriggerFingerSlotDiameter()+0.125, 0],
     
     // Back-Top
     [-ReceiverCenter()-WallFrameBack()+0.5,GripFloorZ()+0.375, 0],
     
     // Behind Trigger Finger Slot
     [-0.5,GripFloorZ()-0.5, 0],
     
     // Handle Bottom-Rear
     [GripHandleOffsetX()-ReceiverOR()-1.75,GripFloorZ()-2.4, 0],
     
     // Handle Bottom-Front
     [GripHandleOffsetX()-ReceiverOR()-0.5,GripFloorZ()-2.9, 0]
  ];



// TODO: Find/make a public domain metric screw library.

/* M3: radius=0.115/2, capRadius=0.212/2, nutRadius=0.247/2, nutHeight=0.096
   M8: radius=0.3,     capRadius=0.29,    nutRadius=0.29,  nutHeight=0.3,
*/
module GripMX(length=25/25.4,
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

module GripScrew() {
  translate([0,-(GripWidth()/2)+0.055,0])
  rotate([-90,0,0])
  GripMX(nutHeightExtra=GripWidth(), capHeightExtra=GripWidth());
}

module GripBodyScrews() {
  for (xzy = GripPins())
  translate([xzy[0],xzy[2],xzy[1]])
  GripScrew();
}

module GripTriggerFingerSlot(receiver=ReceiverTee(), length=0.7, chamfer=false, $fn=Resolution(12, 60)) {
  render()
  union()
  translate([0.45,
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
    
        // Bottom curve
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
          
      // Front grip tab support
      hull() {
        for (i=[-0.125,-1.0])
        translate([ReceiverCenter()+WallFrameFront()+i,0,-ReceiverCenter()])
        mirror([0,0,1])
        cylinder(r=0.625, h=GripFloor(), $fn=Resolution(12,60));
        
        // Hull-smoothing block
        translate([0,-0.25,GripFloorZ()-GripTriggerFingerSlotDiameter()])
        cube([BreechFrontX(), 0.5, 0.1]);
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
    
    GripTriggerFingerSlot();
    
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

module GripMiddle(safetyCutout=true, resetCutout=true) {
  render()
  difference() {
    intersection() {
      GripGuard(ReceiverTee());

      // Just the middle
      GripSplitter(clearance=0);
    }

    // Tigger Group Cutout
    translate([-1.7,
               -GripWidth()/2,-ReceiverCenter()])
    mirror([0,0,1])
    cube([2.7, GripWidth(), 1.505]);
    
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



module Grip(showTrigger=false, debugTrigger=false, showMiddle=true, showLeft=true, showRight=true) {


  // Trigger
  if (showTrigger)
  TriggerGroup(debug=debugTrigger);

  // Trigger Guard Center
  color("White")
  render()
  if (showMiddle)
  GripMiddle();

  // Trigger Guard Sides
  color("Khaki")
  GripSides(showLeft=showLeft, showRight=showRight);

}

//vpr = [$vpr[0], $vpr[1], $t * 360];
//rotate([30,0,120+(15*-$t)])
//render() DebugHalf(dimension=1500)
{

  translate([0,0,0]) {
    Grip(showTrigger=true,
            showLeft=false,
          showMiddle=true,
           showRight=true);

    color("white", 0.1)
    render()
    *%Reference();
  }
}

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