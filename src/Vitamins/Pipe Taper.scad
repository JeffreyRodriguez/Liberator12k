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
function taperNPT_L2(nominalPipeSize, tpi) = (0.8*nominalPipeSize + 6.8)*(1/tpi);

//NPT's Pitch diameter at end of pipe
function taperNPT_E0(nominalPipeSize, tpi) =
	nominalPipeSize - (0.05*nominalPipeSize + 1.1)*(1/tpi);

//NPT's Pitch diameter at large end of internal thread
function taperNPT_E1(E0, L1) = E0 + 0.0625*L1;

module taperNPT(specName, L1 = 0) {
	spec = NPT_Spec(specName);
	assert(spec != undef, concat("Could not find NPT spec: ", specName));
	
	nominalPipeSize = NPT_NominalSize(spec);
	tpi = NPT_ThreadsPerInch(spec);
	
	taperNPT_(nominalPipeSize, tpi, L1);
}

module taperNPT_(nominalPipeSize, tpi, L1 = 0) {
	if(L1 == 0)
	cylinder(taperNPT_L2(nominalPipeSize, tpi),
	         taperNPT_E1(taperNPT_E0(nominalPipeSize, tpi), taperNPT_L2(nominalPipeSize, tpi))/2,
	         taperNPT_E0(nominalPipeSize, tpi)/2);
	else
	cylinder(taperNPT_L2(nominalPipeSize, tpi),
	         taperNPT_E1(taperNPT_E0(nominalPipeSize, tpi), L1)/2,
	         taperNPT_E0(nominalPipeSize, tpi)/2);
}

// Size Name: [Nominal Size (decimal), Threads Per Inch]
NPT_SPECS = [
	["1/16", [1/16, 27]],
	["1/8", [1/8, 27]],
	["1/4", [1/4, 18]],
	["3/8", [3/8, 18]],
	["1/2", [1/2, 14]],
	["3/4", [3/4, 14]],
	["1", [1, 11.5]],
	["1 1/4", [1+(1/4), 11.5]],
	["1 1/2", [1+(1/2), 11.5]],
	["2", [2, 11.5]]
];

function NPT_Spec(sizeString) = slookup(sizeString, NPT_SPECS);
function NPT_NominalSize(spec) = spec[0];
function NPT_ThreadsPerInch(spec) = spec[1];

taperNPT(_NPT_SIZE, _NPT_L1);