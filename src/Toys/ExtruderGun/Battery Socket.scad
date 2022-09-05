use <../../Shapes/Components/T Lug.scad>;

/* X-origin is battery terminals, battery front facing positive-X
 */
module BatteryCutter(clearance=0.25) {


  clear = clearance;
  clear2 = clear*2;
  
  // Widest T-section
  translate([21.6,-25-clear,6.32-clear])
  cube([46.4, 50+clear2, 4.29+clear2]);
  
  // Widest T-section, thickened
  translate([38, -25-clear,5.33])
  cube([30, 50+clear2, 5.28]);
  
  // Front stop
  translate([52, -25-clear,0])
  cube([16, 50+clear2, 10.61+clear]);
  
  hull() {
    
    // Middle-width T-section
    translate([11.6,-(43.75/2)-clear,6.32-clear])
    cube([11.15, 43.75+clear2, 4.29+clear2]);
    
    // Taper towards Battery Terminal Block
    translate([6,-(34.31/2)-clear,6.32-clear])
    cube([60, 34.31+clear2, 4.29+clear2]);
  }
  
  // Battery Terminal Block
  translate([-clear,-(34.31/2)-clear,0])
  cube([66+clear2, 34.31+clear2, 10.61+clear]);
  
  // First set of inclines
  translate([32.85, -(43.75/2)-clear,0])
  cube([30, 43.75+clear2, 3]);
  
  // Latch
  translate([51,-(23.3/2)-clear,10.6])
  cube([6.25, 23.3+clear2, 5.04+clear]);
  
  // Front body
  difference() {
  
    // Front Body
    translate([58, -31,0])
    cube([10, 62, 10.61+clear]);
    
    hull() {
      
      // Front body side curve
      translate([58,0,5])
      rotate([90,0,0])
      cylinder(r=5, h=60+4, center=true);
      
      // Front body side edge
      translate([58, -32, 0])
      rotate([0,-45,0])
      cube([16, 64, 10]);
    }
  }
  
  // Base
  translate([-14.75,-30,-29])
  %cube([114, 60, 29]);
}

module BatterySocket() {

  union() {
    difference() {
      translate([0,-30,0])
      cube([15.75, 60, 72]);
      
      translate([16,0,5])
      rotate([0,-90,0])
      BatteryCutter(); 
    }
    
    scale(25.4)
    translate([-1,0,0.5])
    rotate([0,90,0])
    rotate(180)
    T_Lug();
  }
}

BatterySocket();