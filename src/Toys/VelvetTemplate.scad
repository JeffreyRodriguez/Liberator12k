sideHeight = 1;
width = 2.91;
templateHeight = 0.02;

wingLength = width+(sideHeight*2);


module VelvetTemplate() {
  translate([0,sideHeight,0])
  cube([wingLength, width, templateHeight]);

  translate([sideHeight,0,0])
  cube([width, wingLength, templateHeight]);
}

scale(25.4)
VelvetTemplate();
