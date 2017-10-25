use <../Components/Teardrop.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Manifold.scad>;

module RoundedBoolean(edgeOffset=1, edgeSign=-1,
                      r=0.25,
                      teardrop=false, teardropAngle=-90) {
  difference() {
    translate([edgeOffset-r,-r])
    square([r*2, r*2]);

    translate([edgeOffset+(edgeSign*r),r]) {
      if (teardrop){
        rotate(teardropAngle)
        Teardrop(r=r);
      } else {
        circle(r=r);
      }
    }
  }

}

module HoleChamfer(r1=0.5, r2=0.125, teardrop=false) {
  rotate_extrude()
  RoundedBoolean(r=r2,
                 edgeOffset=r1,
                 edgeSign=1,
                 teardrop=teardrop);
}

module SquareHoleEndChamfer(xy=1, r=0.125, teardrop=true, teardropAngle=-90, center=false) {
  render()
  translate([center ? -xy/2 : 0, center ? -xy/2 : 0, 0])
  difference() {
    
    translate([-r,-r,-r])
    cube([xy+(r*2), xy+(r*2), r*2]);
    
    for (axy = [[0,-r,-r], [90,-r,r], [0,-r,xy+r], [90,-r,-xy-r]])
    rotate([0,0,axy[0]])
    translate([axy[1]-ManifoldGap(),axy[2],r])
    rotate([90,0,90])
    linear_extrude(height=xy+(r*2)+ManifoldGap(2)) {
      if (teardrop){
        rotate(teardropAngle)
        Teardrop(r=r);
      } else {
        circle(r=r);
      }
    }
  }
}

module ChamferedSquare(xy=[1,1], r=0.25, teardrop=true, teardropTruncated=true, $fn=40) {
  hull()
  for (mX = [r,xy[0]-r]) {
    // Top Circle
    translate([mX, xy[1]-r])
    circle(r);

    // Bottom
    translate([mX, r])
    if (teardrop){
      rotate(-90)
      Teardrop(r, truncated=teardropTruncated, $fn=$fn);
    } else {
      circle(r);
    }
  }

}

module ChamferedCube(xyz=[1,2,3], r=0.25, center=false, fn=20) {
  
  translate([center ? -xyz[0]/2 : 0,
              center ? -xyz[1]/2 : 0,
              center ? -xyz[2]/2 : 0])
  intersection() {

    // X
    rotate([90,0,90])
    linear_extrude(height=xyz[0])
    ChamferedSquare(xy=[xyz[1], xyz[2]], r=r, $fn=fn);

    // Y
    mirror([0,1,0])
    rotate([90,0,0])
    linear_extrude(height=xyz[1])
    ChamferedSquare(xy=[xyz[0], xyz[2]], r=r, $fn=fn);
    
    // Z
    linear_extrude(height=xyz[2])
    ChamferedSquare(xy=[xyz[0], xyz[1]], r=r, teardrop=false, $fn=fn);
  }
}


module CylinderChamfer(r1=1, r2=0.25, teardrop=false) {
  rotate_extrude()
  RoundedBoolean(r=r2,
                 edgeOffset=r1,
                 edgeSign=-1,
                 teardrop=teardrop);
}

module CylinderChamferEnds(r1=1, r2=0.25, h=1) {
  render() {

    // Keep the bottom teardropped for printing
    CylinderChamfer(r1=r1, r2=r2, teardrop=true);

    // We can round the top over
    translate([0,0,h])
    mirror([0,0,1])
    CylinderChamfer(r1=r1, r2=r2, teardrop=false);
  }
}


module ChamferedCylinder(r1=0.5, r2=0.25, h=1) {
  render()
  difference() {
    cylinder(r=r1, h=h);
    CylinderChamferEnds(r1=r1, r2=r2, h=h);
  }
}

render() {
  difference() {
    ChamferedCube(xyz=[2,2,2], center=false);
    
    translate([0.5, 0.5, 0])
    ChamferedSquareHole(side=1, length=2, center=false);
  }

  translate([2.5, 0.5, 0])
  ChamferedSquareHole(side=1, length=2, center=false);
}


module ChamferedSquareHole(side=1, length=1, center=true,
                           chamferTop=true, chamferBottom=true, chamferRadius=0.1,
                           corners=true, cornerRadius=0.1) {
  render()
  union() {
  
    // Square Tube
    translate([0,0,chamferBottom ? -chamferRadius/2 : 0])
    linear_extrude(height=length
                         +(chamferTop?chamferRadius/2:0)
                         +(chamferBottom?chamferRadius/2:0)) {
      square(side, center=center);
  
      if (corners)
      translate([center ? -side/2 : 0,center ? -side/2 : 0])
      for (xy = [[0,0], [0, side], [side,0], [side,side]])
      translate([xy[0], xy[1]])
      circle(r=cornerRadius, $fn=20);
    }
      
    // Chamfer the bottom
    if (chamferBottom)
    SquareHoleEndChamfer(xy=side, r=chamferRadius, center=center);
    
    // Chamfer the tube front
    if (chamferTop)
    translate([0,0,length])
    mirror([0,0,1])
    SquareHoleEndChamfer(xy=side, r=chamferRadius, center=center, teardrop=true);
  }
}

translate([-1.5,0,0])
ChamferedSquare(xy=[1,2]);

translate([-3,0,0])
ChamferedCube(r=0.125);


translate([0,-2,0]) {
  RoundedBoolean(teardrop=true, $fn=20);

  translate([0,0,0])
  HoleChamfer($fn=20);

  // Chamfered Cylinder
  translate([-1.5,0,0])
  ChamferedCylinder(r1=0.5, r2=0.25, h=1, $fn=50);
}
