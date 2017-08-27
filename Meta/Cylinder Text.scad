module CylinderTextSweep(t="Liberator12k.com", r=1, letterSpacing=1/25.4/2,
                         depth=0.025, sweep=90, offsetZ=0,
                         center=true, centerZ=true) {
    letterHeight = 0.9528;
    letterWidth  = 0.8314;
    letterCount  = len(t);

    circumference = (2*r)*PI;
    circSweep = circumference * (sweep/360);
    letterArc = sweep/letterCount;
    size = (circSweep/letterCount)+letterSpacing;

    render()
    rotate([0,0,(letterArc/2) - (center ? sweep/2 : 0)])
    // For each letter
    for (i = [0:letterCount]) {
      translate([0,0,centerZ ? 0 : (size*letterWidth/2)])
      translate([0,0,offsetZ])
      difference() {

        // Text
        rotate([0,0,i*letterArc])
        rotate([90,0,0])
        scale(1/10) // We zoomed the letter, zoom back out to normal size

        // Extrude the letter from origin to the edge of the circle
        // Scale up by 10x as we go
        linear_extrude(height=(r+depth)*10, scale=(r+depth)*10)

        // Center the letter at origin
        translate([-(size*letterWidth/2),-(size*letterHeight/2),0])
        text(t[i], font = "Liberation Mono", spacing=letterSpacing, size=size);

        // Cut out the core of the cylinder
        cylinder(r=r-depth, height=size, center=true);
      }
    }
}

$fn=20;
difference() {
  cylinder(r=1, h=2);
  CylinderTextSweep("Liberator12k.com", r=1, offsetZ=1,    sweep=270, centerZ=true);
  CylinderTextSweep("#Liberator12k",    r=1, offsetZ=0.25, sweep=270, centerZ=false);
}
