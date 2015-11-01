include <Components.scad>;
use <Vitamins/Grip.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Forend Rail.scad>;
use <Trigger.scad>;
use <Reference.scad>;

function TeeHousingBaseZ(receiver) = -TeeCenter(receiver)-TeeRimWidth(receiver);

function TeeHousingBottomExtension() = 0.27;
function TeeHousingFrontExtension(bushing=breechBushing) = BushingHeight(bushing) - BushingDepth(bushing);
function TeeHousingFrontX(receiver) = (TeeWidth(receiver)/2)+TeeHousingFrontExtension();

function TeeHousingFrontPinX(receiver, bushing=breechBushing) = (TeeWidth(receiver)/2);
function TeeHousingFrontPinZ(receiver) = -TeeCenter(receiver)
                                         -(TeeRimWidth(receiver)/2);
module TeeHousingFrontPin(receiver, pin=Spec_RodFiveSixteenthInch(), clearance=RodClearanceLoose()) {
    translate([TeeHousingFrontPinX(receiver), 0, TeeHousingFrontPinZ(receiver)])
    rotate([90,0,0])
    Rod(rod=pin, clearance=clearance, length=TeeRimDiameter(receiver)*2, center=true);
}

module TeeHousingRearPin(receiver, pin=Spec_RodFiveSixteenthInch(), clearance=RodClearanceLoose()) {
    translate([-(TeeWidth(receiver)/2) -0.5, 0, TeeHousingFrontPinZ(receiver)])
    rotate([90,0,0])
    Rod(rod=pin, clearance=clearance, length=TeeRimDiameter(receiver)*2, center=true);
}

module ReferenceTeeCutter(receiver) {
  translate([0,0,-TeeCenter(receiver)])
  Tee(receiver);
}

function TriggerGuardHeight() = 1.31;
function TriggerGuardHole() = 1.1;
function TriggerGuardRearLength() = 0.175;

module TriggerGuardFingerSlot(receiver, triggerGuardHole=TriggerGuardHole(),
                              triggerGuardRearLength = TriggerGuardRearLength(),
                              frontExtension=TeeHousingFrontExtension(),
                              frontOffset=-0.2,
                              clearance=0.002, $fn=40) {

    offsets = [[(TeeWidth(receiver)/2)-frontExtension+frontOffset,-TeeRimWidth(receiver)*4.6],[-0.35,-TeeRimWidth(receiver)*3.95]];

    render()
    translate([0,0,-TeeCenter(receiver)-(triggerGuardHole/2) - TeeRimWidth(receiver)]) {
      hull()
      for (i = offsets)
      translate([i[0],0,0])
      rotate([90,0,0])
      cylinder(r=(triggerGuardHole/2)+clearance, h=(triggerGuardHole*3)+TeeInnerDiameter(receiver), $fn=$fn, center=true);

      // Chamfer
      for (side = [1, 0])
      mirror([0,side,0])
      hull()
      for (i = offsets)
      translate([i[0],i[1],0])
      rotate([90,0,0])
      cylinder(r1=0, r2=triggerGuardHole*2, h=triggerGuardHole*4, $fn=$fn, center=true);
    }
}


module front_tee_housing(receiver=Spec_TeeThreeQuarterInch(),
                         barrelPipe=Spec_PipeThreeQuarterInch(),
                         forendRod=Spec_RodFiveSixteenthInch(),
                         forendPinRod=Spec_RodFiveSixteenthInch(),
                         breechBushing=BushingThreeQuarterInch,
                         wall=tee_overlap, $fn=40) {

  length = BushingHeight(breechBushing) - BushingDepth(breechBushing)+TeeRimWidth(receiver);

  render(convexity=2)
  difference() {
    translate([(TeeWidth(receiver)/2) - TeeRimWidth(receiver),0,0])
    rotate([0,-90,180])
    linear_extrude(height=length)
    difference() {
      hull() {
        // Tee Rim
        circle(r=TeeRimRadius(receiver) + wall);

        // Trigger Fork Body
        translate([TeeHousingBaseZ(receiver)-TeeHousingBottomExtension(),-TeeInnerRadius(receiver)])
        square([TeeCenter(receiver), TeeInnerDiameter(receiver)]);

        // Rails
        ForendRail(receiver, barrelPipe, railClearance=RodClearanceLoose);
      }

      // Trigger Fork Cutouts
      for (i=[0,1])
      translate([TeeHousingBaseZ(receiver)-0.005,0])
      mirror([0,i])
      translate([-TeeHousingBottomExtension(),0.125])
      square([TeeCenter(receiver) - TeeRimRadius(receiver)+TeeHousingBottomExtension()+0.005,
              TeeInnerRadius(receiver)-0.115]);

      ForendRods(clearance=RodClearanceSnug());
    }


    // Bushing
    translate([(TeeWidth(receiver)/2) - TeeRimWidth(receiver),0,0])
    rotate([0,-90,180])
    translate([0,0,BushingHeight(breechBushing) - BushingDepth(breechBushing)+TeeRimWidth(receiver)])
    mirror([0,0,1])
    Bushing(breechBushing);

    // Tee
    ReferenceTeeCutter(receiver);

    // Pin hole
    TeeHousingFrontPin(receiver, forendPinRod);

    TriggerGuardFingerSlot(receiver);
  }
}


module back_tee_housing(receiver=Spec_TeeThreeQuarterInch(),
                        stock=Spec_PipeThreeQuarterInch(),
                        rod=Spec_RodFiveSixteenthInch(),
                        wall=tee_overlap,
                        support=true, grip_width=0.9, gripExtension=0.85) {

  //block_length = TeeRimWidth(receiver)*3;
  block_length = TeeRimWidth(receiver) + 1.3;

  difference() {
    union() {

      // Body
      render(convexity=4)
      translate([(-TeeWidth(receiver)/2) + TeeRimWidth(receiver),0,0])
      rotate([0,-90,0])
      intersection() {
        linear_extrude(height=block_length)
        difference() {

          // Rails
          color("Red")
          hull() {
            ForendRail(railClearance=RodClearanceSnug());
            circle(r=TeeRimDiameter(receiver)/2 + wall);

            rotate([0,0,180])
            translate([TeeCenter(receiver)-block_length+0.24,-(grip_width/2),0])
            *square([block_length,grip_width]);
          }

          // Stock Pipe
          Pipe2d(pipe=stock, clearance=PipeClearanceLoose);

          // Rails
          ForendRods(receiver, rod, wall=wall, railClearance=RodClearanceLoose);
        }

        // Back Taper
        translate([0,0,-0.8])
        cylinder(r1=2.3, h=3.5, r2=0);
      }

      // AR15 Grip
      *color("Blue",0.5)
      Reference_Grip_Position(receiver)
      intersection() {
        GripTab(extension=gripExtension, extraFront=0, extraTop=0.9, debug=debug);

        // Taper the grip front
        translate([0.15, 0, -4])
        rotate([0,10,0])
        rotate([0,0,90+45])
        cube([3,3,4]);
      }
    }

    *TeeHousingGripTab(receiver, clearance=0.005);

    // AR15 Grip Bolt
    color("Red")
    Reference_Grip_Position(receiver)
    Grip_Bolt(extension=gripExtension, nut_height=1, debug=false);

    // Bottom Tee Rim
    translate([0,0,-TeeCenter(receiver)])
    cylinder(r=TeeRimDiameter(receiver)/2, h=TeeCenter(receiver));

    // Back Tee Rim
    translate([-TeeWidth(receiver)/2,0,0])
    rotate([0,90,0])
    translate([0,0,-0.1])
    cylinder(r=TeeRimDiameter(receiver)/2, h=TeeWidth(receiver));

    TeeHousingRearPin(receiver);
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

module TeeHousingGripTab(receiver, clearance=0.005,
                          triggerGuardHeight = TriggerGuardHeight(),
                          triggerGuardRearLength = TriggerGuardRearLength(),
                          tab_width=0.345) {
      translate([-(TeeWidth(receiver)/2) +TeeRimWidth(receiver) -TriggerGuardRearLength() -clearance -0.3,
                 -(tab_width/2)-clearance,TeeHousingBaseZ(receiver)-TriggerGuardHeight()-clearance+0.31])
      cube([0.5,tab_width+(clearance*2),0.5+(clearance*2)]);
}

module Reference_TeeHousing(receiver=Spec_TeeThreeQuarterInch(),
                            breechBushing=Spec_BushingThreeQuarterInch(),
                            stock=Spec_PipeThreeQuarterInch(),debug=true) {

  color("Purple")
  front_tee_housing(receiver, debug=false);

  color("CornflowerBlue")
  back_tee_housing(debug=debug);

}

scale([25.4, 25.4, 25.4]) {
  *%Reference();
  Reference_TeeHousing();
}
