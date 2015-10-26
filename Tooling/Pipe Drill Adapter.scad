use <../Vitamins/Pipe.scad>;

module PipeDrillAdapter(pipe=Spec_TubingOnePointOneTwoFive(), extension=1/2, wall=2/16,
                        nutHeight=0.26, nutDiameter=0.58, boltDiameter=0.35) {
  totalHeight = wall+nutHeight+extension;

  difference() {
    
    // Body
    cylinder(r=PipeOuterRadius(pipe, PipeClearanceSnug())+wall, h=totalHeight, $fn=PipeFn(pipe));

    // Pipe hole
    translate([0,0,wall+nutHeight])
    Pipe(pipe=pipe, length=totalHeight+0.2);
    
    // Nut
    translate([0,0,wall])
    cylinder(r=nutDiameter/2, h=nutHeight+0.1, $fn=6);
    
    // Bolt
    translate([0,0,-0.1])
    cylinder(r=boltDiameter/2, h=wall+0.2, $fn=PipeFn(pipe)/2);
  }
}

module PipeCone(nutHeight=0.26, nutDiameter=0.6, boltDiameter=0.38, major=2.5, id=0.32) {
  difference() {
    
    // Body
    cylinder(r1=major/2, r2=nutDiameter*.6, h=(major/2), $fn=20);
    
    // Nut
    translate([0,0,(major/2) - nutHeight])
    cylinder(r=nutDiameter/2, h=nutHeight+0.1, $fn=6);
    
    // Bolt
    translate([0,0,-0.1])
    cylinder(r=boltDiameter/2, h=major, $fn=8);
  }
}

scale([25.4, 25.4, 25.4])
PipeCone();
//PipeDrillAdapter();