use <../../../Meta/Clearance.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Shapes/Components/AR15/Trigger Pocket.scad>;

layerHeight = UnitsMetric(0.3063);

function TriggerPocketRamPlateHeight() = UnitsImperial(0.035)
                                       + (layerHeight*2);
function TriggerPocketModifier() = UnitsMetric(2);
function TriggerPocketRamBumperHeight() = UnitsMetric(2);

module TriggerPocketRamPlate(height=TriggerPocketRamPlateHeight()) {
  translate([0, 0, -AR15_TriggerPocketDepth()-ManifoldGap()])
  linear_extrude(height=height+ManifoldGap())
  AR15_TriggerPocket2d(clearance=-TriggerPocketModifier(), cutter=true);
}

module TriggerPocketRam(height=AR15_TriggerPocketDepth(),
                        clearance=UnitsMetric(0.4), cutter=false, alpha=1) {


  clear = Clearance(clearance, cutter);
  clear2 = clear*2;

  // Don't shrink the cutter
  shrinkage = (cutter ? 0 : -clearance);
                          
  centerOffset = AR15_TriggerPocketX()+AR15_TriggerSelectorLength()+UnitsMetric(18);

  color("OrangeRed", alpha)
  render()
  difference() {

    union() {
        
      // Trigger Pocket
      translate([0,0,-height])
      linear_extrude(height=height+TriggerPocketRamBumperHeight())
      AR15_TriggerPocket2d(clearance=shrinkage, cutter=true);

      // Rear stop bumper
      *for (X = [-shrinkage-UnitsMetric(2), AR15_TriggerPocketLength()-UnitsMetric(10)+shrinkage-clear2])
      translate([X+AR15_TriggerPocketX()+AR15_TriggerSelectorLength(),
                 -(AR15_TriggerPocketSelectorWidth()/2)-UnitsMetric(2)-clear,
                 0])
      cube([UnitsMetric(12)+clear2,
            AR15_TriggerPocketSelectorWidth()+UnitsMetric(4)+clear2,
            TriggerPocketRamBumperHeight()]);
    }

    if (cutter == false) {
      
      TriggerPocketRamPlate();
      
      // Water Hole
      translate([centerOffset,0,-height-ManifoldGap()])
      cylinder(r=UnitsMetric(10.85)/2,
               h=height+TriggerPocketRamBumperHeight()+ManifoldGap(2),
               $fn=12);

      // Central water channel, also where wire is soldered on
      translate([AR15_TriggerPocketX()+AR15_TriggerSelectorLength()-ManifoldGap(),-UnitsMetric(3),-height-ManifoldGap()])
      cube([AR15_TriggerPocketLength(), UnitsMetric(6), UnitsMetric(5)]);
      
      // Cutouts to improve waterflow in corners
      for (XW = [[0,AR15_TriggerPocketHammerWidth()-(TriggerPocketModifier()*2)],
                [AR15_TriggerSelectorLength(),AR15_TriggerPocketWidth()],
                [AR15_TriggerSelectorLength()+AR15_TriggerPocketLength()-TriggerPocketModifier(),AR15_TriggerPocketWidth()],
                [AR15_TriggerPocketOAL()-TriggerPocketModifier(),AR15_TriggerPocketHammerWidth()-(TriggerPocketModifier()*2)]])
      translate([AR15_TriggerPocketX(),0,0])
      translate([XW[0]-ManifoldGap(),
                 (-XW[1]/2)-ManifoldGap(),
                 -height-ManifoldGap()])
      cube([TriggerPocketModifier()+ManifoldGap(2),
             (XW[1]+ManifoldGap(2)),
             TriggerPocketModifier()+ManifoldGap()]);
      
      // Front and rear waterflow clearance
      for (X = [0, AR15_TriggerPocketOAL()-TriggerPocketModifier()])
      translate([AR15_TriggerPocketX()+X-ManifoldGap(),
                 (-AR15_TriggerPocketWidth()/2)-ManifoldGap(),
                 -height-ManifoldGap()])
      cube([TriggerPocketModifier()+ManifoldGap(2),
             (AR15_TriggerPocketWidth()+ManifoldGap(2)),
             height+TriggerPocketRamBumperHeight()+ManifoldGap(2)]);
    }
  }
}


//!scale(25.4) rotate([180,0,0])
TriggerPocketRam(cutter=false);

//!scale(25.4) translate([0,0,AR15_TriggerPocketDepth()])
color("CornflowerBlue", 0.5)
TriggerPocketRamPlate();
