// Constants
RESOLUTION_LOW = 0;
RESOLUTION_HIGH = 1;

// Setting
RESOLUTION = RESOLUTION_HIGH;

// Utility functions
function ResolutionIsLow() = RESOLUTION == RESOLUTION_LOW;
function ResolutionIsHigh() = RESOLUTION == RESOLUTION_HIGH;
function Resolution(low, high) = ResolutionIsLow() ? low : high;
function ResolutionFs() = Resolution(1, 0.25);
function ResolutionFa() = Resolution(10, 4);
