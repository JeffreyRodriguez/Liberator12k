module EpoxyTray(side=40, wall=25, wallThick=2, base=1, handleRadius=8) {
  difference() {
    
    // Base
    cylinder(r=(side/2)+wallThick, h=base+wall);
    
    translate([0,0,base])
    cylinder(r=(side/2), h=base+wall);
    
  }
}

module EpoxyStick(length=100, width=10, height=2) {
  hull() {
    cube([length-width, width, height]);
    
    translate([length-width,width/2,0])
    cylinder(r=width, h=height);
  }
}

EpoxyTray();

translate([-50, 40, 0])
EpoxyStick();