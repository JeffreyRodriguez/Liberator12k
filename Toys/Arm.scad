arm_length = 150;
arm_length = 225;

bearing_od = 22 + 0.25;
bearing_id = 15; // Size required to clear the inner race nut
bearing_height = 7.04;
bearing_lip = 1.15;
tube_od = 27 + 0.25;
tube_od = 19.24 + 0.4;
tube_length = (25.4 * 24);
bolt_od = 8.75;
lockbolt_od = 4;
nut_od = 14.6 + 0.1;
nut_height = 6;
washer_height = 1.75;
washer_od = 15.71;
wall = 6;
wheel_radius = 77;
wheel_height = 10;
wheel_head = 10;
footer_height = nut_height + bearing_height + 2;


// End Parameters
EndHeight = 0;
EndOD = 1;
EndID = 2;
EndFN = 3;
EndTopSocket = 4;
EndTopSocketOD = 5;
EndTopSocketHeight = 6;
EndTopSocketFN = 7;
EndBottomSocket = 8;
EndBottomSocketOD = 9;
EndBottomSocketHeight = 10;
EndBottomSocketFN = 11;

// End Flags
EndSocketDisabled = 0;
EndSocketEnabled = 1;

ThetaInnerTubeEnd = [
    [EndHeight, bearing_height*6],
    [EndOD,     bearing_od + wall*2],
    [EndID,     tube_od],
    [EndFN,     30],
    [EndTopSocket, EndSocketDisabled],
    [EndTopSocketOD, bearing_od],
    [EndTopSocketHeight, bearing_height],
    [EndTopSocketFN, 30],
    [EndBottomSocket, EndSocketDisabled],
    [EndBottomSocketOD, bearing_od],
    [EndBottomSocketHeight, bearing_height],
    [EndBottomSocketFN, 30]
  ];

ThetaInnerJointEnd = [
  [EndHeight, bearing_height*6],
  [EndOD,     bearing_od + wall*2],
  [EndID,     bolt_od],
  [EndFN,     30],
  [EndTopSocket, EndSocketEnabled],
  [EndTopSocketOD, nut_od],
  [EndTopSocketHeight, nut_height],
  [EndTopSocketFN, 6],
  [EndBottomSocket, EndSocketDisabled]
];


module arm_end_cutter(end) {
  union() {

    // Inner Hole
    translate([0,0,-1])
    cylinder(r=lookup(EndID, end)/2,
             h=lookup(EndHeight, end) +2);

    // Top Socket
    if (lookup(EndTopSocket, end) == EndSocketEnabled) {
      translate([0,0,lookup(EndHeight, end) - lookup(EndTopSocketHeight, end)])
      cylinder(r=lookup(EndTopSocketOD, end)/2,
               h=lookup(EndTopSocketHeight, end) + 1,
               $fn=lookup(EndTopSocketFN, end));
    }

    // Bottom Socket
    if (lookup(EndBottomSocket, end) == EndSocketEnabled) {
      translate([0,0,-1])
      cylinder(r=lookup(EndBottomSocketOD, end)/2,
               h=lookup(EndBottomSocketHeight, end) + 1,
               $fn=lookup(EndBottomSocketFN, end));
    }
  }
}

module arm(arm_length=arm_length, arm_height=12.7, arm_width=nut_od+wall*2,
           tapers=true, channel=0,
           end1=undef, end2=undef) {

  // NOTE: End1 is centered at the x=0; End2 is centered at x=arm_length
  render()
  union() {

  difference() {

    union() {
      // Arm Body
      translate([0,-arm_width/2, 0])
      cube([arm_length,arm_width,arm_height]);

      // End 1 Body
      cylinder(r=lookup(EndOD, end1)/2,
               h=lookup(EndHeight, end1),
               $fn=lookup(EndFN, end1));

      // End 2 Body
      translate([arm_length,0,0])
      cylinder(r=lookup(EndOD, end2)/2,
               h=lookup(EndHeight, end2),
               $fn=lookup(EndFN, end2));

      // Tapers
      if (tapers) {
        intersection() {
          translate([0,0,0])
          union() {

             // End 1 Taper
            if (lookup(EndHeight, end1) > arm_height)
            cylinder(r=lookup(EndOD, end1)*2,
                     r2=lookup(EndOD, end1)/2,
                     h=lookup(EndHeight, end1),
                     $fn=lookup(EndFN, end1));


             // End 2 Taper
            if (lookup(EndHeight, end2) > arm_height)
            translate([arm_length,0,0])
            cylinder(r=lookup(EndOD, end2)*2,
                     r2=lookup(EndOD, end2)/2,
                     h=lookup(EndHeight, end2),
                     $fn=lookup(EndFN, end2));
          }

          // Cut the above cones down to just the arm area
          translate([0,-arm_width/2,0])
          cube([arm_length, arm_width, max(lookup(EndHeight, end1), lookup(EndHeight, end2))]);
        }
      }
    }

    // End 1 Cutter
    arm_end_cutter(end=end1);

    // End 2 Cutter
    translate([arm_length, 0,0])
    arm_end_cutter(end=end2);

    // Cable Channel - Just an idea for now
    if (channel > 0) {
      translate([lookup(EndOD, end1),-arm_width/8, arm_height - channel])
      cube([arm_length - lookup(EndOD, end1) - lookup(EndOD, end2),arm_width/4,channel + arm_height]);
    }
  }

    // End1 Bottom Socket Support
    if (lookup(EndBottomSocket, end1) == EndSocketEnabled
        && lookup(EndBottomSocketOD, end1) > lookup(EndID, end1)) {
      cylinder(r=lookup(EndID, end1)/2*1.001,
               h=lookup(EndBottomSocketHeight, end1) + 1,
               $fn=lookup(EndBottomSocketFN, end1));
    }

    // End2 Bottom Socket Support
    translate([arm_length,0,0])
    if (lookup(EndBottomSocket, end2) == EndSocketEnabled
        && lookup(EndBottomSocketOD, end2) > lookup(EndID, end2)) {
      cylinder(r=lookup(EndID, end2)/2*1.001,
               h=lookup(EndBottomSocketHeight, end2) + 1,
               $fn=lookup(EndBottomSocketFN, end2));
    }
  }
}

module arm_theta_inner() {

  // End Parameters
  TubeEnd = ThetaInnerTubeEnd;
  JointEnd = ThetaInnerJointEnd;

  arm(end1=TubeEnd, end2=JointEnd,
      channel=10);
}

module arm_theta_outer() {

  // End Parameters
  JointEnd = [
  [EndHeight, bearing_height*4],
  [EndOD,     bearing_od + wall*2],
  [EndID,     bearing_id],
  [EndFN,     30],
  [EndTopSocket, EndSocketEnabled],
  [EndTopSocketOD, bearing_od],
  [EndTopSocketHeight, bearing_height],
  [EndTopSocketFN, 30],
  [EndBottomSocket, EndSocketEnabled],
  [EndBottomSocketOD, bearing_od],
  [EndBottomSocketHeight, bearing_height],
  [EndBottomSocketFN, 30]
];
  TipEnd = [
  [EndHeight, bearing_height*2],
  [EndOD,     nut_od + wall*2],
  [EndID,     bolt_od],
  [EndFN,     30],
  [EndTopSocket, EndSocketDisabled],
  [EndTopSocketOD, nut_od],
  [EndTopSocketHeight, nut_height],
  [EndTopSocketFN, 6],
  [EndBottomSocket, EndSocketDisabled]
];

  arm(end1=JointEnd, end2=TipEnd,
    arm_height=lookup(EndHeight, TipEnd),
      channel=6);
}

module printhead() {
  block_height = 12.7;
  groovemount_od = 16;
  printhead_offset = 11 + max(lookup(EndOD, PsiOuterTipEnd), lookup(EndOD, ThetaOuterTipEnd))/2;
  block_length = lookup(EndOD, ThetaOuterTipEnd) + wall;
  block_width = lookup(EndOD, ThetaOuterTipEnd)/2 + printhead_offset;

  vertical_offset = 0;
  lockbolt_xoffset = wall;
  lockbolt_yoffset = lookup(EndOD, ThetaOuterTipEnd)/2;

  translate([0,0,-vertical_offset])
  difference() {
      cube([block_length,block_width, block_height+vertical_offset]);

    // Front Inner Bezel
    difference() {
      translate([block_length - 15,-5,-1])
      cube([20,20,block_height+2]);

      translate([lookup(EndOD, ThetaOuterTipEnd)/2 + wall,lookup(EndOD, ThetaOuterTipEnd)/2,-2])
      cylinder(r=lookup(EndOD, ThetaOuterTipEnd)/2, h=block_height+4);
    }

    // Vertical Offset Cutter
    translate([-1,-1,-1])
    cube([block_length+2, lookup(EndOD, ThetaOuterTipEnd) + 1.25, vertical_offset+1]);

    // Front Angle
    translate([block_length-4,block_width+1,-1])
    rotate([0,0,-45])
    cube([20,10,block_height+vertical_offset+2]);

    // Back Angle
    translate([-1,block_width-8,-1])
    rotate([0,0,45])
    cube([20,10,block_height+vertical_offset+2]);

    // Bolt Hole
    translate([lookup(EndOD, ThetaOuterTipEnd)/2+wall,lookup(EndOD, ThetaOuterTipEnd)/2,-1])
    cylinder(r=lookup(EndID, ThetaOuterTipEnd)/2, h=block_height+vertical_offset+2);

    // Lockbolt Hole
    translate([lockbolt_xoffset,lockbolt_yoffset,-1])
    cylinder(r=lockbolt_od/2, h=block_height+vertical_offset +2, $fn=10);

    // Zip Tie Path
    translate([-1,block_width - groovemount_od/2 - 4,block_height/2 - 3])
    cube([block_length+2,3,6]);

    // Groovemount Cutter
    translate([lookup(EndOD, ThetaOuterTipEnd)/2 + wall,lookup(EndOD, ThetaOuterTipEnd)/2 + printhead_offset,0])
    #union() {
      translate([0,0,-1])
      cylinder(r=groovemount_od/2, h=4.25); // 1mm extra high

      translate([0,0,2])
      cylinder(r=6, h=8);

      translate([0,0,9])
      cylinder(r=groovemount_od/2, h=4.66++vertical_offset); // 1mm extra high

      // e3d v6 Body
      %union() {

        // Cooler
        translate([0,0,-30])
        cylinder(r=10, h=30);

        // Heat Break
        translate([0,0,-33.15])
        cylinder(r=1.25, h=3.15, $fn=16);

        // Heater Block
        translate([-4,-8,-44.65])
        cube([20,16,11.5]);

        // Tip
        translate([0,0,-49.9])
        cylinder(r=4, h=5.25);
      }
    }
  }

  *%translate([-arm_length + lookup(EndOD, ThetaOuterTipEnd)/2 + wall,
             lookup(EndOD, ThetaOuterTipEnd)/2,
             -	lookup(EndHeight, ThetaOuterTipEnd)])
  rotate([0,0,0])
  arm_theta_outer();

}


use <../Shapes/Components/T Lug.scad>;
use <../Shapes/Teardrop.scad>;
use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;

module ArmTubeTLug() {
  render()
  linear_extrude(height=0.75)
  difference() {
    union() {
      T_Lug2d();
      
      translate([-1.25,0])
      circle(r=(UnitsMetric(tube_od)/2)+0.25, $fn=50);
    }
    
    translate([-1.25,0])
    circle(r=UnitsMetric(tube_od)/2, $fn=30);
  }
}

module TLugWallPlate(width=2, distance=4, wall=0.75,
                     lugLength=0.75,
                     height=0.5, cutouts=true, tabs=true) {
  render()
  difference() {
    union() {
      translate([wall-ManifoldGap(), -width/2, 0])
      cube([lugLength+distance+ManifoldGap(2),width, height]);
      
      if (tabs)
      for (X = [0, distance+wall+lugLength])
      translate([X,-1.5,0])
      cube([wall, 3, height]);
    }
    
    if (cutouts)
    translate([0,0,height])
    mirror([0,0,1])
    for (X = [0, distance-wall])
    translate([X+wall,0,0]) {
      T_Lug(length=lugLength, tabHeight=1, cutter=true);
      
      translate([lugLength,0,0])
      T_Lug(length=lugLength, cutter=true);
    }
  }
}

*!scale(25.4)
TLugWallPlate();

*!scale(25.4)
TLugWallPlate(height=0.125, cutouts=false, tabs=false);


module plater() {
  
  
  
  // Theta Arms
  color("SaddleBrown")
  arm_theta_inner();

  translate([0,50,0])
  color("Khaki")
  arm_theta_outer();

  *translate([-50,0,0])
  rotate([0,-90,90])
  color("DarkKhaki")
  printhead();
}

plater();

*!scale(25.4)
ArmTubeTLug();
