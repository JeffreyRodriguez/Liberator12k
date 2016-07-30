//$t=0.999999999;
//$t=0;
include <Components/Animation.scad>;

use <Components/Manifold.scad>;
use <Components/Debug.scad>;
use <Components/Semicircle.scad>;
use <Components/Spindle.scad>;
use <Components/Receiver Insert.scad>;

use <Vitamins/Rod.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Spring.scad>;

use <Firing Pin Guide.scad>;
use <Striker.scad>;
use <Charger.scad>;

use <Reset Spring.scad>;
use <Sear.scad>;

use <Reference.scad>;

//function TriggerSpring() = Spec_BicSoftFeelFinePenSpring();
function TriggerSpring() = Spec_BicLighterThumbSpring();


//function SearTowerHeight() = TeeCenter(ReceiverTee()) - 0.35;


function TriggerAngle() = 360/16;
function TriggerWidth() = 0.25;
function TriggerPinX() = -1/4;
function TriggerPinZ() = -TeeCenter(ReceiverTee())-RodRadius(TriggerRod());
function TriggerTravel() = RodDiameter(StrikerRod())*1.75;

function TriggerMaxMajor() = 2.63;

function SafetyPinX() = TriggerPinX() - (TriggerMaxMajor()/2*sqrt(2));
function SafetyPinZ() = TriggerPinZ();
function SafetyMajorOD() = 3;
function SafetyInterfaceOD() = 2.63;
function SafetyMinorRadius() = 0.45;
function SafetyHoleRadius() = 0.2;
function SafetyBarAngle() = 32;
function SafetyBackAngle() = 3;
function SafetyAngle() = 15;

module TriggerBar() {
  
  color("OliveDrab")
  render()
  translate([-(TriggerTravel()*Animate(ANIMATION_STEP_TRIGGER)),0,0])
  rotate([90,0,0])
  linear_extrude(center=true, height=0.24)
  translate([0,-ReceiverCenter()])
  polygon([[-ReceiverCenter(),
            -0.25+RodRadius(PivotRod())],
  
           [RodRadius(SearRod()),
            -0.25+RodRadius(PivotRod())],
  
           [RodRadius(SearRod())+TriggerTravel(),
            -0.25+RodRadius(PivotRod())-RodDiameter(StrikerRod())],
  
           [RodDiameter(SearRod())+TriggerTravel(),
            -0.25+RodRadius(PivotRod())-RodDiameter(StrikerRod())],
  
           [RodDiameter(SearRod())+TriggerTravel(),
            ManifoldGap()],
  
           [-ReceiverCenter(),ManifoldGap()]
  ]);

}

module Trigger(pin=Spec_RodOneEighthInch(), width=0.3+0.3125) {
  height = (RodDiameter(StrikerRod())*2)+(RodDiameter(PivotRod())*1.5);
  
  color("Yellow")
  render()
  translate([-(TriggerTravel()*Animate(ANIMATION_STEP_TRIGGER)),0,0])
  difference() {
    union() {
      
      rotate([90,0,0])
      linear_extrude(center=true, height=0.24) {
        translate([-ReceiverCenter()-0.7,-ReceiverCenter()-0.18])
        mirror([1,0])
        square([1,0.3+ReceiverCenter()-PipeOuterRadius(StockPipe())]);
      }
    }
    
    ReferenceTeeCutter();
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


//$t=0.0;

module TriggerGroup(debug=true) {
    TriggerBar();
  
    //scale(25.4) rotate([90,0,0])
    Trigger();
  
    Striker(debug=debug);

    //DebugHalf(4)
    Charger();
  
    Sear();
    //!scale(25.4)
    //DebugHalf(3)
    %SearGuide(debug=debug);
  
    //!scale(25.4) rotate([90,0,0])
    SearYoke();
  
    //color("lightgreen")
    //render() 
    //!scale(25.4) rotate([0,90,180])
    //DebugHalf(2)
    %FiringPinGuide(debug=true);

    *ResetSpring();

    *Safety();
  
    echo("Striker Travel: ", StrikerTravel());
}

//scale([25.4, 25.4, 25.4])
{

  TriggerGroup();
  *Reference();
  
  echo("ReceiverCenter()-ReceiverIR()",ReceiverCenter());
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
