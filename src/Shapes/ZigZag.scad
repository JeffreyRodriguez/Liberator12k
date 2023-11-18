include <../Meta/Common.scad>;

include<../Meta/Animation.scad>;

use <../Shapes/Semicircle.scad>;
use <../Shapes/Helix.scad>;

DEFAULT_ZIGZAG_DIAMETER  = 1;
DEFAULT_ZIGZAG_POSITIONS = 3;
DEFAULT_ZIGZAG_DEPTH     = 0.125;
DEFAULT_ZIGZAG_WIDTH     = 0.1;
EXTRA_BOTTOM = 0.1000;
EXTRA_TOP = 0.1000;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

module ZigZagSupport(radius,depth, width) {
  translate([radius - (depth*2),-(width/2)-(0.07/2),0])
  hull() {
    cube([depth, 0.07, width]);

    translate([depth*0.9,0,width*2])
    cube([depth*2.2, 0.07, width]);
  }
}

module ZigZag(supportsTop=true, supportsBottom=true,
           radius=DEFAULT_ZIGZAG_DIAMETER/2,
           depth=DEFAULT_ZIGZAG_DEPTH,
           width=DEFAULT_ZIGZAG_WIDTH,
           positions=DEFAULT_ZIGZAG_POSITIONS,
           extraTop=0, extraBottom=0,
           twistRate=0.8, mirrored=false) {

  zigZagCircumference = (radius+depth)*2*PI;
  slotAngle = (width/zigZagCircumference)*360;

  positionAngle      = 360/positions;
  top_slot_height    = width+width+extraTop;
  bottom_slot_height = width+width+extraBottom;

  height       = HelixHeight(radius,(positionAngle/2),width,twistRate);
  height2      = HelixHeight(radius,(positionAngle/2)-slotAngle,width,twistRate);

  mirror([0,(mirrored?1:0),0])
  difference() {
    union() {
      for (i=[0:positions-1]){
        rotate([0,0,positionAngle*i]) {

          // Top
          rotate([0,0,-(positionAngle/2)])
          translate([radius-depth,-width/2,extraBottom+height])
          cube([depth*2, width, top_slot_height]);

          // Bottom
          translate([radius-depth,-width/2,0])
          cube([depth*2, width, bottom_slot_height+ManifoldGap()]);

          // Track
          translate([0,0,bottom_slot_height])
          HelixSegment(radius=radius, angle=(positionAngle/2),
                depth=depth, width=width,
                twist_rate=twistRate);

          // Inverted Track
          rotate([0,0,-(positionAngle/2)])
          translate([0,0,extraBottom+height2+width])
          mirror([0,0,1])
          HelixSegment(radius=radius, angle=(positionAngle/2),
              depth=depth, width=width,
              twist_rate=twistRate);
        }
      }
    }

    // Support Material
    // Top
    if (supportsTop)
    translate([0,0,height-(width*2)+extraBottom])
    mirror([0,0,1])
    for (i=[0:positions-1])
    rotate([0,0,(positionAngle/2)+(positionAngle*i)])
    ZigZagSupport(radius, depth, width);

    // Support Material
    // Bottom
    if (supportsBottom)
    translate([0,0,bottom_slot_height+width])
    for (i=[0:positions-1])
    rotate([0,0,(positionAngle*i)])
    ZigZagSupport(radius, depth, width);
  }
}

// Pin
*translate([DEFAULT_ZIGZAG_DIAMETER/2-DEFAULT_ZIGZAG_DEPTH, 0,DEFAULT_ZIGZAG_WIDTH/2])
rotate([0,90,0])
%cylinder(r=DEFAULT_ZIGZAG_WIDTH/2, h=DEFAULT_ZIGZAG_DEPTH*3, $fn=10);

render()
ZigZag(extraBottom=EXTRA_BOTTOM, extraTop=EXTRA_TOP,
       supportsTop=false, supportsBottom=false);
