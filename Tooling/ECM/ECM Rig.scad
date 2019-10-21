use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Components/T Lug.scad>;
use <../../Components/Printable Shaft Collar.scad>;

CATHODE_SCREW_SPEC = Spec_BoltM3();
ANODE_SCREW_SPEC = Spec_BoltM3();
PIPE_SPEC = Spec_TubingOnePointOneTwoFive();

BARREL_OD = 1.125+0.025;

BARREL_ID = 0.813+0.015;
BARREL_ID = 0.75+0.008;

// 2.5" PVC water jacket
JACKET_ID = 2.5;
JACKET_OD = 2.88+0.02;

module ECRT_Insert(outsideDiameter = BARREL_ID,
                            length = 8,
                         twistRate = 1/12,
                         twistSign = -1,
                       grooveCount = 5,
                       grooveDepth = 0.125,
                       taper=true) {

  outsideRadius = outsideDiameter/2;

  render()
  intersection() {
    linear_extrude(height=length,
                    twist=twistSign*length*twistRate*360,
                   slices=length*10)
    difference() {
      circle(r=outsideRadius, $fn=50);


      // Pentagonal walls (More waterflow than the circle)
      *rotate(360/grooveCount*1.5)
      hull()
      for (groove = [0:grooveCount-1])
      rotate(360/(grooveCount)*groove)
      translate([outsideRadius-0.125,0])
      circle(r=0.125, $fn=25);

      // Grooves
      for (groove = [0:grooveCount-1])
      rotate(360/(grooveCount)*groove)
      translate([outsideRadius,0])
      scale([1,0.75])
      rotate(45)
      square(grooveDepth, center=true);
    }

    // Taper the top
    union() {

      if (taper)
      translate([0,0,length-outsideRadius])
      cylinder(r1=outsideRadius+ManifoldGap(),
               r2=outsideRadius/2,
                h=outsideRadius, $fn=50);

      cylinder(r=outsideRadius+ManifoldGap(), h=length-outsideRadius+ManifoldGap(), $fn=50);
    }
  }

}



module ECRT_WaterFeed(outsideDiameter=BARREL_OD+0.5,
                       tubeOutsideDiameter=0.6,
                         height=1.25, wall=0.25, topWall=0.25) {

  render()
  difference() {

    // Collar around the barrel
    cylinder(r=outsideDiameter/2, h=height, $fn=50);

    // Pipe Cutout
    translate([0,0,topWall])
    Pipe(pipe=PIPE_SPEC,
       length=height+ManifoldGap(2),
    clearance=PipeClearanceSnug());

    cylinder(r=tubeOutsideDiameter/2, h=1, $fn=30);
  }
}

module ECM_FlutingWireIterator(pipeSpec=PIPE_SPEC, wireOffset=0.125, flutes=4) {
  for (i = [0:flutes-1])
  rotate(360/flutes*i)
  translate([PipeOuterRadius(pipeSpec)+wireOffset,0,0])
  children();
}

module ECM_FlutingWire2d(pipeSpec=PIPE_SPEC,
                  wireDiameter=0.1,
                    wireOffset=0.125,
                        flutes=2) {

    // Wire Cutouts
    ECM_FlutingWireIterator()
    circle(r=wireDiameter/2, $fn=10);
}

module ECM_Fluting_WaterFeed(outsideDiameter=2.45,
                     waterJacketInsideDiameter=2.5,
                     waterJacketOutsideDiameter=2.88,
                           tubeOutsideDiameter=0.6,
                                        height=2,
                                          wall=0.25,
                                       topWall=0.25, flangeHeight=0.125) {

  color("White")
  render()
  difference() {

    union() {

      // Collar around the barrel
      cylinder(r1=outsideDiameter/2,
               r2=PipeOuterRadius(pipe=PIPE_SPEC)+wall,
                h=height, $fn=50);

      // Inner alignment ring
      cylinder(r=outsideDiameter/2, h=wall*2, $fn=50);
    }

    // Barrel Cutout
    translate([0,0,-ManifoldGap()])
    //translate([0,0,topWall*2])
    Pipe(pipe=PIPE_SPEC, length=height+ManifoldGap(2),
         clearance=PipeClearanceSnug());

    // Wire channels
    translate([0,0,-ManifoldGap()])
    linear_extrude(height=height+ManifoldGap(2))
    ECM_FlutingWire2d();

    // Anode Terminal
    rotate([0,0,45])
    translate([PipeOuterRadius(PIPE_SPEC)+0.1,0,
               NutHexRadius(ANODE_SCREW_SPEC)+wall])
    rotate([0,45+90,0])
    rotate(90)
    NutAndBolt(bolt=ANODE_SCREW_SPEC, boltLength=UnitsMetric(10),
               capHeightExtra=1,
               nutHeightExtra=PipeOuterRadius(PIPE_SPEC), nutBackset=0.05,
               clearance=true);

    // Cathode Terminators
    ECM_FlutingWireIterator()
    mirror([0,0,1])
    translate([0.375,0,-UnitsMetric(24)])
    Bolt(bolt=CATHODE_SCREW_SPEC, boltLength=UnitsMetric(25), clearance=false);

    // Waterways
    for (r = [-45, 180+45, 90+45])
    rotate(r)
    ECM_FlutingWireIterator(flutes=1)
    translate([0.5,0,-ManifoldGap()])
    cylinder(r=0.5, h=height+ManifoldGap(2), $fn=20);
  }
}

module ECM_Fluting_Plug() {
  difference() {
    union() {

      // Plug
      cylinder(r=BARREL_ID/2, h=0.6, $fn=40);

      // Water channel alignment indicator
      translate([0,0,0.6])
      rotate([45,0,0])
      cube([BARREL_ID/2, 0.05, 0.05], center=true);

      // Flange
      cylinder(r=(BARREL_OD/2)-0.005, h=0.25, $fn=50);

    }

    // Water channel
    rotate([45,0,0])
    cube([BARREL_OD*2, 0.25, 0.25], center=true);
  }
}

module ECM_Fluting_Guide(outsideDiameter=2.45,
                         height=0.5, wall=0.25,
                         flutes=2) {

  render()
  difference() {

    union() {

      // Collar around the barrel
      cylinder(r=outsideDiameter/2, h=height, $fn=50);

      // Ramp for watershed
      translate([0,0,height-ManifoldGap()])
      cylinder(r1=outsideDiameter/2,
               r2=0.2+PipeInnerRadius(pipe=PIPE_SPEC, clearance=PipeClearanceLoose()),
                h=height, $fn=50);
    }

    // Barrel "Foot" Cutout
    translate([0,0,wall])
    Pipe(pipe=PIPE_SPEC, length=height*2, clearance=PipeClearanceLoose());

    // Barrel Hole Cutout
    translate([0,0,-ManifoldGap()])
    cylinder(r=PipeInnerRadius(pipe=PIPE_SPEC, clearance=PipeClearanceSnug()),
             h=wall+ManifoldGap(2), $fn=40);

    linear_extrude(height=height*3) {
      ECM_FlutingWire2d();

      // Waterway
      rotate(22.5)
      for (doubler = [0, 45])
      rotate(doubler)
      for (r = [0,90,-90, 180])
      rotate(r)
      translate([outsideDiameter/2,0,0])
      circle(r=0.25, $fn=20);
    }

    // Cathode Terminators
    rotate(45)
    ECM_FlutingWireIterator()
    mirror([0,0,1])
    translate([0.25,0,-UnitsMetric(24)])
    Bolt(bolt=CATHODE_SCREW_SPEC, boltLength=UnitsMetric(25), clearance=false);

  }
}

module ECM_Jacket_Guide_Lugs2d(jacketDiameter=JACKET_OD,
                                              angles=[0,120,240],
                                                wall=0.25,
                                              height=1,
                                           lugHeight=1,
                                              cutter=false) {

  for (r = angles)
  rotate(r)
  translate([(jacketDiameter/2)+wall, 0])
  mirror([1,0])
  T_Lug2d(length=0.75,
          width=UnitsImperial(0.5),
         height=lugHeight,
         cutter=cutter);
}

module ECM_Jacket_Guide_Lugs(angles=[0,120,240],
                             height=1.5,
                          lugHeight=3.5,
                          bucketCut=false,
                             cutter=false) {

  render()
  difference() {
    linear_extrude(height=height)
    ECM_Jacket_Guide_Lugs2d(angles=angles, lugHeight=lugHeight, cutter=cutter);

    translate([0,0,16]) // TODO: Use a var.
    mirror([0,0,1])
    Bucket5Gal();
  }

}


module ECM_Jacket_Guide(jacketDiameter=JACKET_OD,
                                         wall=0.25,
                                       height=1.5,
                                          $fn=50) {
  render()
  linear_extrude(height=height)
  difference() {
    hull() {
      circle(r=(JACKET_OD/2)+wall);

      offset(r=wall)
      ECM_Jacket_Guide_Lugs2d(lugHeight=0.375);

    }

    circle(r=(JACKET_OD/2));

    ECM_Jacket_Guide_Lugs2d(lugHeight=1, cutter=true);
  }
}

module Bucket5Gal(topDiameter=12.125,
               bottomDiameter=11,
                       height=15, wall=0.375, $fn=60) {
  color("Orange", 0.5)
  render()
  difference() {
    cylinder(r1=bottomDiameter/2,
             r2=topDiameter/2, h=height);

    translate([0,0,wall])
    cylinder(r1=(bottomDiameter/2)-wall,
             r2=(topDiameter/2)-wall, h=height);
  }
}

module LiberatorECM() {
}

scale(25.4) {

  translate([0,0,-16.25])
  ECM_Fluting_Guide();

  // Anode Shaft Collar
  color("Red")
  rotate(90+45)
  translate([0,0,0.26])
  PrintableShaftCollar(pipeSpec=Spec_TubingOnePointOneTwoFive());

  mirror([0,0,1]) {

    color("Gold")
    ECRT_Insert(length=18);

    // Barrel
    color("Black", 0.25)
    Pipe(pipe=PIPE_SPEC, length=16);

    // Fluting
    translate([0,0,-.25])
    ECM_Fluting_WaterFeed();

    translate([0,0,-2.77])
    ECRT_WaterFeed();

    // Water Jacket
    color("Silver", 0.3)
    cylinder(r=2.88/2, h=36, $fn=30);
  }

  // Top Water Jacket Guide
  translate([0,0,-21]) {
    translate([0,0,-0.5])
    ECM_Jacket_Guide();

    translate([0,0,1])
    mirror([0,0,1])
    ECM_Jacket_Guide_Lugs(lugHeight=4.75, bucketCut=true);
  }

  // Botom Water Jacket Guide
  translate([0,0,-33]) {
    ECM_Jacket_Guide();

    ECM_Jacket_Guide_Lugs();
  }

  // Catch Bucket
  translate([0,0,-36])
  Bucket5Gal();
}

// Rifling

// Plated  insert
*!scale(25.4) ECRT_Insert(length=8, taper=false, insideDiameter=0);

// Plated Water Feed
*!scale(25.4) ECRT_WaterFeed();





// Fluting

// Plated Fluting Guide
*!scale(25.4) ECM_Fluting_Guide();

// Plated Fluting Water Feed
*!scale(25.4) ECM_Fluting_WaterFeed();

// Plated Fluting Plug
*!scale(25.4)
ECM_Fluting_Plug();


// Water Jacket Guides

// Plated Bottom Guide
*!scale(25.4) ECM_Jacket_Guide();

// Plated Top Guide Lug
*!scale(25.4) ECM_Jacket_Guide_Lugs(angles=[0]);

// Plated Bottom Guide Lug
*!scale(25.4) ECM_Jacket_Guide_Lugs(angles=[0], lugHeight=4.75, bucketCut=true);
