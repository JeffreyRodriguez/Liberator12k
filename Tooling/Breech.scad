include <../Vitamins/Pipe.scad>;
include <../Vitamins/Rod.scad>;

module breech_jig(breechBushing=BushingThreeQuarterInch, wall=1/8, floor=1/4, $fn=50) {
  difference() {
    cylinder(r=BushingCapWidth(breechBushing)/2 + wall,
             h=BushingCapHeight(breechBushing) + floor,
             $fn=6);

    translate([0,0,floor])
    cylinder(r=(BushingCapWidth(breechBushing)/2), h=BushingCapHeight(breechBushing) + 0.1, $fn=6);

    translate([0,0,-0.1])
    Rod(rod=RodOneEighthInch, clearance=RodClearanceSnug, length=floor + BushingCapHeight(breechBushing) + 0.2);

    translate([0,0,floor])
    mirror([0,0,0])
    %Bushing(breechBushing);
  }
}

scale([25.4, 25.4, 25.4])
breech_jig();