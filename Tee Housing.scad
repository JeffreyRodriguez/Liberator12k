include <Components.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Frame.scad>;
use <Trigger.scad>;
use <Trigger Guard.scad>;
use <Reference.scad>;
use <Cylinder.scad>;



module ReferenceTeeCutter(centerLength = TeeRimDiameter(ReceiverTee()), $fn=Resolution(12,30)) {
  
  // Vertical
  translate([0,0,-TeeWidth(ReceiverTee())])
  TeeRim(ReceiverTee(), height=TeeWidth(ReceiverTee())*2);

  // Horizontal
  translate([-TeeWidth(ReceiverTee())/2,0,0])
  rotate([0,90,0])
  TeeRim(ReceiverTee(), height=TeeWidth(ReceiverTee()));
  
  // Corner Infill
  for (n=[-1,1]) // Top of cross-fitting
  for (i=[-1,1]) // Sides of tee-fitting
  translate([i*TeeOuterRadius(ReceiverTee())/2,0,n*-TeeOuterRadius(ReceiverTee())/2])
  rotate([0,n*i*45,0])
  cylinder(r=TeeOuterRadius(ReceiverTee()), h=0.5, center=true);
}



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
  boltLength   = GripWidth()+0.75;
  length = WallFrameFront()+TeeRimWidth(receiver);

  render(convexity=4)
  difference() {
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
        GripFrontRod(length=boltLength,
                extraRadius=WallTriggerGuardRod(),
                $fn=Resolution(12,60)) {
          
          // Printability - Flatten the printed-bottom, which is the front-face
          translate([0,-RodRadius(GripRod())-(WallTriggerGuardRod()/2),-GripWidth()/2])
          cube([RodRadius(GripRod())+WallTriggerGuardRod(), 1, GripWidth()]);

        };
        
        // Flatten the bottom
        translate([(TeeWidth(ReceiverTee())/2)+WallFrameFront(),-3,-3])
        cube([5, 6, 6]);
      }
    }

    translate([(TeeWidth(receiver)/2) - TeeRimWidth(receiver),0,0])
    rotate([0,90,0])
    linear_extrude(height=length)
    FrameRods();
    
    CylinderSpindle(nutHeight=1);

    Breech(ReceiverTee(), breechBushing);

    // Tee
    ReferenceTeeCutter();
    
    GripFrontRod(length=2) {
      
      // Nut
      rotate([0,0,90])
      TeeHousingPinFlat(offset=0.86);
      
      // Bolt Head
      mirror([0,0,1])
      TeeHousingPinFlat(offset=0.87, $fn=12);
    }
    
    // Stop at the bottom of the receiver
    hull() {
      
      // Grip front-top flat
      translate([0,-GripWidth()/2,-TeeCenter(ReceiverTee())-5])
      cube([(TeeWidth(ReceiverTee())/2)+WallFrameFront()+0.1,GripWidth(),5]);
      
      GripFrontRod(length=GripWidth(), extraRadius=WallTriggerGuardRod()+0.001);
    }
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
        
        GripRearRod(capRadiusExtra=0.2, capHeightExtra=-0.1, capEnabled=true, $fn=Resolution(20,30));

        // Printability - Flatten the printed-bottom, which is the front-face
        translate([-(TeeWidth(ReceiverTee())/2)-WallFrameBack(),-0.7, -TeeRimRadius(ReceiverTee())-0.375])
        cube([RodRadius(GripRod())+WallTriggerGuardRod(), 1.4, 1]);
      }
    }
    
    GripRearRod(capHeightExtra=1);

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


module tee_housing_plater(receiver=ReceiverTee(), debug=false) {
  translate([0,2,(TeeWidth(ReceiverTee())/2)+WallFrameFront()])
  rotate([0,90,0])
  front_tee_housing(debug=debug);

  translate([0,-2,(TeeWidth(receiver)/2)+WallFrameBack()])
  rotate([0,-90,0])
  back_tee_housing(debug=debug);
}


scale([25.4, 25.4, 25.4])
tee_housing_plater();

module Reference_TeeHousing(receiver=ReceiverTee(),
                            breechBushing=Spec_BushingThreeQuarterInch(),
                            stock=Spec_PipeThreeQuarterInch(),debug=true) {

  color("Purple")
  front_tee_housing(receiver, debug=false);

  color("CornflowerBlue")
  back_tee_housing(debug=debug);

}

*!scale([25.4, 25.4, 25.4]) {

  //color("Green", 0.2);
  %Grip(showTrigger=true);

  color("Purple", 0.5)
  Reference_TeeHousing();

  *%Frame();

  %Reference();
}
