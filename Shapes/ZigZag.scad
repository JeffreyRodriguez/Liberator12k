include<../Meta/Animation.scad>;

use <../Vitamins/Rod.scad>;
use <../Vitamins/Pipe.scad>;
use <../Meta/Resolution.scad>;
use <../Shapes/Semicircle.scad>;
use <../Meta/Manifold.scad>;

DEFAULT_ZIGZAG_DIAMETER = 4;
DEFAULT_ZIGZAG_POSITIONS= 6;
DEFAULT_ZIGZAG_DEPTH = 1/4;
DEFAULT_ZIGZAG_WIDTH = 1/4;
DEFAULT_ZIGZAG_ANGLE = 60;

function Circumference(radius) = PI * pow(radius, 2);

function ZigZagSegmentLength(radius, positions)
             = Circumference(radius)
             / (positions*2);
function ZigZagHeight(radius, positions, width, zigzagAngle)
             = ZigZagSegmentLength(radius,positions)*(sin(zigzagAngle)*2);

function TrackAngle(radius, trackWidth)
             = 360
             / (Circumference(radius)/trackWidth);

module ZigZagSegment2D(radius, depth, width, center) {
  translate([radius-depth,-width/2])
  square([depth*2, width]);
}

module ZigZagSegment(radius=1,
           positions=DEFAULT_ZIGZAG_POSITIONS, zigzagAngle=DEFAULT_ZIGZAG_ANGLE,
           depth=DEFAULT_ZIGZAG_DEPTH, width=DEFAULT_ZIGZAG_WIDTH,
           slotHeightExtra=0, $fn=Resolution(120,90)) {
             
  angle=360/positions/2;
  diameter=radius*2;
  track_angle = TrackAngle(radius, width);
  height=ZigZagHeight(radius, positions, width, zigzagAngle+track_angle);
  zigzag_cutter_width = width*sqrt(2);
  slotHeight=width*sqrt(2);
  zigzag_track_angle = TrackAngle(radius, zigzag_cutter_width);
  angleDiff = zigzag_track_angle-track_angle;

  render()
  intersection() {
    union() {
      
      // Angled slot
      translate([0,0,slotHeightExtra])
      translate([0, 0,-ManifoldGap()])
      linear_extrude(height=height+ManifoldGap(2),
                     slices=Resolution(50, 30),
                     twist = angle + track_angle)
      rotate(angleDiff/2)
      ZigZagSegment2D(radius, depth, zigzag_cutter_width, center=true);
        
      // Vertical slot
      linear_extrude(height=slotHeight+slotHeightExtra+ManifoldGap())
      ZigZagSegment2D(radius, depth, width, center=true);
    }
        
    // Trim to shape
    translate([0, 0, -ManifoldGap(2)])
    linear_extrude(height=height+slotHeight+slotHeightExtra+ManifoldGap(4))
    rotate((track_angle/2)-1)
    semidonut(
        angle=angle+track_angle-1,
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
           zigzagAngle=DEFAULT_ZIGZAG_ANGLE,
           extraTop=0, extraBottom=0,
           $fn=Resolution(30,90)) {

  track_angle = TrackAngle(radius, width);
  zigzag_cutter_width = width*cos(zigzagAngle)*2;
  positionAngle=360/positions;
  zigzag_height=ZigZagHeight(radius, positions, width, zigzagAngle+track_angle);
  top_slot_height = (width/2)+extraTop;
  bottom_slot_height = (width/2)+extraBottom;

  render()
  difference() {
    union() {
      for (i=[0:positions-1]){
        rotate([0,0,positionAngle*i])
        render() {
          
          // Lower segment
          ZigZagSegment(radius=radius, positions=positions,
                        width=width, depth=depth, zigzagAngle=zigzagAngle,
                        slotHeightExtra=bottom_slot_height);
          
          // Mirrored upper segment
          rotate([0,0,-positionAngle/2])
          translate([0,0,zigzag_height +(width/2)
                         +bottom_slot_height+top_slot_height])
          mirror([0,0,1])
          ZigZagSegment(radius=radius, positions=positions,
              depth=depth, width=width, zigzagAngle=zigzagAngle,
              slotHeightExtra=top_slot_height);
        }
      }
    }
        
    // Support Material
    if (supports)
    for (i=[0:positions-1])
    rotate([0,0,(positionAngle*i)-(TrackAngle(radius, width)/2)])
    translate([radius - (depth),-1/16,bottom_slot_height])
    render()
    hull() {
      cube([ManifoldGap(), 1/16, width]);
      
      translate([0,0,(zigzag_cutter_width*2)+(width/2)])
      cube([depth*2, 1/16, ManifoldGap()]);
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
%cylinder(r=DEFAULT_ZIGZAG_WIDTH/2, h=depth*3, $fn=10);

*ZigZag(radius=radius, depth=0.125, zigzagAngle=DEFAULT_ZIGZAG_ANGLE,
       width=DEFAULT_ZIGZAG_WIDTH, positions=DEFAULT_ZIGZAG_POSITIONS);

ZigZag(radius=1.8126, depth=0.02, zigzagAngle=50,
       width=width, positions=6);
