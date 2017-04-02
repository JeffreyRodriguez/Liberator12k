use <../Meta/Units.scad>;

use <../Vitamins/Pipe.scad>;
use <../Upper/Cross/Reference.scad>;


module ExtractorRing(barrel=BarrelPipe(),length=UnitsImperial(0.25), wall=UnitsImperial(0.125),
                     extractorHeight=UnitsImperial(1/32+0.01),
                     extractorWidth=UnitsImperial(0.25+0.02)) {
  render()
  linear_extrude(length)
  difference() {
    Pipe2d(pipe=barrel, extraRadius=wall);
    
    Pipe2d(pipe=barrel);
    
    translate([-extractorWidth/2,0])
    square([extractorWidth, PipeOuterRadius(barrel)+extractorHeight]);
  }
}

scale(25.4)
ExtractorRing();