use <Primer.scad>;

use <../Meta/Debug.scad>;
use <../Meta/Manifold.scad>;
use <../Meta/Conditionals/RenderIf.scad>;

use <../Shapes/Chamfer.scad>;
use <../Shapes/Teardrop.scad>;
use <../Shapes/TeardropTorus.scad>;

/* [Print] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "EPrimerCartridge", "EPrimerInsert"]

/* [Assembly] */
_SHOW_PRIMER_INSERT = true;
_SHOW_ELECTRODE = true;
_SHOW_CARTRIDGE = true;

_DEBUG_PRIMER_INSERT = true;
_DEBUG_CARTRIDGE = true;

CHAMBER_DIAMETER = 0.7801;
SHELL_WALL = 0.0625;

function EPrimerElectrodeLength() = 0.8;
function EPrimerElectrodeHeadLength() = 0.045;
function EPrimerElectrodeHeadDiameter() = 0.15;
function EPrimerElectrodeDepth() = 0.01;
function EPrimerInsertHeight() = 0.375+0.03125;

module EPrimerElectrode(cutter=false, debug=false) {
  color("Chocolate") RenderIf(!cutter) DebugHalf(enabled=debug)
  translate([0,0,EPrimerElectrodeDepth()]) {
    // Body
    cylinder(r=1/16/2, h=EPrimerElectrodeLength(), $fn=12);

    // Head
    translate([0,0,(cutter?-EPrimerElectrodeDepth()-ManifoldGap():0)])
    cylinder(r=EPrimerElectrodeHeadDiameter()/2,
             h=EPrimerElectrodeHeadLength()
              +(cutter?EPrimerElectrodeDepth():0)
              +ManifoldGap(),
             $fn=24);
  }
}

module EPrimerInsert(height=EPrimerInsertHeight(), brimHeight=0.0625, cutter=false, debug=false) {
  color("Olive") RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    union() {
      
      // Straight bottom section
      cylinder(r=0.125, h=height, $fn=30);
      
      // Tapered section
      translate([0,0,(height/2)])
      cylinder(r1=0.125, r2=0.1875, h=height/2, $fn=50);
      
      // Brim
      translate([0,0,height])
      mirror([0,0,1])
      cylinder(r=0.25, h=brimHeight, $fn=50);
      
      // Ring
      translate([0,0,height-(brimHeight*2)])
      linear_extrude(brimHeight*2)
      difference() {
        circle(r=0.25, $fn=50);
        circle(r=0.25-0.03125, $fn=50);
      }
    }
    
    if (!cutter)
    EPrimerElectrode(cutter=true);
  }
}

module EPrimerCartridge(chamberDiameter=CHAMBER_DIAMETER, wall=SHELL_WALL,
                        baseHeight=EPrimerInsertHeight(),
                        rimDiameter=0.87, rimHeight=0.07,
                        debug=false, $fn=60) {

  chamberRadius   = chamberDiameter/2;
  rimRadius       = rimDiameter/2;
  rimExtra        = rimRadius-chamberRadius;
  shellLength     = 2.75;

  color("Tan")  
  render() DebugHalf(enabled=debug)

  // Base and rim, minus charge pocket and primer hole
  difference() {
    union() {
      
      // Body
      cylinder(r=chamberRadius, h=shellLength);

      // Rim
      cylinder(r=rimRadius, h=rimHeight/2);

      // Rim Taper
      cylinder(r1=rimRadius, r2=chamberRadius, h=rimExtra);
    }
    
    // Charge pocket
    translate([0,0,EPrimerInsertHeight()])
    ChamferedCylinder(r1=(chamberRadius-wall),
                      r2=0.125,
                       h=shellLength,
                       teardropBottom=true,
                       teardropTop=true,
                       chamferTop=true);
    
    EPrimerInsert(cutter=true);
  }
}


scale(25.4)
if ($preview) {

  if (_SHOW_ELECTRODE)
  EPrimerElectrode();

  if (_SHOW_PRIMER_INSERT)
  EPrimerInsert(debug=_DEBUG_PRIMER_INSERT);

  if (_SHOW_CARTRIDGE)
  EPrimerCartridge(debug=_DEBUG_CARTRIDGE);
} else {
  
  if (_RENDER == "EPrimerInsert")
  EPrimerInsert(debug=_DEBUG_PRIMER_INSERT);
  
  if (_RENDER == "EPrimerCartridge")
  EPrimerCartridge(debug=_DEBUG_CARTRIDGE);
}


