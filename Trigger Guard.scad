//$t = 0;
include <Components.scad>;
use <Components/Semicircle.scad>;
use <Debug.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Frame.scad>;
use <Cylinder.scad>;
use <Trigger.scad>;
use <Reference.scad>;

function GripFloor() = 0.32;
function GripWidth() = 0.9;

function GripRodOffset() = TeeRimRadius(ReceiverTee())
                          + RodRadius(GripRod())
                          + WallTriggerGuardRod();

function GripHandleOffsetX(receiver=Spec_TeeThreeQuarterInch()) = -(TeeWidth(receiver)/2)+0.1;
function GripHandleOffsetZ(receiver=Spec_TeeThreeQuarterInch()) = -TeeCenter(receiver)-GripFloor();


function GripFloorZ() = -TeeCenter(ReceiverTee())-GripFloor();

function TeeHousingBottomExtension() = 0.27;

function GripTriggerFingerSlotDiameter() = 1.05;
function GripTriggerFingerSlotWall() = 0.25;

// XZY
function GripPins() = [

     // Front
     [-TeeRimRadius(ReceiverTee())-0.1, GripFloorZ()-GripTriggerFingerSlotDiameter(), 0],

     // Top-Back
     [-TeeCenter(ReceiverTee()), -TeeRimRadius(ReceiverTee()) - 0.4, 0],

     [SafetyPinX(), SafetyPinZ(), 0],
     
     [ResetPinX(), ResetPinZ(), 0.215],

     // Bottom-Back
     [-(TeeWidth(ReceiverTee())/2)-2,
      GripFloorZ(ReceiverTee())-GripTriggerFingerSlotDiameter()-1.1,
      0.07]
  ];


module GripBodyScrews() {
  translate([0,-(GripWidth()/2)+0.115,0])
  for (xzy = GripPins())
  translate([xzy[0],xzy[2],xzy[1]]) {
    rotate([-90,0,0])
    GripMX(nutHeightExtra=GripWidth(), capHeightExtra=GripWidth());
  }
}


module GripRod(length=2.5, extraRadius=0, enabled=true, clearance=RodClearanceLoose()) {

    echo("GripRod $fn=", $fn);                          
    rotate([90,0,0]) {
      if (enabled)
      cylinder(r=RodRadius(GripRod(), clearance)+extraRadius, center=true,
               h=length, $fn=$fn);
      
      children();
    }
}

module GripFrontRod(length=2.5, extraRadius=0, enabled=true, $fn=30) {
  translate([GripRodOffset(),0,-TeeCenter(ReceiverTee())-RodRadius(GripRod())-WallTriggerGuardRod()])
  GripRod(length=length, extraRadius=extraRadius,enabled=enabled, $fn=$fn)
  children();
}

// TODO: Find/make a public domain metric screw library.

/* M3: radius=0.115/2, length=0.9,
              capRadius=0.212/2, capHeight=0.123, capHeightExtra=0,
              nutRadius=0.247/2, nutHeight=0.096, nutHeightExtra=0


*/

module GripMX(length=20/25.4,
              radius=0.115/2, radiusExtra=0,
              capEnabled=true,
              capRadius=0.212/2, capRadiusExtra=0,
              capHeight=0.123, capHeightExtra=0,
              nutEnabled=true,
              nutRadius=0.247/2, nutRadiusExtra=0,
              nutHeight=0.096, nutHeightExtra=0,
              $fn=8) {
  union() {
    // Screw Body
    translate([0,0,0])
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

module GripRearRod(radiusExtra=0,
                   capEnabled=true, capRadiusExtra=0, capHeightExtra=0,
                   nutEnabled=true, nutRadiusExtra=0, nutHeightExtra=0,
                   $fn=8) {
  
  // Cap at back, forward into nut embedded within grip middle.
  for (i=[1,0])
  mirror([0,i,0])
  translate([0.0,0.07,-0.25])
  translate([-TeeCenter(ReceiverTee()),-TeeRimRadius(ReceiverTee()),-TeeRimRadius(ReceiverTee())])
  rotate([0,90,55])
  GripMX(radiusExtra=radiusExtra,
    capEnabled=capEnabled,
    capRadiusExtra=capRadiusExtra,
    capHeightExtra=capHeightExtra,
    nutEnabled=nutEnabled,
    nutRadiusExtra=nutRadiusExtra,
    nutHeightExtra=nutHeightExtra,
    $fn=$fn);
}

module GripTriggerFingerSlot(receiver, length=0.5, chamfer=true, $fn=Resolution(12, 60)) {
  render()
  union()
  translate([-(GripTriggerFingerSlotDiameter()/2)+0.4,
             0,
             GripFloorZ()-(GripTriggerFingerSlotDiameter()/2)]) {

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

      translate([-TeeWidth(receiver)*2,-5,GripTriggerFingerSlotDiameter()/2])
      cube([TeeWidth(receiver)*4, 10, 4]);
    }
  }
}

module GripGuard(receiver, stock=stockPipe) {
  height = GripTriggerFingerSlotDiameter()+GripTriggerFingerSlotWall()+GripFloor();

  difference() {
    union() {

      // Main block
      difference() {
        hull() {

          // Trigger side plate area
          translate([-2,
                     -GripWidth()/2,
                     GripFloorZ()-GripTriggerFingerSlotDiameter()-GripTriggerFingerSlotWall()])
          cube([0.1,
                GripWidth(),
                GripTriggerFingerSlotDiameter()]);

          // Front Curves
          for (i = [1,-1])
          translate([GripTriggerFingerSlotDiameter()/2, -i*GripWidth()/4, GripFloorZ()-(GripTriggerFingerSlotDiameter()/2)])
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
          
          GripFrontRod(length=GripWidth(), extraRadius=GripFloor(),
              $fn=RodFn(GripRod())*Resolution(1,3));
        }


        // Trigger Guard Bottom Chamfer
        translate([0,0,GripFloorZ()-GripTriggerFingerSlotDiameter()-GripTriggerFingerSlotWall()-0.05])
        difference() {
          translate([-TeeWidth(ReceiverTee()),-(GripWidth()/2)-1,-1])
          cube([TeeWidth(ReceiverTee())*2, GripWidth()+2, 1+(GripWidth()/2)]);

          translate([0,0,(GripWidth()/2)])
          rotate([0,-90,0])
          cylinder(r=GripWidth()*0.6, h=TeeWidth(ReceiverTee())*2.1,
                   center=true, $fn=Resolution(20,60));
        }
      }

      difference() {
        hull() {

          // Bolt support block
          translate([-TeeRimRadius(ReceiverTee()),-GripWidth()/2,-TeeCenter(ReceiverTee())])
          mirror()
          cube([(TeeWidth(ReceiverTee())/2)-TeeRimRadius(ReceiverTee()),
                GripWidth(),
                TeeCenter(ReceiverTee())]);

          // Rounded Back
          translate([-(TeeWidth(ReceiverTee())/2)-(GripWidth()/2),
                     0,
                     GripFloorZ()])
          cylinder(r=GripWidth()/2,
                   h=TeeCenter(ReceiverTee()),
                   $fn=Resolution(20, 60));

        }

        translate([-TeeWidth(ReceiverTee())/2,0,0])
        rotate([0,90,0])
        TeeRim(ReceiverTee());

        // Flatten the tee rim tips
        translate([-TeeWidth(ReceiverTee())/2,
                   -GripWidth(),
                   -TeeRimRadius(ReceiverTee())*0.85])
        cube([TeeRimWidth(ReceiverTee()), GripWidth()*2, 1]);

        // Flatten the pipe tips
        translate([-TeeWidth(ReceiverTee())-1,
                   -TeeRimRadius(ReceiverTee()),
                   -PipeOuterRadius(StockPipe())*0.7])
        cube([TeeWidth(ReceiverTee()),
              TeeRimDiameter(ReceiverTee()),
              TeeInnerRadius(ReceiverTee())]);

        rotate([0,-90,0])
        Pipe(StockPipe(), length=3);

      }


      GripHandle(ReceiverTee());
    }

    GripTriggerFingerSlot(receiver);
    
    GripFrontRod();
    GripRearRod();
    
    CylinderSpindle();

    GripBodyScrews(ReceiverTee());

    GripTriggerFingerSlot(ReceiverTee());
    
    GripText();
  }
}

module GripHandle(receiver, angle=30, length=1.25, height=4.5) {
  difference() {
    translate([GripHandleOffsetX()-1,0,-TeeCenter(receiver)-0.32])
    rotate([0,angle,0])
    union() {
      hull()
      for (i=[0,length])
      translate([i,0,-3])
      cylinder(r=GripWidth()/2, h=4, $fn=Resolution(20, 60));

      // Palm swell
      translate([0,0,0])
      translate([0.6,0,-1.4875])
      rotate([0,0,0])
      scale([2.5,1.7,4.25/GripWidth()])
      sphere(r=GripWidth()/2, $fn=Resolution(12, 60));

      // Finger swell
      translate([length,0,-1.175])
      scale([1,1,0.5])
      sphere(r=GripWidth()*0.7, $fn=Resolution(12, 60));
    }

    // Flatten the bottom
    translate([-6,-2,GripFloorZ()-3.8])
    rotate([0,20,0])
    cube([8, 4, 2]);
  }
}

module GripSplitter(clearance=0) {
  translate([-10, -0.125 -clearance, -10])
  cube([20, 0.25+(clearance*2), 20]);
}

module GripSides() {

  // Trigger Guard Sides
  difference() {
    union() {
        GripGuard(ReceiverTee());

      // Inner plug
      translate([0,0,GripFloorZ(ReceiverTee())-0.001])
      cylinder(r=TeeInnerRadius(ReceiverTee()),
               h=abs(GripFloorZ(ReceiverTee())) -0.35,
               $fn=Resolution(25, 60));

      // Bottom Chamfer
      translate([0,0,GripFloorZ(ReceiverTee())+GripFloor()-0.001])
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
    
    FireControlPins();
  }

}

module GripMiddle() {
  difference() {
    intersection() {
      GripGuard(ReceiverTee());

      // Just the middle
      GripSplitter(ReceiverTee(), clearance=0);
    }
    
    
    //GripRearRod(nutHeightExtra=1);

    // Tigger Group Cutout
    translate([-TeeRimRadius(ReceiverTee())-0.03,
               -2,GripFloorZ(ReceiverTee()) -(GripTriggerFingerSlotDiameter()/2)])
    cube([TeeRimDiameter(ReceiverTee())-0.25, 4,4]);

    // Reset Spring Body OD
    translate([ResetPinX(), 0, ResetPinZ()])
    rotate([90,-112])
    hull() {
      cylinder(r=0.6, center=true, $fn=Resolution(12, 40));

      linear_extrude(center=true)
      semicircle(od=5, angle=64);
    }

    // Trigger Travel Cutout
    translate([TriggerPinX(),0,TriggerPinZ()])
    rotate([90,60,0])
    linear_extrude(height=1, center=true) {

      // Main body track
      semicircle(od=TriggerMaxMajor(), angle=100);

      // Reset spring extension track
      rotate(-61.7)
      semicircle(od=3.24, angle=15);
    }

    // Safety Travel Cutout
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
  translate([-(TeeWidth(ReceiverTee())/2)-0.1,
             (GripWidth()/2)-0.02,
             -TeeRimRadius(ReceiverTee())-0.1])
  rotate([90,0,180])
  linear_extrude(height=0.1)
  text("L", size=0.3);

  translate([-(TeeWidth(ReceiverTee())/2)-0.3,
             -(GripWidth()/2)+0.02,
             -TeeRimRadius(ReceiverTee())-0.1])
  rotate([90,0,0])
  linear_extrude(height=0.1)
  text("R", size=0.3);
}



module Grip(showTrigger=false) {


  // Trigger
  if (showTrigger)
  TriggerGroup();

  // Trigger Guard Center
  color("White", 0.8)
  render()
  GripMiddle();

  // Trigger Guard Sides
  color("Khaki", 0.5)
  render()
  GripSides();

}

//vpr = [$vpr[0], $vpr[1], $t * 360];
scale([25.4, 25.4, 25.4])
//rotate([30,0,120+(15*-$t)])
//render() DebugHalf(dimension=1500)
{
  Grip(showTrigger=true);

  *%color("DarkGrey", 0.5) {
    Reference();
    Frame();
    translate([0,0,-CylinderChamberOffset()])
    rotate([0,90,0])
    Rod(CylinderRod(),length=5);
  }
}

module Plater_TriggerGuard() {

  // Trigger Guard Center
  color("CornflowerBlue")
  render()
  rotate([90,0,-70])
  translate([1,0.25/2,5])
  GripMiddle(ReceiverTee());

  // Trigger Guard Sides
  color("Khaki")
  render()
  for (i = [-1,1])
  rotate([i*90,0,0])
  translate([3,-i*0.125,0])
  difference() {
    GripSides(ReceiverTee());
    DebugHalf(mirrorArray=[0,i==1?1:0,0], dimension=12);
  }
}

!scale([25.4, 25.4, 25.4]) {
  intersection() {
    Plater_TriggerGuard();
    //#cube([4, 3, 0.4]);
  }
}