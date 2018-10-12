use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Finishing/Chamfer.scad>;

// Configured Values
chamferRadius = 0.1;

camPinAngle    = 22.5;
camPinAngleExtra = 22.5*4;
camPinOffset   = 1.262; // From the front of the lugs to the front of the pin
camPinDiameter = 0.3125;
camPinRadius   = camPinDiameter/2;
camPinSquareOffset = 0.5;
camPinSquareHeight = 0.1;
camPinSquareWidth = 0.402;
camPinShelfLength = 0;

boltHeadDiameter = 0.75+0.008;
boltHeadRadius = boltHeadDiameter/2;
boltLugLength  = 0.277;
boltLength = 2.8;
boltLockedLength = 2.3;// - 0.85;
boltLockLengthDiff = boltLength - boltLockedLength;
boltFrontRadius = 0.527/2;
boltFrontLength = camPinOffset+camPinDiameter+0.01;
boltMiddleRadius = 0.49/2;
boltMiddleLength = 2.25;
boltBackRadius = 0.25/2;

firingPinRadius = (0.337/2)+0.01;
firingPinExtension = 0.55;      // From the back of the bolt
firingPinRetainerOffset = 0.35; // From the back of the bolt

module AR15_Bolt(camPin=true, firingPinRetainer=true,
                 clearance=0.007,
                 extraFiringPin=0, // Ugly, but it'll do
                 teardrop=true, $fn=Resolution(20,60)) {
  clear2 = clearance*2;
               
  color("Gold")
  render()
  union() {
    
    // Lugs
    cylinder(r=boltHeadRadius, h=boltLugLength);
    
    // Bolt Cam Pin
    if (camPin)
    translate([0,0,camPinOffset+camPinRadius])
    rotate([0,0,-camPinAngle])
    rotate([0,90,0])
    linear_extrude(height=camPinSquareOffset+camPinSquareHeight+ManifoldGap())
    if (teardrop)
      Teardrop(r=camPinRadius+clearance);
    else
      circle(r=camPinRadius+clearance);
        
    // Front
    translate([0,0,boltLugLength])
    cylinder(r=boltFrontRadius+clearance, h=boltFrontLength+ManifoldGap());
    
    // Front Chamfer
    translate([0,0,boltLugLength])
    HoleChamfer(r1=boltFrontRadius+clearance, r2=chamferRadius, teardrop=false);
    
    // Middle
    cylinder(r=boltMiddleRadius+clearance, h=boltMiddleLength+ManifoldGap(2));
    
    // Back
    translate([0,0,-ManifoldGap()])
    cylinder(r=boltBackRadius+clearance, h=boltLength+ManifoldGap(2));
    
    // Firing Pin-to-bolt-back taper
    translate([0,0,boltLength])
    rotate([180,0,0])
    cylinder(r=firingPinRadius+clear2, r2=boltBackRadius+clearance,
            h=firingPinRadius+ManifoldGap());
    
    // Firing Pin
    color("Silver")
    translate([0,0,boltLength-ManifoldGap()])
    cylinder(r=firingPinRadius+clear2, h=firingPinExtension+extraFiringPin+ManifoldGap(2));
    
    // Firing Pin Retainer
    if (firingPinRetainer)
    translate([-firingPinRadius-ManifoldGap(),
               firingPinRadius+(7/25.4),
               boltLength+firingPinRetainerOffset])
    rotate([90,0,0])
    NutAndBolt(bolt=Spec_BoltM3(), boltLength=20/25.4,
                capOrientation=false, capHeightExtra=1,
                nutHeightExtra=1, nutBackset=3/25.4,
                clearance=true, teardrop=teardrop, teardropAngle=-90);
  }
}

AR15_Bolt(teardrop=false, firingPinRetainer=false, extraFiringPin=0);
