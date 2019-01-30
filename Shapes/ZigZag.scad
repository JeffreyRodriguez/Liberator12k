include<../Meta/Animation.scad>;

use <../Vitamins/Rod.scad>;
use <../Vitamins/Pipe.scad>;
use <../Meta/Resolution.scad>;
use <../Shapes/Semicircle.scad>;
use <../Meta/Manifold.scad>;

DEFAULT_ZIGZAG_DIAMETER = 4;
DEFAULT_ZIGZAG_POSITIONS= 6;
DEFAULT_ZIGZAG_DEPTH = 1/4;
DEFAULT_ZIGZAG_WIDTH = 1/2;
DEFAULT_ZIGZAG_ANGLE = 45;

function ZigZagSegmentLength(radius, positions)
             = RadiusToCircumference(radius)
             / positions;
function ZigZagHeight(radius, positions, width)
             = (ZigZagSegmentLength(radius,positions)*sin(DEFAULT_ZIGZAG_ANGLE))
             *tan(DEFAULT_ZIGZAG_ANGLE);

function RadiusToCircumference(radius) = PI * pow(radius, 2);

function TrackAngle(radius, trackWidth)
             = 360
             / (RadiusToCircumference(radius)/trackWidth);
module SegmentSemiDonut(radius, depth, width, center) {
  translate([radius-depth,-width/2])
  square([depth*2, width]);
  
  *semidonut(major=(radius+depth)*2,
            minor=(radius-depth)*2,
            angle=TrackAngle(radius, width),
            center=true,
            $fn=40);
}
module ZigZagSegment(radius=1,
           positions=DEFAULT_ZIGZAG_POSITIONS,
           depth=DEFAULT_ZIGZAG_DEPTH, width=DEFAULT_ZIGZAG_WIDTH,
           slotHeightExtra=0, $fn=Resolution(120,90)) {
             
  angle=360/positions/2;
  diameter=radius*2;
  height=ZigZagHeight(radius, positions, width);
  twistRate= angle/height;
  zigzag_cutter_width = width*sqrt(2);
  slotHeight=(zigzag_cutter_width)*tan(DEFAULT_ZIGZAG_ANGLE);
  track_angle = TrackAngle(radius,width);
  zigzag_track_angle = TrackAngle(radius, zigzag_cutter_width);
  angleDiff = zigzag_track_angle-track_angle;
  
  *echo("track_angle: ", track_angle);
  *echo("zigzag_track_angle: ", zigzag_track_angle);
  *echo("angleDiff: ", angleDiff);
               
  
  render()
  intersection() {
    union() {
      
      // Angled slot
      translate([0,0,slotHeightExtra])
      translate([0, 0,-ManifoldGap()])
      linear_extrude(height=height+ManifoldGap(2),
                     slices=Resolution(50, 30),
                     twist = angle
                           //- angleDiff
                           + (track_angle*1))
      rotate(angleDiff/2)
      SegmentSemiDonut(radius, depth, zigzag_cutter_width, center=true);
        
      // Vertical slot
      linear_extrude(height=slotHeight+slotHeightExtra+ManifoldGap())
      SegmentSemiDonut(radius, depth, width, center=true);
    }
        
    // Trim to shape
    translate([0, 0, -ManifoldGap(2)])
    linear_extrude(height=height+slotHeight+slotHeightExtra+ManifoldGap(4))
    rotate((track_angle/2))
    semidonut(
        angle=angle+track_angle,
        major=(radius+depth)*2,
        minor=(radius-depth)*2,
        center=false);
  }
}

module ZigZag(supports=true,
           radius=2,
           depth=DEFAULT_ZIGZAG_DEPTH,
           width=DEFAULT_ZIGZAG_WIDTH,
           positions=DEFAULT_ZIGZAG_POSITIONS,
           extraTop=0, extraBottom=0,
           $fn=Resolution(30,90)) {

  //zigzag_cutter_width = width*sqrt(2);
  //slotHeight=(zigzag_cutter_width)*tan(DEFAULT_ZIGZAG_ANGLE);
  angle=360/positions/2;
  zigzag_height=ZigZagHeight(radius, positions, width);
  top_slot_height = (width/2)+extraTop;
  bottom_slot_height = (width/2)+extraBottom;

  render()
  difference() {
    union() {
      for (i=[0:positions-1]){
        rotate([0,0,angle*2*i])
        render() {
          ZigZagSegment(radius=radius, positions=positions,
                        width=width, depth=depth,
                        slotHeightExtra=bottom_slot_height);
          
          rotate([0,0,-angle])
          translate([0,0,zigzag_height+(width*sin(DEFAULT_ZIGZAG_ANGLE))
                         +bottom_slot_height+top_slot_height])
          mirror([0,0,1])
          ZigZagSegment(radius=radius,
              depth=depth, width=width,positions=positions,
              slotHeightExtra=top_slot_height);
        }
      }
    }
        
    // Support Material
    if (supports)
    for (i=[0:positions-1])
    rotate([0,0,(angle*2*i)-(TrackAngle(radius, width)/2)])
    translate([radius - (depth*2),-1/16,bottom_slot_height])
    cube([depth*4, 1/16, width*3]);
  }
}



radius = DEFAULT_ZIGZAG_DIAMETER/2;
positions = DEFAULT_ZIGZAG_POSITIONS;
width = DEFAULT_ZIGZAG_WIDTH;
depth = DEFAULT_ZIGZAG_DEPTH;

  // Pin
  translate([radius-depth, 0,width/2])
  rotate([0,90,0])
  %cylinder(r=5/16/2, h=depth*3, $fn=10);

  ZigZag(radius=radius, depth=0.125,
         width=5/16, positions=DEFAULT_ZIGZAG_POSITIONS);
