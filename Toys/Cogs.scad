include <../Components.scad>;

thickness = 1/4;
id = 1_8_rod_d + 1_8_rod_clearance*2;
od = 3_4_tee_id - 1/16;

module three_quarters_cog(od=od) {
  difference() {
    union() {
      difference() {
        cylinder(r=od/2, h=thickness);

        translate([0,0,-0.1])
        cube([od/2, od/2, thickness + 0.2]);
      }

      cylinder(r=id, h=thickness);
    }

    // Center Hole
    translate([0,0,-0.1])
    cylinder(r=id/2, h=thickness + 0.2);
  }
}

module half_cog(od=od) {
  difference() {
    union() {
      intersection() {
        cylinder(r=od/2, h=thickness);

        translate([0,-od/2,-0.1])
        cube([od/2, od, thickness + 0.2]);
      }

      cylinder(r=id, h=thickness);
    }

    // Center Hole
    translate([0,0,-0.1])
    cylinder(r=id/2, h=thickness + 0.2);
  }
}

module quarter_cog(od=od) {
  difference() {
    union() {
      intersection() {
        cylinder(r=od/2, h=thickness);

        translate([0,0,-0.1])
        cube([od/2, od/2, thickness + 0.2]);
      }

      cylinder(r=id, h=thickness);
    }

    // Center Hole
    translate([0,0,-0.1])
    cylinder(r=id/2, h=thickness + 0.2);
  }
}

scale([25.4, 25.4, 25.4]) {


  *translate([-2,0,0]) {
    translate([0,2,0])
    three_quarters_cog(od=1);

    half_cog(od=1);

    translate([0,-2,0])
    quarter_cog(od=1);
  }


  *translate([2,0,0]) {
    translate([0,2,0])
    three_quarters_cog(od=1.25);

    half_cog(od=1.25);

    translate([0,-2,0])
    quarter_cog(od=1.25);
  }
  
  translate([0,2,0])
  *three_quarters_cog();

  *half_cog();

  *translate([0,-2,0])
  quarter_cog();
}