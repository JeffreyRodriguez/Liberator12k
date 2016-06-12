SpringLengthExtended   = 0;
SpringLengthCompressed = 1;
SpringOD               = 2;
SpringWireDiameter     = 3;

/**
 * Lookup the fully extended length of a spring.
 * @param spring the spring to lookup.
 */
function SpringLengthExtended(spring) = lookup(SpringLengthExtended, spring);

/**
 * Lookup the fully compressed length of a spring.
 * @param spring the spring to lookup.
 */
function SpringLengthCompressed(spring) = lookup(SpringLengthCompressed, spring);

/**
 * Lookup the outside diameter of a spring.
 * @param spring the spring to lookup.
 */
function SpringOD(spring) = lookup(SpringOD, spring);

/**
 * Lookup the wire diameter of a spring.
 * @param spring the spring to lookup.
 */
 function SpringWireDiameter(spring) = lookup(SpringWireDiameter, spring);

/**
 * Calculate the compression distance of a spring.
 * @param spring the spring to lookup.
 */
function SpringCompression(spring) = SpringLengthExtended(spring)
                                   - SpringLengthCompressed(spring);

BicLighterThumbSpring = [
  [SpringLengthExtended,0.63],
  [SpringLengthCompressed,0.32],
  [SpringOD, 0.145],
  [SpringWireDiameter,0.019]
];

function Spec_BicLighterThumbSpring() = BicLighterThumbSpring;

BicSoftFeelFinePenSpring = [
  [SpringLengthExtended,0.95],
  [SpringLengthCompressed,0.33],
  [SpringOD, 0.175],
  [SpringWireDiameter,0.017]
];

function Spec_BicSoftFeelFinePenSpring() = BicSoftFeelFinePenSpring;
