module CylinderTextSweep(t="Liberator12k.com", r=1, letterSpacingFactor=.1, scalingFactor=10,
                         depth=0.025, sweep=90, offsetZ=0,
                         center=true, centerZ=true,
                         font="Liberation Mono") {
    letterCount  = len(t);
    
    circumference = (2*r)*PI;
    circSweep = circumference * (sweep/360);
    letterArc = sweep/letterCount;
    letterSegment = circSweep/letterCount;
    letterSpacing=letterSegment*letterSpacingFactor;
    size = letterSegment-letterSpacing;
                    
                           
                           
    letterWidth  = size;
    letterHeight = 1.13 * letterWidth;


    render()
    rotate([0,0,(letterArc/2) - (center ? sweep/2 : 0)])
    // For each letter
    for (i = [0:letterCount]) {
      translate([0,0,centerZ ? 0 : (letterWidth/2)])
      translate([0,0,offsetZ])
      difference() {

        // Text
        rotate([0,0,i*letterArc])
        rotate([90,0,0])
        scale(1/scalingFactor) // We zoomed the letter, zoom back out to normal size

        // Extrude the letter from origin to the edge of the circle
        // Scale up by 10x as we go
        linear_extrude(height=(r*scalingFactor)+depth,
                       scale=(r+depth)*scalingFactor,
                       slices=2)

        // Center the letter at origin
        translate([-(letterWidth/2),-(letterHeight/2),0])
        text(t[i], font = font, spacing=letterSpacing, size=size);

        // Cut out the core of the cylinder
        cylinder(r=r-depth, h=letterHeight*2, center=true);
      }
    }
}

$fn=20;
difference() {
  %cylinder(r=1, h=2);
  CylinderTextSweep("Liberator12k.com", r=1, offsetZ=1,    sweep=270, centerZ=true);
  *CylinderTextSweep("#Liberator12k",    r=1, offsetZ=0.25, sweep=270, centerZ=false);
}
