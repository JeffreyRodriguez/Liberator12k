use <../Components/Manifold.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Square Tube.scad>;
use <../Grip Tabs.scad>;
use <../Trigger Guard.scad>;
use <../Trigger.scad>;

module SquareTubeHousingTop(squareTube=Spec_SquareTubeOneInch(),
                            tubeClearance=SquareTubeClearanceSnug()) {
  
  translate([0,-(SquareTubeOuter(squareTube)/2)])
  Tubing2D(spec=squareTube, hollow=false);
}

//Spec_PipeThreeQuarterInchSch80()
//Spec_PipeOneInch()
//Spec_PipeOneInchSch80()
module PipeHousingTop(pipeSpec=Spec_PipeOneInchSch80(), 
                      pipeClearance=PipeClearanceSnug()) {
  
  translate([PipeOuterRadius(pipeSpec),0])
  Pipe2d(pipe=pipeSpec, clearance=pipeClearance, $fn=40);
}

module TubeHousing2d(wall=0.25, tabWidthTop=1) {
  difference() {
    hull() {
      minkowski() {
        children();
        
        circle(r=wall, $fn=24);
      }
      
      translate([-wall,-tabWidthTop/2])
      square([wall, tabWidthTop]);
    }
    
    children();
  }
}


module TubeHousing(housingFront=0.25, housingRear=0.25, wall=0.25,
                   tabLength=1, tabWidth=1, tabWidthTop=1.25, tabHeight=0.5, hole=false) {

  render(convexity=4)
  union() {
    rotate([0,-90,180]) {
      translate([wall,0, -housingRear])
      linear_extrude(height=housingFront+tabLength+housingRear)
      TubeHousing2d(wall, tabWidthTop)
      children();
    }
      
    translate([0,0,1.3825]) {
      GripTab(length=tabLength, height=tabHeight, tabWidth=tabWidth,
              extraTop=wall/2, hole=hole, clearance=0);
    }
  }
}

module TubeHousingFront(extraFront=0.5) {
  translate([GripTabFrontMinX(),0,0])
  TubeHousing(housingFront=extraFront, housingRear=0,
              tabLength=GripTabFrontLength(), tabWidth=1.5, tabHeight=0.5)
  PipeHousingTop();
}

module TubeHousingRear(extraRear=0.5) {
  translate([GripTabRearMinX(),0,0])
  TubeHousing(housingFront=0, housingRear=extraRear, hole=true,
              tabLength=GripTabRearLength(), tabHeight=0.75)
  PipeHousingTop();
}

module TubeHousingSearJig(wall=0.25, tabWidth=1) {
  render()
  difference() {
    rotate([0,-90,180]) {
      translate([wall,0, GripTabRearMaxX()])
      linear_extrude(height=GripTabFrontMinX()+abs(GripTabRearMaxX())-0.05) {
        TubeHousing2d(wall, tabWidth) {
          PipeHousingTop();
        }
        
        difference() {
          hull() {
            translate([PipeOuterDiameter(Spec_PipeOneInch())+wall,-1.5])
            square([0.1,3]);
            
            translate([0,-GripWidth()/2])
            mirror([1,0])
            square([0.1,GripWidth()]);
          }
          
          PipeHousingTop();
        }
      }
    }
    
    SearCutter();
  }
  
}

*color("Black", 0.25) {
  TubeHousingSearJig();
}

color("Tan")
TubeHousingFront();

// Middle... work-in-progresss
color("Olive")
linear_extrude(height=GripTabFrontMinX()+abs(GripTabRearMaxX()))
*TubeHousing2d();

color("Tan")
TubeHousingRear();

translate([0,0,1.3825])
Grip(showLeft=true, showTrigger=true, debugTrigger=false);

*!scale(25.4) {
  translate([0,0,GripTabFrontMinX()-0.05])
  rotate([0,90,0])
  TubeHousingSearJig();
}

*!scale(25.4)
rotate([0,-90,0])
TubeHousingFront(extraFront=0);

*!scale(25.4)
rotate([0,90,0])
TubeHousingRear(extraRear=0);
