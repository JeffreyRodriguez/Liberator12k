use <../Meta/Conditionals/RenderIf.scad>;
use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/slookup.scad>;
use <../Shapes/Chamfer.scad>;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

module PlanetaryNEMA17(cutter=true) {
  color("DimGrey")
  render() {

    // Output Shaft
    mirror([0,0,1])
    cylinder(d=Millimeters(8), h=Millimeters(16));

    // Motor Body
    translate([-Millimeters(21), -Millimeters(21), Millimeters(38)])
    cube([Millimeters(42), Millimeters(42), Millimeters(42)]);

    // Gearbox
    cylinder(d=Millimeters(36),
		         h=Millimeters(38) + (cutter?Millimeters(25):0));

    // Center boss
    mirror([0,0,1])
    cylinder(d=Millimeters(22.5), h=Millimeters(2));

    // Mounting bolts
    for (R = [0:90:360]) rotate(45+R)
    translate([Millimeters(28/2), 0, 0])
    mirror([0,0,1])
    cylinder(d=Millimeters(3.5),
		         h=Millimeters(8)+(cutter?Millimeters(12):0));
  }
}

PlanetaryNEMA17();
