use <../Vitamins/Rod.scad>;
use <../Vitamins/Pipe.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Manifold.scad>;

DEFAULT_CYLINDER_CHAMBERS = 9;
DEFAULT_ZIGZAG_DEPTH = 3/16;
DEFAULT_CHAMBER_WALL = 1/8;

function ZigZagDepth() = 3/16;

function BarrelPipe() = Spec_TubingZeroPointSevenFive();
function ActuatorRod() = Spec_RodOneEighthInch();
function CylinderRod() = Spec_RodOneHalfInch();

function CylinderWall() = 0.3125+0.375+.125+(0.0625/2);
function CylinderOuterWall() = 2 /32;
function CylinderChamberOffset() = 
  PipeOuterRadius(BarrelPipe())
  +CylinderWall();
shots = DEFAULT_CYLINDER_CHAMBERS;
zigzag_clearance = 0.00;

/*
function CylinderRadius(barrelPipe=BarrelPipe()) =
                  (PipeOuterDiameter(barrelPipe)*1.5)
                  +CylinderWall() 
                  +CylinderOuterWall()
                  +ZigZagDepth();
*/
function CylinderRadius(barrelPipe=BarrelPipe()) =
                  CylinderChamberOffset()
                  +PipeOuterRadius(BarrelPipe())
                  +CylinderOuterWall()
                  +ZigZagDepth();

// Calculated: Revolver Cylinder
zigzag_width = RodDiameter(ActuatorRod()) + (zigzag_clearance*2);
cylinder_circumference = 3.14 * pow(CylinderRadius(), 2);
rotation_angle = 360/shots;
rotation_arc_length = cylinder_circumference/shots;
zigzag_height = (rotation_arc_length/2) + (RodDiameter(ActuatorRod())*sqrt(2));

zigzag_lead = RodRadius(ActuatorRod())*2.5;
zigzag_tail = zigzag_lead;

cylinder_height = zigzag_height + zigzag_lead + zigzag_tail;

function ZigZagSegmentLength(diameter, positions) = DiameterToCircumference(diameter)/positions;
function ZigZagHeight(diameter, positions) = (rotation_arc_length/2) + (RodDiameter(ActuatorRod())*sqrt(2));

top_slot_height = RodDiameter(ActuatorRod())*2;
bottom_slot_height = RodDiameter(ActuatorRod())*2;

zigzag_cutter_width = zigzag_width + RodDiameter(ActuatorRod())/2.5; // ???: Eyeballed this one

function DiameterToCircumference(diameter) = PI * pow(diameter/2, 2);
function ZigZagTrackWidth(rod=ActuatorRod()) = RodDiameter(rod, clearance=RodClearanceLoose());
function ZigZagMajorArcLength(diameter,trackWidth=ZigZagTrackWidth(ActuatorRod())) = DiameterToCircumference(diameter)/zigzag_width;
function ZigZagMajorArcAngle() = cylinder_circumference/360*ZigZagMajorArcLength();

module ZigZag(
           diameter=CylinderRadius()*2,
           depth=DEFAULT_ZIGZAG_DEPTH,
           width=zigzag_width,
           positions=shots) {

  radius = diameter/2;
  segment_angle = 360/positions;
  
  render()
  for (i=[0:positions-1]) {
    rotate([0,0,segment_angle*i])
    render() {
      
    // Support Material
    *color("Black")
    for (i=[0:shots-1]) {
      rotate([0,0,rotation_angle*i])
      translate([CylinderRadius() - ZigZagDepth() - 0.008,zigzag_width/2,RodDiameter(ActuatorRod())])
      cube([ZigZagDepth(), 0.031, RodDiameter(ActuatorRod()) * 1.75]);
    }

      // Zig
      translate([0,0,bottom_slot_height-RodRadius(ActuatorRod())])
      difference() {
        linear_extrude(height = zigzag_height,
                       center = false,
                       convexity = 1,
                       slices=Resolution(8,20),
                       twist = segment_angle/2)
        translate([CylinderRadius() -ZigZagDepth(),-zigzag_width/2, 0])
        square([ZigZagDepth()*2, zigzag_cutter_width]);

        // Chop off the top tip
        rotate([0,0,-(segment_angle/2)-ZigZagMajorArcAngle()])
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
      rotate([0,0,-segment_angle])
      translate([0,0,RodRadius(ActuatorRod())])
      difference() {
        linear_extrude(height = zigzag_height,
                        center = false,
                        convexity = 3,
                        slices=Resolution(8,20),
                        twist = -segment_angle/2)
        translate([CylinderRadius()-ZigZagDepth(), -(zigzag_cutter_width) + zigzag_width/2, 0])
        square([ZigZagDepth()*2, zigzag_cutter_width]);

        // Chop off the top tip
        rotate([0,0,segment_angle/2 + 360/(1.8*(cylinder_circumference/zigzag_width))])
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
      rotate([0,0,-segment_angle/2])
      translate([
        CylinderRadius() - ZigZagDepth() + 0.001,
        -zigzag_width/2,
        cylinder_height - top_slot_height - zigzag_clearance*2])
      cube([ZigZagDepth()*2, zigzag_width, top_slot_height + zigzag_clearance*3]);

      // Vertical slot bottom
      translate([
        radius - depth,
        -zigzag_width/2,
        -zigzag_clearance])
      cube([depth*2, zigzag_width, bottom_slot_height + zigzag_clearance*2]);
    }
  }
}

module OffsetRevolverIterator(centerOffset=1, positions=4) {
  for (i=[0:positions-1])
  rotate([0,0,rotation_angle*i]) {
    translate([centerOffset,0])
    children();
  }
}

function OffsetRevolverDiameter(centerOffset, chamberDiameter, wall)
             = centerOffset + (chamberDiameter/2) + wall;

module OffsetRevolver(
         centerOffset=1, chamberDiameter=1,
         height=1,
         trackAngle=0,
         chamberLength=undef,
         chambers=true, debug=false) {
positions=shots;
  color("Gold")
  render()
  union() {
    
    // Body
    linear_extrude(height=height)
    difference() {
      circle(r=CylinderRadius(), $fn=Resolution(30,120));

      OffsetRevolverIterator(centerOffset=centerOffset, positions=shots)
      children();
    }

    // Support Material
    color("Black")
    OffsetRevolverIterator(centerOffset=CylinderRadius() - ZigZagDepth() - 0.008, positions=shots)
    translate([0,zigzag_width/2,RodDiameter(ActuatorRod())])
    cube([ZigZagDepth(), 0.031, RodDiameter(ActuatorRod()) * 1.75]);
  }
}

module OffsetZigZagRevolver(barrelPipe=BarrelPipe(),
           centerOffset=1,
           trackAngle=0,
           chambers=true, chamberLength=undef,
           printableZigZag=true, debug=false) {
             
  height=ZigZagHeight();//TODO

  color("Gold")
  render()
  difference() {
    OffsetRevolver(centerOffset=centerOffset, height=height, debug=false)
    translate([0,0,-ManifoldGap()])
    Pipe2d(barrelPipe, clearance=PipeClearanceSnug());
  
    rotate(trackAngle)
    ZigZag(printable=printableZigZag);

    // Spindle
    Rod(rod=CylinderRod(), length=height, clearance=RodClearanceLoose());
  }
  
  if (chambers)
  color("MidnightBlue")
  OffsetRevolverIterator(centerOffset=centerOffset, positions=shots)
  Pipe(BarrelPipe(), length=(chamberLength==undef?height:chamberLength), clearance=undef);
}

OffsetZigZagRevolver(
           centerOffset=CylinderChamberOffset(), chambers=true, chamberLength=1.5,
           trackAngle=0, debug=false);
