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

$fn=20;

// Bullpup AR Barrel Bolt-action (BARBB)

// Configured Values
barrelLength = 16;
hammerTravel = 0.5;
hammerOvertravel=0.125;
tube_wall = 0.3;
barrel_wall = 0.1875;
barrel_offset = 0.75;
barrelExtensionLandingHeight = 0.3;
chamferRadius = 0.1;

magwellOffset = 1;
barrelX = 0; // To the back of the barrel extension
stockWall = 0.5;


// Measured Values
hammerWidth = (5/16)+0.02;
tube_offset = 0.75;
tube_width = 0.75+0.01;

barrelExtensionDiameter = 1;
barrelExtensionRadius = barrelExtensionDiameter/2;
barrelExtensionLength = 0.99;
barrelExtensionLipDiameter=1.25;
barrelExtensionLipRadius = barrelExtensionLipDiameter/2;
barrelExtensionLipLength=0.125;
barrelChamberDiameter = 1;
barrelChamberRadius = barrelChamberDiameter/2;
barrelGasLength = 7.8; // Back of the barrel extension to the gas block shelf
barrelGasDiameter = 0.75;
barrelGasRadius = barrelGasDiameter/2;

camPinAngle    = 22.5;
camPinAngleExtra = 22.5*4;
camPinOffset   = 1.262; // From the front of the lugs to the front of the pin
camPinDiameter = 0.3125;
camPinRadius   = camPinDiameter/2;
camPinSquareOffset = 0.5;
camPinSquareHeight = 0.1;
camPinSquareWidth = 0.402;
camPinShelfLength = 0;

boltHeadDiameter = 0.75+0.008;
boltHeadRadius = boltHeadDiameter/2;
boltLugLength  = 0.277;
boltLength = 2.8;
boltLockedLength = 2.3;// - 0.85;
boltLockLengthDiff = boltLength - boltLockedLength;
boltFrontRadius = 0.527/2;
boltFrontLength = camPinOffset+camPinDiameter+0.01;
boltMiddleRadius = 0.49/2;
boltMiddleLength = 2.25;
boltBackRadius = 0.25/2;

firingPinRadius = 0.337/2;
firingPinExtension = 0.55;      // From the back of the bolt
firingPinRetainerOffset = 0.35; // From the back of the bolt



// Calculated Values
boltSleeveDiameter = barrelExtensionDiameter;
boltSleeveRadius = boltSleeveDiameter/2;


tubeCenterZ = tube_wall+(tube_offset/2);
boltLockedMinX = barrelX-boltLockedLength;
boltLockedMaxX = barrelX+boltLockLengthDiff;


barrelZ = tube_offset+tube_wall+barrel_offset;
lowerLength = LowerMaxX()+abs(ReceiverLugRearMinX());
                
camPinLockedMaxX = boltLockedMaxX -camPinOffset;
camPinLockedMinX = camPinLockedMaxX -camPinDiameter;

upperLength = barrelExtensionLength+abs(camPinLockedMaxX)-0.01;
upperMinX = -upperLength+barrelExtensionLength;

firingPinMinX  = boltLockedMinX -firingPinExtension;
hammerMaxX = firingPinMinX + hammerOvertravel;
hammerMinX = firingPinMinX -hammerWidth -hammerTravel;

stockMinX = hammerMinX-stockWall;
stockLength=abs(hammerMinX)+upperMinX+stockWall;

barbbBoltLength = stockLength
                + barrelExtensionLandingHeight;
handleLength=abs(hammerMinX-hammerMaxX)+firingPinExtension-hammerOvertravel;
handleMinX = stockMinX;//+stockWall;


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
module FlatHeadBolt(diameter=0.193, headDiameter=0.353, extraHead=1, length=0.3955, teardrop=true) {
  radius = diameter/2;
  
  render()
  union() {
    
    if (teardrop) {
      linear_extrude(height=length)
      Teardrop(r=radius, $fn=20);
    } else {
      cylinder(r=radius, h=length, $fn=20);
    }
    
    cylinder(r1=headDiameter/2, r2=0, h=headDiameter/2);
    
    translate([0,0,-extraHead])
    cylinder(r=headDiameter/2, h=extraHead+ManifoldGap());
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
      ChamferedSquareHole(side=tube_width, length=lowerLength, center=true,
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
      
      translate([LowerMaxX(),0,0])
      rotate([0,-90,0])
      ChamferedCircularHole(r1=barrelGasRadius+0.007, r2=chamferRadius,
                            h=lowerLength,
                            chamferTop=false, teardropBottom=true);
    
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
      cylinder(r=barrelGasRadius+0.01, h=lowerLength);
      
      // Chamfer the gas block entrance hole
      translate([LowerMaxX(),0,0])
      rotate([0,-90,0])
      HoleChamfer(r1=(0.75/2)+0.01, r2=chamferRadius, teardrop=true);
    }
    
    SearCutter(length=tube_wall+(tube_offset/2)+0.9+SearTravel());
  }
}

module BARBB_UpperReceiver(magwell=false) {
  
  
  render()
  difference() {
    translate([-upperLength,0,0])
    union() {

      // Barrel section
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
      ChamferedSquareHole(side=tube_width, length=upperLength, center=true,
                           chamferTop=true, chamferBottom=true, chamferRadius=chamferRadius,
                           corners=true, cornerRadius=0.0625);
      
      // Side Bolts
      for (m = [0,1]) mirror([0,m,0])
      for (x = [-0.75, -2])
      translate([x,(tube_offset/2)+tube_wall,0])
      rotate([90,0,0])
      FlatHeadBolt();
      
    }
      
    // Hammer Slot
    translate([upperMinX-ManifoldGap(),-(hammerWidth/2)-0.01,0])
    cube([abs(upperMinX)-boltLockedLength-firingPinExtension+0.01+ManifoldGap(),
          hammerWidth+0.02,
          tube_offset+tube_wall+barrel_offset]);
    
    // Barrel center axis
    translate([0,0,barrelZ]) {
      
      // Chamfer the bolt entrance hole
      translate([-upperLength+barrelExtensionLength,0,0])
      rotate([0,90,0])
      HoleChamfer(r1=boltSleeveRadius+0.015, r2=chamferRadius, teardrop=true);
    
      // Bolt Passage
      translate([-barrelExtensionLandingHeight+ManifoldGap(),0])
      rotate([0,-90,0])
      cylinder(r=boltSleeveRadius+0.015,
               h=upperLength+ManifoldGap(2));
      
      // Bolt  Taper
      translate([-barrelExtensionLandingHeight-ManifoldGap(),0])
      rotate([0,90,0])
      cylinder(r1=boltSleeveRadius+0.015, r2=boltHeadRadius+0.008,
               h=(barrelExtensionLandingHeight/2)+ManifoldGap(2));
    
      // Bolt Head Passage
      translate([tube_offset+barrel_offset-ManifoldGap(),0])
      rotate([0,-90,0])
      cylinder(r=boltHeadRadius+0.01, h=upperLength+ManifoldGap(2));
      
      rotate([0,90,0])
      AR15_Barrel(clearance=0.007);
      
      translate([boltLockedMaxX,0,0])
      rotate([0,-90,0])
      AR15_Bolt(clearance=0.05, camPin=false);

    }
  }
}

module BARBB_CamPinCutout(clearance=0.01, chamferBack=false) {
  clear2 = clearance*2;
  camPinSquareArc = 360/(PI*2*(barrelExtensionRadius+barrel_wall)/camPinSquareWidth);
  
  // Cam Pin cutout
  render()
  rotate(camPinAngleExtra)
  translate([0,0,camPinOffset])
  union() {
    
    // Cam pin travel
    translate([0,-(camPinSquareWidth/2)-clearance,0])
    cube([camPinSquareOffset+camPinSquareHeight+clearance,
          camPinSquareWidth+clear2,
          abs(stockMinX-camPinLockedMaxX)+ManifoldGap()]);
    
    // Cam pin rotation arc
    translate([0,0,-chamferRadius-clearance-ManifoldGap()])
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

module BARBB_HammerCutOut() {
  
  // X-Zero on the firing pin's back face
  translate([hammerMinX,-hammerWidth/2,tubeCenterZ-(hammerWidth/2)]) {
    
    // Hammer linear track
    cube([abs(hammerMaxX-hammerMinX),
                    hammerWidth,
                    barrelZ-tubeCenterZ+(hammerWidth/2)+firingPinRadius], r=chamferRadius);
    
    
    // Hammer rotary track
    rotate([0,90,0])
    linear_extrude(height=hammerWidth)
    rotate(-90)
    semicircle(od=((barrelZ-tubeCenterZ+(hammerWidth/2)+firingPinRadius)*2), angle=90);
    
    // Hammer rotary track, rounded inside corner)
    translate([hammerWidth,0,0])
    linear_extrude(height=barrelZ-tubeCenterZ+(hammerWidth/2)+firingPinRadius)
    rotate(180)
    RoundedBoolean(edgeOffset=0, edgeSign=-1, r=hammerWidth);
  }
}

module BARBB_Bolt(clearance=0.01) {
  chamferClearance = 0.01;
  
  echo("barbbBoltLength", barbbBoltLength);
  
  render()
  difference() {
    
    translate([stockMinX,0,barrelZ])
    rotate([0,90,0])
    union() {
      
      // Body
      ChamferedCylinder(r1=boltSleeveRadius,
                        r2=chamferRadius,
                        h=barbbBoltLength);
      
      // Lever
      translate([-barrelExtensionRadius,-(tube_wall*2)-(tube_offset/2),handleMinX-stockMinX])
      ChamferedCube([barrelZ,tube_wall,handleLength-chamferClearance], r=chamferRadius);
      
      // Lever Support
      translate([-boltSleeveRadius,-(tube_wall*2)-(tube_offset/2),handleMinX-stockMinX])
      ChamferedCube([boltSleeveDiameter,
                     (tube_wall*2)+(tube_offset/2)+chamferRadius,
                     handleLength-chamferClearance],
                    r=chamferRadius);
      
      // Cam Pin Shelf
      // This keeps the bolt forward while we rotate across several lug positions
      // while also allowing a longer opening for ejection.
      rotate(90+camPinAngle+camPinAngleExtra)
      translate([0,-camPinSquareWidth/2,
                 barbbBoltLength
                 +barrelExtensionLandingHeight
                 +boltLockLengthDiff
                 -camPinOffset-camPinDiameter-camPinShelfLength])
      ChamferedCube([boltSleeveRadius+camPinSquareHeight-clearance,
                     camPinSquareWidth,
                     camPinShelfLength-clearance], r=camPinSquareHeight/3);
    }
    
    
    // Hammer Safety Catch
    translate([hammerMinX,-barrelZ,tubeCenterZ+hammerWidth])
    mirror([0,0,1])
    cube([hammerWidth, barrelZ, tubeCenterZ]);
    
    
    // Firing Pin Rear Hole Chamfer
    translate([stockMinX,0,barrelZ])
    rotate([0,90,0])
    HoleChamfer(r1=firingPinRadius+(clearance*2), r2=chamferRadius, teardrop=true);
    
    translate([boltLockedMaxX,0,barrelZ])
    rotate([0,-90,0])
    AR15_Bolt();
    
    // Hammer Track
    translate([hammerMinX,0,barrelZ])
    rotate([0,90,0]) {
    
      // Hammer Pin Cocking Ramp
      intersection() {
        
        linear_extrude(height=hammerWidth+hammerTravel+hammerOvertravel,
                        twist=(camPinAngleExtra),
                       slices=$fn*2)
        rotate(camPinAngleExtra)
        translate([0,-hammerWidth*3.5])
        square([barrel_offset, hammerWidth*4]);
      
        linear_extrude(height=hammerTravel+(hammerWidth*2))
        translate([barrelZ,0])
        rotate(180)
        semicircle(od=(barrelZ+firingPinRadius)*2, angle=90);
      }
    
      // Hammer travel
      translate([0,-(hammerWidth/2),0])
      cube([barrel_offset, hammerWidth, hammerWidth+hammerTravel+hammerOvertravel]);
    }
  }
}

module BARBB_Hammer() {
  color("Orange")
  translate([0,0,tubeCenterZ])
  rotate([0,-90,0])
  cylinder(r=hammerWidth/2,
           h=-ReceiverLugFrontMinX()
            +barrelGasLength
            +abs(hammerMinX)
            -ManifoldGap());
  
  color("Red")
  translate([ReceiverLugFrontMinX()-barrelGasLength+hammerMinX,0,tubeCenterZ])
  translate([0, -hammerWidth/2, -hammerWidth/2])
  cube([hammerWidth, hammerWidth, barrelZ-tubeCenterZ+(hammerWidth/2)]);
}

module BARBB_Stock(topDiameter=tube_offset+(tube_wall*2), bottomDiameter=1,
                  wall=0.25, clearance=0.01) {
                     
  echo("stockLength = ", stockLength);
                     leverMinX=0;

  render()
  difference() {
    
    translate([stockMinX,0,0])
    rotate([0,90,0])
    union() {
        
      hull() {

        // Body
        translate([-barrelZ,0,0])
        ChamferedCylinder(r1=barrelExtensionRadius+barrel_wall,
                          r2=chamferRadius,
                           h=stockLength);
        
        
        translate([-barrelZ,0,0])
        for (m=[0,1]) mirror([0,m,0])
        rotate(180-camPinAngleExtra)
        translate([0,-tube_wall-(camPinSquareWidth/2),0])
        ChamferedCube([boltSleeveRadius+camPinSquareHeight+barrel_wall,
                       camPinSquareWidth+(tube_wall*2),
                       stockLength],
                      r=chamferRadius);
      }
        
        // Square Tube Sleeve
        translate([-tubeCenterZ-barrel_offset, -topDiameter/2,-ManifoldGap()])
        ChamferedCube([tubeCenterZ+barrel_offset, topDiameter,
                        stockLength+ManifoldGap()], r=chamferRadius);
    }
      
    translate([boltLockedMaxX,0,barrelZ])
    rotate([0,-90,0]) {
      AR15_Bolt(camPin=false, teardrop=false, firingPinRetainer=false);
      
      BARBB_CamPinCutout(chamferBack=false);
    }
    
    // Bolt Track
    translate([stockMinX-ManifoldGap(),0,barrelZ])
    rotate([0,90,0])
    ChamferedCircularHole(r1=boltSleeveRadius+clearance, r2=barrel_wall,
                           h=stockLength+ManifoldGap(2));
  
    // Bolt Lever Unlocked Track
    translate([stockMinX-ManifoldGap(),-barrelZ+boltSleeveRadius+clearance,barrelZ])
    cube([abs(handleMinX-stockMinX)+handleLength+clearance-chamferRadius+ManifoldGap(2),
          barrelZ+ManifoldGap(),
          (barrelZ*2)+ManifoldGap()]);
  
    // Bolt Lever Locked Track
    translate([stockMinX-ManifoldGap(2),-barrelZ,barrelZ-boltSleeveRadius-clearance])
    cube([abs(handleMinX-stockMinX)+handleLength+clearance-chamferRadius+ManifoldGap(2),
          barrelZ+ManifoldGap(),
          barrelZ]);
    
    // Square Tube Hole
    translate([hammerMaxX-ManifoldGap(),0,tubeCenterZ])
    rotate([0,90,0])
    ChamferedSquareHole(side=tube_width, length=stockLength, center=true,
                       chamferTop=true, chamferBottom=false, chamferRadius=chamferRadius,
                       corners=true, cornerRadius=0.0625);
    
    // Side Bolts
    //translate([-boltLockedMinX,0,tubeCenterZ])
    for (m = [0,1]) mirror([0,m,0])
    for (x = [0.5, 1.5])
    translate([stockMinX+stockLength-x,tubeCenterZ,tubeCenterZ])
    rotate([90,0,0])
    FlatHeadBolt();
    
    BARBB_HammerCutOut();
  }
}

module BARBB_Foregrip(topDiameter=tube_offset+(tube_wall*2), bottomDiameter=1, length=1.5, extend=3, wall=0.25) {
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
    ChamferedSquareHole(side=tube_width, length=extend, center=true,
                         chamferTop=true, chamferBottom=false, chamferRadius=chamferRadius,
                         corners=true, cornerRadius=0.0625);
    
    // Side Bolts
    for (m = [0,1]) mirror([0,m,0])
    translate([0,(tube_offset/2)+tube_wall,1])
    rotate([90,-90,0])
    FlatHeadBolt();
  }
}

module AR15_Bolt(clearance=0.007, camPin=true, firingPinRetainer=true,
                 extraFiringPin=abs(stockMinX), // Ugly, but it'll do
                 teardrop=true) {
  clear2 = clearance*2;
               
  color("Gold")
  render()
  union() {
    
    // Lugs
    cylinder(r=boltHeadRadius, h=boltLugLength);
    
    // Bolt Cam Pin
    if (camPin)
    translate([0,0,camPinOffset+camPinRadius])
    rotate([0,0,-camPinAngle])
    rotate([0,90,0])
    linear_extrude(height=camPinSquareOffset+camPinSquareHeight+ManifoldGap())
    if (teardrop)
      Teardrop(r=camPinRadius+clearance);
    else
      circle(r=camPinRadius+clearance);
        
    // Front
    translate([0,0,boltLugLength])
    cylinder(r=boltFrontRadius+clearance, h=boltFrontLength+ManifoldGap());
    
    // Front Chamfer
    translate([0,0,barrelExtensionLandingHeight])
    HoleChamfer(r1=boltFrontRadius+clearance, r2=chamferRadius, teardrop=false);
    
    // Middle
    cylinder(r=boltMiddleRadius+clearance, h=boltMiddleLength+ManifoldGap(2));
    
    // Back
    translate([0,0,-ManifoldGap()])
    cylinder(r=boltBackRadius+clearance, h=boltLength+ManifoldGap(2));
    
    // Firing Pin-to-bolt-back taper
    translate([0,0,boltLength])
    rotate([180,0,0])
    cylinder(r=firingPinRadius+clear2, r2=boltBackRadius+clearance,
            h=firingPinRadius+ManifoldGap());
    
    // Firing Pin
    color("Silver")
    translate([0,0,boltLength-ManifoldGap()])
    cylinder(r=firingPinRadius+clear2, h=firingPinExtension+extraFiringPin+ManifoldGap(2));
    
    // Firing Pin Retainer
    if (firingPinRetainer)
    translate([-firingPinRadius-ManifoldGap(),
               firingPinRadius+(4/25.4),
               boltLength+firingPinRetainerOffset])
    rotate([90,0,0])
    NutAndBolt(bolt=Spec_BoltM3(), boltLength=16/25.4,
                capOrientation=false, capHeightExtra=1, nutEnable=false,
                clearance=false, teardrop=teardrop, teardropAngle=-90);
  }
}

module AR15_Barrel(pinRadius=0.125/2, pinHeight=0.09, pinDepth=0.162, clearance=0.01) {
  color("DimGrey")
  render() union() {
    
    // Barrel Extension
    cylinder(r=barrelExtensionRadius+clearance, h=barrelExtensionLength+ManifoldGap());
    
    // Barrel Locating Pin
    translate([barrelExtensionRadius-pinHeight,-pinRadius,barrelExtensionLength-pinDepth])
    cube([pinHeight*2,pinRadius*2,pinDepth+ManifoldGap()]);
    
    // Barrel Extension Lip
    translate([0,0,barrelExtensionLength])
    cylinder(r=barrelExtensionLipRadius+clearance, h=barrelExtensionLipLength);
    
    // Barrel, up to the gas block
    cylinder(r=barrelChamberRadius+clearance, h=barrelGasLength+ManifoldGap());
    
    // Barrel, from the gas block on
    cylinder(r=0.75/2, h=barrelLength);
  }
}


// Lower/Front-end
translate([-ReceiverLugFrontMinX()+barrelGasLength,0,0]) {
  translate([LowerMaxX()+3,0,0])
  BARBB_Foregrip();

  color("Tan")
  render() DebugHalf()
  BARBB_LowerReceiver();

  Lower(showReceiverLugBolts=true,showGuardBolt=true, showHandleBolts=true,
        showTrigger=true, 
        searLength=tubeCenterZ+abs(SearPinOffsetZ()) + SearTravel());
  
  BARBB_Hammer();
}

// Upper/Rear-end
{
  
  translate([0,0,barrelZ])
  rotate([0,90,0])
  AR15_Barrel();
  
  // Hammer Mock
  *translate([hammerMinX,-hammerWidth/2,tubeCenterZ-(hammerWidth/2)])
  %cube([hammerWidth+hammerTravel+hammerOvertravel, hammerWidth, barrelZ-tubeCenterZ+(hammerWidth/2)]);

  translate([boltLockedMaxX,0,barrelZ])
  rotate([0,-90,0])
  AR15_Bolt(teardrop=false, firingPinRetainer=false, extraFiringPin=0);
  
  color("Salmon")
  //render() DebugHalf()
  BARBB_Bolt();
  
  color("Tan", 0.75)
  //render() DebugHalf()
  BARBB_UpperReceiver(magwell=false);
  
  color("Olive", 0.5)
  //render() DebugHalf()
  BARBB_Stock();
  
  // Square Tube
  color("Silver", 0.5)
  translate([hammerMaxX, ManifoldGap(), tubeCenterZ])
  render() DebugHalf()
  rotate([0,90,0])
  linear_extrude(height=26)
  difference() {
    square(tube_width, center=true);
    square(tube_width-0.25, center=true);
  };
}


// Hammer block
*!render() scale(25.4) difference() {
  ChamferedCube([0.5-0.01, 0.5-0.01, 1+ManifoldGap()], r=0.025, center=true);
  cylinder(r=(5/16/2)-0.01, h=2+ManifoldGap(2), center=true);
}

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