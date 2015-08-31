module BoxMagazine(majorWidth=0.92, minorWidth=0.85, shellLength=2.5,
                   wallSide=1/8, wallFront=1/8, wallBack=1/8,
                   floorHeight=1/8, height=4) {

  widthDiff = majorWidth - minorWidth;
  halfDiff  = widthDiff/2;

  union() {
    difference() {
      linear_extrude(height=height)
      polygon([
        [0,0],
        [halfDiff,wallBack+shellLength+wallFront],
        [halfDiff+wallSide+minorWidth+wallSide, wallBack+shellLength+wallFront],
        [wallSide+majorWidth+wallSide, 0]
      ]);
      
      translate([0,0,floorHeight])
      linear_extrude(height=height+0.1)
      polygon([
        [wallSide,wallBack],
        [halfDiff+wallSide,wallBack+shellLength],
        [halfDiff+wallSide+minorWidth, wallBack+shellLength],
        [wallSide+majorWidth, wallBack]
      ]);
    }
  }
}



use <../Components/Semicircle.scad>;

module BoxMagazineSpring(springHeight=0.5, segmentLength=2.25, segmentWidth=0.06,
                         segments=5, angle=15, infill=1) {

  opposite = sin(angle) * segmentLength;
  adjacent = cos(angle) * segmentLength;
  spacing = opposite*2;

  linear_extrude(height=springHeight)
  union() {
    
    // Spring
    for(i = [0:segments-1]) {
      
      // Main Section
      translate([ceil(i/2) * spacing,0,0])
      rotate([0,0,(i % 2 == 0 ? -1 : 1) * angle])
      translate([-segmentWidth/2,0])
      square([segmentWidth, segmentLength]);
      
      // Strain Relief
      if (i != 0)
      translate([i * opposite,(i%2 == 0) ? 0 : adjacent,0])
      rotate([0,0,(i%2==0) ? 90 : -90])
      difference() {
        rotate([0,0,angle])
        semicircle(angle=angle*2, od=infill*2);
        
        translate([segmentWidth*3,0])
        rotate([0,0,angle*1.5])
        semicircle(angle=angle*3, od=infill*2);
      };
    }
    
    // Origin Print Adhesion Anchor
    translate([segmentWidth,segmentWidth*2,0])
    circle(r=segmentWidth*2, $fn=36);
    
    // Final Segment Print Adhesion Anchor
    translate([(opposite * segments),adjacent -(segmentWidth*2),0])
    circle(r=segmentWidth*2, $fn=36);
  }
}


module BoxMagazineFollower(majorWidth=0.88, minorWidth=0.81, length=2.45,
                           baseHeight=0.25, angle=15, cutLength=3/4) {
  
  widthDiff = majorWidth - minorWidth;
  halfDiff  = widthDiff/2;
  
  difference() {
    intersection() {
      linear_extrude(height=baseHeight + (tan(angle)*length))
      polygon([
        [0,0],
        [halfDiff,length],
        [halfDiff+minorWidth, length],
        [majorWidth, 0]
      ]);


      rotate([90,0,90])
      linear_extrude(height=majorWidth)
      polygon([
        [0,0],
        [0,baseHeight],
        [length-cutLength,(tan(angle)*(length-cutLength)) + baseHeight],
        [length,(tan(angle)*(length-cutLength)) + baseHeight],
        [length,0]
      ]);
    }
    
    // 
    translate([majorWidth/2,length+0.1,(tan(angle)*length) + minorWidth/3])
    rotate([90,0,0])
    cylinder(r=minorWidth/2, h=length, $fn=36);
  }
}

scale([25.4, 25.4, 25.4]) {
  //translate([-1/8, -1/8,0])
  BoxMagazine(height=1);
  
  translate([0,-1,0])
  rotate([0,0,-90])
  //rotate([0,-90,0])
  BoxMagazineSpring();
  
  //translate([1/8,1/8,0])
  translate([-2,0,0])
  BoxMagazineFollower();
}
