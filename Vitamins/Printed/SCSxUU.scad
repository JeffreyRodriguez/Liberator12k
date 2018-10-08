use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Meta/Manifold.scad>;
use <../../Finishing/Chamfer.scad>;

module PrintedBearingSurface2d(r=4, depth=1, segment=1.2) {
  diameter = 2*r;
  circumference = PI * diameter;

  segments = floor(circumference / segment);
  segments = r*6;

  union() {
    circle(r, $fn=r*6);

    for (i = [0:segments-1])
    rotate(360/segments*i*2)
    semicircle(od=(r+depth)*2, angle=360/segments/2, center=true);
  }
}

module PrintedBearingSurface(r=4, depth=1, segment=1.2, length=30, taperDepth=2, center=true) {
  render()
  union() {
    linear_extrude(height=length, center=center)
    PrintedBearingSurface2d(r, depth, segment);

    for (m = [0,1])
    mirror([0,0,m])
    translate([0,0,-(length/2)+taperDepth+ManifoldGap()])
    mirror([0,0,1])
    linear_extrude(height=(r+depth)*2, scale=2)
    PrintedBearingSurface2d(r, depth, segment);
  }
}

SCSxUU_BoltDiameter  = 1;
SCSxUU_BoltOffset    = 2;
SCSxUU_BoltSpacing   = 3;
SCSxUU_Length        = 4;
SCSxUU_Width         = 5;
SCSxUU_Height        = 6;
SCSxUU_InnerDiameter = 7;

function SCSxUU_BoltDiameter(spec)  = lookup(SCSxUU_BoltDiameter, spec);
function SCSxUU_BoltOffset(spec)    = lookup(SCSxUU_BoltOffset, spec);
function SCSxUU_BoltSpacing(spec)   = lookup(SCSxUU_BoltSpacing, spec);
function SCSxUU_Length(spec)        = lookup(SCSxUU_Length, spec);
function SCSxUU_Width(spec)         = lookup(SCSxUU_Width, spec);
function SCSxUU_Height(spec)        = lookup(SCSxUU_Height, spec);
function SCSxUU_InnerDiameter(spec) = lookup(SCSxUU_InnerDiameter, spec);
function SCSxUU_InnerRadius(spec)   = lookup(SCSxUU_InnerDiameter, spec)/2;

function Spec_SCS8UU() = [
  [SCSxUU_BoltDiameter,   4],
  [SCSxUU_BoltOffset,    12],
  [SCSxUU_BoltSpacing,   18],
  [SCSxUU_Length,        30],
  [SCSxUU_Width,         34],
  [SCSxUU_Height,        22],
  [SCSxUU_InnerDiameter, 8]
];

function Spec_SCS8LUU() = [
  [SCSxUU_BoltDiameter,   4],
  [SCSxUU_BoltOffset,    12],
  [SCSxUU_BoltSpacing,   42],
  [SCSxUU_Length,        58],
  [SCSxUU_Width,         34],
  [SCSxUU_Height,        22],
  [SCSxUU_InnerDiameter, 8]
];

module SCSxUU_Bolts(spec=undef, clearance=0.02, extraLength=0, teardropAngle=0) {
    translate([0,0,0])
    rotate([0,-90,0])
    linear_extrude(height=SCSxUU_Height(spec)+extraLength, center=true)
    for (X = [-1,1])
    for (Y = [-1,1])
    translate([X*SCSxUU_BoltSpacing(spec)/2,Y*SCSxUU_BoltOffset(spec)])
    rotate(teardropAngle)
    Teardrop(r=SCSxUU_BoltDiameter(spec)/2, truncated=true);
}

module SCSxUU(spec=undef, clearance=0.02) {

  render()
  difference() {
    ChamferedCube(xyz=[SCSxUU_Height(spec),
                       SCSxUU_Width(spec),
                       SCSxUU_Length(spec)],
                  r=2, center=true);

    PrintedBearingSurface(r=SCSxUU_InnerRadius(spec)+clearance,
                          length=SCSxUU_Length(spec), center=true);

    SCSxUU_Bolts(spec=spec, clearance=clearance, extraLength=ManifoldGap(2));
  }
}

SCSxUU(spec=Spec_SCS8LUU(), boltSpec=Spec_BoltM4());
