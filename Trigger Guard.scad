//$t = 0;
include <Components.scad>;
use <Components/Semicircle.scad>;
use <Debug.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Frame.scad>;
use <Forend Rail.scad>;
use <Trigger.scad>;
use <Reference.scad>;

function GripPinOffsetX() = TeeRimRadius(ReceiverTee())
                          + RodRadius(GripRod())
                          + WallTriggerGuardRod();

function GripFloor() = 0.32;
function GripWidth() = 0.9;
function GripOffsetX(receiver=Spec_TeeThreeQuarterInch()) = -(TeeWidth(receiver)/2)+0.1;
function GripOffsetZ(receiver=Spec_TeeThreeQuarterInch()) = -TeeCenter(receiver)-GripFloor();

function TriggerGuardPinZ() = -TeeRimRadius(ReceiverTee()) -RodRadius(FrameRod()) -0.14;
function TriggerGuardFrontPinZ() = TriggerGuardPinZ()-0.05;

function TeeHousingBaseZ(receiver) = -TeeCenter(receiver)-GripFloor();

function TeeHousingBottomExtension() = 0.27;
function TeeHousingFrontExtension(bushing=breechBushing) = BushingHeight(bushing) - BushingDepth(bushing);


module TriggerGuardAlignmentPins(receiver, length=GripWidth()-0.22, nutOd=0.25, pin=Spec_RodOneEighthInch()) {
  ResetPin();

  for (xz = [
    
     // Front
     [(TeeWidth(receiver)/2) -0.1, TeeHousingBaseZ(receiver)-0.4],

     // TODO: Remove these two? We have the Bic pins in the code
     [SafetyPinX(), SafetyPinZ()],
     [ResetPinX(), ResetPinZ()],

     // Bottom-rear
     [-(TeeWidth(receiver)/2)-2.2,
      TeeHousingBaseZ(receiver)-TriggerGuardHeight()-1]
  ])
  translate([xz[0],0,xz[1]]) {
    rotate([90,0,0])
    Rod(rod=pin, center=true, clearance=RodClearanceLoose(),
        length=GripWidth()+0.2);

    for (side = [1,-1])
    translate([0,side*length/2,0])
    rotate([-90*side,0,0])
    cylinder(r=nutOd/2, h=1, $fn=6);
  }
}

module TeeHousingPins(receiver, pin=Spec_RodFiveSixteenthInch(), clearance=RodClearanceLoose()) {
  TeeHousingFrontPin(receiver, pin=pin, clearance=clearance);
  TeeHousingRearPin(receiver, pin=pin, clearance=clearance);
}

module TeeHousingFrontPin(receiver=ReceiverTee(), length=2.5, extraRadius=0, enabled=true,
                          clearance=RodClearanceLoose(), $fn=undef) {
  translate([GripPinOffsetX(),
             0,TriggerGuardFrontPinZ()])
    rotate([90,0,0]) {
      if (enabled)
      cylinder(r=RodRadius(GripRod(), clearance)+extraRadius, center=true,
               h=length, $fn=($fn != undef ? $fn : RodFn(pin)));
      children();
    }
}

module TeeHousingRearPin(receiver, length=2.5, extraRadius=0, enabled=true,
                        stock=Spec_PipeThreeQuarterInch(),
                        pin=Spec_RodFiveSixteenthInch(),
                        clearance=RodClearanceLoose(),
                        wall=tee_overlap, $fn=undef) {
  translate([-TeeRimRadius(receiver) -RodRadius(pin)-WallTriggerGuardRod(),
             0,TriggerGuardPinZ()])
    rotate([90,0,0]) {
      if (enabled)
      cylinder(r=RodRadius(pin, clearance)+extraRadius, center=true,
               h=length, $fn=($fn != undef ? $fn : RodFn(pin)));

      children();
  }
}

module TeeHousingPinFlat(offset=0.3, diameter=0.58, length=5) {
  translate([0,0,offset])
  cylinder(r=diameter/2, h=length, $fn=6);
}


module TriggerGuardSplitter(receiver, triggerGuardHole=TriggerGuardHole(),
                              frontExtension=TeeHousingFrontExtension(), clearance=0) {
  translate([-10, -0.125 -clearance, -10])
  cube([20, 0.25+(clearance*2), 20]);
}

module ReferenceTeeCutter(centerLength = TeeRimDiameter(ReceiverTee())) {
  translate([-centerLength/2,-centerLength/2,-TeeCenter(ReceiverTee())])
  cube([centerLength, centerLength, TeeCenter(ReceiverTee())]);
  //TeeRim(ReceiverTee(), height=TeeCenter(ReceiverTee()));

  translate([-TeeWidth(ReceiverTee())/2,0,0])
  rotate([0,90,0])
  TeeRim(ReceiverTee(), height=TeeWidth(ReceiverTee()));
}

function TriggerGuardHeight() = 1.31;
function TriggerGuardHole() = 1.05;

module TriggerGuardFingerSlot(receiver, length=0.5, chamfer=true, $fn=Resolution(20, 60)) {

    render()
    union()
    translate([-(TriggerGuardHole()/2)+0.4,0,-TeeCenter(receiver)-(TriggerGuardHole()/2) - GripFloor()]) {

      // Trigger guard hole
      hull()
      for (i = [0,length])
      translate([i,0,0])
      rotate([90,0,0])
      cylinder(r=(TriggerGuardHole()/2),
               h=4, $fn=$fn, center=true);

      // Chamfer the rim
      if (chamfer)
      difference() {
        for (side = [1, 0])
        mirror([0,side,0])
        hull()
        for (i = [0,length]) {
          translate([i,0.125 + (GripWidth()/8)])
          rotate([-90,0,0])
          cylinder(r1=TriggerGuardHole()*0.5,
                   r2=TriggerGuardHole()*0.6,
                   h=(GripWidth()/2)-0.125, $fn=$fn);

          translate([i,0.125 + (GripWidth()/2)])
          rotate([-90,0,0])
          cylinder(r=TriggerGuardHole()*0.6,
                   h=2, $fn=$fn);
        }

        translate([-TeeWidth(receiver)*2,-5,TriggerGuardHole()/2])
        cube([TeeWidth(receiver)*4, 10, 4]);
      }
    }
}

module TriggerGuardBlock(receiver, stock=stockPipe) {
  height = TriggerGuardHeight()+abs(TeeHousingBaseZ(receiver));
  rearLength = 0.72;

  difference() {
    union() {
      // Main block
      translate([-(TeeWidth(ReceiverTee())/2)-rearLength,
                 -GripWidth()/2,
                 TeeHousingBaseZ(ReceiverTee())-TriggerGuardHeight()])
      cube([TeeWidth(receiver)+TeeHousingFrontExtension()+rearLength,
            GripWidth(),
            height]);

      // Rounded Back
      translate([-(TeeWidth(ReceiverTee())/2)-rearLength,
                 0,
                 TeeHousingBaseZ(ReceiverTee())-TriggerGuardHeight()])
      cylinder(r=GripWidth()/2, h=height, $fn=Resolution(20, 60));

      TriggerGuardGrip(ReceiverTee());
    }

    // Stock
    Stock(ReceiverTee(), stock, 12+(TeeWidth(ReceiverTee())/2));

    // Tee
    ReferenceTeeCutter();

    // Cut down the front top
    translate([TeeInnerRadius(ReceiverTee()), -(GripWidth()/2)-0.1,-TeeRimRadius(ReceiverTee())])
    cube([TeeWidth(ReceiverTee()), GripWidth()+0.2, TeeCenter(ReceiverTee())]);

    // Cut down the rear top
    translate([-(TeeWidth(ReceiverTee())/2)-WallFrameBack()-0.01, -(GripWidth()/2)-0.1,-TeeRimRadius(ReceiverTee())])
    cube([WallFrameBack()+(TeeWidth(ReceiverTee())/2)-TeeInnerRadius(ReceiverTee()), GripWidth()+0.2, TeeCenter(ReceiverTee())]);

    TriggerGuardFingerSlot(receiver);

    // Chop down the bottom
    rotate([0,20,0])
    translate([-4,-2,-2-(height*2)+0.38])
    cube([8, 4, 2]);

    // Front curve
    translate([-2,0,1.8])
    translate([(TeeWidth(receiver)/2)+TeeHousingFrontExtension(),
               0, TeeHousingBaseZ(receiver)-TriggerGuardHeight()])
    difference() {
      translate([0,-GripWidth(),-4])
      cube([4,GripWidth()*2,4]);

      rotate([90,0,0])
      cylinder(r=2, h=GripWidth()*3, $fn=Resolution(20, 60), center=true);
    }
  }
}

module TriggerGuardGrip(receiver, angle=30, length=1.25, height=4.25) {
    translate([GripOffsetX()-1,0,-TeeCenter(receiver)-0.32])
    rotate([0,angle,0])
    union() {
      hull()
      for (i=[0,length])
      translate([i,0,-height+1])
      cylinder(r=GripWidth()/2, h=height, $fn=Resolution(20, 60));

      // Palm swell
      translate([0,0,0])
      translate([0.6,0,-1.4875])
      rotate([0,0,0])
      scale([2.5,1.7,height/GripWidth()])
      sphere(r=GripWidth()/2, $fn=Resolution(12, 60));
    }
}

module TriggerGuardSides(receiver,
  frontExtension = TeeHousingFrontExtension()) {

  // Trigger Guard Sides
  difference() {
    union() {
        TriggerGuardBlock(receiver);

      // Inner plug
      translate([0,0,TeeHousingBaseZ(receiver)-0.001])
      cylinder(r=TeeInnerRadius(receiver),
               h=abs(TeeHousingBaseZ(receiver)) -0.35,
               $fn=Resolution(25, 60));

      // Bottom Chamfer
      translate([0,0,TeeHousingBaseZ(receiver)+GripFloor()-0.001])
      intersection() {
        cylinder(r1=TeeInnerRadius(receiver)*1.1,
                  r2=TeeInnerRadius(receiver),
                  h=0.05,
                  $fn=Resolution(25, 60));

        // Chop off the sides
        cube([ReceiverInnerWidth(receiver), GripWidth(), 0.2], center=true);
      }
    }

    // Shave the tips
    translate([-TeeWidth(receiver)-1, -TeeRimRadius(receiver), -TeeInnerRadius(receiver)])
    cube([TeeWidth(receiver),TeeRimDiameter(receiver),TeeInnerRadius(receiver)]);

    TeeHousingPins(receiver);

    TriggerGuardAlignmentPins(receiver);

    TriggerGuardFingerSlot(receiver);

    FireControlPins();

    TriggerGuardSplitter(receiver, clearance=0.0000001);
  }

}

module TriggerGuardCenter(receiver) {
  difference() {
    intersection() {
      TriggerGuardBlock(receiver);

      // Just the middle
      TriggerGuardSplitter(receiver, clearance=0);
    }

    // Tigger Group Cutout
    translate([-TeeRimRadius(receiver)-0.03,
               -2,TeeHousingBaseZ(receiver) -(TriggerGuardHole()/2)])
    cube([TeeRimDiameter(receiver)-0.25, 4,4]);

    // Trigger Front reset spring interface
    translate([TeeRimRadius(receiver)-0.01,-0.5,TeeHousingBaseZ(receiver)+GripFloor()+0.001])
    rotate([0,220,0])
    cube([0.5, 1, 1]);

    // Reset Spring Body OD
    translate([ResetPinX(), 0, ResetPinZ()])
    rotate([90,-112])
    hull() {
      cylinder(r=0.6, center=true);

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
      semicircle(od=TriggerMaxMajor()+0.1, angle=SafetyAngle()+SafetyBarAngle(), $fn=Resolution(30, 100));

      // Hand-engagement surface
      //rotate(SafetyAngle())
      rotate(-50)
      mirror()
      semicircle(od=SafetyMajorOD()+0.1, angle=110+SafetyAngle(), $fn=Resolution(30, 100));

      // Safety Spindle
      circle(r=SafetyMinorRadius()+0.02);
    }


    TeeHousingPins(receiver);

    TriggerGuardAlignmentPins(receiver);

    TriggerGuardFingerSlot(receiver);
  }
}

module Reference_TriggerGuard(receiver=Spec_TeeThreeQuarterInch(),
                              breechBushing=Spec_BushingThreeQuarterInch(),
                              stock=Spec_PipeThreeQuarterInch(), debug=false) {
  // Trigger
  if (debug)
  TriggerGroup();

  // Trigger Guard Center
  color("White")
  render()
  TriggerGuardCenter(receiver, debug=debug);

  // Trigger Guard Sides
  color("Khaki", 0.5)
  render()
  DebugHalf()
  TriggerGuardSides(receiver, debug=debug);

}
//rotate([30,0,120+(15*-$t)])
scale([25.4, 25.4, 25.4])
//render() DebugHalf(dimension=1500)
{
  Reference_TriggerGuard(debug=true);

  *%color("DarkGrey", 0.5) {
    Reference();
    Frame();
  }
}


module Plater_TriggerGuard() {

  // Trigger Guard Center
  color("CornflowerBlue")
  render()
  rotate([90,0,-70])
  translate([1,-0.25/2,5])
  TriggerGuardCenter(ReceiverTee());

  // Trigger Guard Sides
  color("Khaki")
  render()
  for (i = [0,1])
  rotate([-90,0,0])
  mirror([0,0,i])
  translate([3,0.25/2,0])
  difference() {
    TriggerGuardSides(ReceiverTee());
    DebugHalf(dimension=12);
  }
}

!scale([25.4, 25.4, 25.4]) {
  intersection() {
    Plater_TriggerGuard();
    //#cube([4, 3, 0.4]);
  }
}
