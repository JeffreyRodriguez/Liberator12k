use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Shapes/Components/T Lug.scad>;
use <../../../Shapes/Components/Printable Shaft Collar.scad>;

CATHODE_SCREW_SPEC = Spec_BoltM3();
ANODE_SCREW_SPEC = Spec_BoltM3();
PIPE_SPEC = Spec_TubingOnePointOneTwoFive();

BARREL_OD = 1.125+0.025;

BARREL_ID = 0.813+0.015;
BARREL_ID = 0.75+0.008;

// 2.5" PVC water jacket
JACKET_ID = 2.5;
JACKET_OD = 2.88+0.02;

module ECM_FlutingWireIterator(pipeSpec=PIPE_SPEC, wireOffset=0.125, flutes=4) {
  for (i = [0:flutes-1])
  rotate(360/flutes*i)
  translate([PipeOuterRadius(pipeSpec)+wireOffset,0,0])
  children();
}

module ECM_FlutingWire2d(pipeSpec=PIPE_SPEC,
                  wireDiameter=0.1,
                    wireOffset=0.125,
                        flutes=2) {

    // Wire Cutouts
    ECM_FlutingWireIterator()
    circle(r=wireDiameter/2, $fn=10);
}

module ECM_Fluting_Guide(outsideDiameter=2.45,
                         height=0.5, wall=0.25,
                         flutes=2) {

  render()
  difference() {

    union() {

      // Collar around the barrel
      cylinder(r=outsideDiameter/2, h=height, $fn=50);

      // Ramp for watershed
      translate([0,0,height-ManifoldGap()])
      cylinder(r1=outsideDiameter/2,
               r2=0.2+PipeInnerRadius(pipe=PIPE_SPEC, clearance=PipeClearanceLoose()),
                h=height, $fn=50);
    }

    // Barrel "Foot" Cutout
    translate([0,0,wall])
    Pipe(pipe=PIPE_SPEC, length=height*2, clearance=PipeClearanceLoose());

    // Barrel Hole Cutout
    translate([0,0,-ManifoldGap()])
    cylinder(r=PipeInnerRadius(pipe=PIPE_SPEC, clearance=PipeClearanceSnug()),
             h=wall+ManifoldGap(2), $fn=40);

    linear_extrude(height=height*3) {
      ECM_FlutingWire2d();

      // Waterway
      rotate(22.5)
      for (doubler = [0, 45])
      rotate(doubler)
      for (r = [0,90,-90, 180])
      rotate(r)
      translate([outsideDiameter/2,0,0])
      circle(r=0.25, $fn=20);
    }

    // Cathode Terminators
    rotate(45)
    ECM_FlutingWireIterator()
    mirror([0,0,1])
    translate([0.25,0,-Millimeters(24)])
    Bolt(bolt=CATHODE_SCREW_SPEC, boltLength=Millimeters(25), clearance=false);

  }
}

// Plated Fluting Guide
*!ScaleToMillimeters() ECM_Fluting_Guide();
