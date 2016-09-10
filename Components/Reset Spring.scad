include <Meta/Animation.scad>;
use <Components/Semicircle.scad>;
use <Meta/Manifold.scad>;
use <Meta/Debug.scad>;

use <Vitamins/Rod.scad>;
use <Vitamins/Spring.scad>;
use <Reference.scad>;
use <Trigger.scad>;

function ResetPinX() = -2.5;
function ResetPinZ() = -3.75;

module ResetPin(clearance=RodClearanceSnug()) {
  translate([ResetPinX(), 0,ResetPinZ()])
  rotate([90,0,0])
  Rod(rod=ResetRod(), center=true, length=0.5);
}

function ResetRadius() = 0.4;
function ResetCircumference() = (2*3.14)*ResetRadius();
function ResetAngleExtended() = 360/(ResetCircumference()/SpringLengthExtended(TriggerSpring()));
function ResetAngleCompressed() = 360/(ResetCircumference()/SpringLengthCompressed(TriggerSpring()));
function ResetAngle() = ResetAngleExtended()-ResetAngleCompressed();




echo("ResetRadius", ResetRadius());
echo("ResetAngleExtended", ResetAngleExtended());
echo("ResetAngleCompressed", ResetAngleCompressed());
echo("SpringOD", SpringOD(TriggerSpring()));
echo("SpringLengthExtended(spring)", SpringLengthExtended(TriggerSpring()));
echo("SpringLengthCompressed(spring)", SpringLengthCompressed(TriggerSpring()));
echo("SpringCompression(TriggerSpring())", SpringCompression(TriggerSpring()));
function TriggerMinorRadius() = 0.22;

module ResetSpring(left=true, right=true) {
  resetAngle=-145;

  leftSpindleRadius = 0.3;
  rightSpindleRadius = 0.2;

  height=0.24;
  sidePlateHeight = (height-SpringOD(TriggerSpring()))*0.5;
  spindleOuterRadius = 0.4;

  heightMinusOD = height-SpringOD(TriggerSpring());
  wall=0.08;

  // Right side
  if (right)
  color("Magenta", 0.5)
  render(convexity=5)
  translate([ResetPinX(), 0, ResetPinZ()])
  rotate([0,resetAngle+(ResetAngle()*0.6*Animate(ANIMATION_STEP_SAFETY)),0])
  union() {
    difference() {
      union() {

        // Side plate
        difference() {
          hull() {

            // Side plate body
            translate([0,-1/8,0])
            rotate([-90,0,0])
            cylinder(r=spindleOuterRadius, h=sidePlateHeight-0.002, $fn=Resolution(12,30));

            // Side plate spring cover
            mirror([0,1])
            translate([0,1/8,0])
            rotate([90,5,0])
            linear_extrude(height=sidePlateHeight-0.002)
            semicircle(od=(ResetRadius()+SpringOD(TriggerSpring())+wall)*2,
                       angle=ResetAngleExtended()+15, $fn=Resolution(12,30));
          }
        }

        // Safety Interface
        difference() {
          // Body
          hull() {

            translate([0,-1/8,0])
            rotate([0,43,0])
            translate([0,0,spindleOuterRadius/2])
            cube([1.5,height,spindleOuterRadius/2]);

            translate([0,-1/8,0])
            rotate([-90,40,0])
            linear_extrude(height=sidePlateHeight)
            semicircle(od=(ResetRadius()+SpringOD(TriggerSpring())+wall+0.015)*2,
                       angle=5, $fn=Resolution(12,30));
          }


          // Path for the left side plate
          translate([-0.01,1/8,-0.01])
          rotate([90,-47,0])
          linear_extrude(height=height-sidePlateHeight+0.012)
          semicircle(od=(ResetRadius()+SpringOD(TriggerSpring())+wall+0.015)*2,
                     angle=360, $fn=Resolution(12,30));
        }

        // Left-side spindle
        translate([0,-height/2,0])
        rotate([-90,0,0])
        Spindle(radius=leftSpindleRadius, center=false, cutter=false, height=height);
      }

      // Spindle hole
      rotate([90,0,0])
      Spindle(radius=rightSpindleRadius, center=true, cutter=true);
    }

    // Spring Interface
    translate([0,(SpringOD(TriggerSpring())/2)-0.01,0])
    rotate([90,6,0])
    linear_extrude(height=SpringOD(TriggerSpring())+sidePlateHeight-0.01)
    semidonut(minor=ResetRadius()*2.1,
              major=(ResetRadius()+SpringOD(TriggerSpring()))*2,
              angle=25, $fn=Resolution(12,30));
  }

  // Left side
  if (left)
  color("CornflowerBlue", 0.5)
  render(convexity=4)
  //DebugHalf()
  translate([ResetPinX(), 0, ResetPinZ()])
  rotate([0,resetAngle+(ResetAngle()*0.4*-Animate(ANIMATION_STEP_TRIGGER)),0])
  difference() {
    union() {

      // Spring Vitamin
      %translate([0,SpringOD(TriggerSpring())*0.51,0])
      rotate([90,30,0])
      linear_extrude(height=SpringOD(TriggerSpring())*1.03)
      semidonut(minor=ResetRadius()*2,
                major=(ResetRadius()+SpringOD(TriggerSpring()))*2.1,
                angle=ResetAngleExtended(), $fn=Resolution(12,30));

      // Body
      hull() {
        translate([0,1/8,0])
        rotate([90,0,0])
        cylinder(r=spindleOuterRadius, h=height-sidePlateHeight-0.002, $fn=Resolution(12,30));

        // Side plate
        translate([0,1/8,0])
        rotate([90,ResetAngleExtended()+28,0])
        linear_extrude(height=height-sidePlateHeight-0.002)
        mirror([0,1])
        semicircle(od=(ResetRadius()+SpringOD(TriggerSpring())+wall)*2,
                   angle=ResetAngleExtended()+25, $fn=Resolution(12,30));
      }

      // Trigger interface
      translate([-spindleOuterRadius/2,1/8,0])
      rotate([90,ResetAngleExtended()-3,0])
      mirror([0,1,0])
      cube([1.87,spindleOuterRadius/2,height]);
    }

    // Spring cutout
    translate([0,SpringOD(TriggerSpring())*0.51,0])
    rotate([90,5,0])
    linear_extrude(height=SpringOD(TriggerSpring())*1.03)
    semidonut(minor=ResetRadius()*2,
              major=(ResetRadius()+SpringOD(TriggerSpring()))*2.1,
              angle=ResetAngleExtended()+20,
              $fn=Resolution(12,30));

    // Spindle hole
    rotate([90,0,0])
    Spindle(radius=leftSpindleRadius, center=true, cutter=true);

    // Right Side plate clearance
    mirror([0,1])
    translate([0,1/8,0])
    rotate([90,5,0])
    linear_extrude(height=sidePlateHeight+0.012)
    semicircle(od=(ResetRadius()+SpringOD(TriggerSpring())+wall)*2.05,
               angle=360, $fn=Resolution(12,30));
  }
}


ResetSpring();