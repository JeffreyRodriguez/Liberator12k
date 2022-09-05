use <../Shapes/Chamfer.scad>;

extrusionWidth=20*(20/19.6)+0.1;
centerWidth = 6.3;
wall=1.5;
height=50;
depth=40;

tapDiameter = 6;

render()
difference() {
  ChamferedCube([extrusionWidth+(wall*2),extrusionWidth+(wall*2),height],
                r=1);
    
  translate([wall,wall, height-depth])
  cube([extrusionWidth,extrusionWidth, depth+1]);
  
  translate([(extrusionWidth/2)+wall,(extrusionWidth/2)+wall,0])
  ChamferedCircularHole(r1=(tapDiameter/2), r2=1, h=height-depth, $fn=30);
  
  translate([(extrusionWidth/2)+wall,(extrusionWidth/2)+wall,0])
  for (R = [0:6]) rotate(360/6*R) translate([tapDiameter+1,0,0])
  ChamferedCircularHole(r1=extrusionWidth/10, r2=1, h=height-depth, $fn=30);
  
}