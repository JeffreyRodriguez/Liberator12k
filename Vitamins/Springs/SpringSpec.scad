use <../../Meta/Units.scad>;
use <../../Meta/slookup.scad>;

function Spec_SpringTemplate() = [
  ["SpringSpec", "SpringTemplate"],

  ["SpringOuterDiameter", UnitsImperial(0.625)],
  ["SpringPitch", UnitsImperial(0.35)],

  ["SpringFreeLength", UnitsImperial(3.5)],
  ["SpringSolidHeight", UnitsImperial(0.93)],

  ["SpringWireDiameter", UnitsImperial(0.055)]
];

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