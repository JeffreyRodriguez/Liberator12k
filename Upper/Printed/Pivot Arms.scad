use <../../Meta/Animation.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Resolution.scad>;

use <../../Vitamins/Bearing.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;
use <../../Lower/Lower Plater.scad>;

use <../../Components/Firing Pin Retainer.scad>;

use <../../Components/Cylinder.scad>;
use <Pivoted Lower Middle.scad>;

//Spec_PipeThreeQuarterInchSch80()
//Spec_PipeOneInch()
//Spec_PipeOneInchSch80()
//Spec_Tubing1628x1125()

DEFAULT_STRIKER = Spec_RodFiveSixteenthInch();
DEFAULT_BARREL = Spec_RodFiveSixteenthInch();
BARREL_PIPE = Spec_FiveSixteenthInchBrakeLine();
RECEIVER_PIPE = Spec_FiveSixteenthInchBrakeLine();
DEFAULT_TEE = Spec_AnvilForgedSteel_TeeThreeQuarterInch();

function PivotArmWidth() = (GripWidth()/2) -0.125;
function PivotArmLugZ(offsetZ=0.15) = -LowerGuardHeight()
                                   + BearingOuterRadius(PivotBearing())
                                   + PivotWall()
                                   + offsetZ;

module PivotNutAndBolt(cutter=false) {
  color("Grey")
  translate([LowerPivotX(),LowerMaxY(),LowerPivotZ()])
  rotate([-90,0,0])
  NutAndBolt(bolt=LowerPivotBolt(), boltLength=LowerMaxWidth()+BoltNutHeight(LowerPivotBolt()), capOrientation=true, clearance=cutter);
}

module LowerPivotBearing(cutter=false) {
    translate([LowerPivotX(),LowerMaxY()+ManifoldGap(),LowerPivotZ()])
    rotate([90,0,0])
    Bearing(spec=PivotBearing(),
            solid=cutter,
            clearance = cutter ? BearingClearanceSnug() : undef);
}

module PivotArm(clearance=0.005, wall=PivotWall(), washerDiameter=0.63,
                height=LowerGuardHeight()-GripCeiling()) {
    
  // Pivot Arm
  color("Orange")
  render()
  difference() {
    hull() {
      
      // Bearing Housing
      translate([LowerPivotX(),0.25+ManifoldGap(),LowerPivotZ()])
      rotate([-90,0,0])
      cylinder(r=BearingOuterRadius(PivotBearing())+PivotWall(), h=PivotArmWidth(),
               $fn=Resolution(15,40));
      
      translate([LowerMaxX()+clearance, 0.25, -LowerGuardHeight()])
      cube([0.001, PivotArmWidth(), height]);
      
      // Take a 2D cross-section of the child lug
      // Extrude that cross-section to outline a wall around it
      difference() {
        PivotArmLugProjection(outline=wall)
        children();
        
        // Make Be sure and clear the lower front-face
        translate([0,-(GripWidth()/2)-0.125-ManifoldGap(), -LowerGuardHeight()])
        cube([LowerMaxX(), GripWidth()+0.25+ManifoldGap(2), LowerGuardHeight()]);
      }
    }
    
    // Inner race/washer clearance
    translate([LowerPivotX(), 0, LowerPivotZ()])
    rotate([90,0,0])
    cylinder(r=0.005+(washerDiameter/2), //BearingRaceRadius(PivotBearing()),
             h=GripWidth()*2,
             center=true, $fn=20);
    
    // Bearing
    LowerPivotBearing(cutter=true);
    
    PivotArmLugProjection(cutter=true)
    children();
  }
}

module PivotArms(sides=[0,1]) {
  for (m = sides)
  mirror([0,m,0])
  children();
}

module PivotArmLugProjection(outline=PivotWall(), cutter=false, clearance=0.005) {
    outline = cutter ? clearance : outline;
    width   = cutter ? PivotArmWidth() + ManifoldGap(2) : PivotArmWidth();
  
    translate([0,0.25 - (cutter ? ManifoldGap() : 0),0])
    rotate([-90,0,0])
    linear_extrude(width)
    offset(r=outline)
    projection(cut=true) {
      rotate([90,0,0])
      children();
    }
}


module PivotArmLug(angle=0, offsetX=-0.75/2, offsetZ=0.15,
                   length=0.75, height=0.25) {  
  translate([LowerPivotX(), -(GripWidth()/2)-0.125, -LowerGuardHeight()])
  rotate([0,angle,0])
  translate([offsetX, 0, BearingOuterRadius(PivotBearing())+PivotWall()+offsetZ])
  cube([length, GripWidth()+0.25, height]);
}

PivotArms()
PivotArm()
PivotArmLug();

LowerPivotBearing(cutter=false);
PivotNutAndBolt(cutter=false);
PivotArmLug();

LowerPivoted();