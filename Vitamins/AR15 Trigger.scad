
pinRadius = 2.4; // 0.1560*25.4/2;
  
frontPinOffsetX = 6.75;
frontPinOffsetY = 16.25;

rearPinOffsetX = 28.5;
rearPinOffsetY = 8;

selectorRadius = 5; // Diameter: .3760" = 9.55mm
selectorOffsetX = frontPinOffsetX+(1.968*25.4) + 1.5;
selectorOffsetY = 14;

hammerLength = 41;
hammerWidth = 9;
hammerPivotRadius = 10;

triggerPackHeight = 43;
triggerPackWidth = 18;
triggerPackLength = 45;
triggerWidth = 7;

module triggerPack(pinWidth=20) {
  
  // Trigger pack body
  cube([triggerPackLength,triggerPackHeight,triggerPackWidth]);
  
  translate([0,0,triggerPackWidth/2]) {
  
    // Pins and hammer path
    translate([frontPinOffsetX,frontPinOffsetY,0]) {
      
      // Hammer pin
      cylinder(r=pinRadius, h=pinWidth, center=true);
      
      // Hammer pivot
      cylinder(r=hammerPivotRadius, h=hammerWidth, center=true);
      
      // Hammer travel
      translate([-hammerPivotRadius,0,-hammerWidth/2])
      cube([hammerLength-hammerPivotRadius,hammerLength-hammerPivotRadius,hammerWidth]);
    };
    
    // Rear pin
    translate([rearPinOffsetX,rearPinOffsetY,0])
    cylinder(r=pinRadius, h=pinWidth, center=true);
    
    // Sear Extension
    translate([0,3,0-hammerWidth/2])
    cube([triggerPackLength+16,triggerPackHeight,hammerWidth]);
    
    // Selector
    translate([selectorOffsetX,selectorOffsetY,0])
    cylinder(r=selectorRadius, h=pinWidth, center=true);
    
    // Trigger
    translate([rearPinOffsetX - 10,-19,-3.5])
    cube([15,20,7]);
  }
}

module triggerHousing(wall=2) {
  difference() {
    cube([85,42,(18 + (wall*2))/2]);
    
    translate([8,5,wall])
    triggerPack(pinWidth=100);
  }
}

triggerHousing();