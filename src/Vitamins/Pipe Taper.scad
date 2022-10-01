use <../Meta/Resolution.scad>;
use <../Meta/slookup.scad>;
use <../Meta/Units.scad>;

/* [Taper Preview] */
_NPT_SIZE = "1/8"; // ["1/16", "1/8", "1/4", "3/8", "1/2", "3/4", "1", "1 1/4", "1 1/2", "2"]
_NPT_L1 = 0;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

// ****************
// * NPT Formulae *
// ****************

//NPT's effective thread length
function taperNPT_L2(outsideDiameter, tpi) = (0.8*outsideDiameter + 6.8)*(1/tpi);

//NPT's Pitch diameter at end of pipe
function taperNPT_E0(outsideDiameter, tpi) =
	outsideDiameter - (0.05*outsideDiameter + 1.1)*(1/tpi);

//NPT's Pitch diameter at large end of internal thread
function taperNPT_E1(E0, L1) = E0 + 0.0625*L1;

module taperNPT(specName, L1 = 0) {
	spec = NPT_Spec(specName);
	assert(spec != undef, concat("Could not find NPT spec: ", specName));
	
	outsideDiameter = NPT_OD(spec);
	tpi = NPT_ThreadsPerInch(spec);
	L1 = NPT_L1(spec);
	
	taperNPT_(outsideDiameter, tpi, L1);
}

module taperNPT_(outsideDiameter, tpi, L1 = 0) {
	if(L1 == 0)
	cylinder(taperNPT_L2(outsideDiameter, tpi),
	         taperNPT_E1(taperNPT_E0(outsideDiameter, tpi), taperNPT_L2(outsideDiameter, tpi))/2,
	         taperNPT_E0(outsideDiameter, tpi)/2);
	else
	cylinder(taperNPT_L2(outsideDiameter, tpi),
	         taperNPT_E1(taperNPT_E0(outsideDiameter, tpi), L1)/2,
	         taperNPT_E0(outsideDiameter, tpi)/2);
}

// Size Name: [Nominal Size (decimal), Threads Per Inch, OD, L1]
NPT_SPECS = [
	["1/16", [1/16, 27, 0.3125, 0.160]],
	["1/8", [1/8, 27, 0.405, 0.1615]],
	["1/4", [1/4, 18, 0.540, 0.2278]],
	["3/8", [3/8, 18, 0.675, 0.240]],
	["1/2", [1/2, 14, 0.840, 0.320]],
	["3/4", [3/4, 14, 1.050, 0.339]],
	["1", [1, 11.5, 1.315, 0.400]],
	["1 1/4", [1+(1/4), 11.5, 1.660, 0.420]],
	["1 1/2", [1+(1/2), 11.5, 1.900, 0.420]], //I _triple_ checked, it _is_ the same L1 as 1 1/4
	["2", [2, 11.5, 2.375, 0.436]]
];

function NPT_Spec(sizeString) = slookup(sizeString, NPT_SPECS);
function NPT_NominalSize(spec) = spec[0];
function NPT_ThreadsPerInch(spec) = spec[1];
function NPT_OD(spec) = spec[2]; //This applies to more than just NPT
function NPT_L1(spec) = spec[3];

taperNPT(_NPT_SIZE, _NPT_L1);