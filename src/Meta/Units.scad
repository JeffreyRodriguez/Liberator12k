Millimeters = 1;
Inches = 2;

DEFAULT_UNITS = Inches;

function Units() = DEFAULT_UNITS;
function UnitsFs() = Units() == Millimeters ? 2 : 2/25.4;

function InchesToMillimeters(n) = n * 25.4;
function MillimetersToInches(n) = n / 25.4;

function Millimeters(n)   = Units() == Millimeters   ? n : MillimetersToInches(n);
function Inches(n) = Units() == Inches ? n : InchesToMillimeters(n);

module ScaleToMillimeters() {
  if (Units() == Inches) {
    scale(25.4)
    children();
  } else {
    children();
  }
}
