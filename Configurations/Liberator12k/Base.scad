//$t=0.7267;
include <../../Meta/Animation.scad>;

use <../../Meta/Debug.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;

use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Double Shaft Collar.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;

use <../../Upper/Cross/Reference.scad>;
use <../../Upper/Cross/Cross Upper.scad>;
use <../../Upper/Cross/Frame.scad>;
use <../../Upper/Cross/Forend/Forend.scad>;
use <../../Upper/Cross/Internals/Charger.scad>;
use <../../Upper/Cross/Internals/Firing Pin Guide.scad>;
use <../../Upper/Cross/Internals/Sear Bolts.scad>;
use <../../Upper/Cross/Internals/Sear Guide.scad>;
use <../../Upper/Cross/Internals/Striker.scad>;

module Liberator12k_PlainFrame(length=FrameRodLength()) {

  // Frame
  translate([OffsetFrameBack(),0,0]) {
    Frame(length=length);

    // Rear Frame Nuts
    mirror([1,0,0])
    FrameNuts(washers=true);
  }


  // Front Frame Nuts
  translate([length+OffsetFrameBack()-ManifoldGap(),0,0])
  FrameNuts(washers=true);
}

module Liberator12k_CoupledFrame(length=6,couplerRecess=UnitsImperial(0.5), couplerAlpha=1) {

  // Rear Frame
  translate([OffsetFrameBack(),0,0]) {
    Frame(length=3.75);

    // Rear Frame Nuts
    mirror([1,0,0])
    FrameNuts(washers=true);
  }

  translate([ForendX()-couplerRecess,0,0])
  Frame(length=length);

  FrameCouplingNuts(alpha=couplerAlpha);

  // Front Frame Nuts
  translate([ForendX()
             +length
             -couplerRecess
             -FrameWasherHeight()
             +ManifoldGap(),0,0])
  FrameNuts(washers=true);
}


module Liberator12k_Base(strikerLength=StrikerRodLength(),
                         lower=true, lowerLeft=true, lowerRight=true,
                         upper=true, trigger=true, alpha=1, debug=true) {

  color("SteelBlue") DebugHalf(enabled=debug)
  Breech();

  ChargingHandle();
  
  ChargingInsert(debug=debug);

  Striker(length=strikerLength);
  SearBolts(teardrop=false);

  // Lower
  if (lower)
  translate([0,0,-ReceiverCenter()]) {
    ReceiverLugBoltHoles(clearance=false);
    GuardBolt(clearance=false);
    HandleBolts(clearance=false);
    Lower(alpha=alpha,
          showTrigger=trigger, searLength=SearLength()+ReceiverCenter()+RodDiameter(SearRod()),
          showLeft=lowerLeft, showRight=lowerRight);
  }
  
  translate([0,0,-ManifoldGap()])
  SearGuide(debug=debug);

  FiringPinGuide(debug=debug);


  color("DarkSlateGray")DebugHalf(dimension=3000, enabled=debug)
  Receiver(alpha=alpha);

  //CrossInserts(alpha=alpha);
  
  if (upper) {
    color("OliveDrab") DebugHalf(dimension=3000, enabled=debug)
    CrossUpperFront(alpha=alpha);
    
    color("YellowGreen") DebugHalf(dimension=3000, enabled=debug)
    CrossUpperBack(alpha=alpha);
  }
}

module Liberator12k_Stock(alpha=1, debug=true) {
  translate([ButtTeeCenterX(),0,0]) {

    // Striker Foot
    translate([TeePipeEndOffset(ButtTee(),StockPipe()),0,0])
    rotate([0,90,180])
    StrikerFoot();

    // Striker Spacers
    for (i = [0,1,2])
    color([0.2*(4-i),0.2*(4-i),0.2*(4-i), 0.5]) // Some colorization
    translate([TeePipeEndOffset(ReceiverTee(),StockPipe())
               +(StrikerSpacerLength()*i)
               +ManifoldGap(1+i),0,0])
    rotate([0,90,0])
    StrikerSpacer(length=StrikerSpacerLength(), alpha=0.5);
  }


  color("SteelBlue") DebugHalf(dimension=3000, enabled=debug)
  Stock(alpha=alpha);
  
  color("DarkSlateGray") DebugHalf(dimension=3000, enabled=debug)
  Butt(alpha=alpha);
}

module Liberator12k_Pistol(alpha=1) {
  Stock(alpha=alpha);
  PipeCap(pipeSpec=DEFAULT_BARREL);
  Butt(alpha=alpha);
}
Liberator12k_CoupledFrame(length=6);
//Liberator12k_PlainFrame(length=10);
Liberator12k_Base();
Liberator12k_Stock();
