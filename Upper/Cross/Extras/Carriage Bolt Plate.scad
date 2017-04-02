use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;

use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Reference.scad>;

use <Frame.scad>;

module CarriageBoltPlate(height=0.25, rodClearance=undef) {
  render()
  linear_extrude(height=height)
  difference() {
    Quadrail2d(clearFloor=true);

    FrameIterator()
    rotate(45)
    square(RodDiameter(FrameRod(), rodClearance), center=true);

    Pipe2d(pipe=StockPipe(), clearance=PipeClearanceLoose());
  }
}

scale(25.4)
CarriageBoltPlate();
