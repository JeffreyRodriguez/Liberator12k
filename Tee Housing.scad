  include <Components.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Frame.scad>;
use <Trigger.scad>;
use <Trigger Guard.scad>;
use <Reference.scad>;
use <Cylinder.scad>;




module TeeHousingPinFlat(offset=0.3, diameter=0.58, length=1, $fn=6) {
  translate([0,0,offset])
  cylinder(r=diameter/2, h=length);
}


module front_tee_housing(receiver=ReceiverTee(),
                         barrelPipe=BarrelPipe(),
                         forendRod=FrameRod(),
                         forendPinRod=Spec_RodFiveSixteenthInch(),
                         breechBushing=BushingThreeQuarterInch,
                         wall=WallTee(), $fn=40) {
  boltLength   = GripWidth()+0.9;
  length = WallFrameFront()+TeeRimWidth(receiver);

  render(convexity=4)
  difference() {
    union() {
      hull() {
        translate([(TeeWidth(receiver)/2) - TeeRimWidth(receiver),0,0])
        rotate([0,90,0])
        linear_extrude(height=length) {

          // Tee Rim
          circle(r=TeeRimDiameter(receiver)/2 + WallTee());
          
          FrameRodSleeves();
      
          // Revolver Spindle
          translate([CylinderChamberOffset(),0])
          circle(r=GripWidth()/2);
        }

        difference () {
          GripFrontRod(length=boltLength, offsetZ=-0.0,
                  extraRadius=WallFrontGripRod(),
                  $fn=Resolution(12,60));
          
          // Flatten the bottom
          translate([(TeeWidth(ReceiverTee())/2)+WallFrameFront(),-3,-3])
          cube([5, 6, 6]);
        }
        
        // Meet the grip front-flat
        translate([TeeCenter(ReceiverTee()),-(GripWidth()/2)+0.1,-TeeCenter(ReceiverTee())])
        mirror([0,0,1])
        cube([WallFrameFront(),
              GripWidth(),
              RodDiameter(GripRod())+WallFrontGripRod()]);
      }
    
      // Assembly Chevron
      translate([TeeRimRadius(ReceiverTee())-0.3,0,TeeRimRadius(ReceiverTee())+((WallFrameRod()+RodRadius(FrameRod())) * sqrt(2))])
      linear_extrude(height=0.04)
      rotate(-90)
      text(text="^", size=1, halign="center");
    }

    *translate([(TeeWidth(receiver)/2) - TeeRimWidth(receiver),0,-length])
    rotate([0,90,0])
    linear_extrude(height=length*3)
    FrameRods();

    translate([-0.001,0,0])
    Frame();
    
    CylinderSpindle(nutHeight=1);

    Breech(ReceiverTee(), breechBushing);

    // Tee
    ReferenceTeeCutter();
    
    GripFrontRod(length=5) {
      
      // Left
      rotate([0,0,90])
      TeeHousingPinFlat(offset=0.94, $fn=Resolution(12,40));
      
      // Right
      mirror([0,0,1])
      TeeHousingPinFlat(offset=0.89, $fn=Resolution(12,40));
    
      }
    
    *GripTriggerFingerSlot();
    
    // Flatten front/top
    translate([0,-GripWidth()/2,-TeeCenter(ReceiverTee())-3])
    cube([(TeeWidth(ReceiverTee())/2)+WallFrameFront()+0.1,GripWidth(),3]);
  }
}


module back_tee_housing(receiver=ReceiverTee(),
                        stock=Spec_PipeThreeQuarterInch(),
                        spin=Spec_RodFiveSixteenthInch(),
                        rod=Spec_RodFiveSixteenthInch(),
                        support=true, gripExtension=0.85) {
  boltLength   = GripWidth()+0.75;
  block_length = TeeRimWidth(ReceiverTee())
                 +WallFrameBack();

  render(convexity=4)
  difference() {
    intersection() {
      union() {
        hull() {

          // Rails
          color("Red")
          translate([-block_length-(TeeWidth(ReceiverTee())/2) +TeeRimWidth(ReceiverTee()),0,0])
          rotate([0,90,0])
          linear_extrude(height=block_length)
          hull() {
            FrameRodSleeves();

            circle(r=TeeRimDiameter(ReceiverTee())/2 + WallTee());
          }
          
          GripRearRod(length=2.25, radiusExtra=0.2,
                      capEnabled=false, nutEnabled=false);

          // Printability - Flatten the printed-bottom, which is the front-face
          translate([-(TeeWidth(ReceiverTee())/2)-WallFrameBack(),
                     -0.7,
                     -TeeRimRadius(ReceiverTee())-0.375])
          cube([RodRadius(GripRod())+WallTriggerGuardRod(), 1.4, 1]);
        }
        
        // Assembly Chevron
        translate([-TeeRimRadius(ReceiverTee())-1.15,0,TeeRimRadius(ReceiverTee())+((WallFrameRod()+RodRadius(FrameRod())) * sqrt(2))])
        linear_extrude(height=0.04)
        rotate(-90)
        text(text="^", size=1, halign="center");
      }
      
      // Flatten the back
      translate([-TeeCenter(ReceiverTee())-WallFrameBack(),
                 -TeeCenter(ReceiverTee()),
                 -TeeCenter(ReceiverTee())-1])
      cube([WallFrameBack()+TeeRimWidth(ReceiverTee()),
            TeeWidth(ReceiverTee()),
            TeeWidth(ReceiverTee())+1]);
    }
    
    GripRearRod(length=2.75) {
    
      // Front
      translate([0,0,-1.13])
      mirror([0,0,1])
      cylinder(r=0.3, h=1, $fn=Resolution(12,40));
    
      // Rear
      translate([0,0,1.14])
      cylinder(r=0.4, h=1, $fn=Resolution(12,40));
    }

    // Cutout
    translate([-(TeeWidth(ReceiverTee())/2) -(WallTriggerGuardRod()*2) -RodDiameter(GripRod()) -0.1,
               -(GripWidth()/2) -0.002,
               -TeeCenter(ReceiverTee()) - 1])
    cube([TeeWidth(ReceiverTee()), GripWidth()+0.004, TeeCenter(ReceiverTee())+1]);

    Stock(ReceiverTee(), StockPipe());

    ReferenceTeeCutter();

    translate([-0.001,0,0])
    Frame();
  }
}

module Reference_TeeHousing(receiver=ReceiverTee(),
                            breechBushing=Spec_BushingThreeQuarterInch(),
                            stock=Spec_PipeThreeQuarterInch(),debug=true) {

  color("Purple")
  front_tee_housing(receiver, debug=false);

  color("CornflowerBlue")
  back_tee_housing(debug=debug);

}


Grip(showRight=false, showTrigger=true);

Reference_TeeHousing();

%Frame();

*Reference();
