use <../Meta/Conditionals/RenderIf.scad>;
use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Cutaway.scad>;
use <../Meta/slookup.scad>;
use <../Shapes/Chamfer.scad>;

MAGAZINE = "Glock 9mm"; // ["Glock 9mm", "1911 9mm"]

_CUTAWAY_MAGWELL = true;

MAGAZINES = [
  ["Glock 9mm", [
    ["Name",        "Glock 9mm"],
    ["Angle",       22],
    ["Width",       Millimeters(23.25)],
    ["Length",      Millimeters(33)],
    ["Depth",       Millimeters(74)],
    ["CatchZ",      Millimeters(-50)],
    ["RadiusFront", Millimeters(4)],
    ["RadiusBack",  Millimeters(1)]
  ]],

  ["1911 9mm", [
    ["Name",        "1911 9mm"],
    ["Angle",       18],
    ["Width",       Inches(0.55)],
    ["Length",      Inches(1.38)],
    ["Depth",       Inches(2+(3/64))],
    ["CatchZ",      Inches(-1.15)],
    ["RadiusFront", Inches(0.275)],
    ["RadiusBack",  Inches(1/32)]
  ]]
];

function MagazineSpec(name) = slookup(name, MAGAZINES);


//
// Magazine Spec Lookup Functions
//

function MagazineName(spec=undef)       = slookup("Name", spec);
function MagazineAngle(spec=undef)      = slookup("Angle", spec);
function MagazineWidth(spec=undef)      = slookup("Width", spec);
function MagazineLength(spec=undef)     = slookup("Length", spec);
function MagwellDepth(spec=undef)       = slookup("Depth", spec);
function MagwellRadiusFront(spec=undef) = slookup("RadiusFront", spec);
function MagwellRadiusBack(spec=undef)  = slookup("RadiusBack", spec);

//
// Magazine Spec Derived Functions
//

function MagazineOffsetX(spec=undef) = sin(MagazineAngle(spec))
                                     * MagwellDepth(spec);
function MagwellLength(spec=undef) = MagazineLength(spec)
                                  + MagazineOffsetX(spec);

//
// Magazine Modules
//

module Magazine_2D(spec=undef,
                         radius=Millimeters(4),
                         clearance=0) {
  clear = clearance;
  clear2 = clear*2;
  difference() {

    // Straight back-section
    translate([-clear, -(MagazineWidth(spec)/2)-clear])
    square([MagazineLength(spec)+clear2, MagazineWidth(spec)+clear2]);

    // Curved front
    for (Y = [0,1]) mirror([0,Y,0])
    translate([MagazineLength(spec)+clear,-(MagazineWidth(spec)/2)-clear])
    RoundedBoolean(edgeOffset=0, r=radius);

    // Curved back
    for (Y = [0,1]) mirror([0,Y,0])
    translate([-clear,-(MagazineWidth(spec)/2)-clear])
    rotate(-90)
    RoundedBoolean(edgeOffset=0, r=Millimeters(1));
  }
}

module Magazine(spec=undef, taperHeight=Inches(0.75), taper=true) {
  multmatrix(m=[[1,0,sin(MagazineAngle(spec)),0], // Here's where the magazine angle is applied
                [0,1,0,0],
                [0,0,1,0],
                [0,0,0,1]]) {

    // Main magazine cutter
    linear_extrude(height=MagwellDepth(spec)+ManifoldGap())
    Magazine_2D(spec);

    // Magazine tapered opening cutter
    if (taper)
    multmatrix(m=[[1,0,sin(MagazineAngle(spec)),0], // Here's where the magazine is angled
                 [0,1,0,0],
                 [0,0,1,0],
                 [0,0,0,1]])
    translate([-taperHeight*sin(MagazineAngle(spec))*0.5,0,-ManifoldGap()])
    linear_extrude(height=taperHeight+ManifoldGap(), scale=0.5)
    scale([1.2,1.3,1])
    Magazine_2D(spec);
  }
}

module MagazineCatch(spec=undef, magHeight=1, catchOffsetZ=1.15, catchOffsetX=1,
                     catchLength=0.265+0.0625, catchHeight=Inches(0.131+0.3),
                     extraY = 1, extraRadius=0, $fn=8) {

  translate([MagazineOffsetX(spec)+catchOffsetX,
             -(MagazineWidth(spec)/2)-extraY,catchOffsetZ]) {
     rotate([0,MagazineAngle(spec),0])
    *cube([catchLength,0.15+extraY,catchHeight]);

    translate([catchLength/2,0,catchHeight/2])
    rotate([-90,0,0])
    cylinder(r=0.0625+extraRadius, h=0.15+extraY);
  }
}

module Magwell(spec=undef, wallSide=Millimeters(8),
               wallBack=Millimeters(8), wallFront=Millimeters(8),
               doRender=true) {
  CR = Inches(1/16);

  color("Orange") RenderIf(doRender)
  difference() {
      hull() {

        // Magwell Body Top
        translate([-wallBack, -(MagazineWidth(spec)/2)-wallSide,MagwellDepth(spec)-Inches(0.25)])
        ChamferedCube([MagwellLength(spec)+wallBack+wallFront,
                       MagazineWidth(spec)+(wallSide*2),
                       Inches(0.25)-ManifoldGap()],
                      r=CR);

        // Magwell Body Bottom
        translate([-wallBack, -(MagazineWidth(spec)/2)-wallSide, ManifoldGap()])
        ChamferedCube([MagazineLength(spec)+wallBack+wallFront,
                       MagazineWidth(spec)+(wallSide*2),
                       Inches(0.25)-ManifoldGap()],
                      r=CR);
      }

      // TODO: Magazine Catch
      //MagazineCatch(magHeight=MagwellDepth(spec), extraRadius=0.1, extraY=wall+0.25);

    // TODO: Bolt Catch / Slide Stop
    //translate([MagazineLength(spec)+MagazineOffsetX(spec)-0.25,0,0]) cube([0.25, 0.25, 0.25]);

    Magazine(spec);
    MagazineCatch(spec);
  }
}

ScaleToMillimeters()
render()
Cutaway(_CUTAWAY_MAGWELL)
Magwell(spec=MagazineSpec(MAGAZINE), doRender=false);
