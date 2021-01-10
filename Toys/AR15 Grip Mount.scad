use <../Receiver/Receiver.scad>;
use <../Receiver/Lower/Trigger.scad>;
use <../Receiver/Lower/Lower.scad>;

  slot_width = .34;
  slot_height = .930;
  slot_length = 1.280;
  slot_angle  = 30.1;
  slot_angle_offset = -0.4;
  slot_overlap = 1/4;

  grip_width = 0.85;
  grip_height = 1.26;
  grip_bolt_diameter = 1/4;

    // TODO: Calculate this instead of specifying
    grip_bolt_length = 2;
    grip_bolt_offset_x = -slot_length/2 - grip_bolt_diameter/2 - 0.04; // Why?


module ar15_grip_bolt(od=grip_bolt_diameter, length=4,
                      nut_od=0.5, nut_height=0.25,
                      nut_offset=2, nut_angle=0,
                      nut_slot_length=0, nut_slot_angle=0) {
    translate([grip_bolt_offset_x,0,-length/4])
    rotate([0,30,0])
    union() {
      cylinder(r=od/2, h=length, $fn=30);

      // Nut
      if (nut_offset && nut_height > 0)
      translate([0,0,nut_offset]) {
      rotate([0,0,nut_angle])
        cylinder(r=nut_od/2, h=nut_height, $fn=6);

        if (nut_slot_length > 0)
        rotate([0,0,nut_slot_angle])
        translate([-nut_od/2,0,0])
        cube([nut_od, nut_slot_length, nut_height]);
      }
    }
}

module ar15_grip(mount_height=1, mount_length=1, top_extension = 0, extension=0,
                 nut_od=0.5, nut_height=0.25, nut_offset=2, nut_angle=0,
                 debug=false) {

  render()
  difference() {
    union() {
        
      // Grip Boss
      translate([-ReceiverLength()+1.5,0,ReceiverBottomZ()])
      hull() {
        translate([-slot_length,-slot_width/2,-0.3460])
        cube([slot_length, slot_width, 0.3460]);
        
        translate([-0.1705,-slot_width/2,-slot_height])
        cube([0.1705, slot_width, slot_height]);
      }
      
      // Receiver Slot Wide Section
      translate([-ReceiverLength(),
                 -(ReceiverSlotWidth()/2),
                 ReceiverBottomZ()+0.1875])
      cube([ReceiverLength()-0.5,
            ReceiverSlotWidth(),
            0.3125]);

      // Receiver Slot Narrow Section
      translate([-ReceiverLength(),
                 -(ReceiverSlotWidth()/2)+0.125,
                 ReceiverBottomZ()])
      cube([ReceiverLength()-0.5,
            ReceiverSlotWidth()-0.25,
            0.25]);
    }
    
    translate([-LowerMaxX(),0,0])
    #SearCutter();

    *union() {


      // Mount body
      translate([-slot_length,-slot_width/2,-slot_height])
      color("Fuchsia")
      cube([slot_length + extension,slot_width,slot_height]);

      // Vertical Mounting Block
      if (mount_height > 0)
      intersection() {
        translate([-slot_length - slot_overlap,-grip_width/2,0])
        color("Purple")
        cube([slot_length + slot_overlap + top_extension,grip_width,mount_height]);

        *union() {
          translate([-slot_length - slot_overlap + grip_width/2,0,-0.1])
          cylinder(r=grip_width/2, h=mount_height + 0.2);

          translate([-slot_length - slot_overlap + grip_width/2,-grip_width/2,0])
          color("Purple")
          cube([slot_length+top_extension,grip_width,mount_height]);
        }
      }

      // Horizontal Mounting Block
      if (mount_length > 0)
      translate([0,-grip_width/2,-grip_height])
      color("Indigo")
      cube([mount_length,grip_width,grip_height + mount_height]);


      // Grip
      if(debug)
      translate([-1.766,0])
      rotate([180,0,-90])
      scale([1/25.4, 1/25.4, 1/25.4])
      import("Vitamins/Grip.stl");
    }
    
    // FCG Slot
    translate([-1.25,-(0.27/2),0])
    mirror([1,0,0])
    mirror([0,0,1])
    cube([1.5, 0.27, 2]);

    // Mounting Hole Cutter
    translate([-ReceiverLength()+1.5,0,ReceiverBottomZ()])
    ar15_grip_bolt(nut_offset=nut_offset, nut_height=0, nut_angle=nut_angle);
  }

}


ReceiverAssembly();

translate([-LowerMaxX(),0,LowerOffsetZ()])
Lower(showTrigger=true, showLeft=false);

//!scale(25.4) rotate([0,180,0]) translate([ReceiverLength()-1.5,0,-ReceiverBottomZ()])
ar15_grip(mount_height = 0, mount_length = 0);

