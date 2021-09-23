// Settings: Resolution 0 = low, 1 = high
RESOLUTION = 1;
function ResolutionIsLow() = RESOLUTION == 0;
function ResolutionIsHigh() = RESOLUTION == 1;
function Resolution(low, high) = RESOLUTION == 0 ? low : high;
function ResolutionFs() = Resolution(1, 0.25);
function ResolutionFa() = Resolution(10, 4);
