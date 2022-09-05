//////////////////////////////////////////////////////////////////////////////////////////////
// Public Domain Parametric Involute Spur Gear (and involute helical gear and involute rack)
// version 1.1
// by Leemon Baird, 2011, Leemon@Leemon.com
//http://www.thingiverse.com/thing:5505
//
// 2017-10-01: Optimized for speed by @zkarcher
//https://www.thingiverse.com/thing:2562847
//
// 2018-04-10: update, fix rack teeth, inner gears (with hole>gear), fix helix gears/racks using twist.
//https://www.thingiverse.com/thing:2854963
//
// This file is public domain.  Use it for any purpose, including commercial
// applications.  Attribution would be nice, but is not required.  There is
// no warranty of any kind, including its correctness, usefulness, or safety.
//
// This is parameterized involute spur (or helical) gear.  It is much simpler and less powerful than
// others on Thingiverse.  But it is public domain.  I implemented it from scratch from the
// descriptions and equations on Wikipedia and the web, using Mathematica for calculations and testing,
// and I now release it into the public domain.
//
//        http://en.wikipedia.org/wiki/Involute_gear
//        http://en.wikipedia.org/wiki/Gear
//        http://en.wikipedia.org/wiki/List_of_gear_nomenclature
//        http://gtrebaol.free.fr/doc/catia/spur_gear.html
//        http://www.cs.cmu.edu/~rapidproto/mechanisms/chpt7.html
//
// The module gear() gives an involute spur gear, with reasonable defaults for all the parameters.
// Normally, you should just choose the first 4 parameters, and let the rest be default values.
// The module gear() gives a gear in the XY plane, centered on the origin, with one tooth centered on
// the positive Y axis.  The various functions below it take the same parameters, and return various
// measurements for the gear.  The most important is pitch_radius, which tells how far apart to space
// gears that are meshing, and adendum_radius, which gives the size of the region filled by the gear.
// A gear has a "pitch circle", which is an invisible circle that cuts through the middle of each
// tooth (though not the exact center). In order for two gears to mesh, their pitch circles should
// just touch.  So the distance between their centers should be pitch_radius() for one, plus pitch_radius()
// for the other, which gives the radii of their pitch circles.
//
// In order for two gears to mesh, they must have the same mm_per_tooth and pressure_angle parameters.
// mm_per_tooth gives the number of millimeters of arc around the pitch circle covered by one tooth and one
// space between teeth.  The pitch angle controls how flat or bulged the sides of the teeth are.  Common
// values include 14.5 degrees and 20 degrees, and occasionally 25.  Though I've seen 28 recommended for
// plastic gears. Larger numbers bulge out more, giving stronger teeth, so 28 degrees is the default here.
//
// The ratio of number_of_teeth for two meshing gears gives how many times one will make a full
// revolution when the the other makes one full revolution.  If the two numbers are coprime (i.e.
// are not both divisible by the same number greater than 1), then every tooth on one gear
// will meet every tooth on the other, for more even wear.  So coprime numbers of teeth are good.
//
// The module rack() gives a rack, which is a bar with teeth.  A rack can mesh with any
// gear that has the same mm_per_tooth and pressure_angle.
//
// Some terminology:
// The outline of a gear is a smooth circle (the "pitch circle") which has mountains and valleys
// added so it is toothed.  So there is an inner circle (the "root circle") that touches the
// base of all the teeth, an outer circle that touches the tips of all the teeth,
// and the invisible pitch circle in between them.  There is also a "base circle", which can be smaller than
// all three of the others, which controls the shape of the teeth.  The side of each tooth lies on the path
// that the end of a string would follow if it were wrapped tightly around the base circle, then slowly unwound.
// That shape is an "involute", which gives this type of gear its name.
//
//////////////////////////////////////////////////////////////////////////////////////////////

//An involute spur gear, with reasonable defaults for all the parameters.
//Normally, you should just choose the first 4 parameters, and let the rest be default values.
//Meshing gears must match in mm_per_tooth, pressure_angle, and twist,
//and be separated by the sum of their pitch radii, which can be found with pitch_radius().
module gear (
    mm_per_tooth    = 3,    //this is the "circular pitch", the circumference of the pitch circle divided by the number of teeth
    number_of_teeth = 11,   //total number of teeth around the entire perimeter
    thickness       = 6,    //thickness of gear in mm
    hole_diameter   = 3,    //diameter of the hole in the center, in mm
    twist           = 0,    //helical gear angle, in degrees
    teeth_to_hide   = 0,    //number of teeth to delete to make this only a fraction of a circle
    pressure_angle  = 28,   //Controls how straight or bulged the tooth sides are. In degrees.
    clearance       = 0.0,  //gap between top of a tooth on one gear and bottom of valley on a meshing gear (in millimeters)
    backlash        = 0.0   //gap between two meshing teeth, in the direction along the circumference of the pitch circle
) {
    p = mm_per_tooth * number_of_teeth / PI / 2;  //radius of pitch circle
    c = p + mm_per_tooth / PI - clearance;        //radius of outer circle
    b = p*cos(pressure_angle);                    //radius of base circle
    r = p - mm_per_tooth / PI - clearance;        //radius of root circle
    h = hole_diameter/2;        //radius of hole gear sits on (or in, for an internal gear)
    t = mm_per_tooth/2-backlash/2;                //tooth thickness at pitch circle
    k = -iang(b, p) - t/2/p/PI*180;               //angle to where involute meets base circle on each side of tooth
    a = (twist) ? tan(twist)*thickness/(mm_per_tooth * number_of_teeth)*360 : 0; // angle of revolution from top to bottom of gear
    s = floor((twist*twist)*thickness/number_of_teeth/200)+1; //higher angle, less teeth, and taller gears need more polys
    linear_extrude(height = thickness, center = true, convexity = 10, twist = a, slices=s)
        for (i = [0:1:number_of_teeth-teeth_to_hide-1] )
            rotate([0,0,i*360/number_of_teeth+a/2])
                polygon(
                    points=[
                        polar(h, 181/number_of_teeth),
                        polar(h, 0),
                        polar(h, -181/number_of_teeth),
                        polar(r, -181/number_of_teeth),
                        polar(r, r<b ? k : -180/number_of_teeth),
                        q7(0/5,r,b,c,k, 1),q7(1/5,r,b,c,k, 1),q7(2/5,r,b,c,k, 1),q7(3/5,r,b,c,k, 1),q7(4/5,r,b,c,k, 1),q7(5/5,r,b,c,k, 1),
                        q7(5/5,r,b,c,k,-1),q7(4/5,r,b,c,k,-1),q7(3/5,r,b,c,k,-1),q7(2/5,r,b,c,k,-1),q7(1/5,r,b,c,k,-1),q7(0/5,r,b,c,k,-1),
                        polar(r, r<b ? -k : 180/number_of_teeth),
                        polar(r, 181/number_of_teeth)
                    ]
                );
};
//these 4 functions are used by gear
function polar(r,theta)   = r*[sin(theta), cos(theta)];                            //convert polar to cartesian coordinates
function iang(r1,r2)      = sqrt((r2/r1)*(r2/r1) - 1)/PI*180 - acos(r1/r2);        //unwind a string this many degrees to go from radius r1 to radius r2
function q7(f,r,b,r2,t,s) = q6(b,s,t,(1-f)*max(b,r)+f*r2);                         //radius a fraction f up the curved side of the tooth
function q6(b,s,t,d)      = polar(d,s*(iang(b,d)+t));                              //point at radius d on the involute curve

//a rack, which is a straight line with teeth (the same as a segment from a giant gear with a huge number of teeth).
//The "pitch circle" is a line along the X axis.
module rack (
    mm_per_tooth    = 3,    //this is the "circular pitch", the circumference of the pitch circle divided by the number of teeth
    number_of_teeth = 11,   //total number of teeth along the rack
    thickness       = 6,    //thickness of rack in mm (affects each tooth)
    height          = 120,   //height of rack in mm, from tooth top to far side of rack.
    twist           = 0,   //helical gear angle, in degrees
    pressure_angle  = 28,   //Controls how straight or bulged the tooth sides are. In degrees.
    backlash        = 0.0   //gap between two meshing teeth, in the direction along the circumference of the pitch circle
) {
    a = mm_per_tooth / PI; //addendum
    t = a*sin(pressure_angle);         //tooth side is tilted so top/bottom corners move this amount
    M = [ [1, 0, twist?tan(twist):0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1] ];
    multmatrix(M) // skew gear by angle of "twist"
        linear_extrude(height = thickness, center = true, convexity = 10)
            for (i = [0:1:number_of_teeth-1] )
                translate([i*mm_per_tooth,0,0])
                    polygon(
                        points=[
                            [-mm_per_tooth * 2/4,                 a-height],
                            [-mm_per_tooth * 2/4 - backlash,     -a],
                            [-mm_per_tooth * 1/4 + backlash - t, -a],
                            [-mm_per_tooth * 1/4 + backlash + t,  a],
                            [ mm_per_tooth * 1/4 - backlash - t,  a],
                            [ mm_per_tooth * 1/4 - backlash + t, -a],
                            [ mm_per_tooth * 2/4 + backlash,     -a],
                            [ mm_per_tooth * 2/4,                 a-height],
                        ],
                        paths=[[0,1,2,3,4,5,6,7]]
                    );
};

//These 5 functions let the user find the derived dimensions of the gear.
//A gear fits within a circle of radius outer_radius, and two gears should have
//their centers separated by the sum of their pictch_radius.
function circular_pitch  (mm_per_tooth=3) = mm_per_tooth;                     //tooth density expressed as "circular pitch" in millimeters
function diametral_pitch (mm_per_tooth=3) = PI / mm_per_tooth;                //tooth density expressed as "diametral pitch" in teeth per millimeter
function module_value    (mm_per_tooth=3) = mm_per_tooth / PI;                //tooth density expressed as "module" or "modulus" in millimeters
function pitch_radius    (mm_per_tooth=3,number_of_teeth=11) = mm_per_tooth * number_of_teeth / PI / 2; // middle of tooth, used for calculating gear spacing.
function outer_radius    (mm_per_tooth=3,number_of_teeth=11,clearance=0.1)    //The gear fits entirely within a cylinder of this radius.
    = pitch_radius(mm_per_tooth, number_of_teeth+0.5) + mm_per_tooth / PI - clearance;
function root_radius    (mm_per_tooth=3,number_of_teeth=11,clearance=0.1) = pitch_radius(mm_per_tooth, number_of_teeth) - mm_per_tooth / PI - clearance;

//////////////////////////////////////////////////////////////////////////////////////////////
//example gear train.
//Try it with OpenSCAD View/Animate command with 20 steps and 24 FPS.
//The gears will continue to be rotated to mesh correctly if you change the number of teeth.

n1 = 12; //red gear number of teeth
n2 = 21; //green gear
n3 = 5;  //blue gear
n4 = 20; //orange gear
n5 = 8;  //gray rack
n6 = n1+n2*2; // purple gear
mm_per_tooth = 9; //all meshing gears need the same mm_per_tooth (and the same pressure_angle/twist)
twist        = 0;
thickness    = 6;
hole         = 3;
height       = 12;

d1 =pitch_radius(mm_per_tooth,n1);
d12=pitch_radius(mm_per_tooth,n1) + pitch_radius(mm_per_tooth,n2);
d13=pitch_radius(mm_per_tooth,n1) + pitch_radius(mm_per_tooth,n3);
d14=pitch_radius(mm_per_tooth,n1) + pitch_radius(mm_per_tooth,n4);

translate([ 0,    0, 0]) rotate([0,0, $t*360/n1])                 color([1.00,0.75,0.75]) gear(mm_per_tooth,n1,thickness,hole,twist);
translate([ 0,  d12, 0]) rotate([0,0,-($t+n2/2-0*n1+1/2)*360/n2]) color([0.75,1.00,0.75]) gear(mm_per_tooth,n2,thickness,root_radius(mm_per_tooth,n2)*2-height,-twist);
*translate([ d13,  0, 0]) rotate([0,0,-($t-n3/4+n1/4+1/2)*360/n3]) color([0.75,0.75,1.00]) gear(mm_per_tooth,n3,thickness,hole,-twist);
*translate([-d14,  0, 0]) rotate([0,0,-($t-n4/4-n1/4+1/2-floor(n4/4)-3)*360/n4]) color([1.00,0.75,0.50]) gear(mm_per_tooth,n4,thickness,hole,-twist,n4-3);
*translate([(-floor(n5/2)-floor(n1/2)+$t+n1/2-1/2)*mm_per_tooth, -d1+0.0, 0]) rotate([0,0,0]) color([0.75,0.75,0.75]) rack(mm_per_tooth,n5,thickness,height,twist=-twist);
*translate([ 0,    0, 0]) rotate([0,0,-($t+0.5+n2/2)*360/n6])                 color([1.00,0.50, 1.00]) gear(mm_per_tooth,n6,thickness,outer_radius(mm_per_tooth, n6)*2+height,-twist);



use <Semicircle.scad>;
intersection() {
  gear(mm_per_tooth,72,thickness,outer_radius(mm_per_tooth, 72)*2+10,-twist);

  linear_extrude(height=height, center=true)
  semicircle(od=300, angle=45);
}
