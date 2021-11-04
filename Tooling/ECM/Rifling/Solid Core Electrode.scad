use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Vitamins/Rod.scad>;

BARREL_OD = 1.125+0.025;

BARREL_ID = 0.813+0.015;
BARREL_ID = 0.75+0.008;

// 0.44 Magnum
BARREL_ID = 0.429-0.01;
TWIST_RATE = 1/20;

module ECM_RiflingChannel(outsideDiameter = BARREL_ID,
                               rodSpec = Spec_RodThreeSixteenthInch(),
                                length = 1,
                             twistRate = TWIST_RATE,
                             twistSign = -1,
                           grooveCount = 6,
                           grooveDepth = 0.06,
                           electrified = true,
                           supportHelix= true,
                           intersect   = false,
                                   $fn = 60) {

  outsideRadius = outsideDiameter/2;

  render()
  difference() {
    union() {
      
      linear_extrude(height=length,
                      twist=twistSign*length*twistRate*360,
                     slices=length*10) {
      intersection() {
          if (intersect)
          circle(r=(outsideDiameter/2));
        
          // Grooves
          for (groove = [0:grooveCount-1])
          rotate(360/(grooveCount)*groove) {
            translate([outsideRadius,0])
            circle(r=grooveDepth);
            
            if (electrified)
            translate([0,-0.02])
            square([outsideRadius,0.04]);
          }
        }
      }
    }
      
    // Internal support helix
    if (supportHelix)
    linear_extrude(height=length,
                    twist=length*sqrt(2)*90,
                   slices=length*sqrt(2)*$fn/4)
    for (groove = [0:grooveCount-1])
    rotate(360/(grooveCount)*groove)
    translate([RodRadius(rodSpec),-0.01])
    square([outsideRadius-RodRadius(rodSpec)-grooveDepth,0.02]);
    
  }
}




module ECM_RiflingMandrel(outsideDiameter = BARREL_ID,
                               rodSpec = Spec_RodThreeSixteenthInch(),
                                length = 1,
                             twistRate = TWIST_RATE,
                             twistSign = -1,
                           grooveCount = 6,
                           grooveDepth = 0.06,
                         chamberLength = 0.898,
                       chamberDiameter = 0.476,
                             baseWidth = 0.125,
                                  base = 0.0625,
                          supportHelix = true,
                                   $fn = 60) {

  outsideRadius = outsideDiameter/2;

  render()
  difference() {
    union() {
      
      // Chamber
      cylinder(r=chamberDiameter/2, h=chamberLength+base);
      
      // Body
      translate([0,0,base-ManifoldGap()])
      cylinder(r=outsideRadius,
                h=length-outsideRadius);
      // Tip
      translate([0,0,base+length-outsideRadius-ManifoldGap()])
      cylinder(r1=outsideRadius,
               r2=outsideRadius-grooveDepth,
                h=outsideRadius);
      
      // Base
      linear_extrude(height=base)
      difference() {
        circle(r=outsideRadius+baseWidth, $fn=grooveCount*4);

        circle(r=outsideRadius*0.9-ManifoldGap());
      }
    }

    // Electrode
    if (rodSpec != undef)
    translate([0,0,-ManifoldGap()])
    Rod(rod=rodSpec, length=base+length+ManifoldGap(2), clearance=RodClearanceSnug());
    
    // Water channels
    rotate(360*twistRate*-twistSign*(base+chamberLength))
    translate([0,0,base+chamberLength-ManifoldGap()])
    ECM_RiflingChannel(length=length-chamberLength-0.05+ManifoldGap(),
                       grooveDepth=grooveDepth,
                       twistRate=twistRate,
                       outsideDiameter=outsideDiameter);
    
    // Base water channels
    translate([0,0,-ManifoldGap()])
    ECM_RiflingChannel(length=base+chamberLength+ManifoldGap(3),
                       grooveDepth=grooveDepth,
                       twistRate=twistRate,
                       outsideDiameter=outsideDiameter-0.01,
                       electrified=false, intersect=true,
                       supportHelix=supportHelix);
    
  }
}

// 0.44 Magnum (Pistol-Length twist rate)
*!ScaleToMillimeters()
ECM_RiflingMandrel(length=5.75-1.25+0.0625, twistRate=1/20, taper=true);


// .22 cal prototype
*!ScaleToMillimeters()
ECM_RiflingMandrel(length=2.795-0.65+0.0625, twistRate=1/20,
                   taper=true, grooveDepth=0.1,
                   outsideDiameter = 0.225);

// 38 Prototype
*ECM_RiflingMandrel(length=1, twistRate=1/20,
                   taper=true, grooveDepth=0.06,
                   outsideDiameter = 0.38);

// 0.45 ACP
!ScaleToMillimeters()
//ECM_RiflingChannel(length=2, chamberLength=0.25, twistRate=1/16, outsideDiameter=0.442125984);
ECM_RiflingMandrel(length=4.5,
                   twistRate=1/16,
                   grooveDepth = 0.07,
                   outsideDiameter=0.442125984,
                   chamberDiameter=0.476,
                   chamberLength=0.898,
                   supportHelix=false);