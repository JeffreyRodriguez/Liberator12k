include<../Meta/Animation.scad>;

use <../Meta/Resolution.scad>;
use <../Shapes/Semicircle.scad>;
use <../Meta/Manifold.scad>;

DEFAULT_ZIGZAG_DIAMETER = 3.6252;
DEFAULT_ZIGZAG_POSITIONS= 6;
DEFAULT_ZIGZAG_DEPTH = 3/16;
DEFAULT_ZIGZAG_WIDTH = 1/4;
DEFAULT_ZIGZAG_ANGLE = 45;

function Circumference(radius) = PI * (radius*2);


function ZigZagSegmentLength(radius, positions)
             = Circumference(radius)
             / (positions*2);
function ZigZagHeight(radius, positions, width, zigzagAngle)
             = ZigZagSegmentLength(radius,positions)*tan(zigzagAngle);

function TrackAngle(radius, trackWidth)
             = (trackWidth/Circumference(radius)) * 360;
             
function ZigZagCutterWidth(width, zigzagAngle) = width*sqrt(2);

function ZigZagCutterHeight(width, zigzagAngle) = width*sqrt(2);

module ZigZagSegment2D(radius, depth, width) {
  translate([radius-depth,-width/2])
  square([depth*2, width]);
}

module ZigZagSegment(radius=DEFAULT_ZIGZAG_DIAMETER/2,
           positions=DEFAULT_ZIGZAG_POSITIONS, zigzagAngle=DEFAULT_ZIGZAG_ANGLE,
           depth=DEFAULT_ZIGZAG_DEPTH, width=DEFAULT_ZIGZAG_WIDTH,
           slotHeightExtra=0, $fn=Resolution(30,90)) {

  angle=360/positions/2;
  diameter=radius*2;
  zigzag_track_angle = TrackAngle(radius, width);
  height=ZigZagHeight(radius, positions, width, zigzagAngle+zigzag_track_angle);
  slotHeight=width*sqrt(2)/0.8;
  zigzag_cutter_width = ZigZagCutterWidth(width, zigzagAngle);
  zigzag_zigzag_track_angle = TrackAngle(radius, zigzag_cutter_width);
  angleDiff = zigzag_zigzag_track_angle-zigzag_track_angle;

  union () {
    
    // Vertical slot
    intersection() {
      linear_extrude(height=slotHeight+slotHeightExtra+ManifoldGap())
      ZigZagSegment2D(radius, depth, width);
      
      translate([0, 0, -ManifoldGap(2)])
      linear_extrude(height=slotHeight+slotHeightExtra+ManifoldGap(4))
      semidonut(
          angle=zigzag_track_angle,
          major=(radius+depth)*2,
          minor=(radius-depth)*2,
          center=true);
    }
    
    // Angled slot
    intersection() {
      
      translate([0,0,slotHeightExtra])
      translate([0, 0,-ManifoldGap()])
      linear_extrude(height=height+ManifoldGap(2),
                     slices=Resolution(30, 50),
                     twist = angle + zigzag_track_angle)
      rotate(angleDiff/2)
      ZigZagSegment2D(radius, depth, zigzag_cutter_width);
        
      // Trim to shape
      translate([0, 0, -ManifoldGap(2)])
      linear_extrude(height=height+slotHeight+slotHeightExtra+ManifoldGap(4))
      semidonut(
          angle=angle+(zigzag_track_angle/2),
          major=(radius+depth)*2,
          minor=(radius-depth)*2,
          center=false);
    }
  }
}

module ZigZagSupport(radius,depth, width) {
  translate([radius - (depth*2),-0.07,0])
  hull() {
    cube([depth, 0.07, width]);
    
    translate([depth*0.9,0,width*2])
    cube([depth*2.2, 0.07, width]);
  }
}

module ZigZag(supports=true,
           radius=DEFAULT_ZIGZAG_DIAMETER/2,
           depth=DEFAULT_ZIGZAG_DEPTH,
           width=DEFAULT_ZIGZAG_WIDTH,
           positions=DEFAULT_ZIGZAG_POSITIONS,
           zigzagAngle=DEFAULT_ZIGZAG_ANGLE,
           extraTop=0, extraBottom=0,
           $fn=Resolution(30,90)) {

  positionAngle=360/positions;
  top_slot_height = (width/2)+extraTop;
  bottom_slot_height = (width/2)+extraBottom;

  zigzag_track_angle = TrackAngle(radius, width);
  zigzag_cutter_width = ZigZagCutterWidth(width, zigzagAngle);
  zigzag_height=ZigZagHeight(radius, positions, width, zigzagAngle+zigzag_track_angle);

  echo("ZigZag angle: ", zigzagAngle);
  echo("ZigZag positions: ", positions);
  echo("ZigZag position angle: ", positionAngle);
  echo("ZigZag radius: ", radius);
  echo("ZigZag depth: ", depth);
  echo("ZigZag track angle: ", zigzag_track_angle);
  echo("ZigZag track width: ", width);
  echo("ZigZag cutter width: ", zigzag_cutter_width);

  difference() {
    union() {
      for (i=[0:positions-1]){
        rotate([0,0,positionAngle*i]) {
          
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
    if (supports) {
      
      // Top
      translate([0,0,bottom_slot_height+zigzag_height-(width*0.5)])
      mirror([0,0,1])
      for (i=[0:positions-1])
      rotate([0,0,(positionAngle/2)+(positionAngle*i)-(TrackAngle(radius, width)/4)])
      ZigZagSupport(radius, depth, width);
      
      // Bottom
      translate([0,0,bottom_slot_height+width])
      for (i=[0:positions-1])
      rotate([0,0,(positionAngle*i)-(TrackAngle(radius, width)/4)])
      ZigZagSupport(radius, depth, width);
    }
  }
}

// Pin
*translate([DEFAULT_ZIGZAG_DIAMETER/2-DEFAULT_ZIGZAG_DEPTH, 0,DEFAULT_ZIGZAG_WIDTH/2])
rotate([0,90,0])
%cylinder(r=DEFAULT_ZIGZAG_WIDTH/2, h=DEFAULT_ZIGZAG_DEPTH*3, $fn=10);

ZigZag();
