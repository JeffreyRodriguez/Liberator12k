module semicircle(od=20, angle=225, center=false) {
  rotate(center ? angle/2 : 0)
  rotate([0,0,-(angle % 90)])
  difference() {
    union() {
      intersection() {

        // Main Body
        circle(r=od/2);

        // 90* Angle cutters
        if (angle < 360)
        for (i=[0:1:(angle / 90)]) {

          // First angle, angle mod 90
          if (i == 0)
          polygon(points=[[0,0],
                          [od,0],
                          [cos(angle%90) * od, sin(angle%90) * od]]);

          // 90* sections
          if (i>0)
          rotate([0,0,-90*i])
          square([od, od]);
        }

      }
    }
  }
}

module semidonut(major=20, minor=10, angle=225, center=false) {
  difference() {
    semicircle(od=major, angle=angle, center=center);

    circle(r=minor/2);
  }
}

scale([25.4, 25.4, 25.4])
semidonut();
