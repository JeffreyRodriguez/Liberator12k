use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Components/Semicircle.scad>;
use <../../Components/Teardrop.scad>;
use <../../Finishing/Chamfer.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Square Tube.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Lower.scad>;
use <../../Lower/Trigger.scad>;
use <../../Magwells/AR15 Magwell.scad>;
use <../Tube/Tube Upper.scad>;

$fn=60;

// Bullpup AR Barrel Bolt-action (BARBB)
tube_wall = 0.3;
barrel_wall = 0.1875;
tube_offset = 0.75;
barrel_offset = 0.75;

camPinAngle    = 22.5;
camPinAngleExtra = 22.5*2;
camPinOffset   = -1.1;
camPinDiameter = 0.3125;
camPinRadius   = camPinDiameter/2;
camPinSquareOffset = 0.5;
camPinSquareHeight = 0.1;
camPinSquareWidth = 0.402;
barrelExtensionDiameter = 1;
barrelExtensionRadius = barrelExtensionDiameter/2;
barrelExtensionLength = 0.99;
boltHeadDiameter = 0.75+0.008;
boltHeadRadius = boltHeadDiameter/2;
boltLugLength  = 0.28;
boltLength = 2.8;
boltLockedLength = 2.3;// - 0.85;

boltSleeveDiameter = barrelExtensionDiameter;
boltSleeveRadius = boltSleeveDiameter/2;
barrelExtensionLandingHeight = 0.3;

chamferRadius = 0.1;

module PicRailBolts() {
  translate([ReceiverLugRearMinX()+(ReceiverLugRearLength()/2),0,
             tube_wall+tube_offset+barrel_offset+0.5])
  for(x = [0,2.6])
  translate([x,0,0])
  NutAndBolt(bolt=Spec_BoltM4(), boltLength=10/25.4,
              capHeightExtra=1, nutHeightExtra=0.5,
              clearance=true, teardrop=true, teardropAngle=180);
}

// m5x10 flat head
module FlatHeadBolt(diameter=0.193, headDiameter=0.353, extraHead=1, length=0.3955, $fn=20, teardrop=true) {
  radius = diameter/2;
  
  render()
  union() {
    
    if (teardrop) {
      linear_extrude(height=length)
      Teardrop(r=radius);
    } else {
      cylinder(r=radius, h=length);
    }
    
    cylinder(r1=headDiameter/2, r2=0, h=headDiameter/2, $fn=$fn*2);
    
    translate([0,0,-extraHead])
    cylinder(r=headDiameter/2, h=extraHead+ManifoldGap(), $fn=$fn*2);
  }
}

module BARBB_LowerReceiver(extraFront=0,wall=tube_wall) {
  overallLength=LowerMaxX()+abs(ReceiverLugRearMinX());
  
  render()
  difference() {
    union() {
      
      translate([LowerMaxX(),0,0]) {
        
        // Barrel/Bolt Body
        translate([0,0,wall+tube_offset+barrel_offset])
        rotate([0,-90,0])
        ChamferedCylinder(r1=0.5+wall,
                          r2=chamferRadius,
                          h=overallLength);
        
        // Square Tube Body
        translate([0, -(tube_offset/2)-tube_wall, 0])
        rotate([0,-90,0])
        ChamferedCube([tube_offset+tube_wall+barrel_offset,
                       tube_offset+(tube_wall*2),
                       overallLength], r=chamferRadius, center=false);
        
        // Flat top for pic rail
        translate([0, -(tube_offset/2), tube_offset+tube_wall+barrel_offset])
        rotate([0,-90,0])
        ChamferedCube([0.75+0.1,
                       tube_offset,
                       overallLength], r=chamferRadius, center=false);
      }
      
      ReceiverLugFront(extraTop=tube_wall);
      
      ReceiverLugRear(extraTop=tube_wall);
    }
    
    PicRailBolts();

    // Square Tube center axis
    translate([0,0,(tube_offset/2)+tube_wall]) {
      
      translate([LowerMaxX(),0,0])
      rotate([0,-90,0])
      ChamferedSquareHole(side=0.753+0.015, length=overallLength, center=true,
                           chamferTop=true, chamferBottom=true, chamferRadius=chamferRadius,
                           corners=true, cornerRadius=0.0625);
      
      // Side Bolts
      for (m = [0,1]) mirror([0,m,0])
      for (x = [ReceiverLugFrontMinX()+(ReceiverLugFrontLength()/2),
                ReceiverLugRearMinX()+(ReceiverLugRearLength()/2)])
      translate([x,(tube_offset/2)+tube_wall,0])
      rotate([90,180,0])
      FlatHeadBolt();
    }
    
    // Barrel center axis
    translate([0,0,tube_wall+tube_offset+barrel_offset]) {
    
      // Barrel Hole
      translate([ReceiverLugFrontMinX()+ManifoldGap(),0,0])
      rotate([0,-90,0])
      cylinder(r=0.5, h=overallLength);
      
      // Chamfer the barrel entrance hole
      translate([ReceiverLugRearMinX(),0,0])
      rotate([0,90,0])
      HoleChamfer(r1=0.5, r2=chamferRadius, teardrop=true);
      
      // Gas Block Hole
      translate([ReceiverLugFrontMinX()-ManifoldGap(),0,0])
      rotate([0,90,0])
      cylinder(r=(0.75/2)+0.01, h=overallLength);
      
      // Chamfer the gas block entrance hole
      translate([LowerMaxX(),0,0])
      rotate([0,-90,0])
      HoleChamfer(r1=(0.75/2)+0.01, r2=chamferRadius, teardrop=true);
    }
    
    SearCutter(length=tube_wall+(tube_offset/2)+0.9+SearTravel());
  }
}

module BARBB_UpperReceiver(pinRadius=0.125/2, pinHeight=0.09, pinDepth=0.162,
                               length=0.99, rearLength=1.075, wall=tube_wall) {
  
  overallLength = barrelExtensionLength+boltLockedLength;

  translate([-barrelExtensionLength-ManifoldGap(),0,0])
  render()
  difference() {
    union() {
      
      // Barrel/Bolt Body
      translate([-boltLockedLength,0,wall+tube_offset+barrel_offset])
      rotate([0,90,0])
      ChamferedCylinder(r1=barrelExtensionRadius+barrel_wall, r2=chamferRadius, h=overallLength);
      
      // Extra meat for the bolt cam pin square
      translate([-boltLockedLength,0,wall+tube_offset+barrel_offset])
      rotate([0,90,0])
      hull() {
        rotate(180-camPinAngleExtra)
        translate([0,-tube_wall-(camPinSquareWidth/2),0])
        ChamferedCube([boltSleeveRadius+camPinSquareHeight+barrel_wall,
                       camPinSquareWidth+(tube_wall*2),
                       boltLockedLength+camPinOffset], r=chamferRadius);
        
        ChamferedCylinder(r1=barrelExtensionRadius+barrel_wall,
                          r2=chamferRadius, h=boltLockedLength+camPinOffset);
      }
      
      // Square Tube Body
      translate([-boltLockedLength,
                 -(tube_offset/2)-tube_wall,
                 tube_offset+tube_wall+barrel_offset])
      rotate([0,90,0])
      ChamferedCube([tube_offset+tube_wall+barrel_offset,
                     tube_offset+(tube_wall*2),
                     overallLength], r=chamferRadius);
      
      *translate([-boltLockedLength,0,wall+tube_offset+barrel_offset])
      rotate([270,0,0])
      AR15_Magwell();
    }
    
    *translate([-boltLockedLength,0,wall+tube_offset+barrel_offset])
    rotate([270,0,0])
    AR15_MagwellInsert();
    
    // Square Tube cener axis
    translate([0,0,(tube_offset/2)+tube_wall]) {
      
      translate([barrelExtensionLength+ManifoldGap(),0,0])
      rotate([0,-90,0])
      ChamferedSquareHole(side=0.753+0.015, length=overallLength, center=true,
                           chamferTop=true, chamferBottom=true, chamferRadius=chamferRadius,
                           corners=true, cornerRadius=0.0625);
      
      // Side Bolts
      for (m = [0,1]) mirror([0,m,0])
      for (x = [barrelExtensionLength-1, -boltLockedLength+1])
      translate([x,(tube_offset/2)+tube_wall,0])
      rotate([90,0,0])
      FlatHeadBolt();
    }
    
    // Barrel center axis
    translate([0,0,wall+tube_offset+barrel_offset]) {
      
      // Chamfer the bolt entrance hole
      translate([-boltLockedLength,0,0])
      rotate([0,90,0])
      HoleChamfer(r1=boltSleeveRadius+0.015, r2=chamferRadius, teardrop=true);
    
      // Bolt Head Passage
      translate([tube_offset+barrel_offset-ManifoldGap(),0])
      rotate([0,-90,0])
      cylinder(r=boltHeadRadius+0.01, h=overallLength+ManifoldGap(2));
    
      // Bolt Sleeve Passage
      translate([-barrelExtensionLandingHeight+ManifoldGap(),0])
      rotate([0,-90,0])
      cylinder(r=boltSleeveRadius+0.015,
               h=overallLength+ManifoldGap(2));
      
      // Bolt Sleeve Taper
      translate([-barrelExtensionLandingHeight-ManifoldGap(),0])
      rotate([0,90,0])
      cylinder(r1=boltSleeveRadius+0.015, r2=boltHeadRadius+0.008,
               h=(barrelExtensionLandingHeight/2)+ManifoldGap(2));
      
    
      // Barrel Extension Locating Pin Cutout
      translate([barrelExtensionLength-pinDepth,-pinRadius,-barrelExtensionRadius-pinHeight])
      cube([pinDepth+ManifoldGap(),pinRadius*2,pinHeight+barrelExtensionRadius]);
      
      // Barrel Extension Cutout
      rotate([0,90,0])
      cylinder(r=barrelExtensionRadius+0.007,
               h=barrelExtensionLength+ManifoldGap());
      
      // Cam Pin cutout
      rotate([-camPinAngleExtra,0,0])
      translate([camPinOffset+camPinDiameter,0,0])
      union () {
        translate([0.005+ManifoldGap(),-(camPinSquareWidth/2)-0.01,0])
        mirror([1,0,0])
        cube([boltLockedLength+camPinOffset+camPinDiameter+0.01+ManifoldGap(2),
              camPinSquareWidth+0.02,
              camPinSquareOffset+camPinSquareHeight+0.01]);
        
        translate([0.005+ManifoldGap(),0,0])
        rotate([0,-90,0])
        linear_extrude(height=camPinDiameter+0.01+ManifoldGap())
        hull() {
          semicircle(od=(camPinSquareOffset
                        +camPinSquareHeight
                        +(/*fudged*/ 0.045)+barrel_wall)*2,
                     angle=camPinAngle+camPinAngleExtra);
          
          for (r = [0,-camPinAngleExtra-camPinAngle]) rotate(r)
          translate([camPinSquareOffset-camPinSquareHeight,-camPinSquareWidth/2])
          square([(camPinSquareHeight*2)+barrel_wall, camPinSquareWidth]);
        }
      }
      
    }
  }
}


module BARBB_Bolt(handleLength=1) {
  boltFrontRadius = 0.527/2;
  boltFrontLength = abs(camPinOffset)+0.01;
  boltMiddleRadius = 0.49/2;
  boltMiddleLength = 0.95;
  boltBackRadius = 0.25/2;
  firingPinRadius = 0.337/2;
  firingPinExtension = 0.65;      // From the back of the bolt
  firingPinRetainerOffset = 0.35; // From the back of the bolt
  
  overallLength = boltLockedLength+handleLength-barrelExtensionLandingHeight;
  
  render()
  translate([-barrelExtensionLength-ManifoldGap(),0,tube_wall+tube_offset+barrel_offset])
  difference() {
    translate([-barrelExtensionLandingHeight,0,0])
    union() {
      rotate([0,-90,0])
      ChamferedCylinder(r1=boltSleeveRadius,
                        r2=chamferRadius,
                        h=overallLength);
      
      // Handle
      translate([-overallLength,-tube_wall-(tube_offset/2),0])
      rotate([0,90,0])
      ChamferedCube([tube_wall+tube_offset+barrel_offset,tube_wall,handleLength], r=chamferRadius);
      
      // Cylinder-Handle Joint
      translate([-overallLength,0,0])
      rotate([0,90,0])
      hull() {
        ChamferedCylinder(r1=barrelExtensionRadius+barrel_wall,
                          r2=chamferRadius,
                          h=handleLength);
        
        translate([0,-(tube_offset/2)-tube_wall,0])
        ChamferedCube([barrel_offset,(tube_offset/2)+tube_wall,handleLength], r=chamferRadius);
      }
    }
    
    // Bolt Cam Pin
    rotate([camPinAngle,0,0])
    translate([camPinOffset+camPinRadius,0,0])
    linear_extrude(height=boltSleeveRadius+ManifoldGap())
    Teardrop(r=camPinRadius+0.005);
    
    // Bolt Clearance
    
    // Front
    translate([ManifoldGap(),0,0])
    rotate([0,-90,0])
    cylinder(r=boltFrontRadius+0.01, h=boltFrontLength+ManifoldGap());
    
    // Front Chamfer
    translate([-barrelExtensionLandingHeight,0,0])
    rotate([0,-90,0])
    HoleChamfer(r1=boltFrontRadius+0.01, r2=chamferRadius, teardrop=false);
    
    // Middle
    translate([camPinOffset+ManifoldGap(),0,0])
    rotate([0,-90,0])
    cylinder(r=boltMiddleRadius+0.015, h=boltMiddleLength+ManifoldGap(2));
    
    // Back
    translate([-ManifoldGap(),0,0])
    rotate([0,-90,0])
    cylinder(r=boltBackRadius+0.015, h=boltLockedLength+ManifoldGap());
    
    // Firing Pin
    translate([-boltLockedLength+ManifoldGap(),0,0])
    rotate([0,-90,0])
    cylinder(r=firingPinRadius+0.025, h=handleLength+ManifoldGap(2));
    
    // Firing Pin Chamfer
    translate([-overallLength-barrelExtensionLandingHeight,0,0])
    rotate([0,90,0])
    HoleChamfer(r1=firingPinRadius+0.025, r2=chamferRadius, teardrop=true);
    
    // Firing Pin-to-bolt-back taper
    translate([-boltLockedLength-barrelExtensionLandingHeight-ManifoldGap(),0,0])
    rotate([0,90,0])
    cylinder(r=firingPinRadius+0.025, r2=boltBackRadius+0.01,
            h=firingPinRadius+ManifoldGap(2));
    
    // Firing Pin Retainer
    translate([-boltLockedLength-firingPinRetainerOffset,boltSleeveRadius-tube_wall,-firingPinRadius-ManifoldGap()])
    rotate([90,0,0])
    cylinder(r=0.125/2, h=boltSleeveDiameter+ManifoldGap(2),$fn=8);
    
  }
  
}



module BARBB_Stock(topDiameter=tube_offset+(tube_wall*2), bottomDiameter=1, length=3, extend=3, wall=0.25) {
  translate([0,0,tube_wall+(tube_offset/2)])
  rotate([0,90,0])
  render()
  difference() {
    hull() {
      translate([-(topDiameter/2), -topDiameter/2,-ManifoldGap()])
      ChamferedCube([topDiameter, topDiameter, extend+ManifoldGap()]);
      
      translate([length,0,0])
      ChamferedCylinder(r1=bottomDiameter/2, r2=chamferRadius, h=wall);
    }
    
    // Square Tube cener axis
    translate([0,0,wall])
    ChamferedSquareHole(side=0.753+0.015, length=extend, center=true,
                         chamferTop=true, chamferBottom=false, chamferRadius=chamferRadius,
                         corners=true, cornerRadius=0.0625);
    
    // Side Bolts
    for (m = [0,1]) mirror([0,m,0])
    for (z = [1, extend-1])
    translate([0,(tube_offset/2)+tube_wall,z])
    rotate([90,-90,0])
    FlatHeadBolt();
  }
}

module BARBB_Foregrip(topDiameter=tube_offset+(tube_wall*2), bottomDiameter=1, length=1.5, extend=2, wall=0.25) {
  translate([0,0,tube_wall+(tube_offset/2)])
  rotate([0,90,0])
  render()
  difference() {
    hull() {
      translate([-(topDiameter/2), -topDiameter/2,-ManifoldGap()])
      ChamferedCube([topDiameter, topDiameter, extend+ManifoldGap()]);
      
      translate([length,0,0])
      ChamferedCylinder(r1=bottomDiameter/2, r2=chamferRadius, h=extend/2);
    }
    
    // Square Tube cener axis
    translate([0,0,-wall])
    ChamferedSquareHole(side=0.753+0.015, length=extend, center=true,
                         chamferTop=true, chamferBottom=false, chamferRadius=chamferRadius,
                         corners=true, cornerRadius=0.0625);
    
    // Side Bolts
    for (m = [0,1]) mirror([0,m,0])
    translate([0,(tube_offset/2)+tube_wall,1])
    rotate([90,-90,0])
    FlatHeadBolt();
  }
}

translate([ReceiverLugRearMinX()-14,0,0])
BARBB_Stock();

translate([LowerMaxX()+3,0,0])
BARBB_Foregrip();

color("Green")
//render() DebugHalf()
translate([ReceiverLugRearMinX()-4.5,0,0])
BARBB_Bolt();

color("Tan")
BARBB_LowerReceiver();

color("Tan")
translate([ReceiverLugRearMinX()-4.5,0,0])
BARBB_UpperReceiver();

color("Silver")
translate([ReceiverLugRearMinX()-4.5-boltLockedLength-barrelExtensionLength-5.8,-tube_offset/2,tube_wall])
cube([22, tube_offset, tube_offset]);

Lower(showTrigger=false);

*!scale(25.4)
rotate([0,-90,0])
BARBB_Bolt();

*!scale(25.4)
rotate([0,90,0])
BARBB_LowerReceiver(extraFront=0);

*!scale(25.4)
rotate([0,-90,0])
BARBB_UpperReceiver(extraRear=0);

*!scale(25.4)
rotate([0,-90,0])
BARBB_Stock();

*!scale(25.4)
rotate([0,-90,0])
BARBB_Foregrip();