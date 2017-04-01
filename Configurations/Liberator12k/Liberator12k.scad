//$t=0.7267;
include <../../Meta/Animation.scad>;

use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;

use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Double Shaft Collar.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;

use <../../Reference.scad>;

use <../../Upper/Cross Fitting/Charger.scad>;
use <../../Upper/Cross Fitting/Cross Upper.scad>;
use <../../Upper/Cross Fitting/Frame.scad>;
use <../../Upper/Cross Fitting/Forend/Barrel Lugs.scad>;
use <../../Upper/Cross Fitting/Forend/Forend.scad>;
use <../../Upper/Cross Fitting/Firing Pin Guide.scad>;
use <../../Upper/Cross Fitting/Sear Bolts.scad>;
use <../../Upper/Cross Fitting/Sear Guide.scad>;
use <../../Upper/Cross Fitting/Striker.scad>;

module Liberator12k_PlainFrame(length=FrameRodLength()) {
  Frame(length=length);

  // Rear Frame Nuts
  translate([ReceiverLugRearMinX(),0,0])
  mirror([1,0,0])
  FrameNuts();

  // Front Frame Nuts
  translate([length+OffsetFrameBack()-ManifoldGap(),0,0])
  mirror([1,0,0])
  FrameNuts();
}


module Liberator12k_Base(strikerLength=StrikerRodLength(),
                         lower=true, trigger=true) {

  Breech();

  ChargingHandle();
  ChargingInsert();

  Striker(length=strikerLength);
  SearBolts();

  translate([0,0,-ManifoldGap()])
  SearGuide();

  FiringPinGuide(debug=true);

  Receiver(alpha=0.5);

  CrossInserts(alpha=0.5);
  CrossUpperFront(alpha=0.25);
  CrossUpperBack(alpha=0.25);

  // Lower
  if (lower)
  translate([0,0,-ReceiverCenter()]) {
    ReceiverLugBoltHoles(clearance=false);
    GuardBolt(clearance=false);
    HandleBolts(clearance=false);
    Lower(showTrigger=trigger);
  }
}

module Liberator12k_Stock() {
  translate([ButtTeeCenterX(),0,0]) {

    // Striker Foot
    translate([TeePipeEndOffset(ReceiverTee(),StockPipe()),0,0])
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
  
  Stock(alpha=0.5);
  Butt(alpha=0.5);
}

module Liberator12k_Pistol() {
  Stock(alpha=0.5);
  PipeCap(pipeSpec=DEFAULT_BARREL);
  Butt(alpha=0.5);
}

Liberator12k_PlainFrame();
Liberator12k_Base();
Liberator12k_Stock();


