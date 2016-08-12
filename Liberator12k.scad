use <Components/Debug.scad>;

//include <Components.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Angle Stock.scad>;

use <Reference.scad>;
use <Frame.scad>;
use <Tee Housing.scad>;

use <Forend Tube.scad>;
//use <Forend Box.scad>;
//use <Forend Slotted.scad>;
//use <Forend Revolver.scad>;

use <Trigger.scad>;
use <Trigger Guard.scad>;
use <Striker.scad>;
use <Firing Pin Guide.scad>;

//echo($vpr);

//$vpr = [80, 0, 360*$t];


module Liberator12k() {

  //color("White", 0.2)
  Reference(hollow=true);

  Forend(debug=true);
  
  TeeHousingFront();
  TeeHousingBack();

  Grip(showTrigger=true);

  FiringPinGuide(debug=true);

  color("Grey")
  Frame();
}

//rotate([0,0,360*$t])
//scale([25.4, 25.4, 25.4])
{
  Liberator12k();
}
