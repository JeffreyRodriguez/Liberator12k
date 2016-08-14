use <../Components/Manifold.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Square Tube.scad>;
use <../Grip Tabs.scad>;
use <../Trigger Guard.scad>;

module SquareTubeHousingTop(squareTube=Spec_SquareTubeOneInch(),
                            tubeClearance=SquareTubeClearanceSnug()) {
  
  translate([0,-(SquareTubeOuter(squareTube)/2)])
  Tubing2D(spec=squareTube, hollow=false);
}

module PipeHousingTop(pipeSpec=Spec_PipeThreeQuarterInch(),
                      pipeClearance=PipeClearanceSnug()) {
  
  translate([PipeOuterRadius(pipeSpec),0])
  Pipe2d(pipe=pipeSpec, clearance=pipeClearance, $fn=40);
}

module TubeHousing(housingFront=0.25, housingRear=0.25, wall=0.25,
                   tabLength=1, tabWidth=1, tabHeight=0.5, hole=false) {

  render(convexity=4)
  union() {
    rotate([0,-90,180]) {
      translate([wall,0, -housingRear])
      linear_extrude(height=housingFront+tabLength+housingRear)
      difference() {
        hull() {
          minkowski() {
            children();
            
            circle(r=wall, $fn=24);
          }
          
          translate([-wall,-tabWidth/2])
          square([wall, tabWidth]);
        }
        
        children();
      }
    }
      
    translate([0,0,1.3825]) {
      GripTab(length=tabLength, height=tabHeight, tabWidth=tabWidth,
              extraTop=wall/2, hole=hole, clearance=0);
    }
  }
}

module TubeHousingFront() {
  translate([GripTabFrontMinX(),0,0])
  TubeHousing(housingFront=0.5, housingRear=0,
              tabLength=GripTabFrontLength(), tabWidth=1.25, tabHeight=0.5)
  PipeHousingTop();
}

module TubeHousingRear() {
  translate([GripTabRearMinX(),0,0])
  TubeHousing(housingFront=0, housingRear=0.5, hole=true,
              tabLength=GripTabRearLength(), tabHeight=0.75)
  PipeHousingTop();
}

color("Tan")
TubeHousingFront();

color("Tan")
TubeHousingRear();

translate([0,0,1.3825])
Grip(showLeft=true, showTrigger=true, debugTrigger=false);

*!scale(25.4)
rotate([0,90,0])
TubeHousingRear();

*!scale(25.4)
rotate([0,-90,0])
TubeHousingFront();
