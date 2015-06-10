// Units are in millimeters
bearing_od = 11;
bearing_id = 4;
bearing_height = 5;
bearing_clearance = 0.1;
bearing_bolt_clearance = 0.1;

work_diameter = 1.06 * 25.4; // 1.06 inches to MM

bearing_distance = sqrt(pow(work_diameter/2, 2) + pow(work_diameter/2, 2));
work_offset = sqrt(pow(work_diameter/2 + bearing_od/2,2) - pow(bearing_distance/2,2));


module bearing() {
  rotate([90,0,0])
  translate([0,0,0])
  difference() {
    cylinder(r=bearing_od/2, h=bearing_height, $fn=20);

    translate([0,0,-0.1])
    cylinder(r=bearing_id/2, h=bearing_height + 0.2, $fn=20);
  }
  
}


translate([-bearing_distance/2,0,0])
bearing();

translate([bearing_distance/2,0,0])
bearing();

translate([0,0,work_offset/2])
rotate([90,0,0])
cylinder(r=work_diameter/2, h=100, center=true);