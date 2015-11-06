use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;

module striker(length=4, od=0.75, id=0.53,
               firingPin = Spec_RodOneEighthInch(),
               linePin = Spec_RodOneEighthInch(),
               depth=0.8,
               rope_width = 1/8, rope_depth=1/4, $fn=30) {

  difference() {

    // Body
    color("Orange")
    cylinder(r=od/2, h=length);

    // Weight Hole
    translate([0,0,depth])
    cylinder(r=id/2, h=length);

    // Line Pin Hole
    translate([0,od/2 + 0.1,length - RodDiameter(firingPin)*2])
    rotate([90,0,0])
    Rod(rod=firingPin, length=od+0.2);

    // Firing Pin Hole
    translate([0,0,-0.1])
    Rod(rod=firingPin, length=length);

    // Firing Pin
    color("Silver")
    translate([0,0,-1])
    %Rod(rod=firingPin, length=1+depth);

    // Line Pin
    translate([0,od/2 + 0.025,length - RodDiameter(firingPin)*2])
    rotate([90,0,0])
    Rod(rod=firingPin, length=od + 0.05);

    // Line
    cylinder(r=rope_width/2, h=12);
  }
}

translate([0,50,0])
scale([25.4, 25.4, 25.4])
striker();
