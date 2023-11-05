use <../Meta/Units.scad>;
use <../Meta/Resolution.scad>;
use <../Shapes/Chamfer.scad>;
use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;

slot_width = .375;
slot_height_a = 0.305;
slot_height_b = 0.93;
slot_length_a = 1.253;
slot_length_b = 0.1705;
slot_angle  = 30.1;
slot_angle_offset = -0.4;
slot_overlap = 1/4;

grip_width = 0.85;
grip_height = 1.26;
grip_bolt = BoltSpec("1/4\"-20");
grip_bolt_length = Inches(1.125);

// TODO: Calculate this instead of specifying
grip_bolt_offset_x = -slot_length_a/2 - BoltRadius(grip_bolt) +0.005; // Why?

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

module ar15_selector_spring(clearance=0) {
	color("Red")
	translate([-0.37220,-0.296,0])
	mirror([0,0,1])
	cylinder(d=0.116+clearance, h=0.67);
}
module ar15_grip_bolt(nut="hex", nutBackset=0, extraLength=0, extraCap=0, extraNut=0, clearance=0) {
	translate([grip_bolt_offset_x,0,-1])
	rotate([0,30,0])
	translate([0,0,-0.05])
	mirror([0,0,1])
	rotate(30) {
		NutAndBolt(grip_bolt,  capOrientation=true,
							 boltLength=grip_bolt_length+extraLength,
							 head="socket", capHeightExtra=extraCap,
							 nut=nut, nutBackset=nutBackset, nutHeightExtra=extraNut,
							 clearance=clearance);
		
		// Washer
		color("DimGrey")
		translate([0,0,-0.05])
		cylinder(d=0.5+clearance, h=0.05+extraCap);
	}
}

module ar15_grip_mount(mount_height=0.125, mount_length=0.125, top_extension = 0, extension=0, chamferRadius=1/16) {
	union() {

		// Grip Boss
		hull() {

			translate([0,-slot_width/2,0])
			mirror([1,0,0]) mirror([0,0,1])
			cube([slot_length_a, slot_width, slot_height_a]);

			translate([0,-slot_width/2,0])
			mirror([1,0,0]) mirror([0,0,1])
			cube([slot_length_b, slot_width, slot_height_b]);
		}
		
		// Curve
		*difference() {
			translate([0,-(grip_width/2),0])
			mirror([1,0,0]) mirror([0,0,1])
			cube([0.5, grip_width, 0.5]);
			
			translate([-0.5, 0, -0.5])
			rotate([90,0,0])
			cylinder(r=0.5, h=grip_width, center=true);
		}

		// Vertical Mounting Block
		if (mount_height > 0)
		translate([mount_length,-grip_width/2,0])
		color("Purple")
		mirror([1,0,0])
		ChamferedCube([slot_length_a + slot_overlap + top_extension+mount_length,
		               grip_width,
		               mount_height],
                  r=chamferRadius, disabled=chamferRadius < 0);

		// Horizontal Mounting Block
		if (mount_length > 0)
		translate([0,-grip_width/2,-grip_height])
		color("Indigo")
		ChamferedCube([mount_length,grip_width,grip_height + mount_height],
                  r=chamferRadius, disabled=chamferRadius < 0);
	}

}

ar15_grip_mount();
ar15_grip_bolt(extraLength=0.625);
ar15_selector_spring();
