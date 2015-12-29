include <Components.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Forend Rail.scad>;
use <Frame.scad>;
use <Trigger.scad>;
use <Trigger Guard.scad>;
use <Reference.scad>;

module front_tee_housing(receiver=ReceiverTee(),
                         barrelPipe=BarrelPipe(),
                         forendRod=FrameRod(),
                         forendPinRod=Spec_RodFiveSixteenthInch(),
                         breechBushing=BushingThreeQuarterInch,
                         wall=WallTee(), $fn=40) {
  length = BushingHeight(breechBushing) - BushingDepth(breechBushing)+TeeRimWidth(receiver);

  render(convexity=2)
  difference() {
    hull() {
      translate([(TeeWidth(receiver)/2) - TeeRimWidth(receiver),0,0])
      rotate([0,-90,180])
      linear_extrude(height=length) {
        ForendRail(railClearance=RodClearanceSnug());

        circle(r=TeeRimDiameter(receiver)/2 + WallTee());

        // Trigger Fork Body
        translate([TriggerGuardFrontPinZ()-RodDiameter(GripRod()),
                   -0.75])
        square([TeeRimRadius(receiver),
                1.5]);
      }

      TeeHousingFrontPin(length=2.4,
                         extraRadius=WallTriggerGuardRod(),
                         $fn=Resolution(20,60));
    }

    // Rear cutout
    translate([0,
               -(GripWidth()/2) -0.002,
               -TeeCenter(receiver) - 1])
    cube([TeeWidth(receiver)/2, GripWidth()+0.004, TeeCenter(receiver)+1]);

    // Front cutout
    translate([0,
               -(GripWidth()/2) -0.002,
               -TeeCenter(receiver) - 1])
    cube([TeeWidth(receiver), GripWidth()+0.004, TeeCenter(receiver)+1-TeeRimRadius(receiver)]);

    Frame(receiver);

    TeeHousingFrontPin(length=3) {
      TeeHousingPinFlat(offset=1, length=1);
    }

    Breech(receiver, breechBushing);

    // Tee
    ReferenceTeeCutter();
  }
}


module back_tee_housing(receiver=Spec_TeeThreeQuarterInch(),
                        stock=Spec_PipeThreeQuarterInch(),
                        spin=Spec_RodFiveSixteenthInch(),
                        rod=Spec_RodFiveSixteenthInch(),
                        support=true, gripExtension=0.85) {
  boltLength = 2.5; //TeeRimDiameter(receiver);
  block_length = TeeRimWidth(receiver)
               +WallFrameBack();

  render(convexity=4)
  difference() {
    union() {
      hull() {

        // Rails
        color("Red")
        translate([(-TeeWidth(receiver)/2) + TeeRimWidth(receiver),0,0])
        rotate([0,-90,0])
        linear_extrude(height=block_length)
        hull() {
          ForendRail(railClearance=RodClearanceSnug());

          circle(r=TeeRimDiameter(receiver)/2 + WallTee());
        }

        TeeHousingRearPin(receiver, length=boltLength, extraRadius=WallTriggerGuardRod(), $fn=30);
      }
    }

    TeeHousingRearPin(receiver, length=3) {
      TeeHousingPinFlat(offset=1);
    }

    // Cutout
    translate([-(TeeWidth(receiver)/2) -(WallTriggerGuardRod()*2) -RodDiameter(rod) -0.1,
               -(GripWidth()/2) -0.002,
               -TeeCenter(receiver) - 1])
    cube([TeeWidth(receiver), GripWidth()+0.004, TeeCenter(receiver)+1]);

    Stock(receiver, stock);

    ReferenceTeeCutter();

    translate([-0.001,0,0])
    Frame();

  }
}


module tee_housing_plater(receiver=Spec_TeeThreeQuarterInch(), debug=false) {
  translate([0,3,0])
  front_tee_housing(debug=debug);

  translate([0,-3,(TeeWidth(receiver)/2)+(TeeRimWidth(receiver)*2)])
  rotate([0,-90,0])
  back_tee_housing(debug=debug);
}


*!scale([25.4, 25.4, 25.4])
tee_housing_plater();

module Reference_TeeHousing(receiver=Spec_TeeThreeQuarterInch(),
                            breechBushing=Spec_BushingThreeQuarterInch(),
                            stock=Spec_PipeThreeQuarterInch(),debug=true) {

  color("Purple")
  front_tee_housing(receiver, debug=false);

  color("CornflowerBlue")
  back_tee_housing(debug=debug);

}

scale([25.4, 25.4, 25.4]) {

  color("Purple", 0.5)
  Reference_TeeHousing();

  color("Green", 0.2);
  %Reference_TriggerGuard(debug=true);

  *%Frame();

  *%Reference();
}
