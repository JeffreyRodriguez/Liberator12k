include <Components.scad>;
use <Vitamins/Grip.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Forend Rail.scad>;
use <Trigger.scad>;
use <Reference.scad>;
use <Tee Housing.scad>;

module TriggerGuardAlignmentPins(receiver, pin=Spec_RodOneEighthInch()) {
  
  #for (xz = [[TeeHousingFrontX(receiver) -TeeRimWidth(receiver),
               -(TriggerGuardHeight()/2)],
             [-(TeeWidth(receiver)/2)+TeeRimWidth(receiver),
              -TriggerGuardHeight() + (RodRadius(pin)*3)]])
  translate([xz[0],0,TeeHousingBaseZ(receiver)+xz[1]])
  rotate([90,0,0])
  Rod(rod=pin, center=true, clearance=RodClearanceLoose(),
      length=TeeInnerDiameter(receiver)+1);
}

module TriggerGuardBlock(receiver, triggerGuardHole=TriggerGuardHole(),
                              triggerGuardRearLength = TriggerGuardRearLength(),
                              frontExtension=TeeHousingFrontExtension()) {
  difference() {
    
    // Main block
    translate([-(TeeWidth(receiver)/2)+TeeRimWidth(receiver)-triggerGuardRearLength,
               -TeeInnerRadius(receiver),
               TeeHousingBaseZ(receiver)-TriggerGuardHeight()])
    cube([TeeWidth(receiver)+frontExtension-TeeRimWidth(receiver)+triggerGuardRearLength-0.001,
          TeeInnerDiameter(receiver),
          TeeRimWidth(receiver)+TriggerGuardHeight()]);
    
    TriggerGuardFingerSlot(receiver);
    
    // Front chamfer
    translate([(TeeWidth(receiver)/2)-TeeRimWidth(receiver),-1,-TeeCenter(receiver)-TriggerGuardHeight()-0.7])
    rotate([0,45,0])
    cube([2,2,2]);
  }
}



module TriggerGuardSplitter(receiver, triggerGuardHole=TriggerGuardHole(),
                              triggerGuardRearLength = TriggerGuardRearLength(),
                              frontExtension=TeeHousingFrontExtension(), clearance=0) {
  translate([-(TeeWidth(receiver)/2) -1,
             -0.125 -clearance,
             TeeHousingBaseZ(receiver)-TriggerGuardHeight()-clearance])
  cube([TeeWidth(receiver)+frontExtension+2,
        0.25+(clearance*2),
        TeeCenter(receiver)+TeeRimWidth(receiver)+TriggerGuardHeight()]);
}

module TriggerGuardSides(receiver,
  frontExtension = TeeHousingFrontExtension(),
  forendPinRod   = Spec_RodFiveSixteenthInch(),
  triggerGuardHole   = TriggerGuardHole(),
  triggerGuardRearLength = TriggerGuardRearLength()) {
  
  // Trigger Guard Sides
  difference() {
    union() {
      
      // Inner plug
      translate([0,0,-TeeCenter(receiver)-0.001])
      cylinder(r=TeeInnerRadius(receiver), h=TeeCenter(receiver) -0.35, $fn=25);
      
      TriggerGuardBlock(receiver);
      
      // Tab tops
      translate([0,0,-TeeCenter(receiver)])
      translate([(TeeWidth(receiver)/2)-TeeRimWidth(receiver)-0.001,
                 -TeeInnerRadius(receiver), -0.001])
      cube([TeeRimWidth(receiver)+frontExtension,
             TeeInnerDiameter(receiver),
             TeeCenter(receiver)-TeeRimRadius(receiver)-TeeRimWidth(receiver)]);
      
      // Grip Tab
      TeeHousingGripTab(receiver, clearance=0);
      
    }

    TriggerGuardSplitter(receiver, clearance=0);
    
    translate([0,0,-TeeCenter(receiver)])
    rotate([0,0,180])
    FireControlPins();
    
    // Front Pin hole
    TeeHousingFrontPin(receiver, forendPinRod);
    
    TriggerGuardAlignmentPins(receiver);
  }

}

module TriggerGuardTop(receiver, wall=tee_overlap) {
  difference() {
    union() {
      translate([0,0,TeeHousingBaseZ(receiver)])
      hull() {

        // Front
        color("Red")
        translate([(TeeWidth(receiver)/2)-TeeRimWidth(receiver),0,-TeeHousingBaseZ(receiver)])
        rotate([0,-90,0])
        linear_extrude(height=TeeRimWidth(receiver))
        hull() {
        
          ForendRail(railClearance=RodClearanceSnug());
          
          // Trigger Fork Body
          translate([TeeHousingBaseZ(receiver)-TeeHousingBottomExtension(),-TeeInnerRadius(receiver)])
          square([TeeCenter(receiver), TeeInnerDiameter(receiver)]);
        }
        
        // Rim
        cylinder(r=TeeRimRadius(receiver)+wall, h=TeeRimWidth(receiver));
        
        // Rear face for hull
        translate([-(TeeWidth(receiver)/2)+TeeRimWidth(receiver),-TeeInnerRadius(receiver),-0.04])
        cube([0.001, TeeInnerDiameter(receiver), (TeeRimWidth(receiver)*2)+0.04]);
      }
        
      // Infill rear center tab
      translate([-(TeeWidth(receiver)/2)-0.001,
                 -0.125,
                 TeeHousingBaseZ(receiver)-TeeHousingBottomExtension()])
      #cube([TeeRimRadius(receiver), 0.25, (TeeRimWidth(receiver)*2)+0.04]);
      
      // AR15 Grip
      color("Blue",0.5)
      Reference_Grip_Position(receiver)
      GripTab(extension=GripExtension(), extraFront=TriggerGuardRearLength()+TeeRimWidth(receiver), extraTop=1, debug=debug);
    }
    
    // Cut off the top
    translate([-TeeWidth(receiver)*2,-2, -TeeCenter(receiver)+TeeRimWidth(receiver)])
    cube([TeeWidth(receiver)*4,4, 4]);
    
    // AR15 Grip Bolt
    color("Red")
    Reference_Grip_Position(receiver)
    #Grip_Bolt(extension=GripExtension(), nut_height=1, debug=false);
    
    translate([0,0,TeeHousingBaseZ(receiver)]) {
    
      // Trigger Guard Slots
      for (i=[0.125, -TeeInnerRadius(receiver)])
      translate([-(TeeWidth(receiver)/2)+TeeRimWidth(receiver),i,-TeeRimWidth(receiver)-0.001])
      cube([TeeWidth(receiver),
             TeeInnerRadius(receiver)-0.125,
             TeeRimWidth(receiver)*2+0.002]);
      
      translate([0,0,TeeRimWidth(receiver)-0.005])
      cylinder(r=TeeRimRadius(receiver), h=TeeRimWidth(receiver)*3, $fn=30);
      
      // Trigger Slot
      translate([-TeeInnerRadius(receiver),-0.13,-TeeRimWidth(receiver)-0.01])
      cube([TeeInnerDiameter(receiver),0.26,TeeRimWidth(receiver)*3]);
    }
    
    TriggerGuardFingerSlot(receiver);
    
    TeeHousingRearPin(receiver);
  }
}

module TeeHousingGripTab(receiver, clearance=0.005,
                          triggerGuardRearLength = TriggerGuardRearLength(),
                          tab_width=0.345) {  
      translate([-(TeeWidth(receiver)/2) +TeeRimWidth(receiver) -TriggerGuardRearLength() -clearance -0.3,
                 -(tab_width/2)-clearance,TeeHousingBaseZ(receiver)-TriggerGuardHeight()-clearance+0.31])
      cube([0.5,tab_width+(clearance*2),0.5+(clearance*2)]);
}

module TriggerGuardCenter(receiver) {
  difference() {
    union() {
      intersection() {
        TriggerGuardBlock(receiver);
        
        // Just the middle
        TriggerGuardSplitter(receiver, clearance=0);
      }
      
      // Grip Tab
      TeeHousingGripTab(receiver, tab_width=0.25, clearance=0);
    }
    
    // Cut off the top
    translate([-TeeWidth(receiver),-1,TeeHousingBaseZ(receiver)-TeeHousingBottomExtension()])
    cube([TeeWidth(receiver)*2,2,2]);
    
    // Trigger Slot
    translate([-TeeInnerRadius(receiver),-0.13,TeeHousingBaseZ(receiver)-TeeRimWidth(receiver)])
    cube([TeeInnerDiameter(receiver),0.26,TeeRimWidth(receiver)*3]);
    
    TriggerGuardAlignmentPins(receiver);
  }
}

module Reference_TriggerGuard(receiver=Spec_TeeThreeQuarterInch(),
                              breechBushing=Spec_BushingThreeQuarterInch(),
                              stock=Spec_PipeThreeQuarterInch(), debug=false) {
  // Trigger
  %translate([0,0,-TeeCenter(receiver)])
  rotate([0,0,180])
  trigger_insert(debug=true);
  
  // Trigger Top
  color("Orange")
  render()
  TriggerGuardTop(receiver, debug=debug);
  
  // Trigger Guard Sides
  color("Green")
  render()
  *TriggerGuardSides(receiver, debug=debug);
  
  // Trigger Guard Center
  color("HotPink")
  render()
  TriggerGuardCenter(receiver, debug=debug);
}


scale([25.4, 25.4, 25.4]) {
  color("DarkGrey")
  *Reference();
  
  render(convexity=4)
  Reference_TeeHousing(debug=true);
  Reference_TriggerGuard(debug=false);
}