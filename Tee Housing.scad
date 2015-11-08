include <Components.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Forend Rail.scad>;
use <Grip.scad>;
use <Frame.scad>;
use <Trigger Guard.scad>;
use <Reference.scad>;

module front_tee_housing(receiver=Spec_TeeThreeQuarterInch(),
                         barrelPipe=Spec_PipeThreeQuarterInch(),
                         forendRod=Spec_RodFiveSixteenthInch(),
                         forendPinRod=Spec_RodFiveSixteenthInch(),
                         breechBushing=BushingThreeQuarterInch,
                         wall=tee_overlap, $fn=40) {
  boltLength = 2; //TeeRimDiameter(receiver);
  length = BushingHeight(breechBushing) - BushingDepth(breechBushing)+TeeRimWidth(receiver);

  render(convexity=2)
  difference() {
    hull() {
      translate([(TeeWidth(receiver)/2) - TeeRimWidth(receiver),0,0])
      rotate([0,-90,180])
      linear_extrude(height=length) {
        ForendRail(railClearance=RodClearanceSnug());

        circle(r=TeeRimDiameter(receiver)/2 + wall);

        // Trigger Fork Body
        translate([TeeHousingBaseZ(receiver)-(TriggerGuardHole()/2),-TeeInnerRadius(receiver)])
        square([TeeCenter(receiver), TeeInnerDiameter(receiver)]);
      }

      TeeHousingFrontPin(receiver, length=boltLength, extraRadius=wall, $fn=30);
    }
    
   difference() {
      TriggerGuardBlock(receiver);

      TriggerGuardSplitter(receiver, clearance=0);
    }

    Frame(receiver);

    TeeHousingFrontPin(receiver, length=boltLength, flat=true);

    Breech(receiver, breechBushing);

    // Tee
    ReferenceTeeCutter(receiver);


    TriggerGuardFingerSlot(receiver, chamfer=true);
  }
}


module back_tee_housing(receiver=Spec_TeeThreeQuarterInch(),
                        stock=Spec_PipeThreeQuarterInch(),
                        spin=Spec_RodFiveSixteenthInch(),
                        rod=Spec_RodFiveSixteenthInch(),
                        support=true, gripExtension=0.85) {
  boltLength = 2.2; //TeeRimDiameter(receiver);
  block_length = TeeRimWidth(receiver)
               + OffsetFrameBack()
               + WallFrameBack();
  
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

    TeeHousingRearPin(receiver, length=boltLength, flat=true);

    // Cutout
    translate([-(TeeWidth(receiver)/2) -(WallTriggerGuardRod()*2) -RodDiameter(rod) -0.1,
               -(GripWidth()/2) -0.002,
               -TeeCenter(receiver) - 0.1])
    cube([TeeWidth(receiver), GripWidth()+0.004, TeeCenter(receiver)]);

    Stock(receiver, stock);

    ReferenceTeeCutter(receiver);

    Frame(receiver);

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

  color("Green", 0.5);
  %Reference_TriggerGuard(debug=true);

  %Frame();

  %Reference();
}
