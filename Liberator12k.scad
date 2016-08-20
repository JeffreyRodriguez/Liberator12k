use <Components/Debug.scad>;

use <Vitamins/Pipe.scad>;

use <Reference.scad>;
use <Frame.scad>;
use <Tee Housing.scad>;

use <Forend Tube.scad>;
//use <Forend Box.scad>;
//use <Forend Slotted.scad>;
//use <Forend Revolver.scad>;

use <Trigger.scad>;
use <Trigger Guard.scad>;
use <Sear Guide.scad>;
use <Striker.scad>;
use <Charger.scad>;
use <Firing Pin Guide.scad>;

//echo($vpr);

//$vpr = [80, 0, 360*$t];


module Liberator12k() {

  Forend(debug=true);
  
  TeeHousingFront();
  
  TeeHousingBack();
  
  Charger(showRetainer=false);

  Grip(showLeft=false);
  
  Striker();

  FiringPinGuide(debug=true);
  
  SearGuide();


  color("Grey")
  Frame();

  color("Black", 0.25)
  Reference(hollow=true);
}

//rotate([0,0,360*$t])
//scale([25.4, 25.4, 25.4])
{
  Liberator12k();
}
