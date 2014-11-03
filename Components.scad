include <Pipe.scad>;

//
// Component Dimensions
//
$fn=60;

// Centerline for firing pin and tee body
centerline_z  = 3_4_tee_center_z; // OK

breech_face_x = (3_4_tee_width/2) + 3_4_x_1_8_bushing_depth;


module circle_cutter(diameter,length, width, height, xp=0, xn=0, yp=0, yn=0) {
  difference() {
    // Outer Box
    cube([length, width, height], center=true);

    // Center Hole
    cylinder(r=(diameter/2), h=height + 0.2, center=true);

    // Legs - X-Positive
    translate([0,-diameter/2,(-height/2) - 0.1])
    cube([xp, diameter, height + 0.2]);

    // Legs - X-Negative
    translate([-xn,-diameter/2,(-height/2) - 0.1])
    cube([xn, diameter, height + 0.2]);

    // Legs - Y-Positive
    translate([-diameter/2,0,(-height/2) - 0.1])
    cube([yp, diameter, height + 0.2]);

    // Legs - Y-Negative
    translate([-diameter/2,-yn,(-height/2) - 0.1])
    cube([yn, diameter, height + 0.2]);
  }
}
