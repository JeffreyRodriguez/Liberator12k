module ReferenceBuildArea(x=3.9, y=3.9, z=3.9) {
  color("Red", 0.1)
  %cube([x,y,z]);
}

scale([25.4, 25.4, 25.4])
ReferenceBuildArea();