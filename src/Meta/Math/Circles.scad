function Circumference(radius) = PI * (2*radius);
function CircleArea(radius) = PI * pow(radius, 2);

function ArcLength(angle, radius=1) = angle * (PI/180) * radius;
assert(ArcLength(180) == PI);

function SegmentAngle(length, radius=1) =  (180*length) / (PI*radius);
assert(SegmentAngle(PI) == 180);
