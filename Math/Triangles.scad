// Pythagorean Theorem
function pyth_A_B(a,b) = sqrt(pow(a, 2) + pow(b, 2));
function pyth_A_C(a,c) = sqrt(pow(c, 2) - pow(a, 2));
function pyth_B_C(b,c) = sqrt(pow(c, 2) - pow(b, 2));

// Heron's Formula for Triangle Area
function heron_triangle_area(a,b,c) = sqrt(
    ((a+b+c)/2)
    * (((a+b+c)/2) - a)
    * (((a+b+c)/2) - b)
    * (((a+b+c)/2) - c)
  );

function heron_triangle_height(a,b,c) = 2 * heron_triangle_area(a,b,c) / c;
