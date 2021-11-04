use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Shapes/Components/T Lug.scad>;
use <../../Shapes/Components/Printable Shaft Collar.scad>;

JACKET_PIPE = Spec_TwoPointFiveInchSch40PVC();

// 2.5" PVC water jacket
JACKET_OD = PipeOuterDiameter(pipe=JACKET_PIPE, clearance=PipeClearanceLoose());

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
          width=Inches(0.5),
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


module ECM_Waterjacket(length=30) {
  
  // Water Jacket
  translate([0,0,0.5])
  color("Silver", 0.3)
  cylinder(r=2.88/2, h=36, $fn=30);

  // Top Water Jacket Guide
  translate([0,0,15]) {
    translate([0,0,-0.5])
    ECM_Jacket_Guide();

    translate([0,0,1])
    mirror([0,0,1])
    ECM_Jacket_Guide_Lugs(lugHeight=4.75, bucketCut=true);
  }

  // Botom Water Jacket Guide
  translate([0,0,3]) {
    ECM_Jacket_Guide();

    ECM_Jacket_Guide_Lugs();
  }

  // Catch Bucket
  Bucket5Gal();
}


ScaleToMillimeters()
ECM_Waterjacket();

// Water Jacket Guides

// Plated Bottom Guide
*!ScaleToMillimeters() ECM_Jacket_Guide();

// Plated Top Guide Lug
*!ScaleToMillimeters() ECM_Jacket_Guide_Lugs(angles=[0]);

// Plated Bottom Guide Lug
*!ScaleToMillimeters() ECM_Jacket_Guide_Lugs(angles=[0], lugHeight=4.75, bucketCut=true);
