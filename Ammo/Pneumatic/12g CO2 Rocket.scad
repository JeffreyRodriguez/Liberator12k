use <../Ammo/Shell Slug.scad>;
use <../Ammo/Fins.scad>;
include <../Ammo/Primer.scad>;
include <../Vitamins/Pipe.scad>;

cartridgeDiameter = 19.8; //18.7;
cartridgeLength = 83;
cartridgeNeck = 12;
cartridgeMouth = 6;
cartridgeMouthDiameter = 8;
wall=2;

// 12 gram CO2 cartridge mouth and neck
Primer12gCO2 = [
  [PrimerRimDiameter,   0.31],
  [PrimerRimHeight,     0.27],
  [PrimerHeight,        0.4],
  [PrimerMajorDiameter, 0.31],
  [PrimerMinorDiameter, 0.778],
  [PrimerClearance,     0],
  [PrimerFn,            24]
];


pg12_fin_reference_height = 100;
pg12_fin_reference_twist = 360;

p12g_chamber = PipeOneInch;
p12g_primer = Primer12gCO2;
p12g_fin_width = PipeInnerDiameter(p12g_chamber)*25.4*.4;
p12g_wall_gap = ((PipeInnerDiameter(p12g_chamber)*25.4) - cartridgeDiameter)/2;

module CO2Cartridge(primer=Primer12gCO2, radius=cartridgeDiameter/2, length=cartridgeLength, invert=true) {
  translate([0,0,invert ? length : 0])
  mirror([0,0,invert ? 1 : 0])
  union() {
    
    // Cartridge body
    translate([0,0,PrimerOAHeight(primer=primer)*25.4+2.5])
    cylinder(r=radius, h=length-PrimerOAHeight(primer=primer)*25.4, $fn=24);
    
    scale([25.4, 25.4, 25.4])
    Primer(primer=primer);
  }
}
*!CO2Cartridge();

module P12G_Fins(count=2, chamber=p12g_chamber, fin_width=p12g_fin_width,
                 fin_height=100, twist=360,
                 clearance=0, slices=200) {
  Fins(count=count, twist=twist, slices=slices,
       major=PipeInnerRadius(chamber)*25.4, minor=0,
       width=fin_width+clearance, height=fin_height - 4);
}

module P12G_Base(chamber=p12g_chamber, primer=Primer12gCO2,
                 fin_width=p12g_fin_width+1, fin_twist=pg12_fin_reference_twist, fin_height=pg12_fin_reference_height,
                 rimHeight=0.1, height=(cartridgeMouth+cartridgeNeck), cutaway=false) {
  difference() {
    scale([25.4, 25.4, 25.4])
    ShellBase(chamber=PipeOneInch, primer=primer,
              rimHeight=0.1, rimDiameter=PipeOuterDiameter(PipeOneInch),
    chargeHeight=0, wadHeight=height/25.4);
    
    // Cartridge
    translate([0,0,(PrimerOAHeight(primer=primer) * 25.4)+2.5])
    cylinder(r=cartridgeDiameter/2, h=cartridgeLength, $fn=24);
    
    // Fins
    translate([0,0,6.54])
    #P12G_Fins(clearance=100);
    
    // Debugging companion cube
    if (cutaway)
    translate([-30,0,-0.1])
    cube([30,30,30]);
  }
}

module P12G_Body(chamber=p12g_chamber, primer=Primer12gCO2,  wall_factor=0.6,
                 fin_width=p12g_fin_width,
                 fin_twist=pg12_fin_reference_twist, fin_height=pg12_fin_reference_height,
                 fin_extension=(PrimerOAHeight(primer=p12g_primer)*25.4)+9) {

  difference() {
    union() {
      P12G_Fins();
      
      // Cylinder body shell
      translate([0,0,0])
      cylinder(r=(cartridgeDiameter/2) + (p12g_wall_gap*wall_factor), h=fin_height-fin_extension);
    }
    
    //translate([0,0,-1])
    //#cylinder(r=(cartridgeDiameter/2), h=fin_height+2);
    translate([0,0,-0.001])
    CO2Cartridge(primer=primer);
  }
}

module P12G_Cap(chamber=p12g_chamber, cutaway=false) {
  //mirror([0,0,1])
  difference() {
    
    *cylinder(r=PipeInnerRadius(pipe=chamber, clearance=PipeClearanceLoose)*25.4,
             h=cartridgeDiameter*1.5, $fn=PipeFn(PipeOneInch));
    
    translate([0,0,-cartridgeNeck])
    union() {
      // Cylinder Body
      cylinder(r=cartridgeDiameter/2, h=cartridgeLength-cartridgeNeck+0.2);
      
      // Cylinder Ball
      translate([0,0,cartridgeLength-cartridgeNeck])
      sphere(r=cartridgeDiameter/2);
    }
  }
}


P12G_Base();

translate([0,0,2.541+pg12_fin_reference_height])
rotate([180,0,90])
//translate([30,30])
difference() {
  P12G_Body();
  
  // Time-saving companion cube
  #cube([30,30,80], center=true);
}

*!P12G_Cap();