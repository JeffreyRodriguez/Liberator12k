//$t=1;
include <Components.scad>;
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
function SafetyMajorOD() = 4;
function SafetyInterfaceOD() = 2.63;
function SafetyMinorRadius() = 0.45;
function SafetyHoleRadius() = 0.2;
function SafetyBarAngle() = 32;
function SafetyBackAngle() = 3;
function SafetyAngle() = 15;

function ResetPinX() = -1.8;
function ResetPinZ() = -2.75;


function ResetRadius() = 0.4;
function ResetCircumference() = (2*3.14)*ResetRadius();
function ResetAngleExtended() = 360/(ResetCircumference()/SpringLengthExtended(TriggerSpring()));
function ResetAngleCompressed() = 360/(ResetCircumference()/SpringLengthCompressed(TriggerSpring()));


echo("SpringLengthExtended(spring)", SpringLengthExtended(TriggerSpring()));
echo("SpringLengthCompressed(spring)", SpringLengthCompressed(TriggerSpring()));
echo("SpringCompression(TriggerSpring())", SpringCompression(TriggerSpring()));
echo("ResetRadius", ResetRadius());
echo("ResetAngleExtended", ResetAngleExtended());
echo("ResetAngleCompressed", ResetAngleCompressed());
echo("SpringOD", SpringOD(TriggerSpring()));
function TriggerMinorRadius() = 0.22;
sear_height = sear_height();
trigger_height = 1/4;

// Hackiest gear module you ever did see.
module TriggerTeeth(teeth=[1:16], angle=1,
                    major=SearMajorRadius()*2,
                    minor=SearMajorRadius()*0.33) {
  for (i = teeth)
  hull() {
    // Spindle
    circle(r=minor);

    // Tooth
    rotate(i*TriggerAngle())
    semicircle(od=major, angle=angle, center=true);
  }
}

module Sear(width=sear_height, angle=230) {
  $fn=30;

  color("Red")
  translate([0,SearPinZ()])
  rotate(-TriggerAngle()*-$t)
  difference() {
    union() {
      hull() {
        // Spindle
        circle(r=SearMinorRadius());

        // Sear-striker interface
        translate([0,-SearPinZ()-StrikerRadius()])
        mirror([1,0])
        square([SearMajorRadius(), SearMajorRadius()]);
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
      semicircle(od=TriggerIntermediateRadius()*2, angle=90);

      translate([TeeInnerRadius(ReceiverTee())*0.9,0])
      rotate(-TriggerAngle())
      square([1,TeeCenter(ReceiverTee())]);
    }

    // Pin Hole
    Rod2d(rod=SearRod(), clearance=RodClearanceLoose());
  }
}

module Trigger(pin=RodOneEighthInch, height=trigger_height) {
  safetyAngle = 70;

  color("Gold")
  render(convexity=2)
  translate([TriggerPinX(), 0, TriggerPinZ()])
  rotate([-90,(TriggerAngle()*$t),0])
  linear_extrude(center=true, height=height)
  union() {
    difference() {
      union() {

        // Spindle Body
        circle(r=TriggerMinorRadius());

        // Finger Body
        rotate(115+SearTriggerAngle())
        semidonut(minor=0, major=2.6, angle=80+SearTriggerAngle());

        // Teeth
        rotate(-90+SearTriggerAngle()+(TriggerAngle()/2)) // Point toward trigger pin
        TriggerTeeth([-2,-1,0], angle=5, major=TriggerMajorRadius()*2);

        // Tooth and front face infill
        rotate(90-SearTriggerAngle())
        semicircle(od=TriggerIntermediateRadius()*2, angle=180);

        // Reset Bar
        rotate(122)
        square([1.5,TriggerMinorRadius()]);

        // Spring
        color("Silver")
        rotate(-(TriggerAngle()*$t))
        rotate(134)
        rotate(180)
        mirror(){
        *%semidonut(minor=ResetRadius()*2,
                   major=(ResetRadius()+SpringOD(TriggerSpring()))*2,
                   //angle=ResetAngleCompressed());
                   //angle=ResetAngleExtended()-((ResetAngleExtended()-ResetAngleCompressed())*$t));
                   angle=ResetAngleExtended());
        * %semidonut(minor=ResetRadius()*1.95,
                    major=(ResetRadius()+SpringOD(TriggerSpring()))*2.05,
                    angle=ResetAngleCompressed());
                    //angle=ResetAngleExtended()-((ResetAngleExtended()-ResetAngleCompressed())*$t));
        }

      }

      // Spindle Hole
      Rod2d(rod=SearRod(), clearance=RodClearanceLoose());

      // Trigger Front Curve
      rotate(90)
      rotate(-60)
      translate([.80,0])
      translate([TeeRimWidth(receiverTee),0])
      circle(r=0.8);

      // Safety-engagement surface
      rotate(-45/2)
      translate([SafetyPinX(), SafetyPinZ()])
      translate([-TriggerPinX(), -TriggerPinZ()])
      rotate(SafetyBarAngle()+1.8)
      semicircle(od=SafetyInterfaceOD()+0.02, angle=30, $fn=Resolution(30, 100));
    }
  }
}

module Safety(width=0.25) {
  springAngle = 20;

  translate([SafetyPinX(), 0, SafetyPinZ()])
  rotate([90,-(SafetyAngle()*$t),0])
  render()
  linear_extrude(height=width, center=true)
  difference() {
    union() {

      // Spindle
      circle(r=SafetyMinorRadius());

      // Trigger-engagement surface
      rotate(134)
      mirror()
      semicircle(od=SafetyInterfaceOD()-0.08, angle=10, $fn=Resolution(30, 100));

      // Safety Trap Top
      rotate(142)
      mirror()
      semicircle(od=SafetyInterfaceOD(), angle=SafetyBarAngle()-10, $fn=Resolution(30, 100));

      // Safety Trap Bottom
      rotate(135-SafetyBackAngle())
      mirror()
      semicircle(od=SafetyInterfaceOD(), angle=SafetyBackAngle(), $fn=Resolution(30, 100));

      rotate(90+30+SafetyAngle())
      {
        // Hand-web tab
        difference() {
          square([SafetyMinorRadius(), SafetyMajorOD()/2]);

          // Cut off that sharp tip
          translate([SafetyMinorRadius()*0.3, SafetyMajorOD()/2])
          rotate(65)
          translate([0,-0.5])
          square([1,1]);
        }

        // Travel stop
        rotate(-90)
        mirror()
        semidonut(major=SafetyMajorOD(), minor=SafetyMajorOD()-0.6, angle=SafetyAngle());
      }

      // Spring Depressor
      *translate([-TriggerPinX(), -TriggerPinZ()])
      translate([SafetyPinX(), SafetyPinZ()])
      rotate(134)
      rotate(180)
      mirror()
      semidonut(minor=ResetRadius()*2.01,
                major=(ResetRadius()+SpringOD(TriggerSpring()))*1.99,
                angle=ResetAngleExtended());

    }

    difference() {
      circle(r=SafetyHoleRadius()+0.01);
      circle(r=SafetyHoleRadius());
    }

    // Spindle Hole
    Rod2d(rod=SafetyRod() );
  }
}

module ResetSpring(left=true, right=true) {
  height=0.24;
  sidePlateHeight = (height-SpringOD(TriggerSpring()))/2;
  
  heightMinusOD = height-SpringOD(TriggerSpring());
  spindleRadius = 0.07;
  spindleOuterRadius = 0.25;
  spindleFn = 8;//Resolution(20,40);
  angle=-90;
  
  wall=0.08;
          
  // Spring
  translate([ResetPinX(), 0, ResetPinZ()])
  %rotate([90,angle,0])
  linear_extrude(height=SpringOD(TriggerSpring()), center=true)
  semidonut(minor=ResetRadius()*2,
            major=(ResetRadius()+SpringOD(TriggerSpring()))*2,
            angle=ResetAngleExtended());
  
  // Left side
  if (left)
  render()
  translate([ResetPinX(), 0, ResetPinZ()])
  rotate([0,angle,0])
  difference() {
    union() {
      
      // Spindle
      translate([0,1/8,0])
      rotate([90,0,0])
      cylinder(r=spindleOuterRadius, h=height-sidePlateHeight-0.002, $fn=Resolution(20,50));
      
      // Side plate
      translate([0,1/8,0])
      rotate([90,-10,0])
      linear_extrude(height=height-sidePlateHeight-0.002)
      semicircle(od=(ResetRadius()+SpringOD(TriggerSpring())+wall)*2,
                 angle=ResetAngleExtended()+20, $fn=Resolution(40,80));
      
      // End cap
      translate([0,1/8,0])
      rotate([90,ResetAngleExtended()+8,0])
      linear_extrude(height=height-sidePlateHeight-0.002)
      semidonut(minor=spindleOuterRadius*2,
                major=(ResetRadius()+SpringOD(TriggerSpring())+wall)*3,
                angle=10, $fn=Resolution(40,80));
    }
      
    // Spring cutout
    translate([0,SpringOD(TriggerSpring())*0.51,0])
    rotate([90,0,0])
    linear_extrude(height=SpringOD(TriggerSpring())*1.03)
    semidonut(minor=ResetRadius()*1.90,
              major=(ResetRadius()+SpringOD(TriggerSpring()))*2.1,
              angle=ResetAngleExtended()+30);

    // Spindle hole
    rotate([90,0,0])
    cylinder(r=spindleRadius, center=true, $fn=spindleFn);
  }
  
  // Right side
  if (right)
  render()
  translate([ResetPinX(), 0, ResetPinZ()])
  rotate([0,angle,0])
  difference() {
    union() {
      
      // Spindle
      translate([0,-1/8,0])
      rotate([-90,0,0])
      cylinder(r=spindleOuterRadius, h=sidePlateHeight-0.002, $fn=Resolution(20,50));
      
      // Side plate
      mirror([0,1])
      translate([0,1/8,0])
      rotate([90,-10.2,0])
      linear_extrude(height=sidePlateHeight-0.002)
      semicircle(od=(ResetRadius()+SpringOD(TriggerSpring())+wall)*2,
                 angle=ResetAngleExtended()+30.2, $fn=Resolution(40,80));
      
      // End cap
      mirror([0,1])
      translate([0,1/8,0])
      rotate([90,-20+0.01,0])
      linear_extrude(height=height)
      semidonut(minor=spindleOuterRadius*2.01,
                major=(ResetRadius()+SpringOD(TriggerSpring())+wall)*3,
                angle=10, $fn=Resolution(40,80));
      
      // Spring Tab
      translate([0,(SpringOD(TriggerSpring())/2)-0.01,0])
      rotate([90,ResetAngleExtended()-2,0])
      linear_extrude(height=SpringOD(TriggerSpring())+sidePlateHeight-0.01)
      semidonut(minor=ResetRadius()*2,
                major=(ResetRadius()+SpringOD(TriggerSpring()))*2,
                angle=22);
    }

    // Spindle hole
    rotate([90,0,0])
    cylinder(r=spindleRadius, center=true, $fn=spindleFn);
  }
}

module SearPin(clearance=RodClearanceSnug()) {
  translate([SearPinX(),0,SearPinZ()])
  rotate([90,0,0])
  Rod(rod=SearRod(), clearance=clearance,
      length=TeeRimDiameter(receiverTee),
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

  // Tee Column
  translate([0,0,-TeeCenter(ReceiverTee())])
  cylinder(r=TeeInnerRadius(ReceiverTee()), h=TeeCenter(ReceiverTee()));
}

module TriggerGroup() {

    %Striker();

    %FiringPinGuide();

    color("Red")
    rotate([90,0,0])
    render(convexity=2)
    linear_extrude(height=0.25, center=true)
    Sear();

    Trigger();

    ResetSpring();

    color("Lime")
    render(convexity=3)
    Safety();
}

scale([25.4, 25.4, 25.4]) {
  TriggerGroup();
  %TriggerGeometry();
  *Reference();
}

module trigger_plater() {
  render()
  scale([25.4, 25.4, 25.4]) {

    translate([-1,-0.4,1/8])
    rotate([90,0,0])
    Trigger();

    translate([-1,0,0])
    *Sear();
    
    translate([-ResetPinX(),1-ResetPinZ(),1/8])
    rotate([-90,0,0])
    ResetSpring(left=true, right=false);
    
    rotate([90,0,0])
    translate([1-ResetPinX(),1/8,-ResetPinZ()])
    ResetSpring(left=false, right=true);
  }
}

!trigger_plater();
