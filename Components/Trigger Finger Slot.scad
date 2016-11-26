use <../Meta/Resolution.scad>;

function TriggerFingerDiameter() = 1;
function TriggerFingerRadius() = TriggerFingerDiameter()/2;

module TriggerFingerSlot(radius=TriggerFingerRadius(), length=0.6, $fn=Resolution(12, 60)) {
  
  hull()
  for (i = [0,length])
  translate([i,0,-radius])
  rotate([90,0,0])
  cylinder(r=radius,
           h=2, $fn=$fn, center=true);
}

TriggerFingerSlot();