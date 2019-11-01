include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/RenderIf.scad>;

use <../../Meta/Math/Triangles.scad>;

use <../../Shapes/Components/Cylinder Redux.scad>;
use <../../Shapes/Components/Pump Grip.scad>;

use <../Lower/Lower.scad>;
use <../Lower/Trigger.scad>;

use <../../Shapes/Chamfer.scad>;

use <../../Shapes/Bearing Surface.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Shapes/TeardropTorus.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/ZigZag.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Ammo/Shell Slug.scad>;

use <../Receiver.scad>;
use <../Recoil Plate.scad>;
use <../Charging Pump.scad>;
use <../Lugs.scad>;
use <../Frame.scad>;


// Settings: Lengths
function ShellRimLength() = 0.06;
function ChamberLength() = 3;
function BarrelLength() = 18-ChamberLength();
function ActuatorPretravel() = 0.125;
function ForendGasGap() = 1.5;
function RevolverSpindleOffset() = 1.0001;
function WallBarrel() = 0.375;
function WallSpindle() = 0.25;

function ChamferRadius() = 1/16;
function CR() = 1/16;


// Settings: Vitamins
//Spec_TubingZeroPointSevenFive();
//Spec_TubingOnePointOneTwoFive();
//Spec_TubingOnePointZero();

//Spec_PipeThreeQuarterInch();
//Spec_PipeOneInch();
function BarrelPipe() = Spec_TubingOnePointZero();

// ZigZag Cylinder
function CylinderRod() = Spec_RodOneQuarterInch();
function SpindleCollarWidth() = 0.32;
function SpindleCollarDiameter() = 0.63;
function SpindleCollarRadius() = SpindleCollarDiameter()/2;

function CranePivotRod() = Spec_RodFiveSixteenthInch();
function CraneBolt() = Spec_BoltFiveSixteenths();
function CraneLatchBolt() = Spec_BoltM4();

// Shorthand: Measurements
function BarrelRadius(clearance=undef)
    = PipeOuterRadius(BarrelPipe(), clearance);

function BarrelDiameter(clearance=undef)
    = PipeOuterDiameter(BarrelPipe(), clearance);

function BarrelCollarDiameter() = 1 + (5/8);
function BarrelCollarRadius() = BarrelCollarDiameter()/2;
function BarrelCollarWidth() = (5/8);


// Calculated: Lengths
function ForendFrontLength() = FrameUpperBoltExtension()-ChamberLength()-ForendGasGap();

// Calculated: Positions
function ForendMaxX() = FrameUpperBoltExtension();
function ForendMinX() = ForendMaxX()-ForendFrontLength();

function BarrelCollarMinX() = ForendMinX()-BarrelCollarWidth();

function RecoilPlateTopZ() = ReceiverOR()
                           + FrameUpperBoltDiameter()
                           + (WallFrameUpperBolt()*2);

// Crane
function CranePivotAngle() = 90;
function WallCrane() = 0.25;

function CranePivotRadius(clearance=0)
    = BoltRadius(CraneBolt(), clearance);
function CranePivotDiameter(clearance=0)
    = BoltDiameter(CraneBolt(), clearance);


function CraneLatchTravel() = BarrelCollarWidth();
function CraneLatchLength() = CraneLatchTravel()+(WallBarrel()*sqrt(2));
function CraneLatchHandleWall() = 0.375;
function CraneLatchHandleDiameter() = 2;
function CraneLatchHandleRadius() = CraneLatchHandleDiameter()/2;
function CraneLatchGuideWidth() = 0.75;
function CraneLatchGuideHeight() = RevolverSpindleOffset();
function CraneLatchHandleZ() = -(RevolverSpindleOffset()*2);
function CraneLatchHandleMaxZ() = -RevolverSpindleOffset()
                                  -(SpindleCollarRadius()+WallCrane());

function CraneLengthFront() = 0.5;
function CraneLengthRear() = 0.5;
function CraneLength() = CraneLengthFront()
                       + CraneLengthRear()
                       + ForendFrontLength()
                       + BarrelCollarWidth();
function CraneMaxX() = ForendMaxX()
                     + CraneLengthFront();
function CraneMinX() = CraneMaxX()-CraneLength();

function CranePivotY() =  1.09375; //FrameBoltY()+(3/32);
function CranePivotZ() =  0.4525; //FrameBoltZ()-(15/16);

function CranePivotHypotenuse() = pyth_A_B(CranePivotY(), CranePivotZ());
function CranePivotPinAngle() = CranePivotHypotenuse()*asin(CranePivotZ());

function CraneLatchMinX() = CraneMaxX();
function CraneLatchMaxX() = CraneLatchMinX()+CraneLatchLength();

module RevolverRecoilPlateHousing(debug=false) {
  color("YellowGreen")
  DebugHalf(enabled=debug) render()
  difference() {
    ReceiverFront(width=2*(FrameBoltY()
                          +WallFrameUpperBolt()
                          +FrameUpperBoltRadius())-(1/16)) {

        // Backing plate for the cylinder
        translate([0,0,-RevolverSpindleOffset()])
        rotate([0,90,0])
        ChamferedCylinder(r1=(BarrelRadius()*3)+(CR()*2), r2=CR(),
                 h=abs(RecoilPlateRearX())-ManifoldGap());

        // Frame upper support
        *hull() {
          translate([0,0,-FrameBoltZ()*2])
          FrameSupport(length=abs(RecoilPlateRearX()));
          FrameSupport(length=abs(RecoilPlateRearX()));
        }
    }

    RevolverSpindle(cutter=true);
  }
}


module Barrel(barrel=BarrelPipe(), barrelLength=BarrelLength(), hollow=true,
              clearance=undef, alpha=1, cutter=false, debug=false) {

  clear = (cutter ? 0.005 : 0);
  clear2 = clear*2;

  color("Silver", alpha) DebugHalf(enabled=debug) RenderIf(!cutter)
  translate([ChamberLength()+ShellRimLength(),0,0])
  rotate([0,90,0])
  Pipe(pipe=barrel, clearance=clearance,
       hollow=hollow, length=barrelLength);

  // Rear Shaft Collar
  color("DimGrey", alpha) DebugHalf(enabled=debug) RenderIf(!cutter)
  translate([ForendMinX(),0,0])
  rotate([0,-90,0])
  cylinder(r=BarrelCollarRadius()+PipeClearance(barrel, clearance),
           h=BarrelCollarWidth()+ManifoldGap(), $fn=PipeFn(BarrelPipe())*2);

  // Front Shaft Collar
  color("DimGrey", alpha) DebugHalf(enabled=debug) RenderIf(!cutter)
  translate([CraneMaxX()-ManifoldGap(),0,0])
  rotate([0,90,0])
  cylinder(r=BarrelCollarRadius()+PipeClearance(barrel, clearance),
           h=BarrelCollarWidth()+clear+ManifoldGap(), $fn=PipeFn(BarrelPipe())*2);
}

module RevolverSpindle(teardrop=false, cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") RenderIf(!cutter)
  translate([RecoilPlateRearX(),0,-RevolverSpindleOffset()])
  rotate([0,90,0])
  Rod(CylinderRod(),
      length=CraneLatchMaxX()-RecoilPlateRearX()
            +ManifoldGap(3),
      clearance=cutter?RodClearanceSnug():undef,
      teardrop=cutter&&teardrop);


  // Rearward shaft collar
  color("SteelBlue")
  translate([ManifoldGap(),0,-RevolverSpindleOffset()])
  rotate([0,90,0])
  cylinder(r=SpindleCollarRadius()+clear,
           h=SpindleCollarWidth(),
           $fn=Resolution(20,50));

  // Forward shaft collar
  color("SteelBlue")
  translate([CraneLatchMaxX()+ManifoldGap(),0,-RevolverSpindleOffset()])
  rotate([0,-90,0])
  cylinder(r=SpindleCollarRadius()+clear,
           h=SpindleCollarWidth(), $fn=Resolution(20,50));
}
module CranePivotPath(clearance=0.005, $fn=Resolution(30,90)) {

    //
    // Pivot Paths (mirrored for ambidexterity)
    // XDL = MaxX, Diameter, Length
    for (M = [0,1]) mirror([0,M,0])
    for (XDL = [[CraneLatchMaxX(),
                 BarrelDiameter(PipeClearanceSnug()),
                 CraneLatchMaxX()],
                [ForendMaxX()+clearance,
                 BarrelCollarDiameter()+(clearance*2),
                 ForendFrontLength()+BarrelCollarWidth()+(clearance*2)]])
      translate([XDL[0]+ManifoldGap(),CranePivotY(),CranePivotZ()])
      rotate([0,-90,0])
      linear_extrude(height=XDL[2])
      semidonut(major=(CranePivotHypotenuse()*2)+XDL[1],
                minor=(CranePivotHypotenuse()*2)-XDL[1],
                angle=90+(CranePivotPinAngle()/2)+5); // TODO: Why is this off by 5 degrees?
}
module CranePivotPosition(angle=CranePivotAngle(), factor=1) {
  translate([0,CranePivotY(),CranePivotZ()])
  rotate([angle*factor,0,0])
  translate([0,-CranePivotY(),-CranePivotZ()])
  children();
}

module CranePivotPin(cutter=false, teardrop=false, clearance=0.005) {
  color("Silver") RenderIf(!cutter)
  translate([CraneMaxX()+ManifoldGap(),CranePivotY(),CranePivotZ()])
  rotate([0,-90,0])
  NutAndBolt(bolt=CraneBolt(), head="hex",
             boltLength=CraneLength()
                       +ManifoldGap(2),
             clearance=cutter?clearance:0,
             nutHeightExtra=cutter?CraneLengthRear():0,
             teardrop=teardrop&&cutter);
}


module CraneLatch(cutter=false, clearance=0.005,
                  alpha=1, debug=false, $fn=Resolution(20,80)) {
    clear = clearance;
    clear2 = clear*2;

  color("BurlyWood", alpha)
  DebugHalf(enabled=debug) RenderIf(!cutter)
  difference() {
      union() {
        hull() {

          // Square the top
          translate([CraneLatchMinX(),
                     -BarrelCollarRadius()-(WallBarrel()/2),0])
          ChamferedCube([BarrelCollarWidth(),
                        BarrelCollarDiameter()+WallBarrel(),
                        RevolverSpindleOffset()+BarrelRadius()],
                        r=CR(),
                            $fn=Resolution(20,40));

          // Square the top front
          translate([CraneLatchMinX()+BarrelCollarWidth(),
                     -BarrelCollarRadius(),0])
          ChamferedCube([CraneLatchLength()-BarrelCollarWidth(),
                        BarrelCollarDiameter(),
                        RevolverSpindleOffset()+BarrelRadius()],
                        r=CR(),
                            $fn=Resolution(20,40));

          // Around the barrel collar
          translate([CraneLatchMinX(),0,0])
          rotate([0,90,0])
          ChamferedCylinder(r1=BarrelCollarRadius()+WallBarrel(), r2=CR(),
                   h=BarrelCollarWidth(),
                   $fn=Resolution(30,60));

          // In front of the barrel collar, narrow tapered portion
          translate([CraneLatchMaxX(),0,0])
          rotate([0,-90,0])
          ChamferedCylinder(r1=BarrelCollarRadius(), r2=CR(),
                   h=WallBarrel(),                   $fn=Resolution(30,60));
      }

      hull() {

        // Around the spindle
        translate([CraneLatchMinX(),0,-RevolverSpindleOffset()])
        rotate([0,90,0])
        ChamferedCylinder(r1=SpindleCollarRadius()+WallSpindle(), r2=CR(),
                          h=CraneLatchLength());

        // Guide block straight segment
        translate([CraneLatchMinX(),-(CraneLatchGuideWidth()/2)-clear,CraneLatchHandleMaxZ()])
        ChamferedCube([CraneLatchLength(),
                       CraneLatchGuideWidth()+clear2,
                       abs(CraneLatchHandleMaxZ())],
                      r=CR());

        // Guide Block Cover
        translate([CraneLatchMinX(),
                   -(CraneLatchGuideWidth()/2)-CraneLatchHandleWall(),
                   CraneLatchHandleMaxZ()-clear])
        ChamferedCube([BarrelCollarWidth(),
              CraneLatchGuideWidth()+(CraneLatchHandleWall()*2),
              abs(CraneLatchHandleMaxZ())+clear],
              r=CR());
      }

      // Crane Latch Guide Block
      union() {

          // Square portion
        translate([CraneLatchMinX(),
                   -(CraneLatchGuideWidth()/2)-clear,
                   -RevolverSpindleOffset()-CraneLatchGuideHeight()-clear])
        ChamferedCube([CraneLatchLength(),
                      CraneLatchGuideWidth()+clear2,
                      CraneLatchGuideHeight()+clear],
                      r=CR(),
                                                   $fn=Resolution(20,40));

        // Tapered cylindrical portion
        hull() {
          translate([CraneLatchMaxX(), 0, CraneLatchHandleZ()])
          rotate([0,-90,0])
          ChamferedCylinder(r1=(CraneLatchGuideWidth()*0.75),
                            r2=CR(), h=CR()*2,
                                                       $fn=Resolution(30,60));

          translate([CraneLatchMinX(), 0, CraneLatchHandleZ()])
          rotate([0,90,0])
          ChamferedCylinder(r1=(CraneLatchGuideWidth()/2)+CR(),
                            r2=CR(), h=CR()*2,
                                                       $fn=Resolution(30,60));
        }
      }
    }

    // Barrel collar chamfer
    translate([CraneLatchMinX(),0,0])
    rotate([0,90,0])
    HoleChamfer(r1=BarrelCollarRadius()+clearance, r2=CR()*2,
                teardrop=true);

    // Barrel chamfer
    translate([CraneLatchMaxX()+ManifoldGap(),0,0])
    rotate([0,-90,0])
    ChamferedCircularHole(r1=BarrelRadius(clearance=PipeClearanceLoose()),
                                               r2=CR(), h=CraneLatchLength()-BarrelCollarWidth());

    CranePivotPath();

    Barrel(cutter=true, hollow=false, clearance=PipeClearanceSnug());

    RevolverSpindle(cutter=true);
  }
}
module CraneLatchHandle(clearance=0.008, alpha=1, debug=false) {
  clear = clearance;
  clear2 = clearance*2;

  color("BurlyWood", alpha)
  DebugHalf(enabled=debug) render()
  difference() {
    union() {

      // Grip
      difference() {
        translate([CraneMinX(),0,CraneLatchHandleZ()])
        rotate([0,90,0])
        PumpGrip(
          length=CraneLength()+CraneLatchLength()-CR(),
          outerRadius=CraneLatchHandleRadius());

        // Cut the top of the grip flat
        translate([CraneMinX()-ManifoldGap(),
                   -CraneLatchGuideWidth(),
                   -RevolverSpindleOffset()
                   -SpindleCollarRadius()-WallSpindle()-CR()])
        cube([CraneLength()+CraneLatchLength()+ManifoldGap(2),
              CraneLatchGuideWidth()*2,
              RevolverSpindleOffset()]);
      }

      // Guide Block Cover
      translate([CraneMinX(),
                 -(CraneLatchGuideWidth()/2)-CraneLatchHandleWall(),
                 CraneLatchHandleMaxZ()-clear])
      mirror([0,0,1])
      ChamferedCube([CraneLength()+CraneLatchLength()-CR(),
            CraneLatchGuideWidth()+(CraneLatchHandleWall()*2),
            abs(CraneLatchHandleMaxZ()-CraneLatchHandleZ())],
            r=CR());

    }

    // Crane Latch Guide Block
    union() {

        // Square portion
      translate([CraneMinX()-CR(),
                 -(CraneLatchGuideWidth()/2),
                 -(RevolverSpindleOffset())])
      mirror([0,0,1])
      ChamferedCube([CraneLength()+CraneLatchLength()+(CR()*2),
            CraneLatchGuideWidth(),
            CraneLatchGuideHeight()], r=CR());

      // Cylindrical portion
      translate([CraneMinX(), 0, CraneLatchHandleZ()])
      rotate([0,90,0])
      ChamferedCircularHole(r1=(CraneLatchGuideWidth()*0.6)+clear, r2=CR(),
                            h=CraneLength()+CraneLatchLength()+(CR()*2),
                            chamferTop=false, teardropBottom=true,
                            $fn=Resolution(30,60));

    }

    translate([CraneLatchMaxX(),0,CraneLatchHandleZ()])
    rotate([0,-90,0])
    CircularOuterEdgeChamfer(r1=CraneLatchHandleRadius(), r2=0.75,
                              teardrop=true, $fn=Resolution(40,90));

    CraneLatch(cutter=true);
  }
}

module RevolverCrane(cutter=false, teardrop=false, clearance=0.005,
                     $fn=Resolution(30,100), alpha=1, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  pivotCutterRadius = RodRadius(CylinderRod())+WallCrane()+clearance;

  color("OliveDrab", alpha)
  DebugHalf(enabled=debug) RenderIf(!cutter)
  difference() {
    union() {
      hull() {

        // Around the crane pivot rods
        for (Y = [1,-1])
        translate([CraneMinX(),CranePivotY()*Y,CranePivotZ()])
        rotate([0,90,0])
        ChamferedCylinder(r1=CranePivotRadius()+WallCrane(), r2=CR(),
                 h=CraneLength());

        // Body around the barrel
        difference() {
          intersection() {
            translate([CraneMinX(),0,0])
            rotate([0,90,0])
            ChamferedCylinder(r1=CranePivotY()+CranePivotRadius()+WallCrane(), r2=CR(),
                     h=CraneLength());

            translate([CraneMinX(),0,0])
            rotate([0,90,0])
            rotate(90)
            linear_extrude(height=CraneLength())
            semidonut(major=(CranePivotY()+CranePivotRadius()+WallCrane())*2,
                      minor=BarrelDiameter(),
                      angle=180);
          }
        }

        // Flat-top fills in, and gets trimmed down for the pivot path
        translate([CraneMinX(),0,CranePivotZ()])
        ChamferedCube([CraneLength(),
                       abs(CranePivotY()),
                       CranePivotRadius()+WallCrane()],
                       r=CR(),$fn=20);
      }

      // Crane Latch Guide Block
      union() {

          // Square portion
        translate([CraneMinX(),
                   -(CraneLatchGuideWidth()/2),
                   -(RevolverSpindleOffset())])
        mirror([0,0,1])
        ChamferedCube([CraneLength(),
              CraneLatchGuideWidth(),
              CraneLatchGuideHeight()], r=CR());

        // Cylindrical portion
        translate([CraneMinX(), 0, CraneLatchHandleZ()])
        rotate([0,90,0])
        ChamferedCylinder(r1=(CraneLatchGuideWidth()*0.6), r2=CR(), h=CraneLength());
      }

      // Guide Block Cover
      translate([CraneMinX(),
                 -(CraneLatchGuideWidth()/2)-CraneLatchHandleWall(),
                 CraneLatchHandleMaxZ()])
      ChamferedCube([CraneLength(),
            CraneLatchGuideWidth()+(CraneLatchHandleWall()*2),
            abs(CraneLatchHandleMaxZ())],
            r=CR());
    }

    // Forend clearance (Crane Supports)
    translate([ForendMinX()-0.005+ManifoldGap(),
               -CranePivotY()-(pivotCutterRadius*2),
                CranePivotZ()-(pivotCutterRadius)])
    cube([ForendFrontLength()+0.01,
          (CranePivotY()+pivotCutterRadius*2)*2,
          (pivotCutterRadius)*3]);

    // Forend + Rear Barrel Collar clearance
    translate([ForendMaxX()+clearance+ManifoldGap(), 0, 0])
    rotate([0,-90,0])
    cylinder(r=BarrelCollarRadius()+clearance,
             h=ForendFrontLength()+BarrelCollarWidth()+(clearance*2));

    // Chamfered Barrel Cutout: Front
    translate([CraneMaxX()+ManifoldGap(),0,0])
    rotate([0,-90,0])
    ChamferedCircularHole(r1=BarrelRadius(clearance=PipeClearanceLoose()),
                                               r2=CR(), h=CraneMaxX()-ForendMaxX());

    // Chamfered Barrel Cutout: Rear
    translate([ManifoldGap(),0,0])
    translate([CraneMinX(),0,0])
    rotate([0,90,0])
    ChamferedCircularHole(r1=BarrelRadius(clearance=PipeClearanceLoose()),
                                                   r2=CR(), h=CraneLengthRear());

    CranePivotPath();

    for (M = [0,1]) mirror([0,M,0]) // Ambidexterity mirror
    CranePivotPin(cutter=true);

    RevolverSpindle(cutter=true);

    *Barrel(hollow=false, cutter=true, clearance=PipeClearanceSnug());
  }
}
module CraneShield(cutter=false, clearance=0.006,
                     debug=false, $fn=Resolution(30,100), alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  pivotCutterRadius = RodRadius(CylinderRod())+WallCrane()+0.005;
  craneRadius = CranePivotY()+CranePivotRadius()+WallCrane();
  cylinderMaxX = 2.3355+ShellRimLength();

  color("OliveDrab", alpha) DebugHalf(enabled=debug)  RenderIf(!cutter)
  difference() {
    union() {

      // Around cylinder
      difference() {
        translate([CraneMinX(),0,-RevolverSpindleOffset()])
        rotate([0,-90,0])
        ChamferedCylinder(r1=1.875, r2=CR(),
                          h=CraneMinX()-cylinderMaxX-0.005);

        // Cutout for chambers
        translate([0,0,-RevolverSpindleOffset()])
        rotate([0,90,0])
        ChamferedCylinder(r1=(0.5*3)+(CR()/2), r2=CR(),
        h=ChamberLength()+ShellRimLength()+0.005);
      }
    }

    RevolverSpindle(cutter=true);

    Barrel(cutter=true, hollow=false, clearance=PipeClearanceLoose());

    CranePivotPath();

    rotate([0,90,0])
    rotate(180)
    linear_extrude(height=CraneMinX()+ManifoldGap())
    difference() {
    translate([-BarrelRadius(),0,0])
      semidonut(major=6, minor=BarrelDiameter(),
                angle=130, center=true);

      translate([-BarrelDiameter(),0])
      for (R = [-60,0,60]) rotate(R)
      translate([BarrelDiameter(),0])
      circle(r=0.505);
    }
  }
}

module RevolverForend(debug=false, alpha=1, $fn=Resolution(30,100)) {

  // Forward plate
  color("DarkOliveGreen", alpha)
  DebugHalf(enabled=debug) render()
  difference() {
    union() {

      // Around the barrel
      translate([ForendMaxX(),0,0])
      rotate([0,-90,0])
      ChamferedCylinder(r1=BarrelCollarRadius(), r2=CR(),
               h=ForendFrontLength());

      // Join the barrel to the frame
      for (M = [0,1]) mirror([0,M,0])
      translate([ForendMaxX(),0,0])
      translate([0,BarrelCollarRadius(),
                 CranePivotZ()-WallCrane()-CranePivotRadius()])
      rotate([0,-90,0])
      Fillet(r=CR(), h=ForendFrontLength(),
                     inset=true, taperEnds=true);

    // Crane Pivot Supports
    translate([FrameUpperBoltExtension(),0,0])
    mirror([1,0,0])
    hull() {

        // Around the upper bolts
        FrameSupport(length=ForendFrontLength());

        // Around the crane pivot pin
        for (M = [0,1]) mirror([0,M,0])
        translate([0,CranePivotY(),CranePivotZ()])
        rotate([0,90,0])
        ChamferedCylinder(r1=CranePivotRadius()+WallCrane(), r2=CR(),
                           h=ForendFrontLength());
      }
    }

    // Cutout for a picatinny rail insert
    translate([-ManifoldGap(), -UnitsMetric(15.6/2), RecoilPlateTopZ()-0.125])
    cube([FrameUpperBoltExtension()+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

    FrameBolts(cutter=true);

    Barrel(hollow=false, clearance=PipeClearanceSnug());

    ChargingRod(cutter=true);

    RevolverSpindle(cutter=true);

    for (M = [0,1]) mirror([0,M,0])
    CranePivotPin(cutter=true);
  }
}

module RevolverFrameAssembly(debug=false) {

  FrameBolts(cutter=false);
  ReceiverBolts(cutter=false);
}

// 1" OD (4130 Tube) chambers
module RevolverCylinder_4130x6(supports=true, chambers=false,
                             chamberBolts=false,
                             debug=false) {
  OffsetZigZagRevolver(
      centerOffset=RevolverSpindleOffset(),
      chamberRadius=0.5, chamberInnerRadius=0.813/2,
      coreInnerRadius=SpindleCollarRadius()+0.003,
      zigzagAngle=80, wall=0.1875,
      extraTop=ActuatorPretravel(),
      supports=supports, chamberBolts=chamberBolts,
      chambers=chambers, chamberLength=ChamberLength(),
      debug=debug, alpha=1.0);
}

module RevolverShotgunAssembly(stock=true,
                               pipeAlpha=1, debug=false) {

  translate([0,0,0]) {
    RevolverRecoilPlateHousing(debug=debug);
    RecoilPlateFiringPinAssembly(debug=debug);
    RecoilPlate(debug=debug);
  }

  RevolverFrameAssembly(debug=debug);

  translate([0,0,0]) {

    ChargingPumpAssembly(debug=debug);

    Barrel(hollow=true, debug=debug);

    RevolverForend(debug=debug);

    CranePivotPosition(factor=Animate(ANIMATION_STEP_UNLOAD)
                     -Animate(ANIMATION_STEP_LOAD)) {

      translate([ShellRimLength(),0,0])
      translate([0,0,-RevolverSpindleOffset()])
      rotate([0,90,0])
      rotate(-360/6/2*SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.25, end=0.8))
      rotate(-360/6/2*SubAnimate(ANIMATION_STEP_CHARGE, start=0.4, end=0.98)) {
        RevolverCylinder_4130x6(supports=false, chambers=true, debug=false);
      }

      CranePivotPin();
      RevolverCrane(debug=debug);
      CraneShield(debug=debug);

      // Latch
      translate([CraneLatchTravel()*(SubAnimate(ANIMATION_STEP_UNLOCK, end=0.5)
                    -SubAnimate(ANIMATION_STEP_LOCK, start=0.5)),0,0])
      {
          RevolverSpindle();
          CraneLatch(debug=debug);
          CraneLatchHandle(debug=debug);
      }
    }
  }

  PipeUpperAssembly(pipeAlpha=pipeAlpha,
                    debug=false);
}


RevolverShotgunAssembly(pipeAlpha=0.5, debug=false);



/*
 * Platers
 */


// Revolver Cylinder shell
*!scale(25.4) render()
difference() {
  translate([-RevolverSpindleOffset(),0,0])
  rotate([0,-90,0])
  RevolverCylinder_4130x6(supports=true);
  //RevolverCylinder_ERW4(supports=true, chambers=false, debug=false);

  translate([0,0,-ManifoldGap()])
  cylinder(r=RevolverSpindleOffset()-0.125,
           h=ChamberLength()+ManifoldGap(2), $fn=20);
}

// Revolver Cylinder core
*!scale(25.4) render() translate([0,0,ChamberLength()]) rotate([180,0,0])
intersection() {
  translate([-RevolverSpindleOffset(),0,0])
  rotate([0,-90,0])
  RevolverCylinder_4130x6(supports=true,
                          chambers=false,
                          chamberBolts=false,
                          debug=false);


  translate([0,0,-ManifoldGap()])
  cylinder(r=RevolverSpindleOffset()-0.25, h=ChamberLength()+ManifoldGap(2), $fn=20);
}

*!scale(25.4) rotate([0,90,0]) translate([-CraneMinX(),0,0])
CraneShield();

*!scale(25.4) rotate([0,-90,0]) translate([-ForendMinX(),0,0])
RevolverForend();

*!scale(25.4) rotate(90) rotate([0,-90,0]) translate([-CraneMinX(),0,0])
RevolverCrane();

*!scale(25.4) rotate([0,90,0]) translate([-CraneLatchMaxX(),0,0])
CraneLatch();

*!scale(25.4) rotate([0,-90,0]) translate([-CraneMinX(),0,-CraneLatchHandleZ()])
CraneLatchHandle();

*!scale(25.4) rotate([0,-90,0]) translate([-RecoilPlateRearX(),0,0])
RevolverRecoilPlateHousing();
