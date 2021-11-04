use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Meta/Units.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Shapes/Components/Pipe/Cap.scad>;
use <../../../Shapes/Semicircle.scad>;

PIPE_SPEC = Spec_TubingZeroPointSevenFive();

// Smoothbore 12ga stock (old test bits)
BARREL_ID = 0.813+0.01;

// Rifled 12ga stock
BARREL_ID = 0.75+0.008;

// .44 Spl stock
BARREL_ID = 0.375;
TARGET_ID = 0.45;

module ECM_Reamer(majorDiameter=TARGET_ID, length=1.5,
                  electrodeDiameter=0.272, electrodeHeight=0.5,
                  electrodeOffset=0.1,
                  fluteAngle=90,
                  $fn=24) {

  length = length;
  electrodeRadius = electrodeDiameter/2;
  majorRadius=majorDiameter/2;
  minorDiameter=electrodeDiameter+(majorRadius-electrodeRadius);
  taperLength = majorDiameter/3;

  render()
  difference() {

    // Starting ID guide
    cylinder(r=majorDiameter/2, h=length);

    // Electrode ring, tapered for printing
    translate([0,0,-ManifoldGap()])
    difference() {

      // Cutter
      cylinder(r=majorDiameter-ManifoldGap(),
               h=majorDiameter/3);

      // Taper the cutter
      translate([0,0,-ManifoldGap()])
      cylinder(r1=(minorDiameter/2)+ManifoldGap(),
               r2=(majorDiameter/2)+ManifoldGap(),
                h=taperLength+ManifoldGap(2));
    }

    // Electrode Hole
    translate([0,0,electrodeOffset-ManifoldGap()])
    cylinder(r=electrodeDiameter/2,h=length+ManifoldGap(2));

    // Top Flute
    translate([0,0,-ManifoldGap()])
    linear_extrude(height=length+ManifoldGap(2))
    semidonut(major=majorDiameter*2,
              minor=minorDiameter,
              angle=fluteAngle, center=true);


    // Electrode Side
    translate([0,0,-ManifoldGap()])
    linear_extrude(height=electrodeHeight+electrodeOffset)
    semicircle(od=majorDiameter*2,
               angle=fluteAngle, center=true);
  }
}

// Plated insert
ScaleToMillimeters()
ECM_Reamer();
