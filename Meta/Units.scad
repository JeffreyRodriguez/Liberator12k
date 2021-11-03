Millimeters = 1;
Inches = 2;

DEFAULT_UNITS = Inches;

function Units() = DEFAULT_UNITS;
function UnitsFs() = Units() == Millimeters ? 2 : 2/25.4;

function InchesToMetric(n) = n * 25.4;
function MillimetersToImperial(n) = n / 25.4;

function Millimeters(n)   = Units() == Millimeters   ? n : MillimetersToImperial(n);
function Inches(n) = Units() == Inches ? n : InchesToMetric(n);
