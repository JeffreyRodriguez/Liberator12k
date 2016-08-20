use <../Components/Manifold.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Square Tube.scad>;
use <../Vitamins/Nuts And Bolts.scad>;
use <../Grip Tabs.scad>;
use <../Trigger Guard.scad>;
use <../Trigger.scad>;

module DummyHousingTop(frontWall=0.25, backWall=0.25, height=0.22) {
  render(convexity=4)
  difference() {
    translate([GripTabRearMaxX()-backWall,-GripWidth()/2,0])
    cube([GripTabFrontMinX()+abs(GripTabRearMaxX())+frontWall+backWall,GripWidth(),height]);
      
    translate([0,0,1.3825]) {
      GripTabFront(clearance=0.005, extraTop=height*2);
      GripTabRear(clearance=0.005, extraTop=height*2);
      SearCutter();
    }
  }
}

module DummyHousingFront() {
  render(convexity=4)
  difference() {
    
    translate([0,0,1.3825])
    GripTabFront(extraTop=0.6);
    
    translate([GripTabFrontMinX()-ManifoldGap(),0,0.3])
    rotate([0,90,0])
    NutAndBolt(bolt=Spec_BoltM3(), length=GripTabFrontLength()+ManifoldGap(2), clearance=true);
  }
}

module DummyHousingRear() {
  render(convexity=4)
  difference() {
    
    translate([0,0,1.3825])
    GripTabRear(extraTop=0.6);
    
    #translate([GripTabRearMaxX()+ManifoldGap(),0,0.3])
    rotate([0,-90,0])
    NutAndBolt(bolt=Spec_BoltM3(), length=GripTabRearLength()+ManifoldGap(2), clearance=true);
  }
}

translate([0,0,1.3825])
Grip(showLeft=false, showTrigger=true, debugTrigger=false);

color("OliveDrab", 0.5)
*DummyHousingTop();

color("Tan")
DummyHousingFront();

color("Tan")
DummyHousingRear();

// Multi-plater
*!scale(25.4) {
  
  //!scale(25.4)
  rotate([0,90,0])
  translate([-GripTabFrontMaxX(),-0.75,0])
  DummyHousingFront();

  //!scale(25.4)
  rotate([0,-90,0])
  translate([-GripTabRearMinX(),0.5,0])
  DummyHousingRear();

  //!scale(25.4)
  translate([1.5,0,0])
  rotate(90)
  *DummyHousingTop();
}