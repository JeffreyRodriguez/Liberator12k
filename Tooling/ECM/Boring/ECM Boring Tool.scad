use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Meta/Units.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Components/Pipe Cap.scad>;
use <../../../Components/Semicircle.scad>;

PIPE_SPEC = Spec_TubingZeroPointSevenFive();

// Smoothbore 12ga stock (old test bits)
BARREL_ID = 0.813+0.01;

// Rifled 12ga stock
BARREL_ID = 0.75+0.008;

// .44 Spl stock
BARREL_ID = 0.375;
TARGET_ID = 0.430;

module ECM_Boring_Insert(startDiameter=BARREL_ID, startHeight=4.0,
                         targetDiameter=TARGET_ID, targetHeight=0.25,
                         electrodeDiameter=0.04, electrodeHeight=0.06,
                         startFluteAngle=45, targetFluteAngle=90,
                         $fn=16) {
  
  length = startHeight+targetHeight;

  render()
  difference() {
    union() {
    
      // Target ID guide
      cylinder(r=targetDiameter/2, h=targetHeight);
      
      // Starting ID guide
      translate([0,0,targetHeight-ManifoldGap()])
      cylinder(r=startDiameter/2, h=startHeight);
    }
    
    // Electrode ring, tapered for printing
    translate([0,0,targetHeight-ManifoldGap()])
    difference() {
      
      // Cutter
      cylinder(r=(targetDiameter/2)-ManifoldGap(),
               h=electrodeHeight);

      // Taper the cutter
      translate([0,0,-ManifoldGap()])
      cylinder(r1=(startDiameter/2)-electrodeDiameter+ManifoldGap(),
               r2=(startDiameter/2)+ManifoldGap(),
                h=electrodeHeight+ManifoldGap(2));
    }

    // Electrode Hole
    translate([0,0,targetHeight])
    cylinder(r=0.04,h=length, $fn=$fn/2);

    // Hex Bit Hole
    translate([0,0,-ManifoldGap()])
    cylinder(r=0.08,h=targetHeight/2, $fn=6);
    
    // Top Water Cutout
    rotate(180)
    translate([0,0,targetHeight-ManifoldGap()])
    linear_extrude(height=startHeight+ManifoldGap(2))
    semicircle(od=targetDiameter*2, angle=startFluteAngle, center=true);
    
    // Bottom Water Cutout
    translate([0,0,-ManifoldGap()])
    linear_extrude(height=targetHeight+ManifoldGap(2))
    semidonut(minor=startDiameter-(electrodeDiameter*2),
              major=targetDiameter*2,
              angle=targetFluteAngle,
              center=true, $fn=16);
  }
}

// Plated insert
scale(25.4)
ECM_Boring_Insert();