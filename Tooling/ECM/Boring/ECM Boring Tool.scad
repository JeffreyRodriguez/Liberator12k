use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Meta/Units.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Components/Pipe Cap.scad>;

PIPE_SPEC = Spec_TubingZeroPointSevenFive();

// Smoothbore 12ga stock (old test bits)
BARREL_OD = 1.125+0.025;
BARREL_ID = 0.813+0.01;

// Rifled 12ga stock
BARREL_OD = 1.125+0.025;
BARREL_ID = 0.75+0.008;

// .44 Spl stock
BARREL_OD = 0.751+0.02;
BARREL_ID = 0.375-0.003;

module ECM_Boring_Insert(length=1.2,
                             barrelInnerDiameter = BARREL_ID,
                             electrodeDiameter=0.09375+0.005,
                             wall=0.5,
                             fluteDepth=0.05, fluteWidth=0.1, fluteCount=2) {

  render()
  difference() {
    
    // Center the insert in the bore
    cylinder(r=barrelInnerDiameter/2,
             h=length, $fn=50);
    
    // Electrode Hole
    cylinder(r=electrodeDiameter/2,
             h=length, $fn=10);
    
    // Bottom Water Cutouts
    for (r = [1:fluteCount])
    rotate(360/fluteCount*r)
    translate([(barrelInnerDiameter/2)-fluteDepth,
               -fluteWidth/2,
               -ManifoldGap()])
    cube([barrelInnerDiameter,
          fluteWidth,
          length+ManifoldGap(2)]);
  }
}

module ECM_Boring_Cap(pipeSpec=PIPE_SPEC,
                      electrodeDiameter=(1/16)+0.005,
                      wall=0.125, base=0.5, length=1) {

  render()
  difference() {
    PipeCap(pipeSpec=pipeSpec,
            length=length,
            base=base,
            wall=wall);
    
    // Electrode Hole
    translate([0,0,-ManifoldGap()])
    cylinder(r=electrodeDiameter/2,
             h=length, $fn=10);
    
    // Watering hole
    translate([0,0,-ManifoldGap()])
    difference() {
      
      // Pipe ID Cutaway
      cylinder(r=PipeInnerRadius(pipeSpec),
                h=length+ManifoldGap(),
              $fn=Resolution(20,60));
    
      // Electrode support
      translate([0,0,-ManifoldGap()])
      cylinder(r=electrodeDiameter/2,
               h=length, $fn=10);
      
      translate([-PipeInnerRadius(pipeSpec), -0.1,0])
      cube([PipeInnerDiameter(pipeSpec), 0.2, length+ManifoldGap(2)]);
    }
    
  }

}

scale(25.4) {
  translate([0,0,1])
  ECM_Boring_Insert();

  color("DimGrey", 0.5)
  ECM_Boring_Cap();
}

// Plated insert
*!scale(25.4) ECM_Boring_Insert();

!scale(25.4) ECM_Boring_Cap();