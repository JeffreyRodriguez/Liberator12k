
include <../Components.scad>;
use <../Reference.scad>;
use <../Components/Semicircle.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;
use <../Forend Rail.scad>;
use <../Trigger Guard.scad>;
use <../Trigger.scad>;

// diode: 0.27
// Laser: 0.532+0.02;

function LaserOD() = 0.67;
//function LaserOD() = ;

module TLP_Receiver_Cutouts() {
  

    // Grip Cutout (Tee)
    translate([-TeeWidth(ReceiverTee()),
               -(GripWidth()/2) -0.01,
               -TeeRimRadius(ReceiverTee())])
    mirror([0,0,1])
    cube([TeeWidth(ReceiverTee())*2, GripWidth()+0.02, TeeCenter(ReceiverTee())]);
    
    // Grip Cutout (Front)
    difference() {
      translate([TeeWidth(ReceiverTee())/2,
                 -(GripWidth()/2) -0.01,
                 -TeeRimRadius(ReceiverTee())])
      mirror([0,0,1])
      cube([1, GripWidth()+0.02, TeeCenter(ReceiverTee())]);
    }
    
    // Grip Cutout (Rear)
    difference() {
      translate([-(TeeWidth(ReceiverTee())/2) -WallFrameBack(),
                 -(GripWidth()/2) -0.01,
                 -PipeOuterRadius(StockPipe()*0.8)])
      mirror([1,0,1])
      cube([2, GripWidth()+0.02, TeeCenter(ReceiverTee())]);
    
      translate([-(TeeWidth(ReceiverTee())/2) -WallFrameBack(),0,0])
      rotate([0,-90,0])
      Pipe(pipe=StockPipe());
    }
    
    // Trigger Column Cutout
    translate([0,0,-TeeCenter(ReceiverTee())])
    cylinder(r=TeeInnerRadius(ReceiverTee())+0.05, h=TeeCenter(ReceiverTee()));
}

module TLP_Receiver_Segment(extraFront=0, extraRear=0, wall=undef) {
   height = RodDiameter(GripRod())+(wall*2);
  
   // Bolt Body
   translate([-(height/2),
              -RodRadius(GripRod()),
              -(GripWidth()/2)-wall])
   cube([height+extraFront,height-wall,GripWidth()+(wall*2)]);

  // Laser Tube Body
  translate([-(height/2)-extraRear,-TriggerGuardPinZ(),0])
  rotate([0,90,0])
  cylinder(r=(LaserOD()/2)+wall,
           h=height+extraFront+extraRear,
           $fn=Resolution(20,60));
}

module TLP_Receiver_Front(laser_back_to_button = 100/25.4,
                     laser_button_width = 0.227 + 0.015,
                     laser_button_height = 0.615 - LaserOD(),
                     laser_button_height_pressed = 0.592 - LaserOD(),
                     wall = 0.25) {
  offsetX = RodRadius(GripRod())+wall;
  height = RodDiameter(GripRod())+(wall*2);
  extraFront = 0.3;

  color("Goldenrod")
  render(convexity=4)
  difference() {
    hull() {
    TeeHousingFrontPin(ReceiverTee(), length=GripWidth()+0.4,
                       extraRadius=wall*0.9,
                       $fn=Resolution(20,60))
      
       // Square Bolt Body
       translate([-(height/2),
                  -RodRadius(GripRod()),
                  -(GripWidth()/2)-wall])
       cube([height,height-wall,GripWidth()+(wall*2)]);
      

      // Laser Body
      translate([GripPinOffsetX()-offsetX,0,0])
      rotate([0,90,0])
      cylinder(r=(LaserOD()/2)+wall,
               h=height+extraFront,
               $fn=Resolution(20,60));
                         
    };
    
    TLP_Receiver_Cutouts();

    TeeHousingPins(receiver=ReceiverTee());
    
    // Laser body
    translate([0,0,0])
    rotate([0,90,0])
    cylinder(r=LaserOD()/2,
             h=3,
             center=false, $fn=24);
    
    // Laser Module
    render() {
      
      // Body
      translate([GripPinOffsetX()+extraFront+offsetX-0.4,0,0])
      rotate([0,90,0])
      cylinder(r=LaserOD()/2,
               h=0.41,
               center=false, $fn=10);
      
      // Laser wiring
      translate([0,0,0])
      rotate([0,90,0])
      cylinder(r=0.08,
               h=3,
               center=false, $fn=10);
    }
    
    // Union Hole
    *translate([(TeeWidth(ReceiverTee())/2) +0.05, 0,0])
    rotate([0,-90,0])
    cylinder(r=0.33, height-0.15, $fn=6);
  }
}

module TLP_Receiver_Rear(laser_back_to_button = 100/25.4,
                     laser_button_width = 0.227 + 0.015,
                     laser_button_height = 0.615 - LaserOD(),
                     laser_button_height_pressed = 0.592 - LaserOD(),
                     wall = 0.25) {

  height = RodDiameter(GripRod())+(wall*2);
  extraRear = 0;
  
  difference() {
      
    hull()
    TeeHousingRearPin(ReceiverTee(), length=GripWidth()+0.4,
                      extraRadius=wall*0.9,
                      $fn=Resolution(20,60)) {

      // Square off that bolt for printing
      translate([-(height/2),
                -RodRadius(GripRod()),
                -(GripWidth()/2)-wall])
      cube([height,height-wall,GripWidth()+(wall*2)]);

      // Laser Tube Body
      translate([-(height/2)-extraRear,-TriggerGuardPinZ(),0])
      rotate([0,90,0])
      cylinder(r=(LaserOD()/2)+wall,
               h=height+extraRear,
               $fn=Resolution(20,60));
    };
    
    TLP_Receiver_Cutouts();

    TeeHousingPins(receiver=ReceiverTee());
    
    // Laser body
    rotate([0,90,0])
    cylinder(r=LaserOD()/2,
             h=6,
             center=true, $fn=Resolution(15,30));
    
  }
}

module LaserSear() {
  translate([SearPinX(),0,SearPinZ()])
  difference() {
    union() {
      translate([-SearPinX(),0,-SearPinZ()])
      Sear();
      
      color("Red")
      rotate([0,TriggerAngle()*-$t,0])
      translate([0.25,-sear_height()/2,-0.-SearMinorRadius()])
      #cube([0.45,sear_height(),0.2]);
    }
    
    // Remove the rear of the sear
    
    rotate([90,(TriggerAngle()*-$t)+170,0])
    linear_extrude(h=1, center=true)
    semidonut(minor=0.5, major=2, angle=100);
  }
  
}




scale([25.4, 25.4, 25.4])
//translate([(TeeWidth(ReceiverTee())/2)+1.25,0,0])
{

  color("Green", 0.2);
  %Reference_TriggerGuard(debug=false);
  
  %LaserSear();
  
  %Trigger();
  %Safety();
  %ResetSpring();

  TLP_Receiver_Front();

  render(convexity=4)
  TLP_Receiver_Rear();

  *%Frame();
}