module Solenoid(shaftDiameter=6+1, shaftLength=8.1,
                   pinDiameter=2+1, pinOffset=2.5, pinLengthExtra=20) {
  
  // Solenoid shaft
  render()
  difference() {
    union() {
      cylinder(r=shaftDiameter/2, h=shaftLength);
    
      mirror([0,0,1])
      cylinder(r1=shaftDiameter/2, r2=0, h=shaftDiameter/2);
    }
    
  }
  
  // Pin
  translate([0,0,pinOffset])
  rotate([90,0,0])
  cylinder(r=pinDiameter/2,
           h=shaftDiameter+pinLengthExtra+2,
      center=true,
         $fn=4);
}

module SolenoidHead(probeDiameter=3) {
  
  render()
  difference() {
    
    // Body
    union() {
      
      // Body
      cylinder(r=7, h=30);
      
      // Alignment Lug
      translate([0,-2,0])
      cube([10,4,30]);
      
      // Electrode Bolt Support
      translate([-8,-6,20])
      cube([10,12,10]);
    }
    
    translate([0,0,7])
    mirror([0,0,1])
    Solenoid();
    
    // Electrode Bolt
    translate([0,0,25])
    rotate([0,-90,0])
    cylinder(r=2, h=10, $fn=4);
    
    // Electrode Nut
    translate([-3,-3,20])
    #cube([3,6,11]);
    
    
    // Probe
    translate([0,0,13])
    cylinder(r=probeDiameter/2, h=30);
  }
}

module SolenoidMount(frameWidth=13, frameLength=30,
                     boltSpacing=15, boltOffset=7,
                     guideLength=70) {

  difference() {
    union() {
      translate([0,-frameWidth/2,0])
      cube([frameLength+50, frameWidth, 8]);
      
      translate([frameLength+50,-frameWidth/2,0])
      cube([guideLength, frameWidth, 23]);
    }
    
    // Head guide slot      
    translate([frameLength,-3,5])
    cube([50, 6, 5]);
    
    // Probe guide hole
    translate([frameLength+49,0,16])
    rotate([0,90,0])
    cylinder(r=1.5, h=guideLength+2, $fn=4);
    
    for (X = [0,boltSpacing])
    translate([boltOffset+X,0,-1])
    cylinder(r=2, h=11);
  }
}

translate([45,0,16])
rotate([0,90,0])
//!mirror([0,0,1])
SolenoidHead();

SolenoidMount();