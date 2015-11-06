use <Vitamins/Pipe.scad>;
use <Reference.scad>;

// TODO: Convert to automatic measurement
function GripExtension() = 1;
function GripSlotAngle() = 30;
function GripWidth() = 0.9;
function GripExtensionX(extension=GripExtension(), angle=GripSlotAngle()) = extension * sin(angle);
function GripExtensionZ(extension=GripExtension(), angle=GripSlotAngle()) = extension * cos(angle);
function GripOffsetX(receiver=Spec_TeeThreeQuarterInch()) = -(TeeWidth(receiver)/2)+0.1;
function GripOffsetZ(receiver=Spec_TeeThreeQuarterInch()) = -TeeCenter(receiver)-TeeRimWidth(receiver);

module GripBolt(length=0.73,
                bolt_od=0.255, bolt_offset_x=-0.22,
                nut_od=0.5, nut_height=0.25, nut_angle=0) {

    translate([bolt_offset_x+GripOffsetX(),0,GripOffsetZ()])
    rotate([0,30,0])
    union() {
      translate([0,0,(nut_height/2)-1.1])
      cylinder(r=bolt_od/2, h=length+1.1, $fn=20);

      // Nut
      rotate([0,0,nut_angle])
      translate([0,0,length-0.125])
      cylinder(r=nut_od/2, h=nut_height, $fn=6);
    }
}

module GripTab(slot_width=0.35, slot_height=0.984, slot_length=1.28,
               slot_angle=30, slot_angle_offset = -0.4136,
               front=abs(GripOffsetX()), top=abs(GripOffsetZ()), debug=true) {
  translate([GripOffsetX(),0,GripOffsetZ()]) {
    difference() {
      union() {

        // Mount body
        translate([-slot_length,-slot_width/2,-slot_height])
        color("Fuchsia")
        cube([slot_length,
              slot_width,
              slot_height+0.0001]);

        // Top
        translate([0,0,-0.001])
        union() {
        translate([-slot_length,-GripWidth()/2,0])
          cube([slot_length+front,GripWidth(),top]);

        translate([-slot_length,0,0])
          cylinder(r=(GripWidth()/2), h=top, $fn=30);
        }
      }

      // Angle cutter
      translate([-slot_length,0,slot_angle_offset])
      rotate([0,slot_angle,0])
      translate([0,-slot_width/2 - 0.1,-1])
      cube([1.2, slot_width + 0.2, 1]);
    }

    // Grip
    color("CornflowerBlue", 0.25)
    %if(debug)
    //hull()
    render(convexity=4)
    translate([-1.766,0])
    rotate([180,0,-90])
    scale([1/25.4, 1/25.4, 1/25.4])
    import("Vitamins/Grip.stl");
  }
}

// Test Print
scale([25.4,25.4,25.4]) {
  Reference();

  difference() {
    GripTab(debug=false);

    // Mounting Hole Cutter
    GripBolt();
  }
}
