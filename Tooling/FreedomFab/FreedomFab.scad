use <../../Vitamins/Printed/SCSxUU.scad>;

use <../../Components/Dovetail.scad>;
use <../../Components/Semicircle.scad>;
use <../../Components/Teardrop.scad>;
use <../../Components/Set Screw.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Meta/Manifold.scad>;
use <../../Finishing/Chamfer.scad>;

DEFAULT_BEARING_SPEC = Spec_SCS8LUU();

dovetailLength = 15;
dovetailWidth  = 30;
dovetailHeight = 25;

xRodLength = 200;
yRodLength = 200;

xBearingSpec = Spec_SCS8LUU();
yBearingSpec = Spec_SCS8LUU();
rodRadius = 4;
wall = 5;
xRodOffsetY = (SCSxUU_BoltSpacing(spec=xBearingSpec)/2)
             - (SCSxUU_BoltDiameter(spec=xBearingSpec)/2)
             - rodRadius;

xRodOffsetZ = SCSxUU_OrthagonalRodOffsetHeight(
                spec=xBearingSpec,
                rodRadius=rodRadius)
            + wall;

xRodOffsetY = SCSxUU_OrthagonalRodOffsetLength(
                spec=xBearingSpec,
                rodRadius=rodRadius)+wall;
xRodOffsetZ = rodRadius;


function SCSxUU_OrthagonalRodOffsetWidth(spec=undef)
    = SCSxUU_InnerRadius(spec)+(SCSxUU_Width(spec)/2);
    
function SCSxUU_OrthagonalRodOffsetHeight(spec=undef)
    = SCSxUU_InnerRadius(spec)+(SCSxUU_Height(spec)/2);
    
function SCSxUU_OrthagonalRodOffsetLength(spec=undef)
    = SCSxUU_InnerRadius(spec)+(SCSxUU_Length(spec)/2);

module FreedomFab_SlideY(spec=DEFAULT_BEARING_SPEC, xRodOffsetY=0, wall=5,
    spec=undef,
    clearance=0.03) {

  width = (SCSxUU_Width(spec=spec));
  rodRadius = SCSxUU_InnerRadius(spec=spec);
  rodOffsetZ = wall/2;
  
  
  rodRadius = SCSxUU_InnerRadius(spec=spec);
  
  
  bearingHeight = 6;
  bearingOD = 12;
  bearingID = 4;
  
  
  bearingOffsetZ  = SCSxUU_OrthagonalRodOffsetWidth(spec=spec, rodRadius=rodRadius)
                  - SCSxUU_BoltOffset(spec);
  
  // Bearing block
  
  %translate([0,0,-SCSxUU_Height(spec)/2])
  rotate([-90,90,0]) {
    SCSxUU(spec=yBearingSpec);
    
    cylinder(r=rodRadius, h=yRodLength, center=true);
  }
  
  // Y-Slide bracket
  color("Orange")
  render()
  difference() {
    
    render()
    difference() {
      union() {
        
        // Faceplate
        translate([-width/2,-xRodOffsetY,0])
        rotate([90,0,90])
        ChamferedCube(xyz=[xRodOffsetY*2, wall, width], r=1);
        
        // Rod Brackets
        render()
        for (Y = [-1, 1])
        translate([-width/2,xRodOffsetY*Y,rodOffsetZ])
        rotate([0,90,0])
        ChamferedCylinder(r1=rodRadius+wall, r2=1, h=width, $fn=30);
      }
      
      // Rod Holes
      for (Y = [-1, 1])
      translate([0,xRodOffsetY*Y,rodOffsetZ])
      rotate([0,90,0])
      cylinder(r=rodRadius+clearance, h=width+ManifoldGap(2), center=true);
      
      // Bolt Holes
      rotate([0,0,90])
      linear_extrude(height=width+ManifoldGap(2))
      projection(cut=false)
      rotate([0,-90,0])
      SCSxUU_Bolts(spec=spec, teardropAngle=0);
    }
    
    // Line Bearings
    *translate([(SCSxUU_Height(spec)/2)+(bearingOD/2)+wall,0,0])
    rotate([90,0,0])
    rotate(-90) {
      for (i = [-1,1])
      translate([0,0,bearingOffsetZ*i])
      linear_extrude(height=bearingHeight+1, center=true) {
        circle(r=(bearingOD/2)+1);
        
        for (r=[0,90])
        rotate(r)
        translate([-bearingOD/2,-(bearingOD/2)-wall-ManifoldGap()])
        square([bearingOD, bearingOD+wall+10]);
      }
      
      // Screw body
      hull()
      for(X=[0,-wall-(bearingOD/2)])
      translate([0,X,0])
      cylinder(r=bearingID/2, h=31.8, center=true);
      
      // Screw cap
      hull()
      for(X=[0,-wall-(bearingOD/2)])
      translate([0,X,0])
      cylinder(r=bearingID/2, h=31.8, center=true);
    }
  }
}

module FreedomFab_SlideX(spec=xBearingSpec, wall=5,  clearance=0.5, cutter=false) {
  
  rodOffsetY = SCSxUU_OrthagonalRodOffsetWidth(spec=yBearingSpec, rodRadius=rodRadius);
  
  if (!cutter)
  %rotate([90,0,90]) {
    SCSxUU(spec=spec);
  
    cylinder(r=rodRadius, h=xRodLength, center=true);
  }
  
  color("SteelBlue")
  render()
  translate([0,SCSxUU_Height(spec)/2,0])
  union() {
    
    // Bolt plate
    if (!cutter)
    difference() {
      translate([-SCSxUU_Length(spec)/2,0,-SCSxUU_Width(spec)/2])
      ChamferedCube(xyz=[SCSxUU_Length(spec),wall,SCSxUU_Width(spec)], r=1, $fn=30);
      
      rotate([-90,0,0])
      translate([0,0,-ManifoldGap()])
      linear_extrude(height=wall+ManifoldGap(2))
      projection(cut=false)
      rotate([0,-90,0])
      SCSxUU_Bolts(spec=spec, clearance=clearance, teardropAngle=-90);
    }
    
    // Dovetail
    translate([0,0,-SCSxUU_Width(spec)/2])
    linear_extrude(height=dovetailHeight)
    translate([0,wall-ManifoldGap()])
    Dovetail2d(length=dovetailLength,
               width=dovetailWidth,
               center=true,
               clearance=clearance,
               cutter=cutter);
  }
  
}

module FreedomFab_CarriageCutter(clearance=0.5) {
    
  // Dovetails    
  for (i = [-1,1])
  translate([0, xRodOffsetY*i, xRodOffsetZ])
  rotate([0,0,90+(90*i)])
  FreedomFab_SlideX(spec=xBearingSpec, wall=wall, cutter=true);
}

module FreedomFab_Carriage(spec=DEFAULT_BEARING_SPEC, wall=5, clearance=0.5) {
  
  length = (2*(xRodOffsetY - (SCSxUU_Height(xBearingSpec)/2) - wall)) - clearance;
  width = dovetailWidth+(wall*2);//SCSxUU_Length(xBearingSpec);
  height = SCSxUU_Width(spec);
  
  color("Green")
  render()
  difference() {
    intersection() {
      translate([-width/2,-length/2,xRodOffsetZ-(height/2)])
      ChamferedCube(xyz=[width,length,height], r=1, $fn=30);
      
      // HAAAAAAACK: Cut off the tips to clear the bolt heads
      hull() {
        for (x = [1,-1])
        for (y = [1,-1])
        for (w = [-1,1])
        translate([((width/2)+(wall*w)-wall)*x,
                   ((length/2)-(wall*w)-wall)*y,
                   xRodOffsetZ-(height/2)-ManifoldGap()])
        cylinder(r=1, $fn=30, h=height+ManifoldGap(2));
      }
    }
    
    
    FreedomFab_CarriageCutter();
  }
  
}

module FreedomFab_DriveWheel(id=5, od=15, height=35, clearance=0.625, dWidth=4) {
  setScrewOffsetZ = 5;
  
  render()
  difference() {
    ChamferedCylinder(r1=od/2, r2=1, h=height, $fn=40);
    
    // D-profile shaft
    translate([0,0,-ManifoldGap()])
    difference() {
      cylinder(r=(id/2)+clearance, h=height+ManifoldGap(2), $fn=16);
      
      // D-cut
      translate([-(id/2)+dWidth+clearance,-od/2, setScrewOffsetZ+3-ManifoldGap()])
      cube([od, od, height+ManifoldGap(2)]);
    }
    
    // Low area of the spool
    rotate_extrude(angle=360, $fn=40)
    hull()
    for (Y = [setScrewOffsetZ+5, height-3])
    translate([od/2,Y,0])
    rotate(90)
    Teardrop(r=1, $fn=40);
    
    // Spool 'threads'
    threadCount = 5;
    threadPitch = 1/20;
    threadHeight = 10;
    threadSteps = 4;
    threadDepth = 1;
    
    // Beware: Hacky stepping in leiu of sweep()
    render() union()
    translate([0,0,height-threadHeight-4])
    for (R = [1:threadSteps])
    linear_extrude(twist=threadCount*360,
                   height=threadHeight,
                   slices=threadCount*40,
                   scale=1)
    rotate(180/threadSteps*R)
    semidonut(minor=od-2-threadDepth+(threadDepth/threadSteps*R),
              major=od,
              angle=180/R, $fn=40);
    
    
    // Set Screw hole
    translate([0,0,setScrewOffsetZ])
    rotate([0,90,0])
    cylinder(r=1.25, h=od*2, center=true, $fn=20);
  }
}


// Motors
for (m = [-1,1]) translate([xRodLength/2*m,-(yRodLength/2) - 30,0]) mirror([m,0,0])
!FreedomFab_DriveWheel();

// Y-Slide
for (m = [-1,1]) translate([xRodLength/2*m,0,0]) mirror([m,0,0])
FreedomFab_SlideY(
  spec=yBearingSpec,
  xRodOffsetY=xRodOffsetY,
  wall=wall);

// X-Slide
for (i = [-1,1])
translate([0, xRodOffsetY*i, xRodOffsetZ])
rotate([0,0,90+(90*i)])
FreedomFab_SlideX(spec=xBearingSpec, dovetail=true, wall=wall);

//!mirror([0,0,1])
translate([0, 0, xRodOffsetZ + (SCSxUU_Height(yBearingSpec)/2) + ManifoldGap()])
FreedomFab_Carriage(spec=xBearingSpec, dovetail=true, wall=wall);