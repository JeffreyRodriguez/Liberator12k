use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Resolution.scad>;

use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Vitamins/Rod.scad>;
use <../../../Vitamins/Pipe.scad>;

use <../../../Magwells/AR15 Magwell.scad>;

use <Forend.scad>;
use <Forend Slotted.scad>;
use <../Reference.scad>;

DEFAULT_BARREL = Spec_TubingZeroPointSevenFive();
DEFAULT_BARREL = Spec_TubingOnePointOneTwoFive();
DEFAULT_BARREL = Spec_PipeThreeQuarterInch();

function ForendMagazineExtraBack() = 0.5;
function ForendMagazineExtraFront() = 0;
function AR15_MagwellX() = ForendX()+ForendMagazineExtraBack();
function AR15_MagwellZ() = 0;

module AR15_MagazineCutouts() {
  translate([AR15_MagwellX(),0,AR15_MagwellZ()]) {
    AR15_MagazineCatch();
    
    translate([0,0,ManifoldGap(10)])
    AR15_MagwellInsert();
  }
}

module ForendMagazine(barrelSpec=DEFAULT_BARREL,
                      length=AR15_MagazineBaseLength()
                         +ForendMagazineExtraBack()
                         +ForendMagazineExtraFront()
                         +0.27) {
  render()
  difference() {
    union() {
      ForendSlotted(barrelSpec=barrelSpec, length=length, slotAngles=[-90])
      
      intersection() {
        translate([ForendMagazineExtraBack(),0,AR15_MagwellZ()])
        AR15_Magwell(wallBack=ForendMagazineExtraBack()+0.1825, 
                    wallFront=ForendMagazineExtraFront());
        
        rotate([0,90,0])
        cylinder(r=5, h=length);
      }
    }
    
    AR15_MagazineCutouts();
  }
  
  %translate([AR15_MagwellX(),0,AR15_MagwellZ()])
  AR15_MagazineCatch();
}


//!scale(25.4) rotate([180,0,0])
//color("Orange")
render()
ForendMagazine();
