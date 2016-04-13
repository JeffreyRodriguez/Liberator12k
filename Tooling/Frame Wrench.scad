use <../Frame.scad>;
use <../Reference.scad>;
use <../Vitamins/Pipe.scad>;


difference() {
  rotate([0,90,0])
  linear_extrude(height=FrameNutHeight())
  //hull()
  FrameRodSleeves(radiusExtra=0.1) {
    square([FrameNutHeight(), 1.25], center=true);
  }

  translate([-FrameNutHeight(),0,0])
  scale([3,1,1])
  FrameNuts();
}

translate([1,0,0])
difference() {
  rotate([0,90,0])
  linear_extrude(height=FrameNutHeight())
  hull()
  FrameRodSleeves(radiusExtra=0.1);

  rotate([0,90,0])
  #Pipe(StockPipe(), center=true);

  translate([-FrameNutHeight(),0,0])
  scale([3,1,1])
  FrameNuts();
}
