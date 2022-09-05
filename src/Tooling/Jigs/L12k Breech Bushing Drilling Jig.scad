use <../../Meta/Manifold.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

module breech_jig(breechBushing=Spec_BushingThreeQuarterInch(),
                  receiver=Spec_AnvilForgedSteel_TeeThreeQuarterInch(),
                  wall=0.2, base=0.5, $fn=50) {
  receiverOD = TeeRimDiameter(receiver);
  height = TeeRimWidth(receiver)
         + BushingExtension(breechBushing)
         + base;

  render()
  difference() {

    // Body
    union() {
      cylinder(r=(receiverOD/2) + wall,
               h=height-ManifoldGap());

      translate([-0.25, 0,0])
      cube([0.5, 2, height]);
    }

    // Cross
    translate([0,0,base+BushingExtension(breechBushing)])
    CrossFitting(tee=receiver);

    // Bushing
    translate([0,0,base])
    cylinder(r=(BushingCapWidth(breechBushing)/2)+0.01,
             h=BushingHeight(breechBushing) + 0.1, $fn=6);


    // Firing Pin/Alignment Hole
    translate([0,0,-ManifoldGap()])
    Rod(rod=Spec_RodOneEighthInch(),
        clearance=RodClearanceSnug(),
        length=base + BushingCapHeight(breechBushing) + 0.2);
  }
}


breechBushing = Spec_BushingThreeQuarterInch();
translate([0,0,0.25])
mirror([0,0,0])
*%Bushing(breechBushing);

scale([25.4, 25.4, 25.4])
breech_jig();
