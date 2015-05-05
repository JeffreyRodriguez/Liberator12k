include <../Vitamins/Pipe.scad>;
include <../Vitamins/Rod.scad>;

module trunnion_jig(wall=3/64, trunnion=PipeOneInch, tee=TeeThreeQuarterInch, $fn=40) {
  difference() {
    cylinder(r=3_4_tee_rim_od/2 + wall, h=3_4_tee_rim_width*3);

    // Tee Rim
    translate([0,0,TeeRimWidth(tee=tee)*2])
    TeeRim(tee=tee, heightMultiplier=2.1);

    // Gas Sealing Pipe
    translate([0,0,-0.1])
    Pipe(pipe=trunnion, clearance=PipeClearanceSnug);
  
  }
}

scale([25.4, 25.4, 25.4])
trunnion_jig();