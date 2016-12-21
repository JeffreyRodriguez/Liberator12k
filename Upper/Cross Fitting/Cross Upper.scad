//$t=0.8;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Lower.scad>;
use <../../Lower/Trigger.scad>;
use <../../Reference.scad>;
use <Frame.scad>;

module CrossFittingQuadrail2d(rod=Spec_RodFiveSixteenthInch(),
                     rodClearance=RodClearanceLoose()) {
  hull() {
    Quadrail2d(rod=rod, rodClearance=rodClearance, wallTee=WallTee(),
               clearFloor=true, clearCeiling=false);

    // Grip flat
    translate([ReceiverCenter()-0.1,-GripWidth()/2])
    square([0.1, GripWidth()]);
  }
}

module CrossInserts(width=0.25, height=0.75, slotHeight=1.25,
                    angles=[0,180], clearance=0, alpha=1) {
  color("SteelBlue", alpha)
  render()
  for (a = angles)
  rotate([a,0,0]) {
    translate([-ReceiverCenter(),
               -ReceiverOR()-(WallTee()/2)-(width/2)-clearance,
               -(height/2)-clearance])
    cube([ReceiverLength(), width+(clearance*2), height+(clearance*2)]);

    // Alignment Cutout
    if (clearance>0)
    hull()
    translate([0,
               -ReceiverOR()-(WallTee()/2)-(width/2)+ManifoldGap(),
               -clearance])
    mirror([0,1,0])
    translate([-ReceiverIR(),0, -0.5])
    cube([ReceiverID(), 1, 1]);
  }
}

module CrossUpperFront($fn=40, alpha=1) {
  color("Orange", alpha)
  render(convexity=4)
  difference() {
    union() {
      translate([ReceiverLugFrontMaxX(),0,0])
      mirror([1,0,0])
      rotate([0,90,0])
      hull() {
        linear_extrude(height=ReceiverLugFrontMaxX())
        CrossFittingQuadrail2d();

        // Protect the charging handle
        translate([0,0,ReceiverLugFrontMaxX()-0.1])
        linear_extrude(height=0.1)
        translate([0,-ReceiverIR()])
        mirror([1,0])
        square([ReceiverCenter()+0.5,ReceiverID()]);
      }

      translate([0,0,-ReceiverCenter()])
      ReceiverLugFront(extraTop=ManifoldGap());
    }

    translate([-0.001,0,0])
    Frame();

    Breech();

    CrossInserts(clearance=0.005);

    // Tee
    ReferenceTeeCutter(topLength=0.01);
  }
}

module CrossUpperBack(alpha=1) {

  color("Gold", alpha)
  render(convexity=4)
  difference() {
    union() {

      translate([ReceiverLugRearMinX(),0,0])
      rotate([0,90,0])
        linear_extrude(height=abs(ReceiverLugRearMinX()))
      hull() {
        CrossFittingQuadrail2d();


        // Protect the charging handle
        translate([0,-ReceiverIR()])
        mirror([1,0])
        square([ReceiverCenter()+0.5,ReceiverID()]);
      }

      translate([0,0,-ReceiverCenter()])
      ReceiverLugRear(extraTop=1, teardropAngle=-90);
    }

    // Charging handle cutout
    translate([-ReceiverLength(), -RodRadius(StrikerRod())*1.1, ReceiverCenter()])
    cube([ReceiverLength(), RodDiameter(StrikerRod())*1.1, 0.75]);

    Stock(ReceiverTee(), StockPipe());

    ReferenceTeeCutter(topLength=0.01);

    CrossInserts(clearance=0.002);

    translate([-0.001,0,0])
    Frame();
  }
}

CrossUpperFront();
CrossInserts();
CrossUpperBack();
Frame();
Receiver();
Breech();
Stock();


// Plated Front
*!scale(25.4)
translate([0,0,ReceiverCenter()+WallFrameFront()])
rotate([0,90,0])
CrossUpperFront();

// Plated Back
*!scale(25.4)
translate([0,0,ReceiverCenter()+WallFrameBack()])
rotate([0,-90,0])
CrossUpperBack();

// Plated Back Modifier
*!scale(25.4)
render()
intersection() {
  translate([0,0,ReceiverCenter()+WallFrameBack()])
  rotate([0,-90,0])
  CrossUpperBack();

  translate([0.7,-2,-ManifoldGap()])
  cube([2,4,0.75+ManifoldGap(2)]);
}
