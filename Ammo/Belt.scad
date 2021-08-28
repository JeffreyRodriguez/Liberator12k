use <../Meta/Manifold.scad>;
use <../Shapes/Chamfer.scad>;
use <../Shapes/Semicircle.scad>;
use <../Shapes/Teardrop.scad>;
use <../Shapes/ZigZag.scad>;

barrelDiameter = 1;
barrelRadius = barrelDiameter/2;
barrelClearance = 0.01;
shellRadius=0.8/2;
shellRimRadius = 0.88/2;
shellRimWidth = 0.065;
shellLength = 3;

rimOffset = 0.0625;
rimBlockHeight = 0.5;
wall=0.0625;
height=1.5;
chamferRadius=1/32;
pinSupportRadius=0.1875;
pinRadius = 0.05/2;
pinClearance = 0.005;
pinLength = 0.75;
clearance=0.01;
slotLength = 0.5;
slotWidth = 0.1875;
slotRadius = slotWidth/2;
slotOffset = rimBlockHeight+0.5;
tabHeight = 0.25;

petalGap = (barrelRadius-shellRadius);
spineExtension = petalGap+0.0625;//0.125;
spineHeight = petalGap + spineExtension;
pinOffset = shellRadius
          + spineHeight
          + petalGap
          + wall
          + pinSupportRadius
          + clearance;// barrelRadius + wall + pinSupportRadius;
pivotAngle = -120;

module Cartridge($fn=30) {
  CR=1/32;
  
  translate([0,0,rimOffset]) {
    // Rim
    color("Gold")
    cylinder(r=shellRimRadius, h=shellRimWidth);
    
    // Body
    color("Red")
    translate([0,0,ManifoldGap(2)])
    cylinder(r=shellRadius, h=shellLength);
  }
}


module BeltLinkBand() {
  color("DimGrey") render()
  translate([0,0,0.125])
  linear_extrude(height=rimBlockHeight/2, center=false)
  difference() {
    offset(r=1/32)
    hull()
    projection(cut=true)
    translate([0,0,-0.125])
    CarrierPetals();
    
    hull()
    projection(cut=true)
    translate([0,0,-0.125])
    CarrierPetals();
  }
}

module CarrierPetal(cutter=false, clearance=0.008, alternate=false, $fn=60) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color((alternate?"Olive":"Tan")) render()
  difference() {
    union() {
      
      // Spine Block
      translate([shellRadius,-(slotWidth/2)-clear,0])
      ChamferedCube([spineHeight+clear,
                     slotWidth+clear2,
                     (rimBlockHeight*1.5)+height], r=1/16,
                    teardropFlip=[true,true,true]);
      
      // Front Block
      if (!cutter)
      translate([0,0,height+rimBlockHeight+clearance])
      difference() {
        hull() {
          linear_extrude(height=rimBlockHeight)
          intersection() {
            semicircle(od=barrelDiameter, angle=120, center=true);
            
            circle(r=barrelRadius);
            
            translate([cos(35)*shellRadius, -shellRadius*0.8])
            square([barrelRadius, shellRadius*2*0.8]);
          }
      
          // Hull to meet the spine
          translate([shellRadius+spineHeight,-(barrelRadius*sqrt(2)/4),0])
          mirror([1,0,0])
          ChamferedCube([0.25,
                barrelRadius*sqrt(2)/2,
                (rimBlockHeight*1.8)],
                r=1/16, teardropFlip=[true,true,true]);
        }
        
        // Shell hole
        cylinder(r=shellRadius, h=rimBlockHeight);
        
        // Chamfered barrel hole
        translate([-(barrelRadius-shellRadius),0,0])
        ChamferedCircularHole(r1=barrelRadius, r2=barrelRadius,
                               h=rimBlockHeight*2, 
                               chamferBottom=false,
                               teardropTop=true);
      }
      
      // Rim Block
      if (!cutter)
      difference() {
        hull() {
          linear_extrude(height=rimBlockHeight)
          intersection() {
            semicircle(od=barrelDiameter, angle=120, center=true);
            
            circle(r=barrelRadius);
            
            translate([cos(35)*shellRadius, -shellRadius*0.8])
            square([barrelRadius, shellRadius*2*0.8]);
          }
      
          // Hull to meet the spine
          translate([shellRadius+spineHeight,-(barrelRadius*sqrt(2)/4),0])
          mirror([1,0,0])
          ChamferedCube([barrelRadius-shellRadius+0.125,
                barrelRadius*sqrt(2)/2,
                rimBlockHeight],
                r=1/16, teardropFlip=[true,true,true]);
        }
        
        // Chamfered shell hole
        translate([0,0,0])
        ChamferedCircularHole(r1=shellRadius, r2=shellRadius/4,
                               h=rimBlockHeight, 
                               chamferBottom=false,
                               teardropTop=true);
        
        // Chamfered barrel hole
        translate([-(barrelRadius-shellRadius),0,0])
        ChamferedCircularHole(r1=barrelRadius, r2=barrelRadius/4,
                               h=rimBlockHeight, 
                               chamferBottom=false,
                               teardropTop=true);
      }
    }
    
    Cartridge();
  }
}

module CarrierPetals(cutter=false, alternate=false, AF=0) {
  
  for (R = [0,120, 240]) rotate(90+R)
  translate([AF*(barrelRadius-shellRadius),0,0])
  CarrierPetal(cutter=cutter, alternate=alternate);
}


// **********
// * Shapes *
// **********
module CarrierHole() {
  
  // Barrel hole
  ChamferedCircularHole(r1=barrelRadius+barrelClearance,
                        r2=wall/2, h=height);
  
  translate([0,0,-0.5]) {
    CarrierPetals(AF=0, cutter=true);
    CarrierPetals(AF=1, cutter=true);
  }
}

module BeltLinkBase($fn=60) {
  difference() {
    union() {
      
      hull() {
        
        // Round body
        ChamferedCylinder(r1=barrelRadius+barrelClearance+wall, r2=chamferRadius, h=height);
        
        // Spine support
        for (R = [0,120, 240]) rotate(90+R)
        translate([shellRadius,-(slotWidth/2)-wall,0])
        ChamferedCube([spineHeight+petalGap+wall,
                       slotWidth+(wall*2),
                       height], r=1/32);
      }
      
      children();
    }
    
    CarrierHole();
  }
}

// **********
// * Prints *
// **********

module BeltLink(alternate=false, $fn=30) {
  color((alternate?"Tan":"Olive")) render()
  difference() {
    translate([0,0,rimBlockHeight])
    union() {
      BeltLinkBase() {
      
        // Pivot supports
        for (Z = [0:tabHeight*2:height-tabHeight]) translate([0,0,Z])
        for (COPY = [0, 1]) rotate(COPY ? pivotAngle :120) translate([0,0,tabHeight*COPY])
        hull() {
          
          ChamferedCylinder(r1=pinSupportRadius*2, r2=chamferRadius,
                            h=tabHeight-clearance);
          
          translate([0,pinOffset,0])
          ChamferedCylinder(r1=pinSupportRadius, r2=chamferRadius,
                            h=tabHeight-clearance);
        }
      }
    }
    
    translate([0,0,rimBlockHeight]) {
    
      // Barrel hole
      ChamferedCircularHole(r1=barrelRadius+barrelClearance,
                            r2=wall/2, h=height);
    
      // Pivot pin hole
      for (R = [120,-pivotAngle]) rotate(R)
      translate([0,pinOffset,0])
      cylinder(r=pinRadius+pinClearance, h=height, $fn=20);
    }
  }
}

module ReversePumpCylinder(shots=5, $fn=80) {
  render()
  translate([0,0,rimBlockHeight])
  difference() {
    ChamferedCylinder(r1=3.5/2, r2=1/16, h=2.5);
    
    for (R = [0:360/5:360]) rotate(R)
    translate([0,-1,0])
    CarrierHole();
  
    // ZigZag track
    //rotate(trackAngle)
    //rotate(360/positions)
    ZigZag(radius=3.5/2, depth=3/16, width=0.25,
           positions=shots,
           extraTop=0, extraBottom=0,
           supportsTop=false, supportsBottom=false);
  }
  
  for (R = [0:360/shots:360]) rotate(R)
  translate([0,-1,0]) {
    for (Z = [0,rimBlockHeight+height]) translate([0,0,Z])
    BeltLinkBand();
    Cartridge();
    CarrierPetals(alternate=true);
  }
}

module Stick(rounds=5) {
  
  render()
  difference() {
    
    hull()
    for (X = [0:rounds-1])
    translate([X*(barrelDiameter+0.5),0,0])
    BeltLinkBase();
    
    for (X = [0:rounds-1])
    translate([X*(barrelDiameter+0.5),0,0])
    CarrierHole();
  }
}

module Belt() {
  for (X = [0,1])
  translate([abs(pinOffset*2)*sin(120)*X,0,0]) {
    alternate = (X%2!=0);
    
    // Pivot pin
    color("Silver") render()
    for (R = [120,pivotAngle]) rotate(R)
    translate([0,pinOffset, rimBlockHeight])
    cylinder(r=pinRadius, h=height, $fn=20);
    
    BeltLinkBand();
    Cartridge();
    CarrierPetals(alternate=true);
    BeltLink(alternate=true);
  }
}

scale(25.4)
if ($preview) {
  Belt();
} else {
  BeltLink();
  
  *rotate([0,90,0])
  CarrierPetal();
}