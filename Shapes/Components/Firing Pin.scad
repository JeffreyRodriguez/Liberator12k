include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Cutaway.scad>;
use <../../Meta/Resolution.scad>;

use <../Chamfer.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;

// Settings: Vitamins
DEFAULT_FIRING_PIN_RETAINER_BOLT = Spec_BoltM4();
DEFAULT_BOLT_LENGTH = 0.5;

function FiringPinTemplateRod() = Spec_RodOneSixteenthInch();
function FiringPinTemplateBolt() = Spec_BoltTemplate();
function FiringPinRod() = Spec_RodFiveSixteenthInch();
function FiringPinRetainingRod() = Spec_RodThreeThirtysecondInch();
function FiringPinTravel() = 1/8;
function FiringPinExtension() = 3/32;
function FiringPinBodyLength() = 1;

function FiringPinSpringLength() = 0.25;

function FiringPinBoltOffsetY() = (1.125/2);
function FiringPinHousingLength() = 0.75;
function FiringPinHousingWidth() = 0.75;

function FiringPinRetainerOffset() = 0.375;


module FiringPin(bolt=DEFAULT_FIRING_PIN_RETAINER_BOLT, template=false, cutter=false, cutaway=false) {
  clear = cutter ? 0.002 : 0;
  clear2 = clear*2;
  radius = template ? RodRadius(FiringPinTemplateRod()) : (3/32/2)+clear;
  
  //FiringPinExtension();
  
  //translate([0,0,FiringPinSpringLength()])
  difference() {
    union() {
      if (!template)
      color("Silver")
      Cutaway(cutaway)
      Rod(FiringPinRod(), clearance=cutter?RodClearanceLoose():undef,
          length=FiringPinBodyLength()+clear2);
      
      color("DarkGoldenrod")
      translate([0,0,-0.5-(cutter?0.5:0)])
      cylinder(r=radius,
               h=FiringPinBodyLength()+(cutter?0.5:0),
               $fn=Resolution(20,50));
    }
    
    if (!cutter)
    translate([3/32/2,-RodRadius(FiringPinRod()), FiringPinRetainerOffset()-BoltRadius(bolt)])
    cube([RodDiameter(FiringPinRod()),
          RodDiameter(FiringPinRod()),
          FiringPinTravel()+BoltRadius(bolt)]);
  }
}

module FiringPinSpring(cutter=false, cutaway=false) {
  clear = cutter ? 0.01 : 0;
  clear2 = clear*2;
  
  mirror([0,0,1])
  color("Silver", 0.25)
  render()    
  cylinder(r=(0.25/2)+clear, h=FiringPinSpringLength(), $fn=Resolution(10,20));
}

module FiringPinRetainingPin(bolt=DEFAULT_FIRING_PIN_RETAINER_BOLT, cutter=false) {
  clear = cutter ? 0.002 : 0;
  clear2 = clear*2;
  
  color("CornflowerBlue")
  translate([RodRadius(FiringPinRod()),-FiringPinHousingWidth()/2,FiringPinRetainerOffset()+ManifoldGap()])
  rotate([-90,0,0])
  rotate(-90)
  Rod(rod=FiringPinRetainingRod(),
      clearance=cutter?RodClearanceSnug():undef,
      teardrop=cutter, teardropTruncated=false,
      length=FiringPinHousingWidth()+ManifoldGap(2));
}


module FiringPinHousingBolts(bolt=DEFAULT_FIRING_PIN_RETAINER_BOLT,
                              boltLength=DEFAULT_BOLT_LENGTH,
                              template=false, cutter=false) {
  color("CornflowerBlue")
  rotate(90)
  for (Y = [1,-1])
  translate([0,Y*FiringPinBoltOffsetY(),FiringPinHousingLength()+ManifoldGap()])
  Bolt(bolt=template ? FiringPinTemplateBolt() : bolt, capOrientation=true,
       clearance=cutter,
       length=FiringPinHousingLength()+boltLength+ManifoldGap(2));
}

module FiringPinHousing(bolt=DEFAULT_FIRING_PIN_RETAINER_BOLT, cutter=false, alpha=0.5, cutaway=false) {
  
  color("Grey")
  Cutaway(cutaway)
  difference() {
    rotate(-90)
    hull() {
      hull()
      for (Y = [1,-1])
      translate([0,Y*FiringPinBoltOffsetY(),0])
      ChamferedCylinder(r1=BoltRadius(bolt)+(1/8), r2=1/32,
                          h=FiringPinHousingLength(), $fn=Resolution(30,50));
      
      translate([-FiringPinHousingWidth()/2, -FiringPinHousingWidth()/2, 0])
      ChamferedCube([FiringPinHousingWidth(),FiringPinHousingWidth(), FiringPinHousingLength()], r=1/16);
    }
    
    if (!cutter) {
      FiringPin(cutter=true);
      
      FiringPinHousingBolts(bolt=bolt, cutter=true);
      
      FiringPinSpring(cutter=true);
      
      FiringPinRetainingPin(cutter=true);
    }
 
  }
}
module FiringPinAssembly(boltLength=DEFAULT_BOLT_LENGTH,
         retainerBolt=DEFAULT_FIRING_PIN_RETAINER_BOLT,
         template=false, cutter=false, cutaway=false) {

  rotate(-90) {
    FiringPin(template=template, cutter=cutter, cutaway=cutaway);
    FiringPinHousingBolts(template=template, bolt=retainerBolt, boltLength=boltLength, cutter=cutter);
    
    
    if (!template) {
      FiringPinSpring(cutter=cutter, cutaway=cutaway);
      FiringPinRetainingPin(cutter=cutter);
      FiringPinHousing(cutter=cutter, cutaway=cutaway, alpha=0.5);
    }
  }
}

FiringPinAssembly(cutter=false, cutaway=false);

translate([0,2,0])
FiringPinAssembly(cutter=false, cutaway=true);

translate([0,-2,0])
FiringPinAssembly(template=true);

// Plated
*!scale(25.4)
FiringPinHousing(cutter=false, cutaway=false);

