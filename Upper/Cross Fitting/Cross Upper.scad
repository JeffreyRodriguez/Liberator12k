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

module CrossFittingQuadrail2d(rod=Spec_RodFiveSixteenthInch(), rodClearance=RodClearanceLoose()) {
  hull() {
    Quadrail2d(rod=rod, rodClearance=rodClearance, wallTee=WallTee(),
               clearFloor=true, clearCeiling=true);

    // Grip flat
    translate([ReceiverCenter()-0.1,-GripWidth()/2])
    square([0.1, GripWidth()]);
  }
}

module CrossInserts(width=0.25, height=0.75, slotHeight=1.25,
                    angles=[0,180], clearance=0) {
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

module CrossUpperCenter() {
  color("DimGrey")
  render(convexity=4)
  difference() {
    translate([-ReceiverIR()+ManifoldGap(),0,0])
    rotate([0,90,0])
    linear_extrude(height=ReceiverID()-ManifoldGap(2))
    CrossFittingQuadrail2d();

    translate([-0.001,0,0])
    Frame();

    CrossInserts(clearance=0.003);

    // Tee
    ReferenceTeeCutter();
  }
}

module CrossUpperFront($fn=40) {
  color("Gold")
  render(convexity=4)
  difference() {
    union() {
      translate([ReceiverLugFrontMaxX(),0,0])
      mirror([1,0,0])
      rotate([0,90,0])
      linear_extrude(height=ReceiverLugFrontMaxX()-ReceiverIR())
      CrossFittingQuadrail2d();

      translate([0,0,-ReceiverCenter()])
      ReceiverLugFront(extraTop=ManifoldGap());
    }

    translate([-0.001,0,0])
    Frame();

    Breech();

    CrossInserts(clearance=0.003);

    // Tee
    ReferenceTeeCutter();
  }
}

module CrossUpperBack(receiver=ReceiverTee(),
                        stock=Spec_PipeThreeQuarterInch(),
                        spin=Spec_RodFiveSixteenthInch(),
                        rod=Spec_RodFiveSixteenthInch(),
                        support=true, gripExtension=0.85) {

  color("Gold")
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

    CrossInserts(clearance=0.002);

    translate([-0.001,0,0])
    Frame();
  }
}

CrossUpperFront();
CrossUpperBack();
Frame();
Reference();


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