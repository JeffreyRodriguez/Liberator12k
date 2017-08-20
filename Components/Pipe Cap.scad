use <../Meta/Manifold.scad>;
use <../Finishing/Chamfer.scad>;

module PipeCap(pipeDiameter=1,
                   base=0.25,
                   wall=0.125,
              extension=0.25) {

  pipeRadius = pipeDiameter/2;
  bodyRadius = pipeRadius+wall;

  render()
  difference() {

    // Sleeve around the pipe
    cylinder(r=bodyRadius,
             h=base+extension,
             $fn=$fn*2);

    // Pipe Cutout
    translate([0,0,base])
    cylinder(r=pipeRadius, h=extension+ManifoldGap());

    // Round the outside edges
    CylinderChamferEnds(r1=bodyRadius, r2=wall/2,
                        h=base+extension, $fn=$fn*2);

    // Round the inside edge
    translate([0,0,base+extension])
    mirror([0,0,1])
    HoleChamfer(r1=pipeRadius,
                r2=wall/4);
  }
}

scale(25.4)
PipeCap($fn=20);
