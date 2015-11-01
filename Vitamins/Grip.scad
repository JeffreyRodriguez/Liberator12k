// TODO: Convert to automatic measurement
function GripExtension() = 0.784;


function GripSlotAngle() = 30;
function GripWidth() = 0.85;
function GripExtensionX(extension, angle=GripSlotAngle()) = extension * sin(angle);
function GripExtensionZ(extension, angle=GripSlotAngle()) = extension * cos(angle);

module Grip_Bolt(od=0.255, lengthUp=1/4, lengthDown=2,
                 nut_od=0.5, nut_height=0.25, nut_angle=90) {

    color("Green", 0.5)
    %cube([.01,.01,.01], center=true);

    translate([0,0,0])
    rotate([0,30,0])
    union() {
      translate([0,0,-lengthDown])
      cylinder(r=od/2, h=lengthUp+lengthDown, $fn=20);

      // Nut
      rotate([0,0,nut_angle])
      translate([0,0,-0.125])
      cylinder(r=nut_od/2, h=nut_height, $fn=6);
    }
}

module GripTab(slot_width=0.35, slot_height=0.984, slot_length=1.28,
               slot_angle=30, slot_angle_offset = -0.4136, bolt_offset = 0.22,
               grip_width = 0.9,
               extension=1/8,
               extraFront=1/2, extraTop=0.2, debug=true) {
    translate([bolt_offset -GripExtensionX(extension, slot_angle),0,-GripExtensionZ(extension, slot_angle)]) {
    difference() {
      union() {

        // Mount body
        translate([-slot_length,-slot_width/2,-slot_height])
        color("Fuchsia")
        cube([slot_length,
              slot_width,
              slot_height+0.0001]);

        // Top
        intersection() {
          translate([-slot_length-0.25,-grip_width/2,-0.001])
          cube([slot_length+0.25+extraFront,grip_width,extraTop]);

          translate([-slot_length+0.23,0,-0.05]) {
            translate([-0.02,-(grip_width/2), 0])
            cube([slot_length+extraFront,grip_width+0.01,extraTop+0.1]);

            cylinder(r=(grip_width/2), h=extraTop+0.1, $fn=30);
          }
        }

        // Front
        translate([-0.0001,-grip_width/2,-slot_height-0.31])
        *cube([extraFront,grip_width,slot_height+0.32]);
      }

      // Angle cutter
      translate([-slot_length,0,slot_angle_offset])
      rotate([0,slot_angle,0])
      translate([0,-slot_width/2 - 0.1,-1])
      cube([1.2, slot_width + 0.2, 1]);
    }

    // Grip
    color("CornflowerBlue")
    %if(debug)
    render(convexity=4)
    translate([-1.766,0])
    rotate([180,0,-90])
    scale([1/25.4, 1/25.4, 1/25.4])
    import("Grip.stl");
  }
}

module Grip(extension=1/8*sqrt(2), debug=false) {

  translate([0,0,0])
  difference() {
    translate([0,0,0])
    GripTab(extension=extension, debug=debug);

    // Mounting Hole Cutter
    translate([0,0,0])
    #Grip_Bolt(lengthDown=extension+5);
  }
}


// Test Print
scale([25.4,25.4,25.4]) {
  //translate([0,0,1/4])
  //rotate([0,90,0])
  Grip(extension=(1/8*sqrt(2)) + 1, debug=true);
}
