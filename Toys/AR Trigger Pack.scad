use <../Vitamins/Nuts And Bolts.scad>;

module TriggerPocket(pinWidth=20,
                   triggerPin=true, hammerPin=true,
                   selector=true,
                   triggerHole=false,
                   triggerPocketModifier=0) {

pinRadius = 2.4; // 0.1560*25.4/2;
  
frontPinOffsetX = 6.75;
frontPinOffsetY = 16.25;

rearPinOffsetX = 28.5;
rearPinOffsetY = 8;

selectorRadius = 5; // Diameter: .3760" = 9.55mm
selectorOffsetX = frontPinOffsetX+(1.968*25.4) + 1.5;
selectorOffsetY = 14;

hammerLength = 41 + triggerPocketModifier;
hammerWidth  = 9  + triggerPocketModifier;
hammerPivotRadius = 10 + triggerPocketModifier;

triggerWidth      = 7;

triggerPocketHeight = 43 + triggerPocketModifier;
triggerPocketWidth  = 18 + triggerPocketModifier;
triggerPocketLength = 45 + triggerPocketModifier;

  render()
  difference() {
    union() {
  
      // Trigger pack body
      cube([triggerPocketLength,triggerPocketHeight,triggerPocketWidth]);
      
      translate([0,0,triggerPocketWidth/2]) {
      
        // Pins and hammer path
        translate([frontPinOffsetX,frontPinOffsetY,0]) {
          
          // Hammer pin
          if (hammerPin)
          cylinder(r=pinRadius, h=pinWidth, center=true);
          
          // Hammer pivot
          cylinder(r=hammerPivotRadius, h=hammerWidth, center=true);
          
          // Hammer travel
          translate([-hammerPivotRadius,0,-hammerWidth/2])
          cube([hammerLength-hammerPivotRadius,hammerLength-hammerPivotRadius,hammerWidth]);
        };
        
        // Trigger pin
        if (triggerPin)
        translate([rearPinOffsetX,rearPinOffsetY,0])
        cylinder(r=pinRadius, h=pinWidth, center=true);
        
        // Sear Extension
        translate([0,3,0-hammerWidth/2])
        cube([triggerPocketLength+16,triggerPocketHeight,hammerWidth]);
        
        // Selector
        if (selector)
        translate([selectorOffsetX,selectorOffsetY,0])
        cylinder(r=selectorRadius, h=pinWidth, center=true);
        
        // Trigger
        translate([rearPinOffsetX - 10,-19,-3.5])
        cube([15,20,7]);
      }
    }
    
    if (triggerHole) {
      translate([0,0,triggerPocketWidth/2])
      translate([rearPinOffsetX - 10,-19,-3.5])
      cube([15,40+triggerPocketHeight,7]);
    }
  }
}


module TriggerHousing(wall=2) {
  tubingOuter=26;
  difference() {
    cube([85,42,18 + (wall*2)]);
    
    translate([8,5,wall])
    TriggerPocket(pinWidth=tubingOuter+10);
  }
}

module TriggerPocketNegative(height=10) {
  render()
  linear_extrude(height=height)
  difference() {
    
    // Trigger Pack 
    projection(cut=false)
    rotate([90,0,0])
    TriggerPocket(triggerPocketModifier=-1,
                selector=false,
                triggerPin=false,
                hammerPin=false,
                triggerHole=true);
  }
}

render()
//rotate([90,0,0])
TriggerHousing();

translate([8,5,2])
TriggerPocket();

!TriggerPocketNegative();