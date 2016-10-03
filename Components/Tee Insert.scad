use <../Meta/Manifold.scad>;
use <../Meta/Resolution.scad>;
use <../Reference.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;

DEFAULT_TEE = Spec_AnvilForgedSteel_TeeThreeQuarterInch();

module TeeInsert(tee=DEFAULT_TEE, topFactor=0.6, baseHeight=0) {
  innerRadius = TeeInnerRadius(ReceiverTee());
  outerRadius = TeeOuterRadius(ReceiverTee());
  teeCenter   = ReceiverCenter();
  height      = teeCenter-(innerRadius*topFactor);

  render(convexity=4)
  difference() {
    union() {
      // Body
      cylinder(r=innerRadius,
               h=height,
             $fn=Resolution(20,30));

      // Front-bottom chamfered curve
      cylinder(r1=innerRadius+0.135,
               r2=innerRadius,
                h=0.103,
              $fn=Resolution(20,60));

      if (baseHeight > 0)
      translate([0,0,-baseHeight])
      cylinder(r=outerRadius,
               h=baseHeight+ManifoldGap(),
             $fn=Resolution(20,60));
    }

    // Middle Clearance
    translate([0,0,teeCenter])
    rotate([0,90,0])
    cylinder(r=innerRadius+ManifoldGap(),
             h=outerRadius*2,
        center=true,
           $fn=Resolution(20,60));
  }
}

TeeInsert();
