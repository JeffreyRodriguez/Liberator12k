use <../Meta/Debug.scad>;
use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Vitamins/Nuts And Bolts.scad>;

module SetScrew(radius=1,
                length=UnitsMetric(8),
                boltSpec=Spec_BoltM4(),
                teardrop=true, teardropAngle=90,
                nutBackset=UnitsMetric(1),
                capHeightExtra=0,
                cutter=false) {
  translate([radius+UnitsImperial(0.02),0,0])
  rotate([0,90,0])
  rotate([0,0,90])
  NutAndBolt(bolt=boltSpec, boltLength=length,
             capHeightExtra=capHeightExtra,
             boltLengthExtra=radius,
             nutHeightExtra=radius,
             nutBackset=nutBackset,
             teardrop=teardrop, teardropAngle=teardropAngle,
             clearance=cutter);
}

module SetScrewSupport(radius=1,
                       length=UnitsMetric(8),
                       height=UnitsMetric(12),
                       wall=UnitsMetric(5),
                       boltSpec=Spec_BoltM4()) {

  // Nut/bolt support
  translate([radius,
       -BoltNutRadius(boltSpec)-wall,
       0])
  cube([BoltNutHeight(boltSpec)+length,
   BoltNutDiameter(boltSpec)+(wall*2),
   height]);
}

module SetScrewBlock(radius=1,
                     length=UnitsMetric(8),
                     height=UnitsMetric(12),
                     wall=UnitsMetric(5),,
                     boltSpec=Spec_BoltM4(),
                     teardrop=true, teardropAngle=90,
                     cutter=false,
                     angles=[0,45,90,135]) {
  difference() {
    hull()
    for (a = angles)
    rotate(a)
    SetScrewSupport();

    translate([0,0,wall])
    for (a = angles)
    rotate(a)
    SetScrew(radius=radius,
              length=length+wall,
              boltSpec=boltSpec,
              teardrop=teardrop, teardropAngle=teardropAngle,
              cutter=cutter);
  }
}

SetScrewBlock();
