use <../Vitamins/Rod.scad>;
use <../Vitamins/Pipe.scad>;
use <../Meta/Resolution.scad>;

function BarrelPipe() = Spec_FiveSixteenthInchBrakeLine();
function ActuatorRod() = Spec_RodOneQuarterInch();
function CylinderRod() = Spec_RodOneQuarterInch();

function CylinderWall() = 0.25;
function CylinderOuterWall() = 3/32;
function CylinderChamberOffset() = PipeOuterDiameter(BarrelPipe()) + CylinderWall();
function ZigZagDepth() = 3/16;
shots = 8;
zigzag_clearance = 0.00;

function CylinderRadius(barrelPipe=BarrelPipe()) =
                  (PipeOuterDiameter(barrelPipe)*1.5)
                  +CylinderWall() 
                  +CylinderOuterWall()
                  +ZigZagDepth();

// Calculated: Revolver Cylinder
zigzag_width = RodDiameter(ActuatorRod()) + (zigzag_clearance*2);
cylinder_circumference = 3.14 * pow(CylinderRadius(), 2);
center_offset = PipeOuterDiameter(BarrelPipe()) + CylinderWall();
rotation_angle = 360/shots;
rotation_arc_length = cylinder_circumference/shots;
zigzag_height = (rotation_arc_length/2) + (RodDiameter(ActuatorRod())*sqrt(2));
cylinder_height = zigzag_height + (RodDiameter(ActuatorRod())*2.5);

top_slot_height = RodDiameter(ActuatorRod())*2;
bottom_slot_height = RodDiameter(ActuatorRod())*2;

zigzag_cutter_width = zigzag_width + RodDiameter(ActuatorRod())/2.5; // ???: Eyeballed this one

function ZigZagMajorArcLength() = cylinder_circumference/zigzag_width;
function ZigZagMajorArcAngle() = cylinder_circumference/360*ZigZagMajorArcLength();

module CylinderSpindle(length=12, nutHeight=0.23) {

    // Spindle Rod
    translate([0,0,-CylinderChamberOffset()])
    rotate([0,90,0])
    linear_extrude(height=length)
    Rod2d(rod=CylinderRod(),clearance=RodClearanceLoose());

    // Spindle Nut
    translate([TeeRimRadius(ReceiverTee())+0.22,0,-CylinderChamberOffset()])
    rotate([0,-90,0])
    rotate(360/6/2)
    cylinder(r=0.58/2, $fn=6, h=nutHeight);
}

module ZigZag() {
    for (i=[0:shots-1]) {
      rotate([0,0,rotation_angle*i]) {

        // Zig
        translate([0,0,bottom_slot_height-RodRadius(ActuatorRod())])
        difference() {
          linear_extrude(height = zigzag_height,
                         center = false,
                         convexity = 1,
                         slices=Resolution(8,20),
                         twist = rotation_angle/2)
          translate([CylinderRadius() -ZigZagDepth(),-zigzag_width/2, 0])
          square([ZigZagDepth()*2, zigzag_cutter_width]);

          // Chop off the top tip
          rotate([0,0,-(rotation_angle/2)-ZigZagMajorArcAngle()])
          translate([CylinderRadius() - ZigZagDepth()*2,
                     -zigzag_cutter_width*1.5,
                     zigzag_height - top_slot_height + zigzag_clearance])
          cube([ZigZagDepth()*4,
                zigzag_cutter_width*1.5,
                top_slot_height+0.1]);

          // Chop off the bottom tip
          translate([CylinderRadius() - ZigZagDepth()*2,
                     zigzag_width/2,
                     -RodDiameter(ActuatorRod())/2])
          cube([ZigZagDepth()*4,
                zigzag_cutter_width,
                RodDiameter(ActuatorRod())*2]);
        }

        // Zag
        rotate([0,0,-rotation_angle])
        translate([0,0,RodRadius(ActuatorRod())])
        difference() {
          linear_extrude(height = zigzag_height,
                          center = false,
                          convexity = 3,
                          slices=Resolution(8,20),
                          twist = -rotation_angle/2)
          translate([CylinderRadius()-ZigZagDepth(), -(zigzag_cutter_width) + zigzag_width/2, 0])
          square([ZigZagDepth()*2, zigzag_cutter_width]);

          // Chop off the top tip
          rotate([0,0,rotation_angle/2 + 360/(1.8*(cylinder_circumference/zigzag_width))])
          translate([CylinderRadius() - ZigZagDepth()*2,
                     0,
                     zigzag_height-top_slot_height + zigzag_clearance])
          cube([ZigZagDepth()*4,
                zigzag_cutter_width,
                top_slot_height]);

          // Chop off the bottom tip
          translate([CylinderRadius() - ZigZagDepth()*2,
                     -zigzag_cutter_width + zigzag_width/2 - zigzag_clearance,
                     -RodDiameter(ActuatorRod())/2])
          cube([ZigZagDepth()*4,
                zigzag_cutter_width,
                RodDiameter(ActuatorRod())*3]);
        }

        // Vertical slot top
        rotate([0,0,-rotation_angle/2])
        translate([
          CylinderRadius() - ZigZagDepth() + 0.001,
          -zigzag_width/2,
          cylinder_height - top_slot_height - zigzag_clearance*2])
        cube([ZigZagDepth()*2, zigzag_width, top_slot_height + zigzag_clearance*3]);

        // Vertical slot bottom
        translate([
          CylinderRadius() - ZigZagDepth() + 0.001,
          -zigzag_width/2,
          -zigzag_clearance])
        cube([ZigZagDepth()*2, zigzag_width, bottom_slot_height + zigzag_clearance*2]);
      }
    }
}

module RevolverCylinder(shots=shots, debug=false) {

  echo("Cylinder OD:", CylinderRadius());
  echo("Cylinder Circ:", cylinder_circumference);
  echo("Rotation Arc:", rotation_arc_length);
  echo("ZigZag Height:", zigzag_height);
  echo("Cylinder Height:", cylinder_height);
  echo ("ZigZagMajorArcAngle(): ", ZigZagMajorArcAngle());

  color("Gold")
  render()
  union() {
    difference() {

      // Body
      linear_extrude(height=cylinder_height)
      difference() {
        circle(r=CylinderRadius(), $fn=Resolution(30,120));

        // Chambers
        for (i=[0:shots-1])
        rotate([0,0,rotation_angle*i]) {
          translate([CylinderChamberOffset(),0])
          Pipe2d(pipe=BarrelPipe(), clearance=PipeClearanceSnug());
        }

        // Spindle
        Rod2d(rod=CylinderRod(), clearance=RodClearanceLoose());

        // Trim the tips between the chambers, it's a donut shape
        *difference() {
          circle(r=CylinderChamberOffset(), $fn=Resolution(30,50));
          circle(r=CylinderChamberOffset()*0.7, $fn=Resolution(30,50));
        }
      }

      ZigZag();
    }

    // Support Material
    color("Black")
    for (i=[0:shots-1]) {
      rotate([0,0,rotation_angle*i])
      translate([CylinderRadius() - ZigZagDepth() - 0.008,zigzag_width/2,RodDiameter(ActuatorRod())])
      cube([ZigZagDepth(), 0.031, RodDiameter(ActuatorRod()) * 1.75]);
    }
  }
  
  color("grey")
  if (debug) {
    
    // Chambers
    translate([0,0,-0.2])
    linear_extrude(height=3)
    for (i=[0:shots-1])
    rotate([0,0,rotation_angle*i]) {
      translate([CylinderChamberOffset(),0])
      Pipe2d(pipe=BarrelPipe(), clearance=PipeClearanceSnug(), hollow=true);
    }
  }
}

scale([25.4, 25.4, 25.4])
RevolverCylinder(debug=false);
