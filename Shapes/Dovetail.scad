use <../Meta/Manifold.scad>;

DEFAULT_DOVETAIL_ANGLE  = 65;
DEFAULT_DOVETAIL_LENGTH = 15;
DEFAULT_DOVETAIL_WIDTH  = 30;
DEFAULT_DOVETAIL_HEIGHT = 25.4;

DEFAULT_DOVETAIL_LENGTH = 10;
DEFAULT_DOVETAIL_WIDTH  = 42;
DEFAULT_DOVETAIL_HEIGHT = 10;

function DovetailTabOffset(length=DEFAULT_DOVETAIL_LENGTH,
                            angle=DEFAULT_DOVETAIL_ANGLE)
                           = cos(angle)*length;
function DovetailTabDepth(length=DEFAULT_DOVETAIL_LENGTH,
                            angle=DEFAULT_DOVETAIL_ANGLE)
                           = sin(angle)*length;

module Dovetail2d(width=DEFAULT_DOVETAIL_WIDTH,
                 length=DEFAULT_DOVETAIL_LENGTH,
                  angle=DEFAULT_DOVETAIL_ANGLE, bevel=1.5, clearance=0.5,
                  center=false, cutter=false) {

  offset(r=cutter ? clearance : 0)
  translate([center ? -width/2 : 0, 0, 0])
  polygon([[(cos(angle)*length),0],                     // Bottom left
           [width-(cos(angle)*length), 0],              // Bottom right

           // Top right (beveled)
           [width-(cos(angle)*bevel), (sin(angle)*(length-bevel))],
           [width-bevel, (sin(angle)*(length))],

           // Top left (beveled)
           [bevel, (sin(angle)*length)],
           [cos(angle)*bevel, (sin(angle)*(length-bevel))],
    ]);

  if (cutter)
  translate([center ? -width/2 : 0, 0, 0])
  translate([(cos(angle)*length)-1,-1])
  square([width-(cos(angle)*length*2)+2,(sin(angle)*length)/2]);
}
