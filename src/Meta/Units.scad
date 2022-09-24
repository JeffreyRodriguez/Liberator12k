Millimeters = 1;
Inches = 2;

DEFAULT_UNITS = Inches;

function Units() = DEFAULT_UNITS;
function UnitsFs() = Units() == Millimeters ? 2 : 2/25.4;

function InchesToMillimeters(n) = n * 25.4;
function MillimetersToInches(n) = n / 25.4;

function Millimeters(n, units=Units())   = units == Millimeters   ? n : MillimetersToInches(n);
function Inches(n, units=Units()) = units == Inches ? n : InchesToMillimeters(n);
function UnitSelect(value, units) = units == Millimeters ? Millimeters(value) : Inches(value);
function UnitType(type) = type == "Millimeters" ? Millimeters : Inches;

module ScaleToMillimeters() {
  if (Units() == Inches) {
    scale(25.4)
    children();
  } else {
    children();
  }
}
