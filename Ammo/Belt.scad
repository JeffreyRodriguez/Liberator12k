use <../Meta/Manifold.scad>;
use <../Meta/RenderIf.scad>;
use <../Meta/Units.scad>;
use <../Meta/Resolution.scad>;
use <../Shapes/Chamfer.scad>;
use <../Shapes/Semicircle.scad>;
use <../Shapes/Teardrop.scad>;
use <../Shapes/ZigZag.scad>;

_RENDER = ""; // ["", "BeltLink", "BeltLink3", "BeltPetal"]

barrelDiameter = 1;
barrelRadius = barrelDiameter/2;
barrelClearance = 0.01;
shellRadius=0.8/2;
shellRimRadius = 0.88/2;
shellRimWidth = 0.065;
shellLength = 2.75;

rimOffset = 0.0625;
rimBlockHeight = 0.5;
wall=0.0625;
height=1.5;
chamferRadius=1/32;
pinSupportRadius=0.1875;
pinRadius = 3/32/2;
pinClearance = 0.005;
pinLength = 0.75;
clearance=0.01;
slotLength = 0.5;
slotWidth = 0.1875;
slotRadius = slotWidth/2;
slotOffset = rimBlockHeight+0.5;
tabHeight = 0.375;

petalGap = (barrelRadius-shellRadius);
spineExtension = petalGap+0.0625;//0.125;

spineHeight = petalGap
            + spineExtension;

vertexOffset = shellRadius
             + spineHeight
             + petalGap
             + wall;

function BeltDriveToothRadius() = (1/8);
function BeltOffsetVertex() = vertexOffset
          + pinSupportRadius
          + clearance;
pivotAngle = -120;

$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();


module Cartridge(cutter=false) {
  CR=1/32;
  
  translate([0,0,rimOffset]) {
    // Rim
    color("Gold") RenderIf(!cutter)
    cylinder(r=shellRimRadius, h=shellRimWidth);
    
    // Body
    color("Red") RenderIf(!cutter)
    translate([0,0,ManifoldGap(2)])
    cylinder(r=shellRadius, h=shellLength);
  }
}


module BeltLinkBand(AF=0) {
  color("DimGrey") render()
  linear_extrude(height=rimBlockHeight/2, center=false)
  difference() {
    offset(r=1/32)
    hull()
    projection(cut=true)
    translate([0,0,-0.125])
    CarrierPetals(doRender=false, AF=AF);
    
    hull()
    projection(cut=true)
    translate([0,0,-0.125])
    CarrierPetals(doRender=false, AF=AF);
  }
}

module CarrierPetal(doRender=true, cutter=false, clearance=0.008) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  blockWidth = (shellRadius*2)*0.8;
  
  color("Olive") RenderIf(doRender && !cutter)
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
          
          translate([cos(35)*shellRadius, -(blockWidth/2),0])
          ChamferedCube([0.125,
                blockWidth,
                rimBlockHeight],
                r=1/32,
                teardropTopXYZ=[0,0,0],
                teardropXYZ=[0,0,0]);
      
          // Hull to meet the spine
          translate([shellRadius+spineHeight,-(slotWidth/2),0])
          mirror([1,0,0])
          ChamferedCube([0.25,
                slotWidth,
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
      
      if (!cutter)
      difference() {
        
      // Rim Block
        hull() {
          translate([cos(35)*shellRadius, -(blockWidth/2),0])
          ChamferedCube([0.125,
                blockWidth,
                rimBlockHeight-clearance],
                r=1/32,
                teardropTopXYZ=[0,0,0],
                teardropXYZ=[0,0,0]);
      
          // Hull to meet the spine
          translate([shellRadius+spineHeight,-(slotWidth/2),0])
          mirror([1,0,0])
          ChamferedCube([barrelRadius-shellRadius+0.125,
                slotWidth,
                rimBlockHeight],
                r=1/16, teardropFlip=[true,true,true]);
        }
        
        // Chamfered barrel hole
        translate([-(barrelRadius-shellRadius),0,0])
        ChamferedCircularHole(r1=barrelRadius, r2=barrelRadius/4,
                               h=rimBlockHeight, 
                               chamferBottom=false,
                               teardropTop=true);
      }
    }
    
    // Chamfered base
    ChamferedCircularHole(r1=shellRadius, r2=1/16,
                           h=rimBlockHeight,
                           chamferTop=false);
    
    Cartridge(cutter=true);
  }
}

module CarrierPetals(doRender=true, cutter=false, AF=0) {
  
  for (R = [0,120, 240]) rotate(90+R)
  translate([AF*(barrelRadius-shellRadius),0,0])
  CarrierPetal(doRender=doRender, cutter=cutter);
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

module BeltLinkBase() {
  //!render()
  difference() {
    union() {
      
      hull() {
        
        // Round body
        ChamferedCylinder(r1=barrelRadius+barrelClearance+wall,
                          r2=chamferRadius,
                           h=height);
        
        // Vertex
        for (R = [0,120, 240]) rotate(90+R)
        translate([0,-(slotWidth/2)-wall,0])
        ChamferedCube([vertexOffset,
                       slotWidth+(wall*2),
                       height], r=1/32);
        
        // Wide flats
        hull()
        for (R = [0:120:360]) rotate(60+90+R)
        translate([0,-1/2,0])
        ChamferedCube([barrelRadius+barrelClearance+wall, 1, height], r=1/16);
      }
      
      children();
    }
    
    CarrierHole();
  }
}

// **********
// * Prints *
// **********

module BeltLink() {
  color("Tan")
  difference() {
    translate([0,0,rimBlockHeight])
    union() {
      BeltLinkBase() {
        
        // Belt Drive Tooth
        translate([0,-barrelRadius-wall,0])
        ChamferedCylinder(r1=BeltDriveToothRadius(),
                          r2=BeltDriveToothRadius(),
                           h=height,
                 teardropTop=true);
          
        // Pivot Forks
        for (Z = [0,height-tabHeight]) translate([0,0,Z])
        rotate(120)
        hull() {
          
          ChamferedCylinder(r1=pinSupportRadius*2,
                            r2=chamferRadius,
                            h=tabHeight);
          
          translate([0,BeltOffsetVertex(),0])
          ChamferedCylinder(r1=pinSupportRadius, r2=chamferRadius,
                            h=tabHeight);
        }
      
        // Pivot Tab
        rotate(pivotAngle) translate([0,0,tabHeight+clearance])
        hull() {
          height = height-((tabHeight+clearance)*2);
          
          ChamferedCylinder(r1=pinSupportRadius*2,
                            r2=chamferRadius,
                            h=height);
          
          translate([0,BeltOffsetVertex(),0])
          ChamferedCylinder(r1=pinSupportRadius, r2=chamferRadius,
                            h=height);
        }
      }
    }
    
    translate([0,0,rimBlockHeight]) {
    
      // Barrel hole
      ChamferedCircularHole(r1=barrelRadius+barrelClearance,
                            r2=wall/2, h=height);
    
      // Pivot pin hole
      for (R = [120,pivotAngle]) rotate(R)
      translate([0,BeltOffsetVertex(),0])
      cylinder(r=pinRadius+pinClearance, h=height);
      
      
    }
  }
}

module ReversePumpCylinder(shots=5) {
  render()
  translate([0,0,rimBlockHeight])
  difference() {
    ChamferedCylinder(r1=3.5/2, r2=1/16, h=1.5);
    
    for (R = [0:360/5:360]) rotate(R)
    translate([0,-1,0])
    CarrierHole();
  
    // ZigZag track
    //rotate(trackAngle)
    //rotate(360/positions)
    *ZigZag(radius=3.5/2, depth=3/16, width=0.25,
           positions=shots,
           extraTop=0, extraBottom=0,
           supportsTop=false, supportsBottom=false);
  }
  
  for (R = [0:360/shots:360]) rotate(R)
  translate([0,-1,0]) {
    for (Z = [0,rimBlockHeight+height]) translate([0,0,Z])
    BeltLinkBand();
    Cartridge();
    CarrierPetals();
  }
}

*!ReversePumpCylinder();

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

module Belt(rounds=3, offset=0, expand=0) {
  translate([-abs(BeltOffsetVertex()*2)*sin(120)*offset,0,0])
  for (X = [0:rounds-1])
  translate([abs(BeltOffsetVertex()*2)*sin(120)*X,0,0]) {
    
    AF = (X == 0 ? expand : 0);
    
    // Pivot pin
    color("Silver") render()
    for (R = [120,pivotAngle]) rotate(R)
    translate([0,BeltOffsetVertex(), rimBlockHeight])
    cylinder(r=pinRadius, h=height);
    
    translate([0,0,2])
    BeltLinkBand(AF=AF);
    
    translate([0,0,0.25])
    BeltLinkBand(AF=AF);
    
    Cartridge();
    CarrierPetals(AF=AF);
    
    render()
    BeltLink();
  }
}

scale(25.4)
if ($preview) {
  Belt();
} else {
  if (_RENDER == "BeltLink")
  BeltLink();
  
  if (_RENDER == "BeltLink3")
  for (R = [0:120:360]) rotate(R)
  translate([0,1.02,-rimBlockHeight])
  BeltLink();
  
  if (_RENDER == "BeltPetal")
  translate([0,0,vertexOffset-spineExtension])
  rotate([0,90,0])
  CarrierPetal();
}