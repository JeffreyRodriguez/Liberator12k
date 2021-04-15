module FlipMirror(offsets=[0,0,0]) {
  
  // Right-side
  translate([offsets.x,-offsets.y,offsets.z])
  children();
  
  // Left-side text
  translate([offsets.x,offsets.y,offsets.z])
  rotate(180)
  children();
}


FlipMirror()
translate([-0.5,0,0])
cube([1,1,1]);