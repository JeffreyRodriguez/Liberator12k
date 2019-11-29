use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Shapes/Components/Bipod.scad>;
use <../../Shapes/Components/T Lug.scad>;
use <../../Shapes/Chamfer.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Square Tube.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/AR15/Barrel.scad>;
use <../../Vitamins/AR15/Bolt.scad>;
use <../Lower/Receiver Lugs.scad>;
use <../Lower/Lower.scad>;
use <../Lower/Trigger.scad>;
use <../../Receiver/Magwells/AR15 Magwell.scad>;

use <../Pipe/Receiver.scad>;
use <../Lugs.scad>;
use <../Pipe/Buttstock.scad>;
use <../Pipe/Charging Pump.scad>;


$fn=Resolution(20, 60);
barrelLength=24;

// Bullpup AR Barrel Bolt-action (BARBB)

BARREL_PIPE = Spec_TubingZeroPointSevenFive();
RECEIVER_PIPE = Spec_OnePointFiveSch40ABS();
BOLT_ROD = Spec_RodOneHalfInch();
BOLT = Spec_BoltOneHalf();
BOLT_GUIDE_ROD = Spec_RodOneQuarterInch();
BOLT_SEAR_ROD = Spec_RodOneQuarterInch();
EJECTOR_PIVOT_ROD = Spec_RodOneEighthInch();

// Configured Values
tubeWall = 0.25;
barrelWall = 0.25;
barrelOffset = 1;
barrelExtensionLandingHeight = 0.3;
chamferRadius = 0.1;

barrelX = 0; // To the back of the barrel extension
stockWall = 0;


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
boltLockedMinX = barrelX-AR15_BoltLockedLength();
boltLockedMaxX = barrelX+AR15_BoltLockLengthDiff();


lowerLength = LowerMaxX()+abs(ReceiverLugRearMinX())+0.25;
lowerX = -ReceiverLugFrontMinX()+AR15BarrelGasLength()+gasShaftCollarWidth;
                
camPinLockedMaxX = boltLockedMaxX -AR15_CamPinOffset();
camPinLockedMinX = camPinLockedMaxX -AR15_CamPinDiameter();

upperLength = AR15BarrelExtensionLength()+abs(camPinLockedMaxX)+AR15BarrelExtensionLipLength()-0.01;
upperMinX = -upperLength+AR15BarrelExtensionLength()+AR15BarrelExtensionLipLength();
upperMaxX = upperMinX+upperLength;

firingPinMinX  = boltLockedMinX -AR15_FiringPinExtension();
hammerMaxX = firingPinMinX;
hammerMinX = firingPinMinX;

stockMinX = hammerMinX-stockWall;
stockLength=abs(hammerMinX)+upperMinX+stockWall;

barbbBoltLength = stockLength
                + barrelExtensionLandingHeight;
handleLength=abs(hammerMinX-hammerMaxX)+AR15_FiringPinExtension();
handleMinX = stockMinX;//+stockWall;

module BARBB_Magwell(cutter=false) {
  if (!cutter) {
    render()
    difference() {
      union() {
        translate([-2.675,0,-0.4375])
        AR15_Magwell(wallFront=0.125, wallBack=0.25, cut=false);
        
        translate([-6,0,0])
        Buttstock(extension=1);
      }
      
      translate([-2.675,0,-0.4375])
      AR15_MagwellInsert();
    }
  } else {
    translate([-2.675,0,-0.4375])
    AR15_MagwellInsert();
  }
}


module BARBB_CamPinCutout(clearance=0.01, chamferBack=false) {
  clear2 = clearance*2;
  camPinSquareArc = 360/(PI*2*(AR15BarrelExtensionRadius()+barrelWall)/AR15_CamPinSquareWidth());
  
  // Cam Pin cutout
  render()
  rotate(AR15_CamPinAngleExtra())
  translate([0,0,AR15_CamPinOffset()])
  union() {
    
    // Cam pin linear travel
    translate([0,-(AR15_CamPinSquareWidth()/2)-clearance,ManifoldGap()])
    cube([AR15_CamPinSquareOffset()+AR15_CamPinSquareHeight()+clearance,
          AR15_CamPinSquareWidth()+clear2,
          abs(stockMinX-camPinLockedMaxX)+ManifoldGap()]);
    
    // Cam pin rotation arc
    translate([0,0,-clearance-ManifoldGap()])
    linear_extrude(height=AR15_CamPinDiameter()+AR15_CamPinShelfLength()+clear2+ManifoldGap(2)) {
      rotate(camPinSquareArc/2)
      semicircle(od=(AR15_CamPinSquareOffset()
                    +AR15_CamPinSquareHeight()
                    +barrelWall)*3,
                 angle=AR15_CamPinAngle()+AR15_CamPinAngleExtra()+camPinSquareArc);
      
      // Cam Pin Square, locked position
      rotate(-AR15_CamPinAngleExtra()-AR15_CamPinAngle())
      translate([0,-(AR15_CamPinSquareWidth()/2)-0.01])
      square([AR15_CamPinSquareOffset()+AR15_CamPinSquareHeight()+barrelWall, AR15_CamPinSquareWidth()+0.02]);
      
      // Cam Pin Square, Unlocked position
      translate([0,-(AR15_CamPinSquareWidth()/2)-0.01])
      square([AR15_CamPinSquareOffset()+AR15_CamPinSquareHeight()+barrelWall, AR15_CamPinSquareWidth()+0.02]);
    }
  }
}

module BARBB_HammerCutOut(extraX=0) {
  
  // X-Zero on the firing pin's back face
  translate([hammerMinX,-hammerWidth/2,tubeCenterZ-(hammerWidth/2)]) {
    
    // Hammer linear track
    cube([abs(hammerMaxX-hammerMinX)+extraX,
                    hammerWidth,
                    -tubeCenterZ+(hammerWidth/2)+AR15_firingPinRadius()], r=chamferRadius);
    
    
    // Hammer rotary track
    rotate([0,90,0])
    linear_extrude(height=hammerWidth)
    rotate(-90)
    semicircle(od=((-tubeCenterZ+(hammerWidth/2)+AR15_firingPinRadius())*2), angle=90);
    
    // Hammer rotary track, rounded inside corner)
    translate([hammerWidth,0,0])
    linear_extrude(height=-tubeCenterZ+(hammerWidth/2)+AR15_firingPinRadius())
    rotate(180)
    RoundedBoolean(edgeOffset=0, edgeSign=-1, r=hammerWidth);
  }
}


module BARBB_UpperReceiver() {
  
  render()
  difference() {
    translate([upperMinX,0,0])
    union() {

      // Barrel section
      rotate([0,90,0])
      ChamferedCylinder(r1=AR15BarrelExtensionRadius()+barrelWall, r2=chamferRadius,
                        h=upperLength-ManifoldGap());
    }
    
    // Barrel center axis
    translate([upperMinX,0,0]) {
    
      // Bolt Head Passage
      rotate([0,90,0])
      cylinder(r=AR15_BoltHeadRadius()+0.01, h=upperLength+ManifoldGap(2));
    
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
      cylinder(r1=boltSleeveRadius+0.015, r2=AR15_BoltHeadRadius()+0.008,
               h=boltSleeveRadius/3);
    }
    
    rotate([0,90,0])
    rotate(180)
    AR15_Barrel(clearance=0.005);
  }
}

module BARBB_Bolt(clearance=0.01) {
  chamferClearance = 0.01;
  
  echo("barbbBoltLength", barbbBoltLength);
  
  render()
  difference() {
    
    translate([stockMinX,0,0])
    rotate([0,90,0])
    union() {
      
      // Body
      ChamferedCylinder(r1=boltSleeveRadius,
                        r2=chamferRadius,
                        h=barbbBoltLength);
      
      // Cam Pin Shelf
      // This keeps the bolt forward while we rotate across several lug positions
      // while also allowing a longer opening for ejection.
      rotate(90+AR15_CamPinAngle()+AR15_CamPinAngleExtra())
      translate([0,-AR15_CamPinSquareWidth()/2,
                 barbbBoltLength
                 +barrelExtensionLandingHeight
                 +AR15_BoltLockLengthDiff()
                 -AR15_CamPinOffset()-AR15_CamPinDiameter()-AR15_CamPinShelfLength()])
      ChamferedCube([boltSleeveRadius+AR15_CamPinSquareHeight()-clearance,
                     AR15_CamPinSquareWidth(),
                     AR15_CamPinShelfLength()-clearance], r=AR15_CamPinSquareHeight()/3);
    }
    
    
    // Hammer Safety Catch
    translate([hammerMinX,0,tubeCenterZ+hammerWidth])
    mirror([0,0,1])
    cube([hammerWidth, 10, tubeCenterZ]);
    
    
    // Firing Pin Rear Hole Chamfer
    translate([stockMinX,0,0])
    rotate([0,90,0])
    HoleChamfer(r1=AR15_firingPinRadius()+(clearance*2), r2=chamferRadius, teardrop=true);
    
    translate([boltLockedMaxX,0,0])
    rotate([0,-90,0])
    AR15_Bolt();
    
    // Hammer Track
    translate([hammerMinX,0,0])
    rotate([0,90,0]) {
    
      // Hammer Pin Cocking Ramp
      intersection() {
        
        linear_extrude(height=hammerWidth,
                        twist=(AR15_CamPinAngleExtra()),
                       slices=$fn*2)
        rotate(AR15_CamPinAngleExtra())
        translate([0,-hammerWidth*3.5])
        square([barrelOffset, hammerWidth*4]);
      
        linear_extrude(height=(hammerWidth*2))
        rotate(180)
        semicircle(od=(AR15_firingPinRadius())*2, angle=90);
      }
    
      // Hammer travel
      translate([0,-(hammerWidth/2),0])
      cube([barrelOffset, hammerWidth, hammerWidth]);
    }
  }
}

module BARBB_UpperRear(topDiameter=tube_width+(tubeWall*2), bottomDiameter=1,
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
        ChamferedCylinder(r1=AR15BarrelExtensionRadius()+barrelWall,
                          r2=chamferRadius,
                           h=stockLength);
      }
    }
      
    translate([boltLockedMaxX,0,0])
    rotate([0,-90,0]) {
      AR15_Bolt(camPin=false, teardrop=false, firingPinRetainer=false);
      
      BARBB_CamPinCutout(chamferBack=false);
    }
    
    // Bolt Track
    translate([stockMinX-ManifoldGap(),0,0])
    rotate([0,90,0])
    ChamferedCircularHole(r1=boltSleeveRadius+clear2, r2=chamferRadius,
                           h=stockLength+ManifoldGap(2));
    
    BARBB_HammerCutOut(extraX=1);
  }
}

BARBB_Magwell(cutter=false);

rotate([0,90,0]) {
  rotate(180)
  AR15_Barrel(length=barrelLength);
    
  color("LightGrey") {
    
    // Gas block shaft collar
    translate([0,0,AR15BarrelGasLength()+ManifoldGap(2)])
    cylinder(r=gasShaftCollarOD/2, h=gasShaftCollarWidth);
    
    // Suppressor
    *translate([0,0,barrelLength-0.5])
    ChamferedCylinder(r1=(1.625/2), r2=chamferRadius, h=9);
  }
}

color("DimGrey")
translate([boltLockedMaxX,0,0])
rotate([0,-90,0])
AR15_Bolt(teardrop=false, firingPinRetainer=false, extraFiringPin=0);



color("Olive")
//render() DebugHalf()
BARBB_Bolt();

color("Tan", 0.25)
DebugHalf(enabled=false)
BARBB_UpperReceiver();

color("Tan", 0.25)
DebugHalf(enabled=false)
BARBB_UpperRear();

translate([AR15BarrelGasLength()+2,0,0]) {
  translate([-3,0,0]) {
    ChargingRod(length=18, minX=-8.5);
    ChargingPump();
  }
  
  Receiver(pipeAlpha=0.5, pipeOffsetX=0,
                    receiverLength=15,
                    frame=true,
                    stock=false, tailcap=false,
                    debug=false);
}

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
rotate([0,-90,0])
BARBB_UpperReceiver(extraRear=0);

*!scale(25.4)
rotate([0,-90,0])
BARBB_UpperRear();

