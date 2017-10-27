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
tube_offset = 0.75;

barrel_wall = 0.1875;
barrel_offset = 0.75;
barrelExtensionDiameter = 1;
barrelExtensionRadius = barrelExtensionDiameter/2;
barrelExtensionLength = 0.99;

camPinAngle    = 22.5;
camPinAngleExtra = 22.5*4;
camPinOffset   = 1; // From the back of the lugs to the front of the pin
camPinDiameter = 0.3125;
camPinRadius   = camPinDiameter/2;
camPinSquareOffset = 0.5;
camPinSquareHeight = 0.1;
camPinSquareWidth = 0.402;
camPinShelfLength = 0.75;

boltHeadDiameter = 0.75+0.008;
boltHeadRadius = boltHeadDiameter/2;
boltLugLength  = 0.28;
boltLength = 2.8;
boltLockedLength = 2.3;// - 0.85;
boltLockLengthDiff = boltLength - boltLockedLength;
boltFrontRadius = 0.527/2;
boltFrontLength = camPinOffset+0.01;
boltMiddleRadius = 0.49/2;
boltMiddleLength = 0.95;
boltBackRadius = 0.25/2;

boltExtraTravel = 1.25;
//boltExtraTravel = 0;

ejectionPortWidth = 0.375+0.025;


firingPinRadius = 0.337/2;
firingPinExtension = 0.65;      // From the back of the bolt
firingPinRetainerOffset = 0.35; // From the back of the bolt

boltSleeveDiameter = barrelExtensionDiameter;
boltSleeveRadius = boltSleeveDiameter/2;
barrelExtensionLandingHeight = 0.3;

chamferRadius = 0.1;
handleLength=1;

barrelZ = tube_offset+tube_wall+barrel_offset;
lowerLength = LowerMaxX()+abs(ReceiverLugRearMinX());
upperLength = barrelExtensionLength+boltLockedLength+boltExtraTravel;
barbbBoltLength = boltLockedLength
                - barrelExtensionLandingHeight
                + handleLength
                + boltExtraTravel;

magwellOffset = 1;


module PicRailBolts() {
  translate([ReceiverLugRearMinX()+(ReceiverLugRearLength()/2),0,
             barrelZ+0.5])
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
  
  render()
  difference() {
    union() {
      
      translate([LowerMaxX(),0,0]) {
        
        // Barrel/Bolt Body
        translate([0,0,barrelZ])
        rotate([0,-90,0])
        ChamferedCylinder(r1=0.5+wall,
                          r2=chamferRadius,
                          h=lowerLength);
        
        // Square Tube Body
        translate([0, -(tube_offset/2)-tube_wall, 0])
        rotate([0,-90,0])
        ChamferedCube([tube_offset+tube_wall+barrel_offset,
                       tube_offset+(tube_wall*2),
                       lowerLength], r=chamferRadius, center=false);
        
        // Flat top for pic rail
        translate([0, -(tube_offset/2), tube_offset+tube_wall+barrel_offset])
        rotate([0,-90,0])
        ChamferedCube([0.75+0.1,
                       tube_offset,
                       lowerLength], r=chamferRadius, center=false);
      }
      
      ReceiverLugFront(extraTop=tube_wall);
      
      ReceiverLugRear(extraTop=tube_wall);
    }
    
    PicRailBolts();

    // Square Tube center axis
    translate([0,0,(tube_offset/2)+tube_wall]) {
      
      translate([LowerMaxX(),0,0])
      rotate([0,-90,0])
      ChamferedSquareHole(side=0.753+0.015, length=lowerLength, center=true,
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
    translate([0,0,barrelZ]) {
    
      // Barrel Hole
      translate([ReceiverLugFrontMinX()+ManifoldGap(),0,0])
      rotate([0,-90,0])
      cylinder(r=0.5, h=lowerLength);
      
      // Chamfer the barrel entrance hole
      translate([ReceiverLugRearMinX(),0,0])
      rotate([0,90,0])
      HoleChamfer(r1=0.5, r2=chamferRadius, teardrop=true);
      
      // Gas Block Hole
      translate([ReceiverLugFrontMinX()-ManifoldGap(),0,0])
      rotate([0,90,0])
      cylinder(r=(0.75/2)+0.01, h=lowerLength);
      
      // Chamfer the gas block entrance hole
      translate([LowerMaxX(),0,0])
      rotate([0,-90,0])
      HoleChamfer(r1=(0.75/2)+0.01, r2=chamferRadius, teardrop=true);
    }
    
    SearCutter(length=tube_wall+(tube_offset/2)+0.9+SearTravel());
  }
}

module BARBB_UpperReceiver(pinRadius=0.125/2, pinHeight=0.09, pinDepth=0.162, magwell=false) {
  camPinLockedMinX = (boltLockLengthDiff)
                     -boltLugLength-camPinOffset
                     -camPinDiameter;
  
  render()
  difference() {
    translate([-upperLength,0,0])
    union() {
          
        // Barrel section
        difference() {
          union() {
            translate([barrelExtensionLength,0,barrelZ])
            rotate([0,90,0])
            ChamferedCylinder(r1=barrelExtensionRadius+barrel_wall, r2=chamferRadius,
                              h=upperLength);
        
            // Square Tube Body
            translate([barrelExtensionLength,
                       -(tube_offset/2)-tube_wall,
                       tube_offset+tube_wall+barrel_offset])
            rotate([0,90,0])
            ChamferedCube([tube_offset+tube_wall+barrel_offset,
                           tube_offset+(tube_wall*2),
                           upperLength], r=chamferRadius);
          }
          
          translate([upperLength+boltLockLengthDiff,0,barrelZ])
          rotate([0,-90,0])
          AR15_Bolt(camPinTravel=true, camPinTravelChamferBack=true,
                    teardrop=false, firingPinRetainer=false);
        }
      
      // Bolt w/ Cam Pin Linear Section Support
      translate([barrelExtensionLength,0,barrelZ])
      rotate([0,90,0])
      hull() {
        rotate(180-camPinAngleExtra)
        translate([0,-tube_wall-(camPinSquareWidth/2),0])
        ChamferedCube([boltSleeveRadius+camPinSquareHeight+barrel_wall,
                       camPinSquareWidth+(tube_wall*2),
                       upperLength-barrelExtensionLength+camPinLockedMinX-camPinShelfLength-0.01],
                      r=chamferRadius);
        
        ChamferedCylinder(r1=barrelExtensionRadius+barrel_wall,
                          r2=chamferRadius,
                           h=upperLength-barrelExtensionLength+camPinLockedMinX-camPinShelfLength-0.01);
      }
      
      if (magwell)
      translate([magwellOffset,0,barrelZ])
      rotate([270+camPinAngle,0,0])
      AR15_Magwell();
    }
    
    if (magwell)
    translate([-upperLength+magwellOffset,0,barrelZ])
    rotate([270+camPinAngle,0,0])
    AR15_MagwellInsert();
    
    // Square Tube center axis
    translate([barrelExtensionLength,0,(tube_offset/2)+tube_wall]) {
      
      translate([ManifoldGap(),0,0])
      rotate([0,-90,0])
      ChamferedSquareHole(side=0.753+0.015, length=upperLength, center=true,
                           chamferTop=true, chamferBottom=true, chamferRadius=chamferRadius,
                           corners=true, cornerRadius=0.0625);
      
      // Side Bolts
      for (m = [0,1]) mirror([0,m,0])
      for (x = [-1, -3])
      translate([x-0.5,(tube_offset/2)+tube_wall,0])
      rotate([90,0,0])
      FlatHeadBolt();
    }
    
    // Barrel center axis
    translate([0,0,barrelZ]) {
      
      // Chamfer the bolt entrance hole
      translate([-upperLength+barrelExtensionLength,0,0])
      rotate([0,90,0])
      HoleChamfer(r1=boltSleeveRadius+0.015, r2=chamferRadius, teardrop=true);
    
      // Bolt Head Passage
      translate([tube_offset+barrel_offset-ManifoldGap(),0])
      rotate([0,-90,0])
      cylinder(r=boltHeadRadius+0.01, h=upperLength+ManifoldGap(2));
    
      // Bolt Sleeve Passage
      translate([-barrelExtensionLandingHeight+ManifoldGap(),0])
      rotate([0,-90,0])
      cylinder(r=boltSleeveRadius+0.015,
               h=upperLength+ManifoldGap(2));
      
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

      // Ejection Port
      linear_extrude(height=barrelExtensionRadius+barrel_wall+ManifoldGap()) {
        
        // Printable tip
        translate([-(ejectionPortWidth/2)-barrelExtensionLandingHeight,0])
        rotate(-45)
        square([ejectionPortWidth*sqrt(2)/2,ejectionPortWidth*sqrt(2)/2]);
        
        // Main ejection port section
        translate([camPinLockedMinX,0,0])
        translate([-barrelExtensionLandingHeight,-ejectionPortWidth/2,0])
        square([abs(camPinLockedMinX), ejectionPortWidth]);
        
        // Round bottom edges
        translate([camPinLockedMinX+camPinDiameter,0,0])
        for (m = [0,1]) mirror([0,m])
        rotate(-90)
        RoundedBoolean(edgeOffset=-ejectionPortWidth/2, r=chamferRadius, teardrop=true);
      }

      // Ejection Port Cone
      translate([-barrelExtensionLandingHeight, 0, barrelExtensionRadius+barrel_wall])
      rotate([0,90,0])
      cylinder(r1=ejectionPortWidth/2, r2=0, h=ejectionPortWidth);
      
      translate([boltLockLengthDiff,0,0])
      rotate([0,-90,0])
      AR15_Bolt(camPinTravel=true, camPinTravelChamferBack=false,
                teardrop=false, firingPinRetainer=false);
    }
  }
}

module BARBB_CamPinCutout(clearance=0.01, chamferBack=false) {
  clear2 = clearance*2;
  camPinSquareArc = 360/(PI*2*(barrelExtensionRadius+barrel_wall)/camPinSquareWidth);
  
  // Cam Pin cutout
  render()
  rotate(camPinAngleExtra)
  translate([0,0,boltLugLength+camPinOffset])
  union() {
    
    // Cam pin travel
    translate([0,-(camPinSquareWidth/2)-clearance,0])
    cube([camPinSquareOffset+camPinSquareHeight+clearance,
          camPinSquareWidth+clear2,
          boltLockedLength-camPinOffset+camPinDiameter+boltExtraTravel+clearance]);
    
    // Chamfered cam locking slot
    translate([0,0,camPinDiameter])
    intersection() {
      rotate_extrude() {
        
        // Rear Chamfer TODO: Don't wipe out the cam pin support block while chamfering
        if (chamferBack)
        translate([0,camPinShelfLength+clearance])
        RoundedBoolean(edgeOffset=barrelExtensionRadius+barrel_wall+ManifoldGap(),
                        r=chamferRadius,teardrop=true);
        
        // Front Chamfer
        translate([0,-clearance-camPinDiameter-ManifoldGap()])
        mirror([0,1])
        RoundedBoolean(edgeOffset=barrelExtensionRadius+barrel_wall+ManifoldGap(),
                        r=chamferRadius,
                       teardrop=true);
        
        // Cam Pin
        translate([0,-camPinDiameter-clearance-ManifoldGap()])
        square([camPinSquareOffset+camPinSquareHeight+barrel_wall,
                camPinDiameter+camPinShelfLength+clear2+ManifoldGap(2)]);
      }
      
      // Cam pin rotation arc
      translate([0,0,-chamferRadius-camPinDiameter-clearance-ManifoldGap()])
      linear_extrude(height=(chamferRadius*2)+camPinDiameter+camPinShelfLength+clear2+ManifoldGap(2)) {
        rotate(camPinSquareArc/2)
        semicircle(od=(camPinSquareOffset
                      +camPinSquareHeight
                      +barrel_wall)*3,
                   angle=camPinAngle+camPinAngleExtra+camPinSquareArc);
        
        // Cam Pin Square, locked position
        rotate(-camPinAngleExtra-camPinAngle)
        translate([0,-(camPinSquareWidth/2)-0.01])
        square([camPinSquareOffset+camPinSquareHeight+barrel_wall, camPinSquareWidth+0.02]);
        
        // Cam Pin Square, Unlocked position
        translate([0,-(camPinSquareWidth/2)-0.01])
        square([camPinSquareOffset+camPinSquareHeight+barrel_wall, camPinSquareWidth+0.02]);
      }
    }
  }
}


module BARBB_Bolt() {
  translate([-upperLength+barrelExtensionLength-handleLength,0,barrelZ])
  rotate([0,90,0])
  render()
  difference() {
    union() {
      
      // Body
      ChamferedCylinder(r1=boltSleeveRadius,
                        r2=chamferRadius,
                        h=barbbBoltLength);
      
      // Body/Handle Fillet
      translate([0,0,handleLength])
      rotate_extrude()
      RoundedBoolean(edgeOffset=boltSleeveRadius, edgeSign=1, r=chamferRadius);
      
      // Handle
      translate([0,-tube_wall-(tube_offset/2),0])
      ChamferedCube([barrelZ,tube_wall,handleLength], r=chamferRadius);
      
      // Lever
      hull() {
        ChamferedCylinder(r1=barrelExtensionRadius+barrel_wall,
                          r2=chamferRadius,
                          h=handleLength);
        
        translate([0,-(tube_offset/2)-tube_wall,0])
        ChamferedCube([barrel_offset,(tube_offset/2)+tube_wall,handleLength], r=chamferRadius);
      }
      
      // Cam Pin Shelf
      // This keeps the bolt forward while we rotate across several lug positions
      // while also allowing a longer opening for ejection.
      rotate(90+camPinAngle+camPinAngleExtra)
      translate([0,-camPinSquareWidth/2, barbbBoltLength+barrelExtensionLandingHeight+boltLockLengthDiff-boltLugLength-camPinOffset-camPinDiameter-camPinShelfLength-0.01])
      ChamferedCube([boltSleeveRadius+camPinSquareHeight,
                     camPinSquareWidth,
                     camPinShelfLength], r=camPinSquareHeight/3);
    }
    
    translate([0,0,barbbBoltLength+barrelExtensionLandingHeight+(boltLockLengthDiff)])
    rotate([180,0,180])
    AR15_Bolt(extraFiringPin=barrelExtensionLandingHeight
                             +boltExtraTravel);
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

module AR15_Bolt(camPinTravel=false, camPinTravelChamferBack=false, firingPinRetainer=true, extraFiringPin=firingPinExtension, teardrop=true) {
  render()
  union() {
    
    // Lugs
    cylinder(r=boltHeadRadius, h=boltLugLength);
    
    // Bolt Cam Pin
    translate([0,0,boltLugLength+camPinOffset+camPinRadius])
    rotate([0,0,-camPinAngle])
    rotate([0,90,0])
    linear_extrude(height=camPinSquareOffset+camPinSquareHeight+ManifoldGap())
    if (teardrop)
      Teardrop(r=camPinRadius+0.005);
    else
      circle(r=camPinRadius+0.005);
    
    if (camPinTravel)
    BARBB_CamPinCutout(chamferBack=camPinTravelChamferBack);
        
    // Front
    translate([ManifoldGap(),0,0])
    cylinder(r=boltFrontRadius+0.01, h=boltFrontLength+ManifoldGap());
    
    // Front Chamfer
    translate([0,0,barrelExtensionLandingHeight])
    HoleChamfer(r1=boltFrontRadius+0.01, r2=chamferRadius, teardrop=false);
    
    // Middle
    translate([0,0,camPinOffset-ManifoldGap()])
    cylinder(r=boltMiddleRadius+0.015, h=boltMiddleLength+ManifoldGap(2));
    
    // Back
    translate([0,0,-ManifoldGap()])
    cylinder(r=boltBackRadius+0.015, h=boltLength+ManifoldGap(2));
    
    // Firing Pin-to-bolt-back taper
    translate([0,0,boltLength])
    rotate([180,0,0])
    cylinder(r=firingPinRadius+0.025, r2=boltBackRadius+0.01,
            h=firingPinRadius+ManifoldGap());
    
    // Firing Pin
    color("Silver")
    translate([0,0,boltLength-ManifoldGap()])
    cylinder(r=firingPinRadius+0.025, h=firingPinExtension+extraFiringPin+0.1+ManifoldGap(2));
    
    // Firing Pin Chamfer
    if (extraFiringPin>0)
    translate([0,0,boltLength+firingPinExtension+extraFiringPin-ManifoldGap()])
    rotate([0,180,0])
    HoleChamfer(r1=firingPinRadius+0.025, r2=chamferRadius, teardrop=true);
    
    // Firing Pin Retainer
    if (firingPinRetainer)
    translate([-firingPinRadius-ManifoldGap(),
               -boltSleeveRadius,
               boltLength+firingPinRetainerOffset])
    rotate([90,0,0])
    NutAndBolt(bolt=Spec_BoltM3(), boltLength=30/25.4,
                capOrientation=true, capHeightExtra=1, nutEnable=false,
                clearance=true, teardrop=teardrop, teardropAngle=-90);
  }
}


translate([ReceiverLugRearMinX()-16,0,0])
BARBB_Stock();

translate([LowerMaxX()+3,0,0])
BARBB_Foregrip();

translate([ReceiverLugRearMinX()-4.5,0,0]) {
  translate([(boltLockLengthDiff),0,barrelZ])
  rotate([0,-90,0])
  AR15_Bolt(teardrop=false, firingPinRetainer=false, extraFiringPin=0);
  
  color("Green")
  BARBB_Bolt();
  
  color("Tan")
  //render() DebugHalf()
  BARBB_UpperReceiver(magwell=false);
}

color("Tan")
BARBB_LowerReceiver();

color("Silver")
translate([ReceiverLugRearMinX()-6.5-boltLockedLength-barrelExtensionLength-5.8,-tube_offset/2,tube_wall])
cube([24, tube_offset, tube_offset]);

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