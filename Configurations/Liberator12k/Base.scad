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
                         lower=true, trigger=true, alpha=1) {

  Breech();

  ChargingHandle();
  ChargingInsert();

  Striker(length=strikerLength);
  SearBolts();

  // Lower
  if (lower)
  translate([0,0,-ReceiverCenter()]) {
    ReceiverLugBoltHoles(clearance=false);
    GuardBolt(clearance=false);
    HandleBolts(clearance=false);
    Lower(alpha=alpha, showTrigger=trigger);
  }

  translate([0,0,-ManifoldGap()])
  SearGuide();

  FiringPinGuide(debug=true);

  Receiver(alpha=alpha);

  CrossInserts(alpha=alpha);
  CrossUpperFront(alpha=alpha);
  CrossUpperBack(alpha=alpha);
}

module Liberator12k_Stock(alpha=1) {
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

  Stock(alpha=alpha);
  Butt(alpha=alpha);
}

module Liberator12k_Pistol(alpha=1) {
  Stock(alpha=alpha);
  PipeCap(pipeSpec=DEFAULT_BARREL);
  Butt(alpha=alpha);
}

Liberator12k_PlainFrame(length=3.75);
Liberator12k_Base();
Liberator12k_Stock();
