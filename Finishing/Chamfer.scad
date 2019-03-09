use <../Shapes/Teardrop.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Manifold.scad>;

module RoundedBoolean(edgeOffset=1, edgeSign=-1,
                      r=0.25, angle=0,
                      teardrop=false, teardropAngle=-90) {
  translate([edgeOffset,0])
  rotate(angle)
  difference() {
    translate([-r,-r])
    square([r*2, r*2]);

    translate([(edgeSign*r),r]) {
      if (teardrop){
        rotate(teardropAngle)
        Teardrop(r=r);
      } else {
        circle(r=r);
      }
    }
  }

}

module Fillet(r=0.125, h=1, inset=false, taperEnds=true) {
  effectiveHeight = h -(inset ? r*2 : 0);
  
  
  render()
  translate([-ManifoldGap(2),-ManifoldGap(2),(inset ? r : 0)])
  difference() {
    linear_extrude(height=effectiveHeight)
    intersection() {
      RoundedBoolean(edgeOffset=0, r=r, teardrop=false, $fn=40);
      
      translate([ManifoldGap(), -ManifoldGap()])
      rotate(90)
      square(r+ManifoldGap());
    }
    
    if (taperEnds)
    for (m = [0,1]) translate([0,0,m ? effectiveHeight : 0]) mirror([0,0,m])
    translate([-r,r,-ManifoldGap()])
    cylinder(r1=r*sqrt(2), r2=0, h=r*sqrt(2)*2, $fn=40);
  }
}


module VerticalFillet(r=0.125, h=1, inset=false, taperEnds=true) {
  Fillet(r=r, h=h, inset=inset, taperEnds=taperEnds);
}

module HoleChamfer(r1=0.5, r2=0.125, teardrop=false, edgeSign=1) {
  rotate_extrude()
  RoundedBoolean(r=r2,
                 edgeOffset=r1,
                 edgeSign=1,
                 teardrop=teardrop);
}

module CircularOuterEdgeChamfer(r1=0.5, r2=0.125, teardrop=false) {
  rotate_extrude()
  RoundedBoolean(r=r2,
                 edgeOffset=r1,
                 edgeSign=-1,
                 teardrop=teardrop);
}

module SquareHoleEndChamfer(xy=[1,1], r=0.125, teardrop=true, teardropAngle=-90, center=false) {
  render()
  translate([center ? -xy[0]/2 : 0, center ? -xy[1]/2 : 0, 0])
  difference() {
    
    translate([-r,-r,-r])
    cube([xy[0]+(r*2), xy[1]+(r*2), r*2]);
    
    for (axyl = [[0,-r,-r,xy[0]], [90,-r,r,xy[1]], [0,-r,xy[1]+r,xy[0]], [90,-r,-xy[0]-r,xy[1]]])
    rotate([0,0,axyl[0]])
    translate([axyl[1]-ManifoldGap(),axyl[2],r])
    rotate([90,0,90])
    linear_extrude(height=axyl[3]+(r*2)+ManifoldGap(2)) {
      if (teardrop){
        rotate(teardropAngle)
        Teardrop(r=r);
      } else {
        circle(r=r);
      }
    }
  }
}

module ChamferedSquareHole(sides=[1,1], length=1, center=true,
                           chamferTop=true, chamferBottom=true, chamferRadius=0.1,
                           teardropTop=true, teardropBottom=true,
                           corners=true, cornerRadius=0.1) {
  render()
  union() {
  
    // Square Tube
    translate([0,0,chamferBottom ? -chamferRadius/2 : 0])
    linear_extrude(height=length
                         +(chamferTop?chamferRadius/2:0)
                         +(chamferBottom?chamferRadius/2:0)) {
      square(sides, center=center);
  
      if (corners)
      translate([center ? -sides[0]/2 : 0,center ? -sides[1]/2 : 0])
      for (xy = [[0,0], [0, sides[1]], [sides[0],0], [sides[0],sides[1]]])
      translate([xy[0], xy[1]])
      circle(r=cornerRadius, $fn=20);
    }
      
    // Chamfer the bottom
    if (chamferBottom)
    SquareHoleEndChamfer(xy=sides, r=chamferRadius, center=center, teardrop=teardropTop);
    
    // Chamfer the tube front
    if (chamferTop)
    translate([0,0,length])
    mirror([0,0,1])
    SquareHoleEndChamfer(xy=sides, r=chamferRadius, center=center, teardrop=teardropBottom);
  }
}

module ChamferedSquare(xy=[1,1], r=0.25,
                       teardrop=true, teardropTop=true, teardropTruncated=true) {
  hull()
  for (mX = [r,xy[0]-r]) {
    // Top Circle
    translate([mX, xy[1]-r])
    if (teardrop) {
      rotate(90)
      Teardrop(r=r, truncated=teardropTruncated, $fn=60);
    } else {
      circle(r=r, $fn=60);
    }

    // Bottom
    translate([mX, r])
    if (teardrop){
      rotate(-90)
      Teardrop(r=r, truncated=teardropTruncated, $fn=60);
    } else {
      circle(r=r, $fn=60);
    }
  }

}

module ChamferedCube(xyz=[1,2,3], r=0.25, center=false, fn=20,
                     chamferXYZ=[1,1,1],
                     teardropXYZ=[true, true, true],
                     teardropTopXYZ=[true, true, true]) {
  
  translate([center ? -xyz[0]/2 : 0,
              center ? -xyz[1]/2 : 0,
              center ? -xyz[2]/2 : 0])
  intersection() {

    // X
    if (chamferXYZ[0])
    rotate([90,0,90])
    linear_extrude(height=xyz[0])
    ChamferedSquare(xy=[xyz[1], xyz[2]], r=r, $fn=fn,
                    teardrop=teardropXYZ[0], teardrop=teardropTopXYZ[0]);

    // Y
    if (chamferXYZ[1])
    mirror([0,1,0])
    rotate([90,0,0])
    linear_extrude(height=xyz[1])
    ChamferedSquare(xy=[xyz[0], xyz[2]], r=r, $fn=fn,
                    teardrop=teardropXYZ[1], teardrop=teardropTopXYZ[1]);
    
    // Z
    if (chamferXYZ[2])
    linear_extrude(height=xyz[2])
    ChamferedSquare(xy=[xyz[0], xyz[1]], r=r, $fn=fn,
                    teardrop=teardropXYZ[2], teardrop=teardropTopXYZ[2]);
  }
}


module CylinderChamfer(r1=1, r2=0.25, teardrop=false) {
  rotate_extrude()
  RoundedBoolean(r=r2,
                 edgeOffset=r1,
                 edgeSign=-1,
                 teardrop=teardrop);
}

module CylinderChamferEnds(r1=1, r2=0.25, h=1,
                           chamferBottom=true, chamferTop=true,
                           teardropBottom=true, teardropTop=false) {
  render() {

    // Keep the bottom teardropped for printing
    if (chamferBottom)
    CylinderChamfer(r1=r1, r2=r2, teardrop=teardropBottom);

    // We can round the top over
    if (chamferTop)
    translate([0,0,h])
    mirror([0,0,1])
    CylinderChamfer(r1=r1, r2=r2, teardrop=teardropTop);
  }
}


module ChamferedCylinder(r1=0.5, r2=0.25, h=1,
                         chamferBottom=true, chamferTop=true,
                           teardropBottom=true, teardropTop=false) {
  render()
  difference() {
    cylinder(r=r1, h=h);
    CylinderChamferEnds(r1=r1, r2=r2, h=h,
                        chamferBottom=chamferBottom,
                        chamferTop=chamferTop,
                        teardropBottom=teardropBottom,
                        teardropTop=teardropTop);
  }
}




module ChamferedCircularHole(r1=1, r2=0.1, h=1,
                             chamferTop=true, chamferBottom=true,
                             teardropBottom=true, teardropTop=false) {
  union() {
  
    // Bottom Chamfer
    if (chamferBottom)
    HoleChamfer(r1=r1, r2=r2, teardrop=teardropBottom);
    
    // TopChamfer
    if (chamferTop)
    translate([0,0,h])
    mirror([0,0,1])
    HoleChamfer(r1=r1, r2=r2, teardrop=teardropTop);
  
    // Center
    translate([0,0,-r2])
    cylinder(r=r1, h=h+(r2*2));
  }
}

module ChamferedToroidalCylinder(r1=1, r2=0.5, r3=0.1, h=1) {
  difference() {
    ChamferedCylinder(r1=r1, r2=r3, h=h);
    ChamferedCircularHole(r1=r2, r2=r3, h=h);
  }
}


//$fn=20;
render() {
  difference() {
    ChamferedCube(xyz=[2,3,2], center=false);
    
    translate([0.5, 0.5, 0])
    ChamferedSquareHole(sides=[1,2], length=2, center=false);
  }

  translate([2.5, 0.5, 0])
  ChamferedSquareHole(sides=[1,2], length=2, center=false);
}

translate([-1.5,0,0])
ChamferedSquare(xy=[1,2]);

translate([-3,0,0])
ChamferedCube(r=0.125, chamferXYZ=[1,1,1]);

translate([-4,0,0]) {
  Fillet();
}

translate([0,-2,0]) {
  RoundedBoolean(teardrop=true, $fn=20);
  
  translate([0,-2,0])
  CircularOuterEdgeChamfer(r1=0.5, r2=0.125, teardrop=false, $fn=20);
  
  translate([0,-4, 0])
  ChamferedCircularHole(r1=1, r2=0.125, h=1, $fn=20);

  translate([0,0,0])
  HoleChamfer($fn=20);

  // Chamfered Cylinder
  translate([-2.5,0,0])
  ChamferedToroidalCylinder(r1=1, r2=0.5, r3=0.1, h=1, $fn=50);
}
