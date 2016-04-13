include <Components.scad>;
include <Components/Animation.scad>;
use <Debug.scad>;
use <Components/Semicircle.scad>;
use <Components/Spring.scad>;
use <Vitamins/Rod.scad>;
use <Vitamins/Pipe.scad>;
use <Striker.scad>;
use <Reference.scad>;

SpringLengthExtended   = 0;
SpringLengthCompressed = 1;
SpringOD               = 2;
SpringWireDiameter     = 3;

function SpringLengthExtended(spring)   = lookup(SpringLengthExtended, spring);
function SpringLengthCompressed(spring) = lookup(SpringLengthCompressed, spring);
function SpringOD(spring)               = lookup(SpringOD, spring);
function SpringWireDiameter(spring)     = lookup(SpringWireDiameter, spring);

function SpringCompression(spring) = SpringLengthExtended(spring)-SpringLengthCompressed(spring);

BicLighterThumbSpring = [
  [SpringLengthExtended,0.63],
  [SpringLengthCompressed,0.32],
  [SpringOD, 0.145],
  [SpringWireDiameter,0.019]
];

BicSoftFeelFinePenSpring = [
  [SpringLengthExtended,0.95],
  [SpringLengthCompressed,0.33],
  [SpringOD, 0.175],
  [SpringWireDiameter,0.017]
];

//function TriggerSpring() = BicSoftFeelFinePenSpring;
function TriggerSpring() = BicLighterThumbSpring;

function sear_height() = 1/4;

function TriggerAngle() = 360/16;
function TriggerWidth() = 0.25;
function TriggerPinX() = -1/4;
function SearPinX() = 0;
function SearPinZ() = -StrikerRadius()-0.25;
function TriggerPinZ() = -TeeCenter(ReceiverTee())-RodRadius(TriggerRod());

function SearTriggerZDistance() = abs(TriggerPinZ() - SearPinZ());

// Angle from sear pin to trigger pin
function SearTriggerAngle() = atan(abs(TriggerPinX())/SearTriggerZDistance());

function TriggerHyp() = sqrt(
                          pow(abs(TriggerPinX()), 2)
                         +pow(SearTriggerZDistance(), 2)
                        );

function SearMajorRadius() = TriggerHyp()*0.56;
function TriggerMajorRadius() = TriggerHyp()*0.56;

function SearMinorRadius() = TriggerHyp()-TriggerMajorRadius();
function TriggerIntermediateRadius() = (TriggerHyp()-SearMajorRadius());
function TriggerMaxMajor() = 2.63;

function TriggerInterfaceArc() = 3.14*pow(SearMajorRadius(),2)/360*TriggerAngle();

function SafetyPinX() = TriggerPinX() - (TriggerMaxMajor()/2*sqrt(2));
function SafetyPinZ() = TriggerPinZ();
function SafetyMajorOD() = 3;
function SafetyInterfaceOD() = 2.63;
function SafetyMinorRadius() = 0.45;
function SafetyHoleRadius() = 0.2;
function SafetyBarAngle() = 32;
function SafetyBackAngle() = 3;
function SafetyAngle() = 15;

function ResetPinX() = -2.5;
function ResetPinZ() = -3.75;

module ResetPin(clearance=RodClearanceSnug()) {
  translate([ResetPinX(), 0,ResetPinZ()])
  rotate([90,0,0])
  Rod(rod=ResetRod(), center=true, length=0.5);
}


function ResetRadius() = 0.4;
function ResetCircumference() = (2*3.14)*ResetRadius();
function ResetAngleExtended() = 360/(ResetCircumference()/SpringLengthExtended(TriggerSpring()));
function ResetAngleCompressed() = 360/(ResetCircumference()/SpringLengthCompressed(TriggerSpring()));
function ResetAngle() = ResetAngleExtended()-ResetAngleCompressed();



chargingRod = Spec_RodOneEighthInch();
chargingWheelOffsetX = -3/16;
chargingWheelOffsetZ = TeeInnerRadius(ReceiverTee())*sqrt(2)+RodRadius(chargingRod);
chargingWheelRadius  = TeeInnerRadius(ReceiverTee())*sqrt(2);
module ChargingRod(rod=Spec_RodOneEighthInch(), clearance=RodClearanceSnug(),
                   length=TeeInnerDiameter(ReceiverTee())+0.2) {
  translate([chargingWheelOffsetX, 0, chargingWheelOffsetZ])
  rotate([90,0,0])
  Rod(rod=rod, center=true, length=length);
}


echo("SpringLengthExtended(spring)", SpringLengthExtended(TriggerSpring()));
echo("SpringLengthCompressed(spring)", SpringLengthCompressed(TriggerSpring()));
echo("SpringCompression(TriggerSpring())", SpringCompression(TriggerSpring()));
echo("ResetRadius", ResetRadius());
echo("ResetAngleExtended", ResetAngleExtended());
echo("ResetAngleCompressed", ResetAngleCompressed());
echo("SpringOD", SpringOD(TriggerSpring()));
function TriggerMinorRadius() = 0.22;
sear_height = sear_height();

// Hackiest gear module you ever did see.
// MCAD isn't public domain, either :(
module TriggerTeeth(teeth=[1:16], angle=1,
                    major=SearMajorRadius()*2,
                    minor=SearMajorRadius()*0.66) {
  for (i = teeth)
  hull() {
    // Spindle
    circle(r=minor/2);

    // Tooth
    rotate(i*TriggerAngle())
    semicircle(od=major, angle=angle, center=true);
  }
}

module Spindle(pin=SafetyRod(), center=false, cutter=false,
               radius=0.2, clearance=0.015, height=0.27,
               $fn=Resolution(12,24)) {
    difference() {
      cylinder(r=radius+(cutter==true ? clearance : 0), h=height, center=center);

      if (cutter==false)
      Rod(rod=pin, clearance=RodClearanceLoose(), length=height*3, center=true);
    }
}

module Sear(width=0.24, angle=230) {
  $fn=30;

  color("Red")
  rotate([90,0,0])
  linear_extrude(height=sear_height(), center=true)
  translate([0,SearPinZ()])
  rotate(-TriggerAngle()*-Animate(ANIMATION_STEP_TRIGGER))
  difference() {
    union() {
      hull() {
        // Spindle
        circle(r=SearMinorRadius());

        // Sear-striker interface
        rotate(90)
        #square([SearMajorRadius()*0.81, SearMajorRadius()*0.8]);
      }

      // Trigger Interface Teeth
      rotate(-90-SearTriggerAngle()) // Point toward trigger pin
      TriggerTeeth([-2,-1,0,1], angle=5);

      // Trigger Stop
      mirror([0,1])
      square([SearMinorRadius(), SearTriggerZDistance()]);
    }

    // Clear the striker when disengaged
    rotate([0,0,-TriggerAngle()])
    translate([-1,-SearPinZ()-StrikerRadius()-0.01])
    square([2, 1]);


    // Trigger stop interface
    translate([TriggerPinX(), TriggerPinZ()])
    translate([-SearPinX(), -SearPinZ()]) {
      rotate(90-SearTriggerAngle()-TriggerAngle())
      semicircle(od=TriggerIntermediateRadius()*2.01, angle=90, $fn=RodFn(TriggerRod())*Resolution(2, 4));

      translate([TeeInnerRadius(ReceiverTee())*0.9,0])
      rotate(-TriggerAngle())
      square([1,TeeCenter(ReceiverTee())]);
    }

    // Pin Hole
    Rod2d(rod=SearRod(), clearance=RodClearanceLoose());
  }
}

module Trigger(pin=RodOneEighthInch, height=0.24) {
  safetyAngle = 70;

  color("Gold")
  render(convexity=2)
  union() {
    difference() {
      translate([TriggerPinX(), 0, TriggerPinZ()])
      rotate([-90,(TriggerAngle()*Animate(ANIMATION_STEP_TRIGGER)),0])
      linear_extrude(center=true, height=height)
      union() {

        // Spindle Body
        circle(r=TriggerMinorRadius(), $fn=20);

        // Finger Body
        rotate(115+SearTriggerAngle())
        semidonut(minor=0, major=2.6, angle=114+SearTriggerAngle(), $fn=Resolution(20,60));

        // Teeth
        rotate(-90+SearTriggerAngle()+(TriggerAngle()/2)) // Point toward trigger pin
        TriggerTeeth([-2,-1,0], angle=5, major=TriggerMajorRadius()*2);

        // Tooth and front face infill
        rotate(90-SearTriggerAngle())
        semicircle(od=TriggerIntermediateRadius()*2, angle=180, $fn=RodFn(TriggerRod())*Resolution(2, 4));

        // Reset Spring-engagement surface
        rotate(122)
        square([1.6,TriggerMinorRadius()]);

      }

      translate([TriggerPinX(), 0, TriggerPinZ()])
      rotate([-90,(TriggerAngle()*Animate(ANIMATION_STEP_TRIGGER)),0])
      linear_extrude(center=true, height=height) {

          // Spindle Hole
          Rod2d(rod=SearRod(), clearance=RodClearanceLoose());

          // Trigger Front Curve
          rotate(90)
          rotate(-70)
          translate([1.7,0])
          translate([TeeRimWidth(receiverTee),0])
          circle(r=1.4,$fn=Resolution(20,60));

          // Safety cutout
          rotate(-8-SafetyAngle())
          translate([SafetyPinX(), SafetyPinZ()])
          translate([-TriggerPinX(), -TriggerPinZ()])
          rotate(SafetyBarAngle()+1.8)
          semicircle(od=SafetyInterfaceOD()+0.02, angle=30, $fn=Resolution(20, 60));

          // Test Rope Hole
          rotate(90)
          rotate(-18)
          translate([0.8,0])
          translate([TeeRimWidth(receiverTee),0])
          circle(r=0.1, $fn=8);
        }
    }
  }
}

module Safety(width=0.24) {
  springAngle = 20;

  color("Lime")
  render(convexity=3)
  translate([SafetyPinX(), 0, SafetyPinZ()])
  rotate([90,-(SafetyAngle()*Animate(ANIMATION_STEP_SAFETY)),0])
  difference() {
    linear_extrude(height=width, center=true)
    union() {

      // Body
      circle(r=SafetyMinorRadius(), $fn=Resolution(12, 30));

      // Trigger-engagement surface
      rotate(134)
      mirror()
      semicircle(od=SafetyInterfaceOD()-0.08, angle=10, $fn=Resolution(30, 100));

      // Trigger Trap Top
      rotate(142)
      mirror()
      semicircle(od=SafetyInterfaceOD(), angle=SafetyBarAngle()-10, $fn=Resolution(30, 100));

      // Trigger Trap Bottom
      rotate(135-SafetyBackAngle())
      mirror()
      semicircle(od=SafetyInterfaceOD(), angle=SafetyBackAngle(), $fn=Resolution(30, 100));

      // Bottom Infill
      rotate(162)
      translate([SafetyMinorRadius()*sqrt(2)/2,0])
      mirror()
      square([(SafetyInterfaceOD()*0.35)+SafetyMinorRadius()*sqrt(2)/2,SafetyMinorRadius()]);


      // Top Infill
      *rotate(135)
      translate([0,-SafetyMinorRadius()])
      mirror([1,0])
      square([SafetyInterfaceOD()*0.35,SafetyMinorRadius()]);


      // Hand Tab
      rotate(90+30+SafetyAngle()) {

        difference() {

          // Hand-web tab
          square([SafetyMinorRadius(), SafetyMajorOD()/2]);

          // Cut off sharp back tip
          translate([SafetyMinorRadius()*0.3, SafetyMajorOD()/2])
          rotate(45)
          translate([0.15,-0.75])
          square([1,1]);
        }

        // Travel stop
        rotate(-90)
        mirror()
        semidonut(major=SafetyMajorOD(), minor=0, angle=SafetyAngle()/2);
      }

    }

    // Spindle hole
    Spindle(center=true, cutter=true, height=1);
  }
}

module ResetSpring(left=true, right=true) {
  resetAngle=-145;

  leftSpindleRadius = 0.3;
  rightSpindleRadius = 0.2;

  height=0.24;
  sidePlateHeight = (height-SpringOD(TriggerSpring()))*0.5;
  spindleOuterRadius = 0.4;

  heightMinusOD = height-SpringOD(TriggerSpring());
  wall=0.08;

  // Right side
  if (right)
  color("Magenta", 0.5)
  render(convexity=5)
  translate([ResetPinX(), 0, ResetPinZ()])
  rotate([0,resetAngle+(ResetAngle()*0.6*Animate(ANIMATION_STEP_SAFETY)),0])
  union() {
    difference() {
      union() {

        // Side plate
        difference() {
          hull() {

            // Side plate body
            translate([0,-1/8,0])
            rotate([-90,0,0])
            cylinder(r=spindleOuterRadius, h=sidePlateHeight-0.002, $fn=Resolution(12,30));

            // Side plate spring cover
            mirror([0,1])
            translate([0,1/8,0])
            rotate([90,5,0])
            linear_extrude(height=sidePlateHeight-0.002)
            semicircle(od=(ResetRadius()+SpringOD(TriggerSpring())+wall)*2,
                       angle=ResetAngleExtended()+15, $fn=Resolution(12,30));
          }
        }

        // Safety Interface
        difference() {
          // Body
          hull() {

            translate([0,-1/8,0])
            rotate([0,43,0])
            translate([0,0,spindleOuterRadius/2])
            cube([1.5,height,spindleOuterRadius/2]);

            translate([0,-1/8,0])
            rotate([-90,40,0])
            linear_extrude(height=sidePlateHeight)
            semicircle(od=(ResetRadius()+SpringOD(TriggerSpring())+wall+0.015)*2,
                       angle=5, $fn=Resolution(12,30));
          }


          // Path for the left side plate
          translate([-0.01,1/8,-0.01])
          rotate([90,-47,0])
          linear_extrude(height=height-sidePlateHeight+0.012)
          semicircle(od=(ResetRadius()+SpringOD(TriggerSpring())+wall+0.015)*2,
                     angle=360, $fn=Resolution(12,30));
        }

        // Left-side spindle
        translate([0,-height/2,0])
        rotate([-90,0,0])
        Spindle(radius=leftSpindleRadius, center=false, cutter=false, height=height);
      }

      // Spindle hole
      rotate([90,0,0])
      Spindle(radius=rightSpindleRadius, center=true, cutter=true);
    }

    // Spring Interface
    translate([0,(SpringOD(TriggerSpring())/2)-0.01,0])
    rotate([90,6,0])
    linear_extrude(height=SpringOD(TriggerSpring())+sidePlateHeight-0.01)
    semidonut(minor=ResetRadius()*2.1,
              major=(ResetRadius()+SpringOD(TriggerSpring()))*2,
              angle=25, $fn=Resolution(12,30));
  }

  // Left side
  if (left)
  color("CornflowerBlue", 0.5)
  render(convexity=4)
  //DebugHalf()
  translate([ResetPinX(), 0, ResetPinZ()])
  rotate([0,resetAngle+(ResetAngle()*0.4*-Animate(ANIMATION_STEP_TRIGGER)),0])
  difference() {
    union() {

      // Spring Vitamin
      %translate([0,SpringOD(TriggerSpring())*0.51,0])
      rotate([90,30,0])
      linear_extrude(height=SpringOD(TriggerSpring())*1.03)
      semidonut(minor=ResetRadius()*2,
                major=(ResetRadius()+SpringOD(TriggerSpring()))*2.1,
                angle=ResetAngleExtended(), $fn=Resolution(12,30));

      // Body
      hull() {
        translate([0,1/8,0])
        rotate([90,0,0])
        cylinder(r=spindleOuterRadius, h=height-sidePlateHeight-0.002, $fn=Resolution(12,30));

        // Side plate
        translate([0,1/8,0])
        rotate([90,ResetAngleExtended()+28,0])
        linear_extrude(height=height-sidePlateHeight-0.002)
        mirror([0,1])
        semicircle(od=(ResetRadius()+SpringOD(TriggerSpring())+wall)*2,
                   angle=ResetAngleExtended()+25, $fn=Resolution(12,30));
      }

      // Trigger interface
      translate([-spindleOuterRadius/2,1/8,0])
      rotate([90,ResetAngleExtended()-3,0])
      mirror([0,1,0])
      cube([1.87,spindleOuterRadius/2,height]);
    }

    // Spring cutout
    translate([0,SpringOD(TriggerSpring())*0.51,0])
    rotate([90,5,0])
    linear_extrude(height=SpringOD(TriggerSpring())*1.03)
    semidonut(minor=ResetRadius()*2,
              major=(ResetRadius()+SpringOD(TriggerSpring()))*2.1,
              angle=ResetAngleExtended()+20,
              $fn=Resolution(12,30));

    // Spindle hole
    rotate([90,0,0])
    Spindle(radius=leftSpindleRadius, center=true, cutter=true);

    // Right Side plate clearance
    mirror([0,1])
    translate([0,1/8,0])
    rotate([90,5,0])
    linear_extrude(height=sidePlateHeight+0.012)
    semicircle(od=(ResetRadius()+SpringOD(TriggerSpring())+wall)*2.05,
               angle=360, $fn=Resolution(12,30));
  }
}

module SearPin(clearance=RodClearanceSnug()) {
  translate([SearPinX(),0,SearPinZ()])
  rotate([90,0,0])
  Rod(rod=SearRod(), clearance=clearance,
      length=TeeRimDiameter(receiverTee),
      center=true);
}

module SafetyPin(clearance=RodClearanceSnug()) {
  translate([SafetyPinX(),0,SafetyPinZ()])
  rotate([90,0,0])
  Rod(rod=SafetyRod(), clearance=clearance,
      length=0.5,
      center=true);
}

module ResetPin(clearance=RodClearanceSnug()) {
  translate([ResetPinX(),0,ResetPinZ()])
  rotate([90,0,0])
  Rod(rod=ResetRod(), clearance=clearance,
      length=0.5,
      center=true);
}


module FireControlPins(clearance=RodClearanceSnug()) {

    // Sear Pin
    translate([SearPinX(),0,SearPinZ()])
    rotate([90,0,0])
    Rod(rod=SearRod(), clearance=clearance,
        length=TeeRimDiameter(receiverTee),
        center=true);

    // Trigger Pin
    translate([TriggerPinX(),0,TriggerPinZ()])
    rotate([90,0,0])
    Rod(rod=TriggerRod(), clearance=clearance,
        length=TeeRimDiameter(receiverTee),
        center=true);

}

module TriggerGeometry() {
  echo("Trigger Geometry");
  echo("================");
  echo("Hypotenuse: ", TriggerHyp());
  echo("Sear-Trigger angle: ", SearTriggerAngle());
  echo("Interface arc: ", TriggerInterfaceArc());

  rotate([90,0,0]) {
    // Polygon based on pin coordinates
    color("White", 0.25)
    polygon(points=[
      [SearPinX(), TriggerPinZ()],
      [TriggerPinX(), TriggerPinZ()],
      [SearPinX(), SearPinZ()]
    ]);

    // Hypotenuse from Sear
    color("Yellow", 0.25)
    translate([0, SearPinZ()])
    rotate(90-SearTriggerAngle())
    mirror([1,0])
    square([TriggerHyp(),.1]);

    // Hypotenuse from Trigger
    color("Red", 0.25)
    translate([TriggerPinX(), TriggerPinZ()])
    rotate(90-SearTriggerAngle())
    //mirror([1,0])
    square([TriggerHyp(),.1]);

    // SearTriggerZDistance
    color("Green", 0.25)
    translate([0,TriggerPinZ()])
    square([.1, SearTriggerZDistance()]);

    // Trigger Pin X
    color("Blue", 0.25)
    translate([0, TriggerPinZ()])
    rotate(180)
    square([abs(TriggerPinX()), .1]);
  }

  // Top Insert Column
  translate([0,0,TeeInnerRadius(ReceiverTee())])
  cylinder(r=TeeInnerRadius(ReceiverTee()), h=TeeCenter(ReceiverTee()), $fn=Resolution(12,36));

  // Bottom Insert Column
  translate([0,0,-TeeCenter(ReceiverTee())])
  cylinder(r=TeeInnerRadius(ReceiverTee()), h=TeeCenter(ReceiverTee())-TeeInnerRadius(ReceiverTee()), $fn=Resolution(12,36));
}

module Charger() {

  translate([chargingWheelOffsetX,0,TeeInnerRadius(ReceiverTee())*sqrt(2)+RodRadius(chargingRod)])
  rotate([90,0,0]) {

    // Striker interface
    linear_extrude(height=0.24, center=true) {
      rotate(70*Animate(ANIMATION_STEP_CHARGE))
      difference() {
        union() {
          rotate(65)
          mirror()
          semicircle(od=(chargingWheelRadius*2)-0.04,
                     angle=90, h=0.24, $fn=Resolution(20,40));

          // Spindle Body
          circle(r=0.22, $fn=Resolution(15,30));

          // Infill
          rotate(-65)
          square([chargingWheelRadius-(RodRadius(chargingRod)*5),0.25]);

          // Pivot Boss
          rotate(-25)
          translate([chargingWheelRadius-RodRadius(chargingRod),0,0])
          Rod2d(chargingRod, clearance=undef, center=true);

          // Sear Interface
          rotate(-25-90)
          translate([chargingWheelRadius-RodRadius(chargingRod),0,0])
          Rod2d(chargingRod, clearance=undef, center=true);
        }

        // Spindle Rod
        Rod2d(chargingRod, center=true);

        // Pivot Socket
        rotate(-25)
        translate([chargingWheelRadius-(RodRadius(chargingRod)*3),0,0])
        Rod2d(chargingRod, clearance=undef, center=true);
      }
    }
  }


  // Charging Supports
  color("Red", 0.25)
  difference() {
    union() {
      translate([0,0,TeeInnerRadius(ReceiverTee())])
      cylinder(r=TeeInnerRadius(ReceiverTee()), h=TeeCenter(ReceiverTee()), $fn=Resolution(12,30));

      translate([0,0,TeeCenter(ReceiverTee())])
      TeeRim(ReceiverTee(), height=0.5, $fn=Resolution(20,40));
    }

    translate([-2,-0.125,0])
    cube([4, 0.25, TeeCenter(ReceiverTee())*2]);

    ChargingRod(length=1);
  }
}

module TriggerGroup() {

    %Striker();

    %FiringPinGuide();

    Sear();

    Trigger();

    ResetSpring();

    Safety();

    *Charger();

}

scale([25.4, 25.4, 25.4]) {

  TriggerGroup();
  *%TriggerGeometry();
  *Reference();
}

module trigger_plater($t=0) {
  scale([25.4, 25.4, 25.4]) {
    for (i=[[0, SafetyRod()], [1, ResetRod()]])
    translate([i[0],-1/4,0])
    Spindle(pin=i[1], height=0.28, center=false);

    translate([1/8,1/2,1/8])
    rotate([90,0,0])
    Trigger();

    translate([1/8,-1/8,1/8])
    rotate([90,0,0])
    Sear();

    translate([0,0,1/8])
    rotate([90,0,0])
    Safety();

    translate([3,-5,1/8])
    rotate([90,0,0])
    ResetSpring(left=false, right=true);

    translate([0,-SafetyPinZ(),1/8])
    rotate([-90,0,0])
    ResetSpring(left=true, right=false);
  }
}

*!trigger_plater();
