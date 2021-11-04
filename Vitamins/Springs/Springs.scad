use <../../Meta/Resolution.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Manifold.scad>;

use <SpringSpec.scad>;

SPRING_OD = 0.625;
SPRING_PITCH = 0.35;
SPRING_FREE_LENGTH = 3.5;
SPRING_SOLID_HEIGHT = 0.93;
SPRING_WIRE_DIAMETER = 0.055;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

function Spec_SpringCustomizer() = [
    ["SpringSpec", "Customizer Spring"],

    ["SpringOuterDiameter", SPRING_OD],
    ["SpringPitch", SPRING_PITCH],

    ["SpringFreeLength", SPRING_FREE_LENGTH],
    ["SpringSolidHeight", SPRING_SOLID_HEIGHT],

    ["SpringWireDiameter", SPRING_WIRE_DIAMETER]
  ];

module Spring(spring = Spec_SpringCustomizer(), degrees_per_step = ResolutionFa()*4, compressed = false, custom_compression_ratio = -1, cutter = false, clearance = 0, doRender=true) {
  compressed_length = max(SpringSolidHeight(spring),
                          SpringFreeLength(spring) * custom_compression_ratio);

  if (!cutter) {
    effective_pitch = !compressed ? SpringPitch(spring)
        : SpringPitch(spring) / (SpringFreeLength(spring) / compressed_length);

    helix_r = SpringMiddleRadius(spring);
    wire_r = SpringWireRadius(spring);

    // TODO: Check why * 1.5 look at firing pin spring
    active_length = (SpringFreeLength(spring) - SpringWireDiameter(spring) * 1.5);
    active_coils = active_length / SpringPitch(spring);

    total_degrees = 360 * active_coils;
    total_steps = total_degrees / degrees_per_step;

    z_factor = effective_pitch / 360;

    translate([0,0,wire_r])
    union() {
      for (i = [0 : total_steps-1]) {
        start_degrees = i * degrees_per_step;
        end_degrees = (i + 1) * degrees_per_step;

        hull() {
          translate([helix_r * sin(start_degrees),
                     helix_r * cos(start_degrees),
                     z_factor * start_degrees])
          rotate([start_degrees, 90, 0])
          cylinder(r = wire_r, h = ManifoldGap());

          translate([helix_r * sin(end_degrees),
                     helix_r * cos(end_degrees),
                     z_factor * end_degrees])
          rotate([end_degrees, 90, 0])
          cylinder(r = wire_r, h = ManifoldGap());
        }
      }
    }
  } else {
    cylinder(r=SpringOuterRadius(spring, clearance),
             h=!compressed ? SpringFreeLength(spring) : compressed_length);
  }
}

ScaleToMillimeters()
Spring();
