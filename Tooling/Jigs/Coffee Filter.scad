use <../../Meta/Resolution.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Cutaway.scad>;
use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Components/ORing.scad>;
use <../../Shapes/TeardropTorus.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;

/* [Stock and Hole Dimensions] */

/* [Jig Dimensions] */
MAJOR_DIAMETER = 5.25;
MINOR_DIAMETER = 3.875;
FILTER_HEIGHT = 2.5;
FILTER_WALL = 0.03;
TAPER_HEIGHT = 0.25;
RIB_WIDTH = 0.06;


/* [Fine Tuning] */
CLEARANCE = 0.0051;
CHAMFER_RADIUS = 0.0625;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();


module CoffeeFilterCup() {
  difference() {
    union() {
      
      // Filter cup
      difference() {
        
        // Outer wall
        cylinder(r1=MINOR_DIAMETER/2,
                 r2=MAJOR_DIAMETER/2,
                  h=FILTER_HEIGHT+FILTER_WALL+TAPER_HEIGHT);
        
        // Inner wall cutaway
        difference() {
          translate([0,0,FILTER_WALL+TAPER_HEIGHT])
          cylinder(r1=(MINOR_DIAMETER/2),
                   r2=(MAJOR_DIAMETER/2),
                    h=FILTER_HEIGHT+FILTER_WALL+TAPER_HEIGHT);
          
          // Ribs
          for (R = [0:15:360]) rotate(R)
          translate([-RIB_WIDTH/2,(MINOR_DIAMETER/2)-(FILTER_WALL*3),TAPER_HEIGHT])
          multmatrix([[1,0,0,0],
                      [0,1,0.22,0],
                      [0,0,1,0],
                      [0,0,0,1]])
          cube([RIB_WIDTH,1,FILTER_HEIGHT+FILTER_WALL+TAPER_HEIGHT]);
        }
        
        // Bottom Taper
        translate([0,0,FILTER_WALL])
        cylinder(r1=0,
                 r2=(MINOR_DIAMETER/2)-FILTER_WALL,
                  h=TAPER_HEIGHT);
        
      }
      
      // Long bottom ribs
      for (R = [0:30:360]) rotate(15+R)
      translate([-RIB_WIDTH/2,0.375,FILTER_WALL])
      cube([RIB_WIDTH,(MINOR_DIAMETER/2)-0.375,RIB_WIDTH+TAPER_HEIGHT]);
      
      // Short bottom ribs
      for (R = [0:30:360]) rotate(R)
      translate([-RIB_WIDTH/2,0.75,FILTER_WALL])
      cube([RIB_WIDTH,(MINOR_DIAMETER/2)-0.75,TAPER_HEIGHT]);
    }
    
    // Hole taper
    cylinder(r1=0.125, r2=0.5,h=0.5);
  }
}

render() CoffeeFilterCup();