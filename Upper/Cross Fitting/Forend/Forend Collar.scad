//$t=0.8;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Double Shaft Collar.scad>;
use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Lower.scad>;
use <../../Lower/Trigger.scad>;
use <../../Reference.scad>;
use <Frame.scad>;
use <Cross Upper.scad>;

module ForendCollar(barrelPipe=BarrelPipe(), length=1,
                    wall=WallTee(), $fn=40) {
  color("Purple")
  render(convexity=4)
  difference() {
    translate([BreechFrontX(),0,0])
    rotate([0,90,0])
    linear_extrude(height=length)
    Quadrail2d();
    
    Frame();
    
    Barrel();
    
    translate([BreechFrontX()-ManifoldGap(),0,0])
    rotate([45,0,0])
    DoubleShaftCollar(long=false);
  }
}

translate([0,0,-ReceiverCenter()]) {
  Trigger();
  Lower();
}


UpperReceiverFront();
UpperReceiverBack();

translate([3,0,0])
ForendCollar();

%Frame();

Reference();


// Plated Forend
*!scale(25.4)
rotate([0,90,0])
translate([-BreechFrontX()-1,0,0])
ForendCollar();