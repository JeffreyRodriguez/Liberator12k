// Settings: Resolution 0 = low, 1 = high
RESOLUTION = 1;
function Resolution(low, high) = RESOLUTION == 0 ? low : high;
function ResolutionFs() = Resolution(1, 0.25);
