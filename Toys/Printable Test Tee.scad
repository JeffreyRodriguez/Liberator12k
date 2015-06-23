include <../Components.scad>;
use <../Components/Semicircle.scad>;
use <../Vitamins/Rod.scad>;
use <../Vitamins/Pipe.scad>;
use <../Striker.scad>;
use <../Firing Pin Guide.scad>;


module test_block(spindleRod=RodOneEighthInch, spindleClearance=RodClearanceSnug, debug=false) {
height= 1/2;
width = 1;
inner_width = 3/4;

  if (debug) {
    translate([0,0,-TeeRimWidth(receiverTee)])
    rotate([0,0,90])
    trigger_insert(debug=debug);
  }

    // Tee Block
    rotate([0,0,-90])
      difference() {
        union() {
          Tee(TeeThreeQuarterInch);

          // Floorplate
          translate([-TeeWidth(receiverTee)/2,-TeeRimDiameter(receiverTee)/2,0])
          cube([TeeWidth(receiverTee),.25, TeeHeight(receiverTee)]);
        }

        // Cut the block in half(ish)
        translate([-TeeWidth(receiverTee)/2 + TeeRimWidth(receiverTee),0,TeeRimWidth(receiverTee)])
        cube([TeeWidth(receiverTee) - (TeeRimWidth(receiverTee)*2),2,TeeHeight(receiverTee)]);

        // Cut out the inner track
        translate([0,0,-0.1])
        cylinder(r=TeeInnerDiameter(receiverTee)/2 +0.01, h=TeeCenter(receiverTee)+0.1);

        // Cut out the Striker
        #translate([TeeInnerDiameter(receiverTee)/2,0,TeeCenter(receiverTee)]) // Back of tee to back of breech measured at 2.2"
        rotate([0,-90,0])
        union() {
          #cylinder(r=TeeInnerDiameter(receiverTee)/2 +0.01, h=TeeWidth(receiverTee), center=false);
          translate([0,0,-1])
          Rod(rod=spindleRod, clearance=spindleClearance, length=TeeRimDiameter(receiverTee) + 0.1, center=false);
        }

        // Rubberband Pin
        for (i = [0:3]) {
          translate([-i*.25,0,TeeCenter(receiverTee)])
          rotate([90,0,0])
          Rod(rod=spindleRod, clearance=RodClearanceSnug, length=TeeRimDiameter(receiverTee)+0.2, center=true);
        }
      }
}

  
scale([25.4, 25.4, 25.4])
translate([0,0,TeeRimDiameter(receiverTee)/2])
rotate([0,-90,0])
test_block(debug=false);