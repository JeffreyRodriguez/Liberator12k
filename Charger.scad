//$t=0.9999999999;
//$t=0.75;
//$t=0;
include <Components/Animation.scad>;
use <Components/Semicircle.scad>;
use <Components/Receiver Insert.scad>;
use <Vitamins/Rod.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Spring.scad>;

    

use <Debug.scad>;
use <Reference.scad>;

use <Frame.scad>;
use <Striker.scad>;


chargingWheelOffsetX = -12/64;
chargingWheelOffsetZ = (ReceiverIR()*1.55)+RodRadius(StrikerRod());
chargingWheelRadius  = chargingWheelOffsetZ-RodRadius(StrikerRod());
chargingSpindleRadius = ReceiverIR()-abs(chargingWheelOffsetX)-RodRadius(PivotRod());

module ChargingPivot(rod=PivotRod(), clearance=RodClearanceSnug(),
                   length=ReceiverIR()+0.2) {
  translate([chargingWheelOffsetX, 0, chargingWheelOffsetZ]) {
    rotate([90,0,0])
    Rod(rod=rod, center=true, length=length);
                       
    children();
  }
}


module ChargingWheel(angle=90) {
  color("OrangeRed")
  render(convexity=4)
  translate([chargingWheelOffsetX,0,chargingWheelOffsetZ])
  rotate([90,-angle+(angle*Animate(ANIMATION_STEP_CHARGE)),0]) {

    // Striker interface
    intersection() {
      difference() {
        linear_extrude(height=0.22, center=true) {
          difference() {
            hull() {
              rotate(90-45)
              mirror()
              semicircle(od=(chargingWheelRadius*2),
                      angle=100, $fn=Resolution(20,40));

              // Spindle Body
              circle(r=chargingSpindleRadius, $fn=Resolution(15,30));
            }

            // Spindle Rod
            Rod2d(PivotRod(), RodClearanceLoose(), center=true);
            
            // Charging Rod Cutout
            rotate(-25)
            translate([chargingWheelRadius-RodDiameter(ChargingRod()),0])
            Rod2d(ChargingRod(), RodClearanceLoose(), center=true);
          
            translate([0,chargingWheelOffsetX-ReceiverIR()])
            rotate(-180)
            square([1,1]);
          }
          
          // Charging Rod Boss
          rotate(-40)
          translate([chargingWheelRadius-RodRadius(ChargingRod(), RodClearanceLoose()),0])
          circle(r=0.125, $fn=20);
        }
        
        // Charging Ramp Flats
        rotate([-90,0,15])
        translate([chargingSpindleRadius,-0.25,-chargingWheelRadius+0.4])
        cube([chargingWheelRadius-abs(chargingWheelOffsetX),
               0.5,
               ReceiverLength()]);
        
        // Clear the receiver wall
        intersection() {
          translate([0,0,-0.5])
          rotate_extrude(convexity = 10, $fn=Resolution(20,100))
          translate([ReceiverIR()-chargingWheelOffsetX, 0, 0])
          square([1,1]);
          
          linear_extrude(height=1, center=true)
          rotate(90)
          mirror()
          semicircle(od=2,
                  angle=90, $fn=Resolution(20,40));
        }
      }
      
      // Receiver-clearing Undercut
      union()
      translate([-chargingWheelOffsetX,-chargingWheelOffsetZ,0])
      for (axis=[[0,90,0], [90,0,0]])
      rotate(axis)
      cylinder(r=ReceiverIR()-0.01,
                h=ReceiverLength(),
              $fn=Resolution(20,60),
           center=true);
    }
  }
}

module ChargingSupports() {

  // Charging Supports
  color("Moccasin")
  render(convexity=4)
  difference() {
    union() {
        
      // Rim
      translate([0,0,TeeCenter(ReceiverTee())])
      intersection() {
        union() {
          
          // Insert
          mirror([0,0,1])
          ReceiverInsert();
        
          translate([0,0,-ManifoldGap()])
          TeeRim(ReceiverTee(), height=0.5, $fn=Resolution(20,40));
        }
        
        translate([0,0,-0.45])
        rotate([0,45,0])
        cube([2,4,2], center=true);
        
        // Fit into retainer
        translate([-ReceiverOR()-ManifoldGap(),
                   -ReceiverIR(),
                   -ReceiverLength()+0.5])
        cube([ReceiverOD()+ManifoldGap(2), ReceiverID(), ReceiverLength()]);

      }
    }
    
    // Firing Pin Guide Clearance
    rotate([0,90,0])
    cylinder(r=ReceiverIR()-ManifoldGap(),
             h=TeeCenter(ReceiverTee()),
        center=true,
           $fn=Resolution(12,30));

    // Charging Wheel Travel Path
    translate([-2,-RodRadius(ChargingRod(), RodClearanceLoose()),0])
    cube([4,
          RodDiameter(ChargingRod(), RodClearanceLoose()),
          TeeCenter(ReceiverTee())-0.36]);
    
    
    // Charging Rod Hole
    translate([+RodRadius(rod=SearRod())
               +RodRadius(rod=ChargingRod()),0,0.1])
    Rod(rod=ChargingRod(),
     length=ReceiverLength(),
     clearance=RodClearanceLoose(),
        $fn=4);

    ChargingPivot(length=1) {
    
      // Charging Wheel Travel
      rotate([90,-60,0])
      linear_extrude(height=RodDiameter(ChargingRod(), RodClearanceLoose()),
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

module ChargerRetainer() {
  color("Teal")
  render(convexity=4)
  difference() {
    hull() {
      // Rails
      render(convexity=4)
      rotate([0,90,0])
      linear_extrude(height=ReceiverLength()-(TeeRimWidth(ReceiverTee())*2),
                     center=true) {
        translate([-ReceiverLength()/2,-ReceiverOR()-WallFrameRod()])
        mirror([1,0])
        square([0.75,ReceiverOD()+(WallFrameRod()*2)]);
                       
        FrameRodSleeves();
      }
    }
    
    // Charging Support Cutout
    translate([-ReceiverOR()-ManifoldGap(),
               -ReceiverIR()-0.005,
               TeeCenter(ReceiverTee())-ManifoldGap()])
    cube([ReceiverOD()+ManifoldGap(2), ReceiverID()+0.01, 0.5+ManifoldGap()]);

    ReferenceTeeCutter();
    
    
    translate([-0.001,0,0])
    Frame();
    
    // Charging Rod Hole
    translate([RodRadius(rod=SearRod())
               +RodRadius(rod=ChargingRod()),0,0.1])
    Rod(rod=ChargingRod(),
     length=ReceiverLength(),
     clearance=RodClearanceLoose(),
        $fn=4);
  }
}

module Charger() {
  //!scale(25.4) rotate([90,0,0])
  ChargingWheel();
  
  //!scale(25.4) rotate([180,0,0])
  DebugHalf(4)
  ChargingSupports();
  
  //!scale(25.4) rotate([0,90,0])
  *ChargerRetainer();
  
  translate([1,0,(ReceiverLength()/2)])
  rotate([90,0,0])
  cylinder(r=0.5, h=0.22, center=true, $fn=20);
  
  // Charging Rod
  translate([0,0,-0.75*Animate(ANIMATION_STEP_CHARGE)]) // TODO: Run the math on this, just roughed out for now.
  translate([RodDiameter(rod=ChargingRod()),0,(ReceiverLength()/2)-0.02])
  %Rod(rod=ChargingRod(), length=0.75, $fn=Resolution(20,40));
}

Striker();
Charger();
//Reference();