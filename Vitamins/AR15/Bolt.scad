use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Finishing/Chamfer.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;

// Configured Values
chamferRadius = 0.1;

function AR15_CamPinAngle()    = 22.5;
function AR15_CamPinAngleExtra() = 22.5*4;
function AR15_CamPinOffset()   = 1.262; // From the front of the lugs to the front of the pin
function AR15_CamPinDiameter() = 0.3125;
function AR15_CamPinRadius()   = AR15_CamPinDiameter()/2;
function AR15_CamPinSquareOffset() = 0.5;
function AR15_CamPinSquareHeight() = 0.1;
function AR15_CamPinSquareWidth() = 0.402;
function AR15_CamPinShelfLength() = 0;

function AR15_BoltHeadDiameter() = 0.75+0.008;
function AR15_BoltHeadRadius() = AR15_BoltHeadDiameter()/2;
function AR15_BoltLugLength()  = 0.277;
function AR15_BoltLength() = 2.8;
function AR15_BoltLockedLength() = 2.3;// - 0.85;
function AR15_BoltLockLengthDiff() = AR15_BoltLength() - AR15_BoltLockedLength();
function AR15_BoltFrontRadius() = 0.527/2;
function AR15_BoltFrontLength() = AR15_CamPinOffset()+AR15_CamPinDiameter()+0.01;
function AR15_BoltMiddleRadius() = 0.49/2;
function AR15_BoltMiddleLength() = 2.25;
function AR15_BoltBackRadius() = 0.25/2;

function AR15_firingPinRadius() = (0.337/2)+0.01;
function AR15_FiringPinExtension() = 0.55;      // From the back of the bolt
function AR15_FiringPinRetainerOffset() = 0.35; // From the back of the bolt

module AR15_Bolt(camPin=true, firingPinRetainer=true,
                 clearance=0.007,
                 extraFiringPin=0, // Ugly, but it'll do
                 teardrop=true, $fn=Resolution(20,60)) {
  clear2 = clearance*2;
               
  color("Gold")
  render()
  union() {
    
    // Lugs
    cylinder(r=AR15_BoltHeadRadius(), h=AR15_BoltLugLength());
    
    // Bolt Cam Pin
    if (camPin)
    translate([0,0,AR15_CamPinOffset()+AR15_CamPinRadius()])
    rotate([0,0,-AR15_CamPinAngle()])
    rotate([0,90,0])
    linear_extrude(height=AR15_CamPinSquareOffset()+AR15_CamPinSquareHeight()+ManifoldGap())
    if (teardrop)
      Teardrop(r=AR15_CamPinRadius()+clearance);
    else
      circle(r=AR15_CamPinRadius()+clearance);
        
    // Front
    translate([0,0,AR15_BoltLugLength()])
    cylinder(r=AR15_BoltFrontRadius()+clearance, h=AR15_BoltFrontLength()+ManifoldGap());
    
    // Front Chamfer
    translate([0,0,AR15_BoltLugLength()])
    HoleChamfer(r1=AR15_BoltFrontRadius()+clearance, r2=chamferRadius, teardrop=false);
    
    // Middle
    cylinder(r=AR15_BoltMiddleRadius()+clearance, h=AR15_BoltMiddleLength()+ManifoldGap(2));
    
    // Back
    translate([0,0,-ManifoldGap()])
    cylinder(r=AR15_BoltBackRadius()+clearance, h=AR15_BoltLength()+ManifoldGap(2));
    
    // Firing Pin-to-bolt-back taper
    translate([0,0,AR15_BoltLength()])
    rotate([180,0,0])
    cylinder(r=AR15_firingPinRadius()+clear2, r2=AR15_BoltBackRadius()+clearance,
            h=AR15_firingPinRadius()+ManifoldGap());
    
    // Firing Pin
    color("Silver")
    translate([0,0,AR15_BoltLength()-ManifoldGap()])
    cylinder(r=AR15_firingPinRadius()+clear2, h=AR15_FiringPinExtension()+extraFiringPin+ManifoldGap(2));
    
    // Firing Pin Retainer
    if (firingPinRetainer)
    translate([-AR15_firingPinRadius()-ManifoldGap(),
               AR15_firingPinRadius()+(7/25.4),
               AR15_BoltLength()+AR15_FiringPinRetainerOffset()])
    rotate([90,0,0])
    NutAndBolt(bolt=Spec_BoltM3(), boltLength=20/25.4,
                capOrientation=false, capHeightExtra=1,
                nutHeightExtra=1, nutBackset=3/25.4,
                clearance=true, teardrop=teardrop, teardropAngle=-90);
  }
}

AR15_Bolt(teardrop=false, firingPinRetainer=false, extraFiringPin=0);
