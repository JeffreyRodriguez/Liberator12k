use <../../../Meta/Debug.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Components/Semicircle.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../Reference.scad>;
use <../../../Ammo/Cartridges/Cartridge.scad>;
use <../../../Ammo/Cartridges/Cartridge_12GA.scad>;
use <../../../Ammo/Shell Base.scad>;
use <../Frame.scad>;

function ForendRearLength() = 1;
function ForendFrontLength() = 0.6;
function ForendOffset() = 4;
function ForendTravel() = 2;

module ForendSegment(wall=3/16, length=1, $fn=50,
                     shaftCollar=false, shaftCollarDiameter=1.875, shaftCollarHeight=0.51, shaftCollarThrough=false,
                     open=false, openingAngle=90) {

  shaftCollarRadius = shaftCollarDiameter/2;
                       
  // Override the shaft collar height if this is a through-cut
  shaftCollarHeight = shaftCollarThrough == true ? length : shaftCollarHeight;

  render(convexity=4)
  difference() {
    rotate([0,90,0])
    linear_extrude(height=length)
    Quadrail2d()
    children();

    // Barrel Hole
    translate([-ForendOffset(),0,0])
    Barrel();

    // Forend Rod Holes
    Frame();

  }
}

module ForendTubeSegment(length=1, debug=false,
                         shaftCollar=true, shaftCollarThrough=false,
                         open=false, openingAngle=90,
                         shells=true, shellHoles=false, shellSlots=false, shellSlotAngle=110) {
  
  
  // Front
  color("OliveDrab")
  render(convexity=4)
  difference() {
    ForendSegment(length=length,
                  shaftCollar=shaftCollar, shaftCollarThrough=shaftCollarThrough,
                  open=open, openingAngle=openingAngle) {
      
      // Shell Tube
      for (i = [0, 1])
      mirror([0,i])
      translate([shellTubeOffsetZ,shellTubeOffsetY])
      circle(r=shellTubeRadius+0.25, $fn=PipeFn(BarrelPipe()));
    }
      
    // Shell Hole
    if (shells==true)
    rotate([0,90,0])
    linear_extrude(height=10) {
      
      // Shell Holes
      for (i = [0, 1])
      mirror([0,i])
      translate([shellTubeOffsetZ,shellTubeOffsetY]) {
        
        // Hole
        if (shellHoles==true)
        circle(r=shellTubeRadius+0.02, $fn=PipeFn(BarrelPipe()));
        
        
        // Slot
        if (shellSlots==true)
        rotate(shellSlotAngle)
        translate([-shellTubeRadius-0.01,0])
        square([(shellTubeRadius*2)+0.02, shellTubeOffsetZ]);
      }
      
    }
  };
}

module ForendShells(cartridge=Spec_Cartridge_12GAx275(), count=3) {
  
  shellTubeOffsetZ = 0.9375+(CartridgeRimDiameter(cartridge)/2)+0.125;
  
  color("Red")
  for (i = [0:count-1])
  translate([i*CartridgeOverallLength(cartridge),0,-shellTubeOffsetZ])
  rotate([0,90,0])
  ShellBase(wadHeight=CartridgeOverallLength(cartridge)-1);
}

module Forend(barrelSpec=BarrelPipe(), cartridge=Spec_Cartridge_12GAx275(), alpha=1, debug=false) {
  
  shellTubeOffsetZ = 0.9375+(CartridgeRimDiameter(cartridge)/2)+0.125;
  shellTubeRadius = (CartridgeRimDiameter(cartridge)/2);
  
  translate([BreechFrontX(),0,0])
  rotate([0,90,0]) {
    color("Gold", alpha)
    render()
    linear_extrude(height=7.5)
    difference() {
      Quadrail2d()
      translate([shellTubeOffsetZ,0])
      circle(r=shellTubeRadius+0.25, $fn=PipeFn(BarrelPipe()));
      
      Pipe2d(pipe=barrelSpec, clearance=PipeClearanceLoose());
      
      FrameRods();
    }
  }
  
}

translate([BreechFrontX(),0,0])
ForendShells();

Reference();
Frame();
Forend(alpha=0.25, debug=true);



// Plate
*!scale(25.4) {

  // Rear (user-end) Segment
  translate([2,1.5,1])
  rotate([0,90,0])
  render()
  ForendTubeSegment(length=0.25,
                    open=false,
                    shaftCollar=false, shaftCollarThrough=true,
                    shells=true, shellHoles=false, shellSlots=false);
  
}