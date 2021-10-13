use <../../Meta/Cutaway.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Conditionals/RenderIf.scad>;
use <../../Meta/Resolution.scad>;
use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;

// Configured Values
chamferRadius = 0.1;

function AR15_CamPinAngle()    = 22.5;
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

function AR15_FiringPin_TipRadius() = 0.0585/2;
function AR15_FiringPin_TipLength() = 0.118;

function AR15_FiringPin_FrontRadius() = 0.1/2;
function AR15_FiringPin_FrontLength() = 0.867;

function AR15_FiringPin_Radius() = 0.15/2;
function AR15_FiringPin_Length() = 1.84;

function AR15_FiringPin_ShoulderRadius() = (0.372/2);
function AR15_FiringPin_ShoulderLength() = 0.0715;
function AR15_FiringPin_HeadRadius() = 0.247/2;
function AR15_FiringPin_HeadLength() = 0.2;

function AR15_FiringPin_Extension() = 0.55;      // From the back of the bolt
function AR15_FiringPin_ExtensionRadius() = 0.156/2;
function AR15_FiringPinRetainerOffset() = 0.35; // From the back of the bolt

module AR15_FiringPin(cutter=false, clearance=0.007, extraShoulder=0, $fn=Resolution(20,60)) {
  clear2 = clearance *2;
  
  color("Silver") RenderIf(!cutter)
  union() {

    // Firing Pin Tip
    cylinder(r=AR15_FiringPin_TipRadius()+clear2,
             h=AR15_FiringPin_TipLength()+ManifoldGap(2));

    // Firing Pin Front
    translate([0,0,AR15_BoltLength()-AR15_FiringPin_Length()-ManifoldGap()])
    mirror([0,0,1])
    cylinder(r=AR15_FiringPin_FrontRadius()+clear2,
             h=AR15_FiringPin_FrontLength()+ManifoldGap(2));

    // Firing Pin Body
    translate([0,0,AR15_BoltLength()-ManifoldGap()])
    mirror([0,0,1])
    cylinder(r=AR15_FiringPin_Radius()+clear2,
             h=AR15_FiringPin_Length()+ManifoldGap(2));

    // Firing Pin Shoulder
    translate([0,0,AR15_BoltLength()-ManifoldGap()])
    cylinder(r=AR15_FiringPin_ShoulderRadius()+clear2,
             h=AR15_FiringPin_ShoulderLength()+extraShoulder+ManifoldGap(2));

    // Firing Pin Head
    translate([0,0,AR15_BoltLength()+AR15_FiringPin_Extension()])
    mirror([0,0,1])
    ChamferedCylinder(r1=AR15_FiringPin_HeadRadius()+clear2,
                      r2=1/16, chamferTop=false, chamferBottom=true, teardropBottom=false,
                      h=AR15_FiringPin_HeadLength()+ManifoldGap(2));

    // Firing Pin Extension
    translate([0,0,AR15_BoltLength()-ManifoldGap()])
    cylinder(r=AR15_FiringPin_ExtensionRadius()+clear2,
             h=AR15_FiringPin_Extension()+ManifoldGap(2));
    
    // Firing Pin-to-bolt-back taper
    if (cutter)
    translate([0,0,AR15_BoltLength()])
    rotate([180,0,0])
    cylinder(r1=AR15_FiringPin_ShoulderRadius()+clear2, r2=AR15_BoltBackRadius()+clearance,
            h=AR15_FiringPin_ShoulderRadius()+ManifoldGap());
  }
}

module AR15_CamPin(cutter=false, clearance=0.007,
                   extraCamPinSquareHeight=0,
                   extraCamPinSquareLength=0,
                   rectangleTop=true,
                   teardrop=true, teardropTruncate=true, teardropAngle=0,
                   $fn=Resolution(20,60)) {
                     
    color("Silver") RenderIf(!cutter)
    translate([0,0,AR15_CamPinOffset()+AR15_CamPinRadius()])
    rotate([0,90,0]) {

      // Rectangular potion
      if (rectangleTop)
      translate([-AR15_CamPinRadius()-clearance,
                 -(AR15_CamPinSquareWidth()/2)-clearance,
                 AR15_CamPinSquareOffset()])
      cube([AR15_CamPinDiameter()+extraCamPinSquareLength+(clearance*2),
            AR15_CamPinSquareWidth()+(clearance*2),
            AR15_CamPinSquareHeight()+clearance+extraCamPinSquareHeight]);


      linear_extrude(height=AR15_CamPinSquareOffset()+AR15_CamPinSquareHeight()+ManifoldGap())
      if (teardrop)
        rotate(teardropAngle)
        Teardrop(r=AR15_CamPinRadius()+clearance, truncated=teardropTruncate);
      else
        circle(r=AR15_CamPinRadius()+clearance);
    }
}

module AR15_Bolt(cutter=false, camPin=true, firingPinRetainer=false,
                 clearance=0.007,
                 teardrop=false, $fn=Resolution(20,60)) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;;

  color("DimGrey")
  union() {

    // Lugs
    cylinder(r=AR15_BoltHeadRadius(), h=AR15_BoltLugLength());

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

    // Firing Pin Retainer
    if (firingPinRetainer)
    translate([-AR15_FiringPin_ShoulderRadius()-ManifoldGap(),
               AR15_FiringPin_ShoulderRadius()+(7/25.4),
               AR15_BoltLength()+AR15_FiringPinRetainerOffset()])
    rotate([90,0,0])
    NutAndBolt(bolt=BoltSpec("M3"), boltLength=20/25.4,
                capOrientation=false, capHeightExtra=1,
                nutHeightExtra=1, nutBackset=3/25.4,
                clearance=true, teardrop=teardrop, teardropAngle=-90);
  }
}

module AR15_BoltCamPinTrack(length=2,
                 clearance=0.007,
                 extraFiringPin=0, // Ugly, but it'll do
                 $fn=Resolution(20,60)) {
    camTrackRadius = (AR15_CamPinSquareOffset()
                      +AR15_CamPinSquareHeight()+0.05);

    // Rectangular portion rotation
    translate([0,0,AR15_CamPinOffset()-clearance])
    linear_extrude(height=AR15_CamPinDiameter()+(clearance*2))
    rotate(AR15_CamPinAngle()/2)
    hull() {
      semicircle(od=(AR15_CamPinSquareOffset()
                    +AR15_CamPinSquareHeight()+0.05)*2,
                 angle=AR15_CamPinAngle()*2.67,
                 center=true, $fn=60);
      circle(r=AR15_CamPinSquareWidth()/2, $fn=30);
    }

    translate([0,0,AR15_CamPinOffset()-camTrackRadius-clearance])
    intersection() {

      // Rectangular portion rotation
      translate([0,0,camTrackRadius/2])
      linear_extrude(height=camTrackRadius)
      rotate(AR15_CamPinAngle()/2)
      hull() {
        semicircle(od=camTrackRadius*2,
                   angle=AR15_CamPinAngle()*2.67,
                   center=true, $fn=60);
        circle(r=AR15_CamPinSquareWidth()/2, $fn=30);
      }

      // Taper
      cylinder(r1=0,
               r2=camTrackRadius,
               h=camTrackRadius,
               $fn=60);
    }

    //
    // Linear portion
    //
    hull() for (Z = [0, length]) translate([0,0,Z])
    translate([0,0,AR15_CamPinOffset()+AR15_CamPinRadius()])
    rotate([0,90,0])
    translate([-AR15_CamPinRadius()-clearance,
               -(AR15_CamPinSquareWidth()/2)-clearance,
               0])
    cube([AR15_CamPinDiameter()+(clearance*2),
          AR15_CamPinSquareWidth()+(clearance*2),
          AR15_CamPinSquareOffset()+AR15_CamPinSquareHeight()+clearance]);
}


module AR15_BoltAssembly(cutter=false) {
  
  AR15_Bolt(cutter=cutter);
  AR15_CamPin(cutter=cutter);
  AR15_FiringPin(cutter=cutter);
}

//AR15_BoltCamPinTrack();
AR15_BoltAssembly();
