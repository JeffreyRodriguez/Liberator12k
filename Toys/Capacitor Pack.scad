use <../Shapes/Chamfer.scad>;

capDiameter = 23+1;
capRadius = capDiameter/2;
capHeight = 47;
capCount = 6;

WALL=2;
WALL2=WALL*2;

brickWidth=3;
brickSpacerHeight=8;
  
module CapModule() {
  difference() {
    translate([-WALL-capRadius,-WALL-capRadius,0])
    ChamferedCube([((capDiameter+WALL)*capCount)+WALL,capDiameter+WALL2,capHeight+WALL], r=1);

    for (i = [0:capCount-1])
    translate([(capDiameter+WALL)*i,0,0]) {
      translate([0,0,WALL])
      cylinder(r=capRadius, h=capHeight+0.5);
      
      translate([0,0,-WALL/2])
      cylinder(r=capRadius*0.75, h=WALL2);
    }
  }
}

module CapBrick() {
  for (i = [0:brickWidth-1])
  translate([0,(capDiameter+(WALL*2))*i,0]) {
  translate([0,0,WALL])
  CapModule();
  }
}

module CapBrickSpacer() {
  render()
  difference() {
    CapBrickSpacerBase();
    
    // Parallel Wiring cutouts
    translate([WALL-(capRadius*0.75),WALL2-capRadius+WALL,-1])
    cube([((capDiameter+WALL)*capCount)-WALL2-(capRadius*0.75),
          ((capDiameter)*brickWidth)-WALL2,
          brickSpacerHeight+2]);
  }
}

module CapBrickSpacerCenter() {
  render()
  intersection() {
    CapBrickSpacerBase();
    
    // Parallel Wiring cutouts
    translate([WALL,WALL2,-1])
    cube([((capDiameter+WALL)*capCount)-WALL2-capDiameter-WALL,
          (capDiameter)-WALL2,
          brickSpacerHeight+2]);
  }
}

module CapBrickSpacerBase() {
  render()
  difference() {
    translate([-WALL-capRadius,-WALL-capRadius,0])
    ChamferedCube([((capDiameter+WALL)*capCount)+WALL,
                   ((capDiameter+WALL2)*brickWidth),
                   brickSpacerHeight], r=1);

    for (i = [0:capCount-1])
    for (n = [0:brickWidth-1])
    translate([(capDiameter+WALL)*i,(capDiameter+WALL2)*n,-0.1])
    cylinder(r=capRadius, h=brickSpacerHeight+0.2);
    
    // Terminal holes
    for (i = [0,capCount-2])
    translate([(capDiameter+WALL)*i,capRadius+WALL,-0.1])
    translate([capRadius+(WALL/2),0,0])
    cylinder(r=4, h=brickSpacerHeight+0.2);
  }
}
  
*CapModule();

CapBrick();

translate([0,0,capHeight+WALL2]) {
  
  CapBrickSpacer();
  
  for (Y = [0,capDiameter+WALL2])
  translate([0,Y,0])
  CapBrickSpacerCenter();
}