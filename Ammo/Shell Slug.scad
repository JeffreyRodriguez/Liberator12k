include <Shell Base.scad>;
include <../Vitamins/Pipe.scad>;

module ShellSlug(chamber=PipeThreeQuartersInch, primer=Primer209,
                 height=1.5, slug_diameter=0.52,
                 fin_width=.25, fin_wall=2/32, fin_taper=1/4) {
  ShellBase(chamber=chamber, primer=primer) {
    
    color("Orange")
    render()
    intersection() {
      linear_extrude(height=height, twist=-70, slices=12)
      difference() {
        union() {
          
          // Fin
          translate([-fin_width/2, -ShellRadius(chamber)])
          square([fin_width, ShellRadius(chamber)*2]);

          // Fin
          translate([-ShellRadius(chamber), -fin_width/2])
          square([ShellRadius(chamber)*2, fin_width]);
          
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
        cylinder(r1=ShellRadius(chamber), r2=(slug_diameter/2) + fin_wall, h=fin_taper);
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
