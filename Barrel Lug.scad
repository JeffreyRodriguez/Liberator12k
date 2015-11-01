use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Reference.scad>;
use <Forend Rail.scad>;

barrel=Spec_TubingOnePointOneTwoFive();
breech = Spec_BushingThreeQuarterInch();
receiver=Spec_TeeThreeQuarterInch();

module Barrel_Lug(barrel=Spec_TubingOnePointOneTwoFive(),
                  receiver=Spec_TeeThreeQuarterInch(),
                  breech=Spec_BushingThreeQuarterInch(),
                  wall=3/8, length=3/8) {
  difference() {
    cylinder(r1=PipeOuterRadius(barrel) + wall, r2=TeeRimRadius(receiver), h=length, $fn=30);
    #Pipe(pipe=barrel, length=length*3, center=true);
  }
}

module Reference_Barrel_Lug() {
  for (i = [0:2])
  translate([i + (TeeWidth(receiver)/2) + BushingExtension(breech) +1,0,0])
  rotate([0,-90,0])
  Barrel_Lug();
}

module Receiver_Lug(barrel=barrel, receiver=receiver, rod=Spec_RodFiveSixteenthInch(), wall=3/8) {
  difference() {
    cylinder(r1=TeeRimRadius(receiver), r2=RodRadius(rod) + wall, h=1/2, $fn=30);
    #Rod(rod=rod, length=length*3, center=true);
  }
}

module Reference_Lock(barrel=barrel, receiver=receiver, rod=Spec_RodFiveSixteenthInch()) {
  for (a = [-50, 50])
  for (i = [0:2])
  rotate([a,0,0])
  translate([i + (TeeWidth(receiver)/2) + BushingExtension(breech) +1,0,])
  rotate([0,90,0])
  Receiver_Lug();
}

!scale([25.4, 25.4, 25.4])
Barrel_Lug(barrel=Spec_PipeThreeQuarterInch());

scale([25.4, 25.4, 25.4]) {
  %Reference();
  Reference_Barrel_Lug();

  #ForendRods(receiverTee=receiver, railRod=Spec_RodFiveSixteenthInch(), tee_overlap=3/8);

  translate([0,0,0])
  Reference_Lock();
}

//module Reference_Barrel(receiver, breech, barrel, barrelLength) {
//  translate([(TeeWidth(receiver)/2) + BushingHeight(breech) - BushingDepth(breech),0,0])
//  rotate([0,90,0])
//  Pipe(barrel, length=barrelLength);
//
//}
//
//module Reference_Receiver(receiver) {
//  translate([0,0,-TeeCenter(receiver)])
//  Tee(receiver);
//}
//
//module Reference_Stock(receiver, stock, stockLength) {
//  translate([-TeeWidth(receiver)/2,0,0])
//  rotate([0,-90,0])
//  Pipe(stock, length=stockLength);
//}
//
//module Reference_Butt(receiver, stockLength) {
//  translate([-stockLength,0,0])
//  rotate([0,-90,0])
//  Tee(receiver);
//}
//
//// TODO
//module Reference_Grip(receiver) {
//}
//
//// TODO
//module Reference_Forend() {
//}
//
//module Reference_Breech(receiver, breech) {
//  translate([(TeeWidth(receiver)/2) + BushingHeight(breech) - BushingDepth(breech),0,0])
//  rotate([0,-90,0])
//  Bushing(spec=breech);
//}
//
//module Reference(barrel=Spec_TubingOnePointOneTwoFive(), barrelLength=18,
//                 breech=Spec_BushingThreeQuarterInch(),
//                 receiver=Spec_TeeThreeQuarterInch(),
//                 stock=Spec_PipeThreeQuarterInch(), stockLength=12,
//                 butt=Spec_TeeThreeQuarterInch(),
//                 forend=Spec_RodFiveSixteenthInch()) {
//
//  Reference_Receiver(receiver);
//  Reference_Breech(receiver, breech);
//  Reference_Butt(receiver, stockLength);
//  Reference_Stock(receiver, stock, stockLength);
//  Reference_Barrel(receiver, breech, barrel, barrelLength);
//  Reference_Forend(forend);
//  Reference_Grip(receiver);
//}



//module Base(receiverTee=TeeThreeQuarterInch) {
//
//  tee_housing_reference(debug=true);
//
//  color("Red")
//  render()
//  translate([-1/4,-1/8,-1/16])
//  rotate([0,90,90])
//  trigger();
//
//  color("Gold")
//  translate([0,0,TeeCenter(receiverTee)])
//  rotate([0,-90,0])
//  striker();
//
//  color("HotPink")
//  translate([(TeeWidth(receiverTee)/2) - BushingDepth(breechBushing),0,TeeCenter(receiverTee)])
//  rotate([0,-90,0])
//  firing_pin_guide();
//
//  color("Green")
//  translate([-9.4,0,TeeCenter(receiverTee)])
//  rotate([0,-90,0])
//  stock_spacer(length=3.5);
//
//  translate([-4,0,TeeCenter(receiverTee)])
//  rotate([0,-90,0])
//  SpringCartridge(debug=true);
//
//  translate([-4-3,0,TeeCenter(receiverTee)])
//  rotate([0,-90,0])
//  SpringCartridge(debug=true);
//
//  color("CornflowerBlue")
//  translate([-TeeWidth(receiverTee)/2 -12,0,-1/8])
//  StrikerGuide();
//
//  // Stock
//  union() {
//
//    // Tee
//    translate([-12,0,TeeCenter(receiverTee)])
//    rotate([0,-90,0])
//    %Tee(receiverTee);
//
//    translate([(TeeWidth(receiverTee)/2) + lookup(BushingHeight, breechBushing) - lookup(BushingDepth, breechBushing),0,TeeCenter(receiverTee)])
//    rotate([0,-90,0])
//    %Bushing(spec=breechBushing);
//
//    // Stock Pipe
//    translate([-TeeWidth(receiverTee)/2,0,TeeCenter(receiverTee)])
//    rotate([0,-90,0])
//    %Pipe(stockPipe, length=12);
//  }
//}
//
//
//module Single() {
//  Base();
//
//  color("Purple")
//  translate([2,0,TeeCenter(receiverTee)])
//  rotate([0,-90,180])
//  forend_single(length=6);
//}
//
//
//module Revolver() {
//  Base();
//
//  translate([TeeWidth(receiverTee)/2 +BushingHeight(breechBushing) - BushingDepth(breechBushing)+1/8,0,1/8])
//  rotate([0,90,0]) {
//    revolver_cylinder(debug=true);
//
//    color("Red")
//    for (i=[0:6-1])
//    rotate([0,0,360/6*i])
//    translate([PipeOuterDiameter(PipeThreeQuarterInch) + revolver_cylinder_wall, 0,-1/8])
//    ShellSlug();
//  }
//
//  color("Purple")
//  render()
//  translate([6.15+1/8,0,TeeCenter(receiverTee)])
//  rotate([0,-90,0])
//  forend();
//}
//
////rotate([0,0,360*$t])
//scale([25.4, 25.4, 25.4]) {
//  Single();
//  //Revolver();
//}
