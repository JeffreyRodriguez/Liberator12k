use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;


// Length of the barrel to be rifled
BARREL_LENGTH = 2;

// Internal diameter (top of the lands)
BARREL_ID = 0.429;

// i.e. 1 over 20
twistRate = 0.05;

// Left or right twist
twistSign = -1;

// Number of grooves
grooveCount = 6;

// Groove water channel depth
grooveDepth = 0.06;

// Electrode wire diameter
wireDiameter= 0.045;

// Length to protect from ECM cutting
chamberLength = 0.898;

// Diameter of the chamber / case OD
chamberDiameter = 0.476;

baseWidth = 0.125;
base = 0.0625;

module ECM_RiflingChannel(outsideDiameter = BARREL_ID,
                                length = BARREL_LENGTH,
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
          
            // Water Grooves
            for (groove = [0:grooveCount-1])
            rotate(360/(grooveCount)*groove)
            translate([outsideRadius,0])
            circle(r=grooveDepth, $fn=20);
          }
        
        // Wire Grooves
        for (groove = [0:grooveCount-1])
        rotate(360/(grooveCount)*groove)
        translate([outsideRadius-grooveDepth,0])
        circle(r=wireDiameter/2, $fn=10);
      }
    }
    
  }
}




module ECM_RiflingMandrel(outsideDiameter = BARREL_ID,
                                length = BARREL_LENGTH,
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
    
    // Water channels
    rotate(360*twistRate*-twistSign*(base+chamberLength))
    translate([0,0,base+chamberLength-ManifoldGap()])
    ECM_RiflingChannel(length=length-chamberLength-0.05+ManifoldGap());
    
    // Base water channels
    translate([0,0,-ManifoldGap()])
    ECM_RiflingChannel(length=base+chamberLength+ManifoldGap(3),
                       outsideDiameter=outsideDiameter,
                       intersect=true);
    
  }
}

// 0.44 Magnum (Pistol-Length twist rate)
*!ScaleToMillimeters()
ECM_RiflingMandrel(taper=true);


// .22 cal prototype
*!ScaleToMillimeters()
ECM_RiflingMandrel(taper=true, grooveDepth=0.1,
                   outsideDiameter = 0.225);

// 38 Prototype
*ECM_RiflingMandrel(taper=true, grooveDepth=0.06,
                   outsideDiameter = 0.38);

// 0.45 ACP
ScaleToMillimeters()
ECM_RiflingMandrel();