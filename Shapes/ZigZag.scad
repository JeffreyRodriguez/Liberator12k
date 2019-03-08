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
DEFAULT_ZIGZAG_ANGLE = 45;

function ZigZagSegmentLength(radius, positions)
             = RadiusToCircumference(radius)
             / positions;
function ZigZagHeight(radius, positions, width, zigzagAngle)
             = (ZigZagSegmentLength(radius,positions)*sin(zigzagAngle))
             *tan(zigzagAngle);

function RadiusToCircumference(radius) = PI * pow(radius, 2);

function TrackAngle(radius, trackWidth)
             = 360
             / (RadiusToCircumference(radius)/trackWidth);

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
  height=ZigZagHeight(radius, positions, width, zigzagAngle);
  twistRate= angle/height;
  zigzag_cutter_width = width*cos(zigzagAngle)*2;
  slotHeight=(zigzag_cutter_width)*tan(zigzagAngle);
  track_angle = TrackAngle(radius,width);
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
                     twist = angle
                           //- angleDiff
                           + (track_angle*1))
      rotate(angleDiff/2)
      ZigZagSegment2D(radius, depth, zigzag_cutter_width, center=true);
        
      // Vertical slot
      linear_extrude(height=slotHeight+slotHeightExtra+ManifoldGap())
      ZigZagSegment2D(radius, depth, width, center=true);
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
           zigzagAngle=DEFAULT_ZIGZAG_ANGLE,
           extraTop=0, extraBottom=0,
           $fn=Resolution(30,90)) {

  zigzag_cutter_width = width*cos(zigzagAngle)*2;
  angle=360/positions/2;
  zigzag_height=ZigZagHeight(radius, positions, width, zigzagAngle);
  top_slot_height = (width/2)+extraTop;
  bottom_slot_height = (width/2)+extraBottom;

  render()
  difference() {
    render()
    union() {
      for (i=[0:positions-1]){
        rotate([0,0,angle*2*i])
        render() {
          ZigZagSegment(radius=radius, positions=positions,
                        width=width, depth=depth, zigzagAngle=zigzagAngle,
                        slotHeightExtra=bottom_slot_height);
          
          rotate([0,0,-angle])
          translate([0,0,zigzag_height+(width*sin(zigzagAngle))
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
    rotate([0,0,(angle*2*i)-(TrackAngle(radius, width)/2)])
    translate([radius - (depth),-1/16,bottom_slot_height])
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
  %cylinder(r=5/16/2, h=depth*3, $fn=10);

  ZigZag(radius=radius, depth=0.125, zigzagAngle=60,
         width=DEFAULT_ZIGZAG_WIDTH, positions=DEFAULT_ZIGZAG_POSITIONS);
