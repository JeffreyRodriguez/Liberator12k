//$t=0.8;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../LowerReceiver Lugs.scad>;
use <../../Lower/Lower.scad>;
use <Frame.scad>;
use <Reference.scad>;


function FrameRodAngles() = [
                    FrameRodMatchedAngle(),
                    -FrameRodMatchedAngle(),
                    FrameRodMatchedAngle()+180,
                    -FrameRodMatchedAngle()-180
                   ];

function FrameRodOffset()
           = ReceiverOR()
           + RodRadius(FrameRod())
           + OffsetFrameRod()
           ;


module CrossFittingQuadrail2d(rod=Spec_RodFiveSixteenthInch(), rodClearance=RodClearanceLoose(),
                              wallTee=0.5, wallRod=0.2) {
  union() {


    for (angle = FrameRodAngles())
    hull() {

      // Tee Rim
      circle(r=ReceiverOR() + wallTee, $fn=Resolution(20,50));

      // Rod
      rotate([0,0,angle])
      translate([-FrameRodOffset(ReceiverTee()), 0])
      Rod2d(rod=FrameRod(), extraWall=wallRod, clearance=rodClearance, $fn=Resolution(20,50));
    }

    hull() {

      // Grip flat
      translate([ReceiverCenter()-0.1,-GripWidth()/2])
      square([0.1, GripWidth()]);

      // Top-Cover
      #translate([0,-ReceiverIR()])
      mirror([1,0])
      *square([ReceiverCenter()-0.2, ReceiverID()]);

      // Tee Rim
      circle(r=ReceiverOR() + wallTee);
    }
  }
}

module UpperReceiverFront(receiver=ReceiverTee(),
                         barrelPipe=BarrelPipe(),
                         forendRod=FrameRod(),
                         forendPinRod=Spec_RodFiveSixteenthInch(),
                         breechBushing=BreechBushing(),
                         wall=WallTee(), $fn=40) {
  color("Purple")
  render(convexity=4)
  difference() {
    union() {
      translate([ReceiverLugFrontMaxX(),0,0])
      mirror([1,0,0])
      rotate([0,90,0])
      linear_extrude(height=ReceiverLugFrontMaxX()-0.5)
      CrossFittingQuadrail2d();

      translate([0,0,-ReceiverCenter()])
      ReceiverLugFront(extraTop=ManifoldGap());
    }

    translate([-0.001,0,0])
    Frame();

    Breech(ReceiverTee(), breechBushing);

    // Tee
    ReferenceTeeCutter();
  }
}

module UpperReceiverBack(receiver=ReceiverTee(),
                        stock=Spec_PipeThreeQuarterInch(),
                        spin=Spec_RodFiveSixteenthInch(),
                        rod=Spec_RodFiveSixteenthInch(),
                        support=true, gripExtension=0.85) {

  color("CornflowerBlue")
  render(convexity=4)
  difference() {
    union() {

      translate([ReceiverLugRearMinX(),0,0])
      rotate([0,90,0])
      linear_extrude(height=abs(ReceiverLugRearMinX())-ReceiverIR())
      CrossFittingQuadrail2d();

      translate([0,0,-ReceiverCenter()])
      ReceiverLugRear(extraTop=1);
    }

    Stock(ReceiverTee(), StockPipe());

    ReferenceTeeCutter();

    translate([-0.001,0,0])
    Frame();
  }
}


module Reference_UpperReceiver(receiver=ReceiverTee(),
                            breechBushing=Spec_BushingThreeQuarterInch(),
                            stock=Spec_PipeThreeQuarterInch(),debug=true) {

  UpperReceiverFront(receiver, debug=false);

  UpperReceiverBack(debug=debug);

}


translate([0,0,-ReceiverCenter()])
*Grip(showLeft=true, showTrigger=true);

Reference_UpperReceiver();

%Frame();

%color("white", 0.25)
Reference();


// Plated Front
*!scale(25.4)
translate([0,0,ReceiverCenter()+WallFrameFront()])
rotate([0,90,0])
UpperReceiverFront();

// Plated Back
*!scale(25.4)
translate([0,0,ReceiverCenter()+WallFrameBack()])
rotate([0,-90,0])
UpperReceiverBack();
