use <Frame.scad>;
use <../../Reference.scad>;
use <../../Vitamins/Pipe.scad>;

module FrameRetainer() {
  render()
  translate([-ReceiverCenter()-WallFrameBack()-FrameNutHeight(),0,0])
  difference() {
    rotate([0,90,0])
    linear_extrude(height=FrameNutHeight())
    hull()
    FrameRodSleeves(radiusExtra=0.1);

    rotate([0,90,0])
    Pipe(StockPipe(), center=true);

    translate([-FrameNutHeight(),0,0])
    scale([3,1,1])
    FrameNuts();
  }
}

FrameRetainer();
%Reference();

!scale(25.4)
translate([0,0,-ReceiverCenter()-WallFrameBack()])
rotate([0,90,0])
FrameRetainer();
