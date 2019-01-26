include<../Meta/Animation.scad>;

use <../Vitamins/Rod.scad>;
use <../Vitamins/Pipe.scad>;
use <../Meta/Resolution.scad>;
use <../Shapes/Semicircle.scad>;
use <../Meta/Manifold.scad>;

DEFAULT_ZIGZAG_DIAMETER = 4;
DEFAULT_ZIGZAG_POSITIONS= 2;
DEFAULT_ZIGZAG_DEPTH = 1/2;
DEFAULT_ZIGZAG_WIDTH = 1/2;
DEFAULT_ZIGZAG_ANGLE = 50;

function ZigZagSegmentLength(radius, positions)
             = RadiusToCircumference(radius)
             / positions;
function ZigZagHeight(radius, positions, width)
             = (ZigZagSegmentLength(radius,positions)*(sin(DEFAULT_ZIGZAG_ANGLE)))
             *tan(DEFAULT_ZIGZAG_ANGLE);

function RadiusToCircumference(radius) = PI * pow(radius, 2);

function TrackAngle(radius, trackWidth)
             = 360
             / (RadiusToCircumference(radius)/trackWidth);
module SegmentSemiDonut(radius, depth, width, center) {
  translate([radius-depth,-width/2])
  square([depth*2, width]);
}
module ZigZagSegment(radius=1,
           positions=DEFAULT_ZIGZAG_POSITIONS,
           depth=DEFAULT_ZIGZAG_DEPTH, width=DEFAULT_ZIGZAG_WIDTH,
           slotHeightExtra=0.5, $fn=Resolution(120,90)) {
             
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
      SegmentSemiDonut(radius, depth*2, zigzag_cutter_width, center=true);
        
      // Vertical slot
      linear_extrude(height=slotHeight+slotHeightExtra+ManifoldGap())
      SegmentSemiDonut(radius, depth*2, width, center=true);
    }
        
    // Trim to shape
    translate([0, 0, -ManifoldGap(2)])
    linear_extrude(height=height+slotHeight+slotHeightExtra+ManifoldGap(4))
    rotate((track_angle/2))
    difference() {
      semidonut(
          angle=angle+track_angle,
          major=(radius+depth)*2,
          minor=(radius-depth)*2,
          center=false);
      
      rotate(-angle-track_angle)
      translate([radius-depth,0])
      rotate(5)
      *#mirror([0,1])
      square([(depth*2*tan(DEFAULT_ZIGZAG_ANGLE))*cos(angle+track_angle),
              depth*2*sin(angle+track_angle)]);
    }
  }
}

module ZigZag(
           radius=2,
           depth=DEFAULT_ZIGZAG_DEPTH,
           width=DEFAULT_ZIGZAG_WIDTH,
           positions=DEFAULT_ZIGZAG_POSITIONS,
           $fn=Resolution(30,90)) {

  slotHeight=width/2;
  angle=360/positions/2;
  zigzag_height=ZigZagHeight(radius, positions, width);
  top_slot_height = width;
  bottom_slot_height = width;

  render()
  union() {
    for (i=[0:positions-1]){
      rotate([0,0,angle*2*i])
      render() {
        
        // Support Material
        *color("Black")
        translate([radius - depth,width/2,width])
        cube([depth, 0.031, width * 1.75]);
        
        ZigZagSegment(radius=radius, depth=depth, width=width, positions=positions,
            slotHeightExtra=top_slot_height);
        
        rotate([0,0,-angle])
        translate([0,0,zigzag_height+slotHeight+bottom_slot_height+top_slot_height])
        mirror([0,0,1])
        ZigZagSegment(radius=radius,
            depth=depth, width=width,positions=positions,
            slotHeightExtra=bottom_slot_height);
      }
    }
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

  ZigZag(radius=radius, depth=depth,
         width=5/16, positions=DEFAULT_ZIGZAG_POSITIONS);
