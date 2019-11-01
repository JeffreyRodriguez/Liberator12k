use <../../Meta/Clearance.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../Chamfer.scad>;
use <../Teardrop.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
include <Latch_Lookup.scad>;

module LatchBolt(latchSpec=DEFAULT_LATCH,
                 boltSpec=DEFAULT_LATCH_BOLT,
                 cutter=false) {
    translate([LatchBoltOffset(latchSpec),
               0,
               LatchHeight(latchSpec)])
    mirror([0,0,1])
    NutAndBolt(bolt=boltSpec,
               boltLength = LatchBoltLength(latchSpec), capHeightExtra=(cutter?1:0),
               nutBackset=UnitsMetric(0.5), nutHeightExtra=UnitsMetric(0.5)+ManifoldGap(),
               clearance = cutter);
}

module Latch(spec=DEFAULT_LATCH,
             boltSpec=DEFAULT_LATCH_BOLT,
             cutter=false, clearance=0.015, alpha=1) {
  clear  = Clearance(clearance, cutter);
  clear2 = clear*2;

  color("LightGrey", alpha)
  render()
  difference() {
    
    // Latch body
    translate([-clear,
               -(LatchWidth(spec)/2)-clear,
               -clear])
    cube([LatchLength(spec)+clear+(cutter ? LatchTravel(spec) : 0),
          LatchWidth(spec)+clear2,
          LatchHeight(spec)+clear2]);

    // Latch Spring Cutout
    translate([LatchBoltOffset(spec)
                 + (LatchHandleWidth(spec)/2)
                 //+ LatchSpringLength(spec)
                 + LatchTravel(spec)
                 + (cutter ? LatchSpringLength(spec) : 0),
               -(LatchHeight(spec)/2)+clear-ManifoldGap(),
               -ManifoldGap()-clear])
    cube([LatchSpringLength(spec)+LatchTravel(spec)+(cutter ? LatchTravel(spec) : 0),
          LatchHeight(spec)+-clear2+ManifoldGap(2),
          LatchHeight(spec)+clear2+ManifoldGap(2)]);

    if (!cutter) {
      LatchBolt(latchSpec=spec, boltSpec=boltSpec, cutter=true);

      // Latch Bolt Cutout
      translate([LatchBoltOffset(spec),
                 0,
                 ManifoldGap()])
      cylinder(r=BoltRadius(bolt=boltSpec, clearance=true),
               h=LatchHeight(spec)+ManifoldGap(2), $fn=8);

      // Incline the tip
      translate([(sin(15)*LatchHeight(spec)),
                  -(LatchWidth(spec)/2)-ManifoldGap(),
                  LatchHeight(spec)+ManifoldGap(1)])
      rotate([0,180+25,0])
      cube([1, LatchWidth(spec)+ManifoldGap(2), LatchHeight(spec)*2]);

      // Bevel the fork
      translate([LatchLength(spec)-LatchHeight(spec),0,0])
      scale([1,0.75,1])
      rotate(-45)
      cube([LatchWidth(spec),LatchWidth(spec),LatchHeight(spec)+ManifoldGap(2)]);
    }
  }
}

module LatchHandle(latchSpec=DEFAULT_LATCH,
                   boltSpec=DEFAULT_LATCH_BOLT,
                   slotExtraLength=0,
                   cutter=false, clearance=0.005,
                   $fn=30, alpha=1) {

  clear  = clearance;
  clear2 = clearance*2;

  color("DimGrey", alpha)
  render()
  if (!cutter)
  difference() {
    union() {
      translate([LatchBoltOffset(latchSpec),0,-LatchHandleLength(latchSpec)+ManifoldGap()])
      cylinder(r=LatchHandleWidth(latchSpec)/2, h=LatchHandleLength(latchSpec));
    }
    
    LatchBolt(latchSpec=latchSpec, boltSpec=boltSpec, cutter=true);
  }
    
  // Slot
  if (cutter)
  hull()
  for (X = [0,LatchTravel(latchSpec)])
  translate([LatchBoltOffset(latchSpec)+X,
             0,
             ManifoldGap()])
  mirror([0,0,1])
  linear_extrude(height=LatchHandleLength(latchSpec))
  rotate(180)
  Teardrop(r=(LatchHandleWidth(latchSpec)/2)+clearance, truncated=true);
}

module LatchAssembly(latchSpec=DEFAULT_LATCH,
                     boltSpec=DEFAULT_LATCH_BOLT,
                     travelFactor=0) {
  translate([LatchTravel(latchSpec)*travelFactor,0,0]) {
    LatchBolt(latchSpec=latchSpec, boltSpec=boltSpec);
    Latch(spec=latchSpec);
    LatchHandle(latchSpec=latchSpec, boltSpec=boltSpec);
  }
  
  #Latch(spec=latchSpec, cutter=true);
  #LatchHandle(latchSpec=latchSpec, boltSpec=boltSpec, cutter=true);
}

// Plated Pivot Latch
*!scale(25.4)
Latch();

// Plated Latch Handle
*!scale(25.4)
translate([-LatchBoltOffset(DEFAULT_LATCH),
           0,
           LatchHandleLength(DEFAULT_LATCH)])
LatchHandle();

translate([-0.25,0,0])
LatchAssembly(latchSpec=DEFAULT_LATCH, travelFactor=$t);