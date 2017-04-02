//$t=0.9999999999;
//$t=0.25;
//$t=0.395;
//$t=0.455;
//$t=0.75;
//$t=0;
include <../../Meta/Animation.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;

use <../../Components/Semicircle.scad>;
use <../../Components/Tee Insert.scad>;

use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Spring.scad>;

use <../../Lower/Trigger.scad>;

use <../../Reference.scad>;

use <Frame.scad>;
use <Cross Upper.scad>;
use <Striker.scad>;

chargerPivotX  = -3/16;
chargerPivotZ  = ReceiverIR()+(ReceiverCenter()/2);
chargingSpindleRadius = ReceiverIR()-abs(chargerPivotX)-(0.03);
function ChargingHandleWidth() = 5/16;

module ChargingPivot(rod=PivotRod(), clearance=RodClearanceSnug(),
                   length=ReceiverIR()+0.2) {
  translate([chargerPivotX, 0, chargerPivotZ]) {
    rotate([90,0,0])
    Rod(rod=rod, center=true, length=length);

    children();
  }
}


module ChargingHandle(angle=35) {
  
  chargingWheelRadius   = chargerPivotZ-RodRadius(StrikerRod());
  
  color("OrangeRed")
  render(convexity=4)
  translate([chargerPivotX,0,chargerPivotZ])
  rotate([0,-(angle*Animate(ANIMATION_STEP_CHARGER_RESET)),0])
  rotate([0,(angle*Animate(ANIMATION_STEP_CHARGE)),0])
  rotate([90,0,0]) {
    union()
    linear_extrude(height=ChargingHandleWidth(), center=true) {

      // Charging handle body
      translate([-chargerPivotX,ReceiverCenter()-chargerPivotZ])
      mirror([1,0])
      square([ReceiverCenter()+1, 0.75-chargingSpindleRadius]);

      difference() {
        hull() {

          // Stick out the top, so the charging handle can be attached
          translate([-chargerPivotX,0])
          mirror([1,0])
          square([abs(chargerPivotX)+chargingSpindleRadius, 0.75]);

          // Charger supporting infill
          rotate(70+angle)
          semidonut(major=(ReceiverIR()+abs(chargerPivotX))*2,
                    minor=chargingSpindleRadius,
                    angle=80+angle, $fn=Resolution(20,40));

          // StrikerTop interface
          rotate(-51)
          semicircle(od=(chargingWheelRadius*2),
                  angle=16, $fn=Resolution(20,60));

          // Pivot body
          circle(r=chargingSpindleRadius, $fn=Resolution(15,30));
        }

        // Pivot hole
        Rod2d(PivotRod(), RodClearanceLoose(), center=true);
      }
    }
  }
}

module ChargingInsert(single=true) {

  // Charging Supports
  color("Moccasin", 0.5)
  render(convexity=4)
  difference() {

    // Insert
    translate([0,0,ReceiverCenter()+ManifoldGap()])
    mirror([0,0,1])
    intersection() {
      TeeInsert();
      
      translate([0,0,-ManifoldGap()])
      cylinder(r=TeeInnerRadius(ReceiverTee())+0.1,
               h=ReceiverCenter(), $fn=Resolution(20, 40));
    }

    // Charging Wheel Travel Path
    translate([-2,-(ChargingHandleWidth()/2)-0.01,0])
    cube([4,
          ChargingHandleWidth()+0.02 + (single?1:0),
          ReceiverCenter()+ManifoldGap(2)]);

    ChargingPivot(length=1);
  }
}

ChargingHandle();

ChargingInsert();

Striker();

translate([0,0,-ReceiverCenter()])
TriggerGroup();

color("black", 0.25)
Reference();


// Plated charging handle
*!scale(25.4) rotate([90,0,0])
ChargingHandle();

// Plated charging insert
*!scale(25.4) rotate([-90,0,0])
ChargingInsert(left=true, right=false);