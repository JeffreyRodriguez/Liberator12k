include <../Meta/Common.scad>;
use <../Meta/slookup.scad>;

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

function CommonHammerSpringSpec() = [
	["SpringSpec", "Hammer Spring"],

	["SpringOuterDiameter", Inches(0.6)],
	["SpringPitch", Inches(0.2139)],

	["SpringFreeLength", Inches(3.059)],
	["SpringSolidHeight", Inches(0.903)],

	["SpringWireDiameter", Inches(0.059)]
];

function CommonSmallShortSpringSpec() = [
    ["SpringSpec", "Disconnector Spring"],

    ["SpringOuterDiameter", Inches(0.23)],
    ["SpringPitch", Inches(0.05)],

    ["SpringFreeLength", Inches(0.4)],
    ["SpringSolidHeight", Inches(0.3125)],

    ["SpringWireDiameter", Inches(0.025)]
  ];

function CommonSmallLongSpringSpec() = [
    ["SpringSpec", "Sear Return Spring"],

    ["SpringOuterDiameter", Inches(0.25)],
    ["SpringPitch", Inches(0.075)],

    ["SpringFreeLength", Inches(1.2)],
    ["SpringSolidHeight", Inches(0.3)],

    ["SpringWireDiameter", Inches(0.025)]
  ];

// *************************
// * Spring Spec Accessors *
// *************************

/**
 * Lookup the name of a spring size.
 *
 * @param spring The spring to lookup.
 */
function SpringName(spring = undef)
= slookup("SpringSpec", spring);

/**
 * Lookup the outer diameter of a spring.
 *
 * @param spring    The spring to lookup.
 * @param clearance Clearance to add, total diameter clearance is 2*clearance.
 */
function SpringOuterDiameter(spring = undef, clearance = 0)
= slookup("SpringOuterDiameter", spring) + clearance * 2;

/**
 * Lookup the inner diameter of a spring.
 *
 * @param spring    The spring to lookup.
 * @param clearance Clearance to add, total diameter clearance is 2*clearance.
 */
function SpringInnerDiameter(spring = undef, clearance = 0)
= slookup("SpringOuterDiameter", spring) + clearance * 2 - SpringWireDiameter(spring=spring) * 2;

/**
 * Lookup the middle diameter of a spring. The diameter between the centers of the wire.
 *
 * @param spring    The spring to lookup.
 * @param clearance Clearance to add, total diameter clearance is 2*clearance.
 */
function SpringMiddleDiameter(spring=undef, clearance = 0)
= (SpringInnerDiameter(spring=spring, clearance=clearance) + SpringOuterDiameter(spring=spring, clearance=clearance)) / 2;

/**
 * Lookup the outer radius of a spring.
 *
 * @param spring    The spring to lookup.
 * @param clearance Clearance to add, total diameter clearance is 2*clearance.
 */
function SpringOuterRadius(spring=undef, clearance = 0)
= SpringOuterDiameter(spring=spring, clearance=clearance) / 2;

/**
 * Lookup the inner radius of a spring.
 *
 * @param spring    The spring to lookup.
 * @param clearance Clearance to add, total diameter clearance is 2*clearance.
 */
function SpringInnerRadius(spring = undef, clearance = 0)
= SpringInnerDiameter(spring=spring, clearance=clearance) / 2;

/**
 * Lookup the middle radius of a spring. The diameter between the centers of the wire.
 *
 * @param spring    The spring to lookup.
 * @param clearance Clearance to add, total diameter clearance is 2*clearance.
 */
function SpringMiddleRadius(spring = undef, clearance = 0)
= SpringMiddleDiameter(spring=spring, clearance=clearance) / 2;

/**
 * Lookup the pitch of a spring.
 *
 * @param spring The spring to lookup.
 */
function SpringPitch(spring = undef)
= slookup("SpringPitch", spring);

/**
 * Lookup the Free length of a spring.
 *
 * @param spring The spring to lookup.
 */
function SpringFreeLength(spring = undef)
= slookup("SpringFreeLength", spring);

/**
 * Lookup the compressed length of a spring.
 *
 * @param spring The spring to lookup.
 */
function SpringSolidHeight(spring = undef)
= slookup("SpringSolidHeight", spring);

/**
 * Lookup the wire diameter of a spring.
 *
 * @param spring The spring to lookup.
 */
function SpringWireDiameter(spring = undef)
= slookup("SpringWireDiameter", spring);

/**
 * Lookup the wire radius of a spring.
 *
 * @param spring    The spring to lookup.
 * @param clearance Clearance to add, total diameter clearance is 2*clearance.
 */
function SpringWireRadius(spring = undef)
= SpringWireDiameter(spring)/2;

/**
 * Lookup the compression length of a spring.
 *
 * @param spring The spring to lookup.
 */
function SpringCompressionLength(spring = undef)
= SpringFreeLength(spring=spring) -SpringSolidHeight(spring=spring) ;
///

// *****************
// * Spring Module *
// *****************
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
///

ScaleToMillimeters()
Spring();
