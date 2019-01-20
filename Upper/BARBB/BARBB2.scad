use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Components/Bipod.scad>;
use <../../Components/T Lug.scad>;
use <../../Finishing/Chamfer.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Square Tube.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/AR15/Barrel.scad>;
include <../../Vitamins/AR15/Bolt.scad>;
use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Lower.scad>;
use <../../Lower/Trigger.scad>;

$fn=Resolution(20, 60);

// Bullpup AR Barrel Bolt-action (BARBB)



BARREL_PIPE = Spec_TubingZeroPointSevenFive();
RECEIVER_PIPE = Spec_OnePointFiveSch40ABS();
BOLT_ROD = Spec_RodOneHalfInch();
BOLT = Spec_BoltOneHalf();
BOLT_GUIDE_ROD = Spec_RodOneQuarterInch();
BOLT_SEAR_ROD = Spec_RodOneQuarterInch();
EJECTOR_PIVOT_ROD = Spec_RodOneEighthInch();

// Configured Values
hammerTravel = 1.25;
hammerOvertravel=0.125;
tubeWall = 0.25;
barrelWall = 0.25;
barrelOffset = 1;
barrelExtensionLandingHeight = 0.3;
chamferRadius = 0.1;

barrelX = 0; // To the back of the barrel extension
stockWall = 0.5;


// Measured Values
hammerWidth = (5/16)+0.02;
tube_width =1.015;// 0.75;
tubeInnerWidth = 1-(1/8);
springRadius = 0.75/2;
springLength = 3;
gasShaftCollarWidth = 9/16;
gasShaftCollarOD    = 1.25;


// Calculated Values
boltSleeveDiameter = AR15BarrelExtensionDiameter();
boltSleeveRadius   = AR15BarrelExtensionRadius();


tubeCenterZ = tubeWall+(tube_width/2);
boltLockedMinX = barrelX-boltLockedLength;
boltLockedMaxX = barrelX+boltLockLengthDiff;


barrelZ = tube_width+tubeWall+barrelOffset;
lowerLength = LowerMaxX()+abs(ReceiverLugRearMinX())+0.25;
lowerX = -ReceiverLugFrontMinX()+AR15BarrelGasLength()+gasShaftCollarWidth;
                
camPinLockedMaxX = boltLockedMaxX -camPinOffset;
camPinLockedMinX = camPinLockedMaxX -camPinDiameter;

upperLength = AR15BarrelExtensionLength()+abs(camPinLockedMaxX)+AR15BarrelExtensionLipLength()-0.01;
upperMinX = -upperLength+AR15BarrelExtensionLength()+AR15BarrelExtensionLipLength();
upperMaxX = upperMinX+upperLength;

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


module BARBB_CamPinCutout(clearance=0.01, chamferBack=false) {
  clear2 = clearance*2;
  camPinSquareArc = 360/(PI*2*(AR15BarrelExtensionRadius()+barrelWall)/camPinSquareWidth);
  
  // Cam Pin cutout
  render()
  rotate(camPinAngleExtra)
  translate([0,0,camPinOffset])
  union() {
    
    // Cam pin linear travel
    translate([0,-(camPinSquareWidth/2)-clearance,ManifoldGap()])
    cube([camPinSquareOffset+camPinSquareHeight+clearance,
          camPinSquareWidth+clear2,
          abs(stockMinX-camPinLockedMaxX)+ManifoldGap()]);
    
    // Cam pin rotation arc
    translate([0,0,-clearance-ManifoldGap()])
    linear_extrude(height=camPinDiameter+camPinShelfLength+clear2+ManifoldGap(2)) {
      rotate(camPinSquareArc/2)
      semicircle(od=(camPinSquareOffset
                    +camPinSquareHeight
                    +barrelWall)*3,
                 angle=camPinAngle+camPinAngleExtra+camPinSquareArc);
      
      // Cam Pin Square, locked position
      rotate(-camPinAngleExtra-camPinAngle)
      translate([0,-(camPinSquareWidth/2)-0.01])
      square([camPinSquareOffset+camPinSquareHeight+barrelWall, camPinSquareWidth+0.02]);
      
      // Cam Pin Square, Unlocked position
      translate([0,-(camPinSquareWidth/2)-0.01])
      square([camPinSquareOffset+camPinSquareHeight+barrelWall, camPinSquareWidth+0.02]);
    }
  }
}

module BARBB_HammerCutOut(extraX=0) {
  
  // X-Zero on the firing pin's back face
  translate([hammerMinX,-hammerWidth/2,tubeCenterZ-(hammerWidth/2)]) {
    
    // Hammer linear track
    cube([abs(hammerMaxX-hammerMinX)+extraX,
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


module BARBB_LowerReceiver(clearance=0.007, extraFront=0,wall=tubeWall) {
  
  render()
  difference() {
    union() {
      
      translate([LowerMaxX(),0,0]) {
        
        hull() {
          // Barrel/Bolt Body
          translate([0,0,barrelZ])
          rotate([0,-90,0])
          ChamferedCylinder(r1=0.5+wall,
                            r2=chamferRadius,
                            h=LowerMaxX()-ReceiverLugFrontMinX());
          
          translate([0, -tubeCenterZ, 0])
          rotate([0,-90,0])
          ChamferedCube([tube_width+(tubeWall*2),
                         tube_width+(tubeWall*2),
                         LowerMaxX()-ReceiverLugFrontMinX()],
                        r=chamferRadius, center=false);
        }
        
        // Square Tube Body
        translate([0, -tubeCenterZ, 0])
        rotate([0,-90,0])
        ChamferedCube([tube_width+(tubeWall*2),
                       tube_width+(tubeWall*2),
                       lowerLength], r=chamferRadius, center=false);
      }
      
      ReceiverLugFront(extraTop=tubeWall);
      
      ReceiverLugRear(extraTop=tubeWall);
    }

    // Square Tube center axis
    translate([0,0,tubeCenterZ]) {
      
      translate([LowerMaxX(),0,0])
      rotate([0,-90,0])
      ChamferedSquareHole(side=tube_width, length=lowerLength, center=true,
                           chamferTop=true, chamferBottom=true, chamferRadius=chamferRadius,
                           corners=true, cornerRadius=0.0625);
    }
    
    // Barrel center axis
    translate([0,0,barrelZ]) {
      
      translate([LowerMaxX(),0,0])
      rotate([0,-90,0])
      ChamferedCircularHole(r1=AR15BarrelGasRadius()+clearance, r2=chamferRadius,
                            h=LowerMaxX()-ReceiverLugFrontMinX(),
                            chamferTop=true, teardropBottom=true);
    
      
      // Gas Block Hole
      translate([ReceiverLugFrontMinX()-ManifoldGap(),0,0])
      rotate([0,90,0])
      cylinder(r=AR15BarrelGasRadius()+0.01, h=lowerLength);
      
      // Chamfer the gas block entrance hole
      translate([LowerMaxX(),0,0])
      rotate([0,-90,0])
      HoleChamfer(r1=(0.75/2)+0.01, r2=chamferRadius, teardrop=true);
    }
    
    SearCutter(length=tubeCenterZ+0.9+SearTravel());
  }
}

module BARBB_UpperReceiver() {
  
  render()
  difference() {
    translate([upperMinX,0,0])
    union() {

      // Barrel section
      translate([0,0,barrelZ])
      rotate([0,90,0])
      ChamferedCylinder(r1=AR15BarrelExtensionRadius()+barrelWall, r2=chamferRadius,
                        h=upperLength-ManifoldGap());
  
      // Square Tube Body
      translate([0,-tubeCenterZ,barrelZ])
      rotate([0,90,0])
      ChamferedCube([tube_width+tubeWall+barrelOffset,
                     tube_width+(tubeWall*2),
                     upperLength-ManifoldGap()], r=chamferRadius);
    }
    
    // Square Tube
    translate([upperMinX,0,tubeCenterZ])
    translate([ManifoldGap(),0,0])
    rotate([0,90,0])
    ChamferedSquareHole(side=tube_width, length=upperLength, center=true,
                         chamferTop=true, chamferBottom=true,
                         teardropTop=true, teardropBottom=false,
                         chamferRadius=chamferRadius,
                         corners=true, cornerRadius=0.0625);
    
    // Barrel center axis
    translate([upperMinX,0,barrelZ]) {
    
      // Bolt Head Passage
      rotate([0,90,0])
      cylinder(r=boltHeadRadius+0.01, h=upperLength+ManifoldGap(2));
    
      // Bolt Sleeve  Passage
      translate([-ManifoldGap(),0,0])
      rotate([0,90,0])
      cylinder(r=boltSleeveRadius+0.015,
               h=barrelExtensionLandingHeight+ManifoldGap(2));
      
      // Chamfer the bolt passage inside diameter
      rotate([0,90,0])
      HoleChamfer(r1=boltSleeveRadius+0.015, r2=chamferRadius, teardrop=true);
      
      // Barrel Extension Rear Support Cone
      translate([barrelExtensionLandingHeight,0,0])
      rotate([0,90,0])
      cylinder(r1=boltSleeveRadius+0.015, r2=boltHeadRadius+0.008,
               h=boltSleeveRadius/3);
    }
    
    translate([0,0,barrelZ])
    rotate([0,90,0])
    AR15_Barrel(clearance=0.005);
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
      translate([-AR15BarrelExtensionRadius(),-(tubeWall*2)-(tube_width/2),handleMinX-stockMinX])
      ChamferedCube([barrelZ,tubeWall,handleLength-chamferClearance], r=chamferRadius);
      
      // Lever Support
      translate([-boltSleeveRadius,-(tubeWall*2)-(tube_width/2),handleMinX-stockMinX])
      ChamferedCube([boltSleeveDiameter,
                     (tubeWall*2)+(tube_width/2)+chamferRadius,
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
        square([barrelOffset, hammerWidth*4]);
      
        linear_extrude(height=hammerTravel+(hammerWidth*2))
        translate([barrelZ,0])
        rotate(180)
        semicircle(od=(barrelZ+firingPinRadius)*2, angle=90);
      }
    
      // Hammer travel
      translate([0,-(hammerWidth/2),0])
      cube([barrelOffset, hammerWidth, hammerWidth+hammerTravel+hammerOvertravel]);
    }
  }
}

module BARBB_Hammer() {
  color("Orange")
  translate([-0.125,0,tubeCenterZ])
  rotate([0,-90,0]) {
    
    // Hammer rod
    cylinder(r=hammerWidth/2,
             h=-ReceiverLugFrontMinX()-0.125
              +AR15BarrelGasLength()
              +abs(hammerMinX)
              -ManifoldGap());
    
    // Nut
    rotate(90)
    cylinder(r=(0.575/2), h=0.25, $fn=6);
  }
  
  color("Red")
  translate([ReceiverLugFrontMinX()-AR15BarrelGasLength()+hammerMinX,0,tubeCenterZ])
  translate([0, -hammerWidth/2, -hammerWidth/2])
  cube([hammerWidth, hammerWidth, barrelZ-tubeCenterZ+(hammerWidth/2)]);
}

module BARBB_HammerSpringTrunnion(clearance=0.007) {
  
  clear2 = clearance*2;
  
  hammerSpringTrunnionLength = abs(hammerMaxX)+upperMaxX;
  echo("hammerSpringTrunnionLength", hammerSpringTrunnionLength);
  
  // Mock Spring
  %color("DimGrey", 0.8)
  translate([upperMaxX,0,tubeCenterZ])
  rotate([0,90,0])
  cylinder(r=springRadius, h=springLength);

  render()
  difference() {
    
    // Trunnion body
    translate([hammerMaxX,
               -(tubeInnerWidth/2)+clearance,
               tubeCenterZ-(tubeInnerWidth/2)+clear2])
    ChamferedCube([hammerSpringTrunnionLength,
                   tubeInnerWidth-clear2,
                   tubeInnerWidth-clear2],
                  r=chamferRadius);
    
    // Hammer
    translate([hammerMaxX-ManifoldGap(),0,tubeCenterZ])
    rotate([0,90,0])
    ChamferedCircularHole(r1=(hammerWidth/2)+clearance,
                          r2=chamferRadius,
                          h=hammerSpringTrunnionLength+ManifoldGap(2),
                          teardropTop=true, teardropBottom=true);
    
    // Hammer Curve Clearance
    translate([hammerMaxX,
               -(hammerWidth/2)-clearance,
               tubeCenterZ])
    cube([hammerWidth, hammerWidth+clear2, tubeInnerWidth]);
  }
}

module BARBB_HammerGuide(clearance=0.005) {
  clear2=clearance*2;
  hammerGuideLength = abs(ReceiverLugRearMinX());
  cutoutLength = (hammerWidth*1.5)+hammerTravel+hammerOvertravel;
  
  translate([-0.125,0,0])
  render()
  difference() {
    
    // Hammer Guide Body
    translate([-hammerGuideLength+ManifoldGap(),0,0])
    translate([0,
               -(tubeInnerWidth/2)+clearance,
               tubeCenterZ-(tubeInnerWidth/2)+clearance])
    ChamferedCube([hammerGuideLength,
                   tubeInnerWidth-clear2,
                   tubeInnerWidth-clear2],
                  r=chamferRadius);
    
    // Hammer
    translate([-ManifoldGap(),0,tubeCenterZ])
    rotate([0,-90,0])
    ChamferedCircularHole(r1=(hammerWidth/2)+clearance,
                          r2=chamferRadius,
                          h=hammerGuideLength+ManifoldGap(2),
                          teardropTop=true, chamferBottom=false);
    
    // Sear Track
    translate([-hammerTravel-hammerOvertravel-hammerWidth,-hammerWidth/2,-0.23])
    cube([hammerTravel+hammerOvertravel+hammerWidth+ManifoldGap(),
          hammerWidth,
          tubeCenterZ]);
          
    // Lower Bolt Tracks
    for(m = [0,1]) mirror([0,m,0])
    translate([ManifoldGap(),(tubeInnerWidth/2)-0.34+tubeWall-clearance,tubeCenterZ-0.125])
    mirror([1,0,0])
    cube([hammerGuideLength+ManifoldGap(2),
          tubeCenterZ,
          0.25]);
    
    // Nut
    translate([ManifoldGap(),0,tubeCenterZ])
    rotate([90,0,-90])
    cylinder(r=(0.575/2)+0.005, h=0.25, $fn=6);
    
  }
}

module BARBB_Receiver_T_Lug(height=1+chamferRadius, cutter=false) {
  render()
  difference() {
  
    // T-Lug
    translate([stockMinX+stockWall,0,chamferRadius])
    translate([0,0,-height-ManifoldGap()])
    T_Lug(length=2, height=height, clearVertical=true, cutter=cutter);
  }
}

module BARBB_Stock(topDiameter=tube_width+(tubeWall*2), bottomDiameter=1,
                  wall=0.25, clearance=0.008) {
                    
  clear2 = clearance*2;
                     
  echo("stockLength = ", stockLength);
                     leverMinX=0;

  render()
  difference() {
    union() {
        
      translate([stockMinX,0,0])
      rotate([0,90,0])
      hull() {

        // Body
        translate([-barrelZ,0,0])
        ChamferedCylinder(r1=AR15BarrelExtensionRadius()+barrelWall,
                          r2=chamferRadius,
                           h=stockLength);
        
        
        translate([-barrelZ,0,0])
        rotate(180-camPinAngleExtra)
        translate([0,-tubeWall-(camPinSquareWidth/2),0])
        ChamferedCube([boltSleeveRadius+camPinSquareHeight+barrelWall,
                       camPinSquareWidth+(tubeWall*2),
                       stockLength],
                      r=chamferRadius);
      }
        
      // Square Tube Sleeve
      translate([stockMinX,0,0])
      rotate([0,90,0])
      translate([-barrelZ, -topDiameter/2,-ManifoldGap()])
      ChamferedCube([barrelZ, topDiameter,
                      stockLength+ManifoldGap()], r=chamferRadius);
      
      BARBB_Receiver_T_Lug();
    }
      
    translate([boltLockedMaxX,0,barrelZ])
    rotate([0,-90,0]) {
      AR15_Bolt(camPin=false, teardrop=false, firingPinRetainer=false);
      
      BARBB_CamPinCutout(chamferBack=false);
    }
    
    // Bolt Track
    translate([stockMinX-ManifoldGap(),0,barrelZ])
    rotate([0,90,0])
    ChamferedCircularHole(r1=boltSleeveRadius+clear2, r2=chamferRadius,
                           h=stockLength+ManifoldGap(2));
  
    // Bolt Lever Track
    hull()
    translate([0,0,barrelZ-clearance])
    for (r=[0,-camPinAngle-camPinAngleExtra]) rotate([r,0,0])
    translate([stockMinX-ManifoldGap(2),-barrelZ,-boltSleeveRadius])
    cube([abs(handleMinX-stockMinX)+handleLength+clearance+ManifoldGap(2),
          barrelZ+ManifoldGap(),
          (boltSleeveRadius*2)+clearance]);
    
    // Square Tube Hole
    translate([hammerMaxX-ManifoldGap(),0,tubeCenterZ])
    rotate([0,90,0])
    ChamferedSquareHole(side=tube_width+clear2, length=stockLength, center=true,
                       chamferTop=true, chamferBottom=false, chamferRadius=chamferRadius,
                       corners=true, cornerRadius=0.0625);
    
    BARBB_HammerCutOut(extraX=1);
  }
}

module BARBB_Buttpad(topDiameter=tube_width+(tubeWall*2), bottomDiameter=1,
                     length=2, extend=2+stockWall-ManifoldGap()) {
  difference() {
    translate([stockMinX,0,0])
    rotate([0,90,0])
    hull() {
      translate([0.008, -topDiameter/2,-ManifoldGap()])
      ChamferedCube([1+chamferRadius, topDiameter, extend+ManifoldGap()],
                     r=chamferRadius);
      
      translate([length,0,0])
      ChamferedCylinder(r1=bottomDiameter/2, r2=chamferRadius, h=extend/2);
    }
    
    BARBB_Receiver_T_Lug(cutter=true);
  }
}
  

module BARBB_Foregrip(topDiameter=tube_width+(tubeWall*2), bottomDiameter=1,
                      length=2, extend=2, frontWall=0) {
  translate([0,0,tubeCenterZ])
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
    translate([0,0,-frontWall-ManifoldGap()])
    ChamferedSquareHole(side=tube_width, length=extend, center=true,
                         chamferTop=true, chamferBottom=true, chamferRadius=chamferRadius,
                         corners=true, cornerRadius=0.0625);
    
    // Side Bolts
    for (m = [0,1]) mirror([0,m,0])
    translate([0,tubeCenterZ,1])
    rotate([90,-90,0])
    FlatHeadBolt();
  }
}

module BARBB_RailMount(id=1, clearance=0.003, length=1, height=1, wall=tubeWall) {
  render()
  difference() {
    hull() {
      
      // Barrel/Bolt Body
      translate([0,0,barrelZ])
      rotate([0,-90,0])
      ChamferedCylinder(r1=(id/2)+wall,
                        r2=chamferRadius,
                        h=length);
      
      translate([0, -tubeCenterZ, 0])
      rotate([0,-90,0])
      ChamferedCube([tube_width+(tubeWall*2),
                     tube_width+(tubeWall*2),
                     length],
                    r=chamferRadius, center=false);
    
      // Flat top for pic rail
      translate([0, -(tube_width/2), barrelZ+(id/2)])
      rotate([0,-90,0])
      ChamferedCube([0.75+0.1,
                     tube_width,
                     height],
                    r=chamferRadius, center=false);
    }

    translate([-length/2,0,barrelZ+height])
    NutAndBolt(bolt=Spec_BoltM4(), boltLength=10/25.4,
                capHeightExtra=1, nutHeightExtra=height+(id/3),
                clearance=true, teardrop=true, teardropAngle=180);
    
    // Barrel center axis
    translate([0,0,barrelZ])
    rotate([0,-90,0])
    ChamferedCircularHole(r1=(id/2)+clearance, r2=chamferRadius,
                          h=length,
                          chamferTop=true, teardropBottom=true);

    // Square Tube center axis
    translate([0,0,tubeCenterZ]) {
      
      rotate([0,-90,0])
      ChamferedSquareHole(side=tube_width+(clearance*2), length=length, center=true,
                           chamferTop=true, chamferBottom=true, chamferRadius=chamferRadius,
                           corners=true, cornerRadius=0.0625);
      
      // Side Bolts
      for (m = [0,1]) mirror([0,m,0])
      translate([-length/2,tubeCenterZ,0])
      rotate([90,180,0])
      FlatHeadBolt(sink=0.01);
    }
  }
}

translate([0,0,barrelZ])
rotate([0,90,0]) {
  AR15_Barrel();
    
  color("Black") {
    
    // Gas block shaft collar
    translate([0,0,AR15BarrelGasLength()+ManifoldGap(2)])
    cylinder(r=gasShaftCollarOD/2, h=gasShaftCollarWidth);
    
    // Suppressor
    translate([0,0,AR15BarrelLength()-0.5])
    ChamferedCylinder(r1=(1.625/2), r2=chamferRadius, h=9);
  }
}

translate([hammerMaxX+26,0,0])
Bipod();

color("Olive")
translate([lowerX,0,0])
translate([ReceiverLugRearMinX()-0.25+12-3.5,0,0])
*BARBB_RailMount();

*translate([lowerX,0,0]) {
  color("Black")
  translate([ReceiverLugRearMinX()-0.25,0,0]) 
  translate([-1,-0.75/2,barrelZ+1.5])
  cube([12, 0.75, 0.375]);
  
  color("Olive")
  translate([ReceiverLugRearMinX()-0.25,0,0]) 
  BARBB_RailMount(id=1);
}

// Lower/Front-end
translate([lowerX,0,0])
BARBB_Hammer();

translate([lowerX,0,0])  
BARBB_HammerGuide();

color("Tan")
translate([lowerX-0.5,0,0])  
translate([LowerMaxX()+5,0,0])
BARBB_Foregrip();

translate([lowerX,0,0])
Lower(showReceiverLugBolts=true,showGuardBolt=true, showHandleBolts=true,
        showTrigger=true, 
        searLength=tubeCenterZ+abs(SearPinOffsetZ()) + SearTravel(), alpha=1);

translate([lowerX,0,0])
color("Tan")
//render() DebugHalf()
BARBB_LowerReceiver();

color("Black")
translate([boltLockedMaxX,0,barrelZ])
rotate([0,-90,0])
AR15_Bolt(teardrop=false, firingPinRetainer=false, extraFiringPin=0);

BARBB_HammerSpringTrunnion();

color("Olive")
//render() DebugHalf()
BARBB_Bolt();

color("Tan")
//render() DebugHalf()
BARBB_UpperReceiver();

color("Olive")
BARBB_Buttpad();

color("Tan")
//render() DebugHalf()
BARBB_Stock();

// Square Tube
color("Silver")
translate([hammerMaxX, ManifoldGap(), tubeCenterZ])
//render() DebugHalf()
rotate([0,90,0])
linear_extrude(height=26)
difference() {
  square(tube_width, center=true);
  square(tube_width-0.125, center=true);
};

*!scale(25.4)
rotate([0,90,0])
BARBB_HammerSpringTrunnion();

*!scale(25.4)
rotate([0,-90,0])
BARBB_HammerGuide();

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
BARBB_Buttpad();

*!scale(25.4)
rotate([0,-90,0])
BARBB_Foregrip();

*!scale(25.4)
rotate([0,90,0])
BARBB_RailMount();

*!scale(25.4)
rotate([0,90,0])
BARBB_RailMount(id=1);

*!scale(25.4)
rotate([0,90,0])
translate([-26,0,0])
Bipod();
