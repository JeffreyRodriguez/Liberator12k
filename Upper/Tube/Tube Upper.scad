use <../../Meta/Manifold.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Lower.scad>;

module TubeHousingBase(pipeSpec=Spec_Tubing1628x1125(), 
                      pipeClearance=PipeClearanceSnug()) {
  
  translate([PipeOuterRadius(pipeSpec),0])
  Pipe2d(pipe=pipeSpec, clearance=pipeClearance, $fn=40);
}

module TubeHousing2d(wall=0.25, tabWidthTop=1, flatBottom=true) {
  difference() {
    hull() {
      minkowski() {
        children();
        
        circle(r=wall, $fn=24);
      }
      
      if (flatBottom)
      translate([-wall,-tabWidthTop/2])
      square([wall, tabWidthTop]);
    }
    
    children();
  }
}


module TubeHousing(housingFront=0.25, housingRear=0.25, wall=0.25,
                   tabLength=1, tabWidth=1, tabWidthTop=1.25, tabHeight=0.5,
                   hole=false, flatBottom=true) {

  render(convexity=4)
  union() {
    rotate([0,-90,180]) {
      translate([wall,0, -housingRear])
      linear_extrude(height=housingFront+tabLength+housingRear)
      TubeHousing2d(wall, tabWidthTop, flatBottom)
      children();
    }
  }
}

module TubeHousingFront(extraFront=0.5) {
  union() {
    translate([ReceiverLugFrontMinX(),0,0])
    TubeHousing(housingFront=extraFront, housingRear=0,
                tabLength=ReceiverLugFrontLength(), tabWidth=1.5, tabHeight=0.5)
      TubeHousingBase();
    
    ReceiverLugFront(extraHeight=ManifoldGap(2));
  }
}

module TubeHousingRear(extraRear=0.5, flatBottom=true) {
  union() {
    translate([ReceiverLugRearMinX(),0,0])
    TubeHousing(housingFront=0, housingRear=extraRear, hole=true,
                tabLength=ReceiverLugRearLength(), tabHeight=0.75, flatBottom=flatBottom)
    TubeHousingBase();
    
    ReceiverLugRear();
  }
}

color("Tan")
TubeHousingFront();

color("Tan")
TubeHousingRear();

Lower(showTrigger=true);

*!scale(25.4)
rotate([0,-90,0])
TubeHousingFront(extraFront=0);

*!scale(25.4)
rotate([0,90,0])
TubeHousingRear(extraRear=0);
