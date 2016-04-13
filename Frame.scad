use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Reference.scad>;

function FrameNutHeight() = 0.28;
function FrameRodAngles() = [FrameRodMatchedAngle(), -FrameRodMatchedAngle()];
function FrameRodOffset()
           = TeeRimRadius(ReceiverTee())
           + RodRadius(FrameRod())
           + OffsetFrameRod()
           ;

module Frame(clearance=RodClearanceLoose(),
             rodLength=12,
             rodFnAngle=90) {

  render(convexity=4)
  translate([-(TeeWidth(ReceiverTee())/2)-OffsetFrameBack(),0,0])
  rotate([0,90,0])
  linear_extrude(height=rodLength)
  FrameRods(clearance=clearance);
}


module FrameRods(clearance=RodClearanceLoose(),
                 squared=false,
                 rodFnAngle=90) {

  for (angle = FrameRodAngles())
  rotate([0,0,angle])
  translate([-FrameRodOffset(ReceiverTee()), 0])
  rotate([0,0,-angle+rodFnAngle])
  Rod2d(rod=FrameRod(), clearance=clearance);
}

module FrameNuts(nutHeight=FrameNutHeight(), nutRadius=0.3) {
  for (angle = FrameRodAngles())
  rotate([angle,0,0])
  translate([0, 0,FrameRodOffset()])
  rotate([0,90,0]) {
    cylinder(r=nutRadius, h=nutHeight, $fn=6);
    children();
  }
}

module FrameHoleSupport(height=FrameNutHeight()+0.001, extraRadius=0.01) {
  for (angle = FrameRodAngles())
  rotate([angle,0,0])
  translate([0, 0,FrameRodOffset()])
  rotate([0,-90,0])
  cylinder(r=RodRadius(FrameRod(), clearance=RodClearanceLoose())+extraRadius, h=height, $fn=RodFn(FrameRod()));
}


module FrameRodSleeves(radiusExtra=0, rodFnAngle=90) {

  for (angle = FrameRodAngles())
  rotate([0,0,angle])
  translate([-FrameRodOffset(ReceiverTee()), 0])
  rotate([0,0,-angle+rodFnAngle]) {
    circle(r=RodRadius(FrameRod())+WallFrameRod()+radiusExtra,
           $fn=RodFn(FrameRod())*Resolution(1,3));
    
    children();
  }
}


scale([25.4, 25.4, 25.4]) {
  %Reference();
  *Frame();
  FrameNuts();
  #FrameHoleSupport();
}
