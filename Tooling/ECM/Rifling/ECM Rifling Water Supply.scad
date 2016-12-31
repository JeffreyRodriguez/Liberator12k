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

module RiflingWaterSupply(outsideDiameter=BARREL_OD+0.5,
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


scale(25.4) {

  BarrelWaterSupply();

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

// Plated Barrel Water Supply
*!scale(25.4) RiflingWaterSupply();


// Water Jacket Guides

// Plated Bottom Guide
*!scale(25.4) ECM_Jacket_Guide();

// Plated Top Guide Lug
*!scale(25.4) ECM_Jacket_Guide_Lugs(angles=[0]);

// Plated Bottom Guide Lug
*!scale(25.4) ECM_Jacket_Guide_Lugs(angles=[0], lugHeight=4.75, bucketCut=true);
