//$t=0.8;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Frame.scad>;
use <Trigger.scad>;
use <Trigger Guard.scad>;
use <Grip Tabs.scad>;
use <Reference.scad>;
use <Cylinder.scad>;
use <Components/Manifold.scad>;

module TeeHousingPinFlat(offset=0.3, diameter=0.58, length=1, $fn=6) {
  translate([0,0,offset])
  cylinder(r=diameter/2, h=length);
}


module TeeHousingFront(receiver=ReceiverTee(),
                         barrelPipe=BarrelPipe(),
                         forendRod=FrameRod(),
                         forendPinRod=Spec_RodFiveSixteenthInch(),
                         breechBushing=BreechBushing(),
                         wall=WallTee(), $fn=40) {
  length = WallFrameFront()+TeeRimWidth(receiver);

  color("Purple")
  render(convexity=4)
  difference() {
    union() {
      translate([ReceiverCenter() - TeeRimWidth(receiver),0,0])
      rotate([0,90,0])
      hull()
      linear_extrude(height=length) {

        // Tee Rim
        circle(r=TeeRimDiameter(receiver)/2 + WallTee());
        
        FrameRodSleeves();
      
        // Meet the grip front-flat
        translate([ReceiverCenter()-0.1,-GripWidth()/2])
        square([0.1, GripWidth()]);
      
        // Top-Cover
        translate([-ReceiverCenter(),-GripWidth()/2])
        *#square([0.5, GripWidth()]);
      }
        
      GripTabFront();
    
      // Assembly Chevron
      translate([TeeRimRadius(ReceiverTee())-0.3,0,TeeRimRadius(ReceiverTee())+((WallFrameRod()+RodRadius(FrameRod())) * sqrt(2))])
      linear_extrude(height=0.04)
      rotate(-90)
      text(text="^", size=1, halign="center");
    }

    translate([-0.001,0,0])
    Frame();
    
    CylinderSpindle(nutHeight=1);

    Breech(ReceiverTee(), breechBushing);

    // Tee
    ReferenceTeeCutter();
  }
}

module TeeHousingBack(receiver=ReceiverTee(),
                        stock=Spec_PipeThreeQuarterInch(),
                        spin=Spec_RodFiveSixteenthInch(),
                        rod=Spec_RodFiveSixteenthInch(),
                        support=true, gripExtension=0.85) {
  block_length = TeeRimWidth(ReceiverTee())+WallFrameBack();

  color("CornflowerBlue")
  render(convexity=4)
  difference() {
    union() {
      
      translate([-block_length-ReceiverCenter() +TeeRimWidth(ReceiverTee()),0,0])
      rotate([0,90,0])
      linear_extrude(height=block_length)
      hull() {
        // Rails
        FrameRodSleeves();

        // Receiver rim
        circle(r=ReceiverOR() + WallTee(), $fn=Resolution(30,70));
      
        // Meet the grip front-flat
        translate([ReceiverCenter()-0.1,-GripWidth()/2])
        square([0.1, GripWidth()]);
      }
      
      translate([-ReceiverCenter()-WallFrameBack(),0,0])
      GripTab(length=1);
      
      // Assembly Chevron
      translate([-TeeRimRadius(ReceiverTee())-1.15,0,TeeRimRadius(ReceiverTee())+((WallFrameRod()+RodRadius(FrameRod())) * sqrt(2))])
      linear_extrude(height=0.04)
      rotate(-90)
      text(text="^", size=1, halign="center");
    }

    Stock(ReceiverTee(), StockPipe());

    ReferenceTeeCutter();

    translate([-0.001,0,0])
    Frame();
  }
}


module Reference_TeeHousing(receiver=ReceiverTee(),
                            breechBushing=Spec_BushingThreeQuarterInch(),
                            stock=Spec_PipeThreeQuarterInch(),debug=true) {

  TeeHousingFront(receiver, debug=false);

  TeeHousingBack(debug=debug);

}


Grip(showLeft=true, showTrigger=true);

Reference_TeeHousing();

%Frame();

%CylinderSpindle();

%color("white", 0.25)
Reference();


// Plated Front
*!scale(25.4)
translate([0,0,ReceiverCenter()+WallFrameFront()])
rotate([0,90,0])
TeeHousingFront();

// Plated Back
*!scale(25.4)
translate([0,0,ReceiverCenter()+WallFrameBack()])
rotate([0,-90,0])
TeeHousingBack();
