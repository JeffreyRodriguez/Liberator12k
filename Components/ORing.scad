use <TeardropTorus.scad>;

module ORing(innerDiameter=3/4, section=1/8, clearance=0.005, $fn=20) {
    hull()
    TeardropTorus(majorRadius=innerDiameter/2,
                  minorRadius=(section/2)+clearance);
}


ORing();