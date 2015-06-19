module BoxMagazine(shellDiameter=0.95, shellLength=3,
                   wallSide=1/8, wallFront=1/8, wallBack=1/8,
                   capacity=3) {
                     
  linear_extrude(height=shellDiameter*capacity)
  difference() {
    square([shellDiameter + (wallSide*2),
            shellLength + wallFront + wallBack]);
    
    translate([wallSide, wallBack])
    square([shellDiameter, shellLength]);
  }
}

scale([25.4, 25.4, 25.4])
BoxMagazine();