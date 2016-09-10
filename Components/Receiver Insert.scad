use <../Meta/Manifold.scad>;
use <../Meta/Resolution.scad>;
use <../Reference.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;

module ReceiverInsert(topFactor=0.6, baseHeight=0) {
  render(convexity=4)
  difference() {
    union() {
      // Body
      cylinder(r=ReceiverIR(),
               h=(ReceiverLength()/2)-(ReceiverIR()*topFactor),
             $fn=Resolution(20,30));

      // Front-bottom chamfered curve
      cylinder(r1=ReceiverIR()+0.135,
               r2=ReceiverIR(),
                h=0.103,
              $fn=Resolution(20,60));
      
      if (baseHeight > 0)
      translate([0,0,-baseHeight])
      cylinder(r=ReceiverOR(),
               h=baseHeight+ManifoldGap(),
             $fn=Resolution(20,60));
    }
    
    // Middle Clearance
    translate([0,0,ReceiverLength()/2])
    rotate([0,90,0])
    cylinder(r=ReceiverIR()+ManifoldGap(),
             h=ReceiverLength(),
        center=true,
           $fn=Resolution(20,60));
  }
}

ReceiverInsert();