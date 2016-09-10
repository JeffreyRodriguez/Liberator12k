use <Meta/Debug.scad>;
use <Meta/Manifold.scad>;
use <Components/Semicircle.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Frame.scad>;
use <Reference.scad>;
use <Reference Build Area.scad>;
use <Ammo/Cartridges/Cartridge.scad>;
use <Ammo/Cartridges/Cartridge_12GA.scad>;
use <Ammo/Shell Base.scad>;

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
    hull() {
      FrameRodSleeves();

      // Add some more material to the center for ergo and strength
      circle(r=TeeRimRadius(ReceiverTee())+wall,
             $fn=PipeFn(BarrelPipe()));
      
      children();
    }

    // Barrel Hole
    translate([-ForendOffset(),0,0])
    Barrel();

    // Forend Rod Holes
    Frame();

    // Open bottom
    if(open==true)
    rotate([openingAngle,0,0])
    translate([-0.1,-(CartridgeRimDiameter(Spec_Cartridge_12GAx3())/2),-TeeCenter(ReceiverTee())])
    cube([length+0.2, CartridgeRimDiameter(Spec_Cartridge_12GAx3()), TeeCenter(ReceiverTee())]);
    //translate([-0.1,-PipeOuterRadius(BarrelPipe()),-TeeCenter(ReceiverTee())])
    //cube([length+0.2, PipeOuterDiameter(BarrelPipe()), TeeCenter(ReceiverTee())]);
    

    // Shaft collar
    if (shaftCollar)
    translate([shaftCollarHeight+ManifoldGap(),0,0])
    rotate([0,0,0])
    rotate([0,-90,0])
    linear_extrude(height=shaftCollarHeight+ManifoldGap(2)) {
    
      // Shaft Collar
      circle(r=shaftCollarRadius+0.01, $fn=Resolution(12,40));
    
      // Screw Holes
      for (y = [-shaftCollarRadius,shaftCollarRadius-0.375])
      translate([0,y])
      square([0.3,0.375]);
    }
  }
}

module ForendTubeSegment(length=1, debug=false,
                         shaftCollar=true, shaftCollarThrough=false,
                         open=false, openingAngle=90,
                         shells=true, shellHoles=false, shellSlots=false, shellSlotAngle=110) {
  shellTubeOffsetY = (CartridgeRimDiameter(Spec_Cartridge_12GAx3())/2)+0.05;
  shellTubeOffsetZ = 0.9375+(CartridgeRimDiameter(Spec_Cartridge_12GAx3())/2)+0.125;
  shellTubeRadius = (CartridgeRimDiameter(Spec_Cartridge_12GAx3())/2);
  
  if (debug==true)
  color("Red")
  for (m = [1,-1])
  for (i = [0,1])
  translate([i*2.655,shellTubeOffsetY*m,-shellTubeOffsetZ])
  rotate([0,90,0])
  ShellBase(wadHeight=2);
  
  // Front
  color("OliveDrab")
  render(convexity=4)
  difference() {
    ForendSegment(length=length,
                  shaftCollar=shaftCollar, shaftCollarThrough=shaftCollarThrough,
                  open=open, openingAngle=openingAngle) {
      
      // Shell Tube
      if (shells==true)
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

module Forend(debug=false) {

  // Rear
  translate([BreechFrontX()+0.05,0,0])
  ForendTubeSegment(length=4, debug=debug, shellHoles=true,
                    open=true, openingAngle=90);
  
  
  translate([BreechFrontX()+4.01,0,0])
  ForendTubeSegment(length=3.5, debug=false, shellHoles=true);
  
  translate([BreechFrontX()+7.515,0,0])
  ForendTubeSegment(length=0.25, debug=false, shaftCollar=false);
  
}

Reference();
Forend(debug=true);


// Plate
!scale(25.4) {

  // Rear (user-end) Segment
  translate([2,1.5,1])
  rotate([0,90,0])
  render()
  ForendTubeSegment(length=0.25,
                    open=false,
                    shaftCollar=false, shaftCollarThrough=true,
                    shells=true, shellHoles=false, shellSlots=false);
  
  *ReferenceBuildArea();
}