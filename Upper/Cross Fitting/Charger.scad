//$t=0.9999999999;
//$t=0.36;
//$t=0.395;
//$t=0.455;
//$t=0.75;
//$t=0;
include <../../Meta/Animation.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;

use <../../Components/Semicircle.scad>;
use <../../Components/Receiver Insert.scad>;

use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Spring.scad>;

use <../../Lower/Trigger.scad>;

use <../../Striker.scad>;
use <../../Reference.scad>;

use <Frame.scad>;
use <Cross Upper.scad>;
use <Firing Pin Guide.scad>;

chargingWheelOffsetX  = -3/16;
chargingWheelOffsetZ  = ReceiverIR()+(ReceiverCenter()/2);
chargingWheelRadius   = chargingWheelOffsetZ-RodRadius(StrikerRod());
chargingSpindleRadius = ReceiverIR()-abs(chargingWheelOffsetX)-(0.03);

module ChargingPivot(rod=PivotRod(), clearance=RodClearanceSnug(),
                   length=ReceiverIR()+0.2) {
  translate([chargingWheelOffsetX, 0, chargingWheelOffsetZ]) {
    rotate([90,0,0])
    Rod(rod=rod, center=true, length=length);

    children();
  }
}


module ChargingHandle(angle=35) {
  color("OrangeRed")
  render(convexity=4)
  translate([chargingWheelOffsetX,0,chargingWheelOffsetZ])
  rotate([0,-(angle*Animate(ANIMATION_STEP_CHARGER_RESET)),0])
  rotate([0,(angle*Animate(ANIMATION_STEP_CHARGE)),0])
  rotate([90,0,0]) {
    union() {
      
      linear_extrude(height=RodDiameter(StrikerRod())*0.9, center=true) {
        
        // Charging handle body
        translate([-chargingWheelOffsetX,ReceiverCenter()-chargingWheelOffsetZ])
        mirror([1,0])
        square([ReceiverCenter()+1, 0.75-chargingSpindleRadius]);
        
        
        
        difference() {
          hull() {
        
            // Stick out the top, so the charging handle can be attached
            translate([-chargingWheelOffsetX,0])
            mirror([1,0])
            square([abs(chargingWheelOffsetX)+chargingSpindleRadius, 0.75]);
            
            // Charger supporting infill
            rotate(70+angle)
            semidonut(major=(ReceiverIR()+abs(chargingWheelOffsetX))*2,
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
}

module ChargingInsert() {

  // Charging Supports
  color("Moccasin", 0.5)
  render(convexity=4)
  difference() {

    // Insert
    translate([0,0,ReceiverCenter()+ManifoldGap()])
    mirror([0,0,1])
    ReceiverInsert();

    // Firing Pin Guide Clearance
    *rotate([0,90,0])
    cylinder(r=ReceiverIR()-ManifoldGap(),
             h=TeeCenter(ReceiverTee()),
        center=true,
           $fn=Resolution(12,30));

    // Charging Wheel Travel Path
    translate([-2,-RodRadius(StrikerRod(), RodClearanceLoose()),0])
    cube([4,
          RodDiameter(StrikerRod(), RodClearanceLoose()),
          ReceiverCenter()+ManifoldGap(2)]);

    ChargingPivot(length=1) {

      // Charging Wheel Travel
      rotate([90,-50,0])
      linear_extrude(height=RodDiameter(StrikerRod(), RodClearanceLoose()),
                     center=true) {

        // Outer clearance
        semicircle(od=(abs(chargingWheelOffsetX)+ReceiverIR())*2,
                 $fn=Resolution(20,60));

        // Spindle clearance
        circle(r=chargingSpindleRadius+0.07,
                 $fn=Resolution(20,60));
      }
    }
  }
}

module ChargerSideplates() {
  color("DimGrey")
  render(convexity=4)
  difference() {
    hull() {
      CrossUpperCenter();
      
      // Rails
      render(convexity=4)
      rotate([0,90,0])
      linear_extrude(height=ReceiverID(),
                     center=true) {
        translate([-ReceiverLength()/2,-ReceiverOR()-WallFrameRod()])
        mirror([1,0])
        square([0.3,ReceiverOD()+(WallFrameRod()*2)]);
      }
    }
    
    ReferenceTeeCutter();


    translate([-0.001,0,0])
    Frame();
    
    CrossInserts(clearance=0.003);

    // Charging Rod Hole
    translate([-ReceiverIR()-ManifoldGap(),
              -RodRadius(ChargingRod(), RodClearanceLoose()),
               ReceiverCenter()-ManifoldGap()])
    cube([ReceiverID()+ManifoldGap(2), RodDiameter(ChargingRod(), RodClearanceLoose()), 1]);

  }
}

module Charger(showSupports=true, showRetainer=true) {
  
  //!scale(25.4) rotate([90,0,0])
  ChargingHandle();

  //!scale(25.4) rotate([180,0,0])
  //DebugHalf(4)
  if (showSupports==true)
  ChargingInsert();

  //!scale(25.4) rotate([0,-90,0])
  //DebugHalf(5)
  if (showRetainer==true)
  ChargerSideplates();

  translate([1,0,(ReceiverLength()/2)])
  rotate([90,0,0])
  *cylinder(r=0.5, h=0.22, center=true, $fn=20);
}

Charger(showSupports=true, showRetainer=false);

//color("Silver", 0.5)
*Striker(debug=true);

translate([0,0,-ReceiverCenter()])
*TriggerGroup();

*FiringPinGuide(debug=true);

color("black", 0.25)
*Reference();


*!scale(25.4) rotate([90,0,0])
ChargingHandle();

*!scale(25.4) rotate([180,0,0])
ChargingInsert();

*!scale(25.4) rotate([0,-90,0])
ChargerSideplates();
