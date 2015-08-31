include <Shell Base.scad>;
include <../Vitamins/Pipe.scad>;

module ShellSlug(chamber=12GaugeChamber, primer=Primer209,
                 height=1.5, slug_diameter=0.52,
                 chargeDiameter=undef, chargeHeight=undef, wadHeight=undef,
                 rimDiameter=undef, rimHeight=undef,
                 fin_width=.4, fin_wall=5/64, fin_taper=1/4, fin_slices=20,
                 dummy=false) {
  ShellBase(chamber=chamber, primer=primer, dummy=dummy,
            rimDiameter=rimDiameter, rimHeight=rimHeight,
            chargeDiameter=chargeDiameter, chargeHeight=chargeHeight, wadHeight=wadHeight) {

    color("Orange")
    render()
    intersection() {
      linear_extrude(height=height, twist=-100, slices=fin_slices)
      difference() {
        union() {

          // Fin
          translate([-fin_width/2, -ShellRadius(chamber)*1.5])
          square([fin_width, ShellRadius(chamber)*3]);

          // Fin
          translate([-ShellRadius(chamber)*1.5, -fin_width/2])
          square([ShellRadius(chamber)*3, fin_width]);

          // Fin Wall
          circle(r=(slug_diameter/2) + fin_wall, h=height, $fn=20);
        }

        // Slug Hole
        circle(r=slug_diameter/2, $fn=20);
      }

      // Fins
      union() {

        // Straight Section
        cylinder(r=ShellRadius(chamber), h=height - fin_taper);

        // Tapered Section
        translate([0,0,height - fin_taper])
        cylinder(r1=ShellRadius(chamber), r2=(slug_diameter/2) + fin_wall/2, h=fin_taper);
      }
    }
  }
}

scale([25.4, 25.4, 25.4])
difference() {
  ShellSlug();

  *translate([-2, 0, -1])
  cube([4,4,4]);
}
