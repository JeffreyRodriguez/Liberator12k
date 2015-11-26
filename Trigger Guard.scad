include <Components.scad>;
use <Debug.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Grip.scad>;
use <Frame.scad>;
use <Forend Rail.scad>;
use <Trigger.scad>;
use <Reference.scad>;

function TriggerGuardPinZ() = -TeeRimRadius(ReceiverTee()) -RodRadius(FrameRod()) -0.14;
function TriggerGuardFrontPinZ() = TriggerGuardPinZ()-0.05;

function TeeHousingBaseZ(receiver) = -TeeCenter(receiver)-TeeRimWidth(receiver);

function TeeHousingBottomExtension() = 0.27;
function TeeHousingFrontExtension(bushing=breechBushing) = BushingHeight(bushing) - BushingDepth(bushing);

module TriggerGuardAlignmentPins(receiver, length=GripWidth()-0.22, nutOd=0.25, pin=Spec_RodOneEighthInch()) {

  for (xz = [[(TeeWidth(receiver)/2) -0.1, -0.4],

             [-(TeeWidth(receiver)/2) -0.6, 0.3],

             [-(TeeWidth(receiver)/2)-1.35,
              -TriggerGuardHeight()-1.75]])
  translate([xz[0],0,TeeHousingBaseZ(receiver)+xz[1]]) {
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

module TeeHousingFrontPin(receiver, length=2.5, extraRadius=0, enabled=true,
                          pin=Spec_RodFiveSixteenthInch(),
                          clearance=RodClearanceLoose(), $fn=undef) {
  translate([TeeRimRadius(receiver) +RodRadius(pin)+WallTriggerGuardRod(),
             0,TriggerGuardFrontPinZ()])
    rotate([90,0,0]) {
      if (enabled)
      cylinder(r=RodRadius(pin, clearance)+extraRadius, center=true,
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

module ReferenceTeeCutter() {
  translate([0,0,-TeeCenter(ReceiverTee())])
  TeeRim(ReceiverTee(), height=TeeCenter(ReceiverTee()));

  translate([-TeeWidth(ReceiverTee())/2,0,0])
  rotate([0,90,0])
  TeeRim(ReceiverTee(), height=TeeWidth(ReceiverTee()));
}

function TriggerGuardHeight() = 1.31;
function TriggerGuardHole() = 1.05;

module TriggerGuardFingerSlot(receiver, length=0.8, chamfer=true, $fn=Resolution(20, 60)) {

    render()
    union()
    translate([-(TeeWidth(receiver)/2)+(TriggerGuardHole()/2) + 0.4,0,-TeeCenter(receiver)-(TriggerGuardHole()/2) - TeeRimWidth(receiver)]) {

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
  height = TriggerGuardHeight()+abs(TeeHousingBaseZ(receiver));//(TeeRimWidth(receiver)*2);
  rearLength = TeeRimWidth(receiver)+.4;

  difference() {

    union() {
      // Main block
      translate([-(TeeWidth(receiver)/2)-rearLength,
                 -GripWidth()/2,
                 TeeHousingBaseZ(receiver)-TriggerGuardHeight()])
      cube([TeeWidth(receiver)+TeeHousingFrontExtension()+rearLength,
            GripWidth(),
            height]);

      // Rounded Back
      translate([-(TeeWidth(receiver)/2)-rearLength,
                 0,
                 TeeHousingBaseZ(receiver)-TriggerGuardHeight()])
      cylinder(r=GripWidth()/2, h=height, $fn=Resolution(20, 60));

      TriggerGuardGrip(receiver);
    }

    // Stock
    Stock(receiver, stock, 12+(TeeWidth(receiver)/2));

    // Tee
    ReferenceTeeCutter();

    // Cut down the front top
    translate([(TeeWidth(receiver)/2)-0.01, -(GripWidth()/2)-0.1,-TeeRimRadius(receiver)])
    cube([TeeWidth(receiver), GripWidth()+0.2, TeeCenter(receiver)]);

    TriggerGuardFingerSlot(receiver);

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
      translate([length*0.42,0,-height*0.35])
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
      difference() {
        TriggerGuardBlock(receiver);

        translate([-ReceiverInnerWidth(receiver)/2,-2,
                   TeeHousingBaseZ(receiver)+(TeeRimWidth(receiver)*2)])
        *cube([ReceiverInnerWidth(receiver), 4,4]);
      }

      // Inner plug
      translate([0,0,TeeHousingBaseZ(receiver)-0.001])
      cylinder(r=TeeInnerRadius(receiver),
               h=abs(TeeHousingBaseZ(receiver)) -0.35,
               $fn=Resolution(25, 60));

      // Bottom Chamfer
      translate([0,0,TeeHousingBaseZ(receiver)+TeeRimWidth(receiver)-0.001])
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

    translate([0,0,-TeeCenter(receiver)])
    rotate([0,0,180])
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

    *TriggerGuardBackCenter(receiver, clearance=0.001);

     // Front Cutout
    translate([(TeeWidth(receiver)/2)-TeeRimWidth(receiver)-0.005,
               -2,TeeHousingBaseZ(receiver)-0.1])
    *cube([TeeWidth(receiver), 4,4]);

     // Tigger cutout
    translate([-TeeRimRadius(receiver),
               -2,TeeHousingBaseZ(receiver) -(TriggerGuardHole()/2)])
    cube([TeeRimDiameter(receiver)-(TeeRimRadius(receiver)-TeeInnerRadius(receiver)), 4,4]);

    *TeeHousingFrontPin(receiver, length=2.5, extraRadius=WallTriggerGuardRod()+0.005, $fn=Resolution(20,60));

    TeeHousingPins(receiver);

    TriggerGuardAlignmentPins(receiver);

    TriggerGuardFingerSlot(receiver);
  }
}


module TriggerGuardTop(receiver, wall=tee_overlap) {
  intersection() {
    difference() {
      translate([-(ReceiverInnerWidth(receiver)/2)-0.002,
                 -TeeRimRadius(receiver)-wall,
                 TeeHousingBaseZ(receiver)-TeeRimWidth(receiver)])
        cube([ReceiverInnerWidth(receiver)-0.004,
              TeeRimDiameter(receiver)+(wall*2),
              (TeeRimWidth(receiver)*3)]);

      // Cutouts for grip
      translate([0,0,0.001])
      difference() {
        translate([-(ReceiverInnerWidth(receiver)/2)-0.002,
                   -GripWidth()/2,
                   TeeHousingBaseZ(receiver) - (TeeRimWidth(receiver)*2)])
          cube([ReceiverInnerWidth(receiver)+0.004,
                GripWidth(),
                (TeeRimWidth(receiver)*3)]);

        TriggerGuardSplitter(receiver,clearance=0.0000001);
      }

      // Trigger Slot
      translate([-TeeInnerRadius(receiver),-0.13,TeeHousingBaseZ(receiver)-TeeRimWidth(receiver)-0.01])
      cube([TeeInnerDiameter(receiver),0.26,TeeRimWidth(receiver)*3]);

      ReferenceTeeCutter(receiver);

      TriggerGuardFingerSlot(receiver);

      TeeHousingRearPin(receiver);
    }

    translate([-TeeWidth(receiver)/2,0,-TeeCenter(receiver)-(TeeRimWidth(receiver)*2*sqrt(2))])
    rotate([45,0,0])
    cube([TeeWidth(receiver), TeeWidth(receiver), TeeWidth(receiver)]);
  }
}

module Plater_TriggerGuard() {

  // Trigger Top
  color("Orange")
  render()
  translate([0,2,-TeeCenter(ReceiverTee()) + TeeRimWidth(receiverTee)])
  rotate([180,0,0])
  *TriggerGuardTop(ReceiverTee());

  // Trigger Guard Center
  color("CornflowerBlue")
  render()
  rotate([-90,0,-90])
  translate([1,-0.25/2,0])
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

module Reference_TriggerGuard(receiver=Spec_TeeThreeQuarterInch(),
                              breechBushing=Spec_BushingThreeQuarterInch(),
                              stock=Spec_PipeThreeQuarterInch(), debug=false) {
  // Trigger
  if (debug)
  translate([0,0,-TeeCenter(receiver)])
  rotate([0,0,180])
  trigger_insert();

  // Trigger Top
  color("Orange")
  render()
  *%TriggerGuardTop(receiver, debug=debug);

  // Trigger Guard Center
  color("CornflowerBlue")
  render()
  TriggerGuardCenter(receiver, debug=debug);

  // Trigger Guard Sides
  color("Khaki")
  render()
  DebugHalf()
  TriggerGuardSides(receiver, debug=debug);
}

scale([25.4, 25.4, 25.4])
//render() DebugHalf(dimension=1500)
{
Reference_TriggerGuard(debug=true);

  %color("DarkGrey", 0.5) {
    Reference();
    Frame();
  }
}

*!scale([25.4, 25.4, 25.4])
Plater_TriggerGuard();
