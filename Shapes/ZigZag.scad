include<../Meta/Animation.scad>;

use <../Meta/Resolution.scad>;
use <../Meta/Units.scad>;
use <../Meta/Manifold.scad>;

use <../Shapes/Semicircle.scad>;
use <../Shapes/Helix.scad>;

DEFAULT_ZIGZAG_DIAMETER  = 3.6252;
DEFAULT_ZIGZAG_POSITIONS = 6;
DEFAULT_ZIGZAG_DEPTH     = 0.1875;
DEFAULT_ZIGZAG_WIDTH     = 0.2500;
EXTRA_BOTTOM = 0.0000;
EXTRA_TOP = 0.0000;

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
  overTwist = slotAngle/2;

  positionAngle=360/positions;
  top_slot_height = (width/2)+extraTop;
  bottom_slot_height = (width/2)+extraBottom;
  
  height = (radius*2*3.14/positions/2/twistRate)
         + (width*3)
         + (width/2*sqrt(2));
  

  mirror([0,(mirrored?1:0),0])
  difference() {
    union() {
      for (i=[0:positions-1]){
        rotate([0,0,positionAngle*i]) {
          
          // Lower segment
          HelixSegment(radius=radius, angle=positionAngle/2,
                width=width, depth=depth,
                bottomExtra=extraBottom,
                topExtra=bottom_slot_height,
                teardropBottom=false,
                teardropTop=false,
                twist_rate=twistRate);
          
          // Upper Segment
          intersection() {
            rotate([0,0,-(positionAngle/2)])
            translate([0,0,height+extraBottom+extraTop])
            mirror([0,0,1])
            HelixSegment(radius=radius, angle=(positionAngle/2)+overTwist,
                depth=depth, width=width,
                bottomExtra=top_slot_height, topExtra=0,
                teardropBottom=false,
                teardropTop=false,
                twist_rate=twistRate);
            
            linear_extrude(height=height+extraBottom+extraTop)
            hull() {
              rotate(-(positionAngle/2)+overTwist)
              semicircle(od=(radius+depth+depth)*2,
                         angle=(positionAngle/2)+(overTwist*2));
              
              circle(r=width/2, $fn=20);
            }
          }
          
          // Extend the straight section to compensate for overtwist
          //rotate([0,0,-(positionAngle/2)])
          translate([radius-depth,-width/2,extraBottom+width])
          cube([depth*2, width, width]);
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
    rotate([0,0,(positionAngle*i)+overTwist])
    ZigZagSupport(radius, depth, width);
  }
}

// Pin
*translate([DEFAULT_ZIGZAG_DIAMETER/2-DEFAULT_ZIGZAG_DEPTH, 0,DEFAULT_ZIGZAG_WIDTH/2])
rotate([0,90,0])
%cylinder(r=DEFAULT_ZIGZAG_WIDTH/2, h=DEFAULT_ZIGZAG_DEPTH*3, $fn=10);

//render()
ZigZag(extraBottom=EXTRA_BOTTOM, extraTop=EXTRA_TOP,
       supportsTop=false, supportsBottom=false);
