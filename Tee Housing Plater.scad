use <Tee Housing.scad>;
use <Reference.scad>;

PLATE_TEE_HOUSING_FRONT=true;
PLATE_TEE_HOUSING_BACK=true;

scale([25.4, 25.4, 25.4]) {
  if (PLATE_TEE_HOUSING_FRONT)
  translate([2,0,(TeeWidth(ReceiverTee())/2)+WallFrameFront()])
  rotate([0,90,0])
  front_tee_housing();

  if (PLATE_TEE_HOUSING_BACK)
  translate([-2,0,(TeeWidth(ReceiverTee())/2)+WallFrameBack()])
  rotate([0,-90,0])
  back_tee_housing();
}


