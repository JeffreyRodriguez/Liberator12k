include <../Meta/Common.scad>;
include<../Meta/Animation.scad>;
use <../Shapes/Semicircle.scad>;
use <../Shapes/Teardrop.scad>;

RADIUS=2; // "2"
DEPTH=0.1875; // "0.1875"
WIDTH=0.25; // "0.25"
TWIST_RATE=1; // [0.1:0.1:2]
ANGLE=22.5; // [0:0.5:360]

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

function HelixHeight(radius,angle,width,twistRate) = (((PI * (radius*2))*(angle/360))+width)/twistRate;

module HelixSegment(radius=RADIUS, depth=DEPTH, width=WIDTH,
                    angle=ANGLE, twist_rate=TWIST_RATE,
                    slices=Resolution(30,50),
                    verbose=false) {

  //twist_angle = 90*(2-twist_rate);
  diameter     = radius*2;
  circumf      = PI * diameter;
  segment      = circumf*(angle/360);
  height       = HelixHeight(radius,angle,width,twist_rate);
  width_angle  = (width/circumf)*360;

  // HACK: The max(width*sqrt(2), ...) will cause the track to be
  // wider than strictly necessary... sloppier.
  // This will only affect helices that overhang greater than 45 degrees.
  // Since this is optimized for printing, that's a sane floor.

  // TODO: Adjust the height of the "bottom" square. I used (width/2),
  // Which works fine for the above hack, but using only the latter portion.
  //twistedWidth = max(width*sqrt(2), (width*sqrt(2))*twist_rate);
  twistedWidth = width+(width*0.5);
  twistedCutterAngle = (twistedWidth/circumf)*360;
  twistAngleExtra = twistedCutterAngle-width_angle;


  if (verbose) {
    echo("Helix height: ", height);
    echo("Helix width_angle: ", width_angle);
    echo("Helix twist_rate: ", twist_rate);
    echo("Helix radius: ", radius);
    echo("Helix circumference: ", circumf);
    echo("Helix segment: ", segment);
  }


  intersection() {
    union() {
      linear_extrude(height=height,
                     slices=slices,
                     twist = angle+twistAngleExtra)
      translate([radius-(depth*2),-width/2])
      square([depth*4, twistedWidth]);
    }

    // Chop off the leading and trailing tips
    linear_extrude(height=height)
    union() {
      semidonut(major=(radius+depth)*2,
                minor=(radius-depth)*2,
                angle=angle);

      // This is a little hacky, but I'm done fucking with it for now.
      for (R = [0,-angle]) rotate(R)
      translate([radius-depth, -(width/2)])
      square([depth*2,width]);
    }
  }
}

// Sample Cases
render()
difference() {
  cylinder(r=RADIUS, h=(RADIUS/TWIST_RATE)+2);

  HelixSegment();
}
