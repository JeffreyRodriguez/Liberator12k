use <../../Meta/Manifold.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Square Tube.scad>;
use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Lower.scad>;

//Spec_PipeThreeQuarterInchSch80()
//Spec_PipeOneInch()
//Spec_PipeOneInchSch80()
//Spec_Tubing1628x1125()
module PipeHousingTop(pipeSpec=Spec_Tubing1628x1125(), 
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
  }
}

module TubeHousingFront(extraFront=0.5) {
  union() {
    translate([ReceiverLugFrontMinX(),0,0])
    TubeHousing(housingFront=extraFront, housingRear=0,
                tabLength=ReceiverLugFrontLength(), tabWidth=1.5, tabHeight=0.5)
      PipeHousingTop();
    
    ReceiverLugFront(extraHeight=ManifoldGap(2));
  }
}

module TubeHousingRear(extraRear=0.5) {
  union() {
    translate([ReceiverLugRearMinX(),0,0])
    TubeHousing(housingFront=0, housingRear=extraRear, hole=true,
                tabLength=ReceiverLugRearLength(), tabHeight=0.75)
    PipeHousingTop();
    
    ReceiverLugRear();
  }
}

module TubeHousingSearJig(wall=0.25, tabWidth=1) {
  render()
  difference() {
    rotate([0,-90,180]) {
      translate([wall,0, ReceiverLugRearMaxX()])
      linear_extrude(height=ReceiverLugFrontMinX()+abs(ReceiverLugRearMaxX())-0.05) {
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
linear_extrude(height=ReceiverLugFrontMinX()+abs(ReceiverLugRearMaxX()))
*TubeHousing2d();

color("Tan")
TubeHousingRear();

Lower(showTrigger=true);

*!scale(25.4) {
  translate([0,0,ReceiverLugFrontMinX()-0.05])
  rotate([0,90,0])
  TubeHousingSearJig();
}

*!scale(25.4)
rotate([0,-90,0])
TubeHousingFront(extraFront=0);

*!scale(25.4)
rotate([0,90,0])
TubeHousingRear(extraRear=0);
