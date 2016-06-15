//$t=0;
include <Components.scad>;
use <Components/Semicircle.scad>;
use <Components/Debug.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Frame.scad>;
use <Cylinder.scad>;
use <Trigger.scad>;
use <Striker.scad>;
use <Reference.scad>;
use <Reset Spring.scad>;

function GripFloor() = 0;
function GripWidth() = 0.9;

function GripRodOffset() = TeeRimRadius(ReceiverTee())
                          + RodRadius(GripRod())
                          + WallTriggerGuardRod();

function GripFloorZ() = -ReceiverCenter()-GripFloor();

function TeeHousingBottomExtension() = 0.27;

function GripTriggerFingerSlotDiameter() = 0.8;
function GripTriggerFingerSlotWall() = 0.35;

// XZY
function GripPins() = [
     
     // Top-Back, above safety
     [-TeeCenter(ReceiverTee())-0.35, -TeeRimRadius(ReceiverTee()) + 0.1, -0.03],

     [SafetyPinX(), SafetyPinZ(), -0.03],
     
     [ResetPinX(), ResetPinZ(), 0.215],

     // Bottom-Back tip
     [-(ReceiverLength()/2)-2.4,
      GripFloorZ()-GripTriggerFingerSlotDiameter()-1.45,
      -0.03],

     // Bottom-Front tip
     [-(ReceiverLength()/2)-1.08,
      GripFloorZ()-GripTriggerFingerSlotDiameter()-1.90,
      -0.03]
  ];



// TODO: Find/make a public domain metric screw library.

/* M3: radius=0.115/2, capRadius=0.212/2, nutRadius=0.247/2, nutHeight=0.096
   M8: radius=0.3,     capRadius=0.29,    nutRadius=0.29,  nutHeight=0.3,
*/
module GripMX(length=20/25.4,
              radius=(0.115/2)+0.02, radiusExtra=0,
              capEnabled=true,
              capRadius=(0.212/2)+0.01, capRadiusExtra=0,
              capHeight=0.123, capHeightExtra=0,
              nutEnabled=true,
              nutRadius=0.247/2, nutRadiusExtra=0,
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

module GripBodyScrews() {
  translate([0,-(GripWidth()/2)+0.115,0])
  for (xzy = GripPins())
  translate([xzy[0],xzy[2],xzy[1]]) {
    rotate([-90,0,0])
    GripMX(nutHeightExtra=GripWidth(), capHeightExtra=GripWidth());
  }
}

module GripFrontRod(length=2.5, offsetZ=0,
                   radius=RodRadius(GripRod(), RodClearanceLoose),
                   extraRadius=0,
                   $fn=Resolution(8,30)) {
  
  radiusExtra = extraRadius;
                     
  // Angled bolt
  translate([TeeRimRadius(ReceiverTee())+RodRadius(GripRod())+0.15,0,-TeeCenter(ReceiverTee())-RodRadius(GripRod())-0.07])
  rotate([0,0,-69])
  rotate([0,-90+5,0]) {
    translate([0,0,offsetZ])
    cylinder(r=radius+radiusExtra, h=length, center=true);
  
    children();
  }
}

module GripRearRod(length=2.5,
                   radius=RodRadius(GripRod(), RodClearanceLoose),
                   radiusExtra=0,
                   $fn=Resolution(8,30)) {
  translate([-TeeCenter(ReceiverTee())+0.27,0,-TeeRimRadius(ReceiverTee())-0.35])
  rotate([0,0,-69])
  rotate([0,-90+5,0]) {
    cylinder(r=radius+radiusExtra, h=length, center=true);
  
    children();
  }
}

module GripTriggerFingerSlot(receiver=ReceiverTee(), length=0.6, chamfer=true, $fn=Resolution(12, 60)) {
  render()
  union()
  translate([-GripTriggerFingerSlotDiameter()-ReceiverOR(),
             0,
             GripFloorZ()]) {

    // Trigger guard hole
    hull()
    for (i = [0,length])
    translate([i,0,0])
    rotate([90,0,0])
    cylinder(r=(GripTriggerFingerSlotDiameter()/2),
             h=4, $fn=$fn, center=true);

    // Chamfer the rim
    if (chamfer)
    difference() {
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
        cylinder(r1=GripTriggerFingerSlotDiameter()*0.5,
                 r2=GripTriggerFingerSlotDiameter()*0.6,
                 h=(GripWidth()/2)-0.125, $fn=$fn);
      }

      translate([-ReceiverLength()*2,-5,GripTriggerFingerSlotDiameter()/2])
      cube([ReceiverLength()*4, 10, 4]);
    }
  }
}

module GripHandle(receiver, angle=30, length=1.3, height=4.75) {
  translate([-(ReceiverLength()/2)-1.5,0,-TeeCenter(ReceiverTee())])
  rotate([0,angle,0])
  difference() {
    union() {
      hull()
      for (i=[0,length])
      translate([i,0,-3.25])
      cylinder(r=GripWidth()/2, h=height, $fn=Resolution(20, 60));

      // Palm swell
      translate([0,0,0])
      translate([0.6,0,-1.1875])
      rotate([0,0,0])
      scale([2.5,1.7,4.25/GripWidth()])
      sphere(r=GripWidth()/2, $fn=Resolution(12, 60));

      // Finger swell
      translate([length,0,-0.8])
      scale([1,1.05,0.5])
      sphere(r=GripWidth()*0.7, $fn=Resolution(12, 60));
    }

    // Flatten the bottom
    translate([-4,-2,-1-height])
    rotate([0,-10,0]) // TODO: Parameterize this with angle?
    cube([8, 4, 2]);
  }
}

module GripGuard(receiver, stock=stockPipe, showHandle=true) {
  height = GripTriggerFingerSlotDiameter()+GripTriggerFingerSlotWall()+GripFloor();

  difference() {
    union() {

      // Main block
      difference() {
        hull() {

          // Trigger side plate area
          translate([-1.5,
                     (-GripWidth()/2)+0.1,
                     GripFloorZ()-(GripTriggerFingerSlotDiameter()/2)])
          cube([0.1,
                GripWidth()-0.2,
                GripTriggerFingerSlotDiameter()]);
          
          // Front-bottom chamfered curve
          for (i = [1,-1])
          translate([-(GripTriggerFingerSlotDiameter()/2),
                     -i*GripWidth()/4,
                     GripFloorZ()-(GripTriggerFingerSlotDiameter()/2)])
          rotate([i*90,0,0])
          cylinder(r1=(GripTriggerFingerSlotDiameter()/2)+GripTriggerFingerSlotWall(),
                   r2=(GripTriggerFingerSlotDiameter()/2)+GripTriggerFingerSlotWall()-0.05,
                   h=GripWidth()/4,
                   $fn=Resolution(20,60));
          
          // Tee Bottom Flats
          translate([-TeeRimRadius(ReceiverTee())-0.25, -GripWidth()/2,
                     GripFloorZ()])
          cube([TeeRimDiameter(ReceiverTee())+0.25,
          
                GripWidth(),
                GripFloor()]);
          
          // Front flat
          translate([ReceiverOR(),-GripWidth()/2,-TeeCenter(ReceiverTee())])
          mirror([0,0,1])
          cube([ReceiverCenter()-ReceiverOR()+WallFrameFront(),
                GripWidth(),
                RodDiameter(GripRod())+WallFrontGripRod()]);
        
          // Grip Block Rear
          #translate([-TeeRimRadius(ReceiverTee()),-GripWidth()/2,0])
          mirror([1,0,1])
          cube([abs(GripFloorZ())
                +(GripTriggerFingerSlotDiameter()/2)
                +GripTriggerFingerSlotWall(),
                GripWidth(),
                ReceiverCenter()]);
        }
        
        // Trigger Guard Bottom Edge Chamfer
        translate([0,0,GripFloorZ()-(GripTriggerFingerSlotDiameter()/2)-GripTriggerFingerSlotWall()-0.05])
        difference() {
          translate([-ReceiverLength(),-(GripWidth()/2)-1,-1])
          cube([ReceiverLength()*2, GripWidth()+2, 1+(GripWidth()/2)]);

          translate([0,0,(GripWidth()/2)])
          rotate([0,-90,0])
          cylinder(r=GripWidth()*0.6, h=ReceiverLength()*2.1,
                   center=true, $fn=Resolution(20,60));
        }
      }

      if (showHandle)
      GripHandle(ReceiverTee());
    }
    
    ReferenceTeeCutter();
    
    // Flatten the front-top
    translate([0,-ReceiverOR(), -ReceiverCenter()-ManifoldGap()])
    cube([ReceiverLength(), ReceiverOD(), ReceiverCenter()]);

    // Flatten the back tee rim tips
    translate([-ReceiverLength()/2,
               -GripWidth(),
               -TeeRimRadius(ReceiverTee())*0.85])
    cube([TeeRimWidth(ReceiverTee()), GripWidth()*2, 1]);

    // Flatten the stock tips
    translate([-ReceiverLength()-1,
               -TeeRimRadius(ReceiverTee()),
               -PipeOuterRadius(StockPipe())*0.7])
    cube([ReceiverLength(),
          TeeRimDiameter(ReceiverTee()),
          TeeInnerRadius(ReceiverTee())]);

    rotate([0,-90,0])
    Pipe(StockPipe(), length=3);

    GripTriggerFingerSlot(receiver);
    
    GripFrontRod();
    GripRearRod();
    
    CylinderSpindle();

    GripBodyScrews(ReceiverTee());

    GripTriggerFingerSlot(ReceiverTee());
    
    GripText();
  }
}

module GripSplitter(clearance=0) {
  translate([-10, -0.125 -clearance, -10])
  cube([20, 0.25+(clearance*2), 20]);
}

module GripSides(showLeft=true, showRight=true) {

  // Trigger Guard Sides
  difference() {
    union() {
        GripGuard(ReceiverTee());

      // Bottom Chamfer
      translate([0,0,GripFloorZ()+GripFloor()-0.001])
      intersection() {
        cylinder(r1=TeeInnerRadius(ReceiverTee())*1.1,
                  r2=TeeInnerRadius(ReceiverTee()),
                  h=0.05,
                  $fn=Resolution(25, 60));

        // Chop off the sides
        cube([ReceiverInnerWidth(ReceiverTee()), GripWidth(), 0.2], center=true);
      }
    }

    GripSplitter(ReceiverTee(), clearance=0.0000001);
    
    if (showLeft == false)
    translate([-10,0,-10])
    cube([20,2,20]);
    
    if (showRight == false)
    translate([-10,-2,-10])
    cube([20,2,20]);
  }

}

module GripMiddle(safetyCutout=true, resetCutout=true) {
  difference() {
    intersection() {
      GripGuard(ReceiverTee());

      // Just the middle
      GripSplitter(ReceiverTee(), clearance=0);
    }

    // Tigger Group Cutout
    translate([-ReceiverOR(),
               -2,
               GripFloorZ() -(GripTriggerFingerSlotDiameter()/2)])
    #cube([ReceiverOR()+RodDiameter(SearRod()), 4,4]);

    // Reset Spring Body OD
    *if (resetCutout)
    translate([ResetPinX(), 0, ResetPinZ()])
    rotate([90,-112])
    hull() {
      cylinder(r=0.6, center=true, $fn=Resolution(12, 40));

      linear_extrude(center=true)
      semicircle(od=5, angle=64);
    }

    // Trigger Travel Cutout
    *translate([TriggerPinX(),0,TriggerPinZ()])
    rotate([90,60,0])
    linear_extrude(height=1, center=true) {

      // Main body track
      semicircle(od=TriggerMaxMajor(), angle=90+TriggerAngle());

      // Reset spring extension track
      rotate(-61.7)
      semicircle(od=3.24, angle=15+TriggerAngle());
    }

    // Safety Travel Cutout
    *if (safetyCutout)
    translate([SafetyPinX(), 0, SafetyPinZ()])
    rotate([90,0,0])
    linear_extrude(height=1, center=true) {

      // Trigger-engagement surface
      //rotate(135)
      //mirror()
      rotate(135-SafetyBackAngle())
      mirror()
      semicircle(od=TriggerMaxMajor()+0.1, angle=SafetyAngle()+SafetyBarAngle(), $fn=Resolution(12, 100));

      // Hand-engagement surface
      //rotate(SafetyAngle())
      rotate(-50)
      mirror()
      semicircle(od=SafetyMajorOD()+0.1, angle=110+SafetyAngle(), $fn=Resolution(12, 100));

      // Safety Spindle Body
      circle(r=SafetyMinorRadius()+0.02, $fn=Resolution(12, 40));
    }
  }
}


module GripText() {
  
  // Text
  translate([-(ReceiverLength()/2)-0.1,
             (GripWidth()/2)-0.02,
             -TeeRimRadius(ReceiverTee())-0.1])
  rotate([90,0,180])
  linear_extrude(height=0.1)
  text("L", size=0.3);

  translate([-(ReceiverLength()/2)-0.2,
             -(GripWidth()/2)+0.02,
             -TeeRimRadius(ReceiverTee())-0.35])
  rotate([90,0,0])
  linear_extrude(height=0.1)
  text("R", size=0.3);
}



module Grip(showTrigger=false, showLeft=true, showRight=true) {


  // Trigger
  if (showTrigger)
  TriggerGroup();

  // Trigger Guard Center
  color("White")
  render()
  GripMiddle();

  // Trigger Guard Sides
  color("Khaki")
  render()
  GripSides(showLeft=showLeft, showRight=showRight);

}

//vpr = [$vpr[0], $vpr[1], $t * 360];
//rotate([30,0,120+(15*-$t)])
//render() DebugHalf(dimension=1500)
{

  translate([0,0,0]) {
    Grip(showTrigger=true, showLeft=false, showRight=true);

    Reference();
    %Frame();
    
    translate([0,0,-CylinderChamberOffset()])
    rotate([0,90,0])
    %Rod(CylinderRod(),length=12);
  }
}