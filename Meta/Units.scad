UnitsMetric = 1;
UnitsImperial = 2;

DEFAULT_UNITS = UnitsImperial;

function Units() = DEFAULT_UNITS;
function UnitsFs() = Units() == UnitsMetric ? 2 : 2/25.4;

function UnitsImperialToMetric(n) = n * 25.4;
function UnitsMetricToImperial(n) = n / 25.4;

function UnitsMetric(n)   = Units() == UnitsMetric   ? n : UnitsMetricToImperial(n);
function UnitsImperial(n) = Units() == UnitsImperial ? n : UnitsImperialToMetric(n);
