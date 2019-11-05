use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Shapes/Chamfer.scad>;

function AR15BarrelLength()               = UnitsImperial(16);
function AR15BarrelGasLength()            = UnitsImperial(7.8); // Back of the barrel extension to the gas block shelf
function AR15BarrelGasDiameter()          = UnitsImperial(0.75);
function AR15BarrelGasRadius()            = UnitsImperial(AR15BarrelGasDiameter()/2);
function AR15BarrelChamberDiameter()      = UnitsImperial(1);
function AR15BarrelChamberRadius()        = UnitsImperial(AR15BarrelChamberDiameter()/2);
function AR15BarrelExtensionDiameter()    = UnitsImperial(1);
function AR15BarrelExtensionRadius()      = AR15BarrelExtensionDiameter()/2;
function AR15BarrelExtensionLength()      = UnitsImperial(0.99);
function AR15BarrelExtensionLipDiameter() = UnitsImperial(1.172);
function AR15BarrelExtensionLipRadius()   = UnitsImperial(AR15BarrelExtensionLipDiameter()/2);
function AR15BarrelExtensionLipLength()   = UnitsImperial(0.125);
function AR15BarrelExtensionPinDiameter() = UnitsImperial(0.125);
function AR15BarrelExtensionPinRadius()   = AR15BarrelExtensionPinDiameter()/2;
function AR15BarrelExtensionPinHeight()   = UnitsImperial(0.09);
function AR15BarrelExtensionPinDepth()    = UnitsImperial(0.162);

module AR15_Barrel(length=AR15BarrelLength(),
                   clearance=UnitsImperial(0.007),
                   cutter=false,
                   $fn=60) {
  color("DimGrey") union() {

    // Barrel Extension
    translate([0,0,-ManifoldGap()])
    cylinder(r=AR15BarrelExtensionRadius()+clearance,
             h=AR15BarrelExtensionLength()+ManifoldGap(2));

    // Barrel Locating Pin
    translate([AR15BarrelExtensionRadius()-AR15BarrelExtensionPinHeight(),
              -AR15BarrelExtensionPinRadius(),
               AR15BarrelExtensionLength()-AR15BarrelExtensionPinDepth()])
    cube([AR15BarrelExtensionPinHeight()*2,
          AR15BarrelExtensionPinDiameter(),
          AR15BarrelExtensionPinDepth()+ManifoldGap()]);

    // Barrel Extension Lip
    translate([0,0,AR15BarrelExtensionLength()])
    cylinder(r=AR15BarrelExtensionLipRadius()+clearance,
             h=AR15BarrelExtensionLipLength()+ManifoldGap());

    // Barrel, up to the gas block
    cylinder(r=AR15BarrelChamberRadius()+clearance, h=AR15BarrelGasLength()+ManifoldGap());

    // Barrel, from the gas block on
    cylinder(r=AR15BarrelGasRadius(), h=length);
  }
}

AR15_Barrel();
