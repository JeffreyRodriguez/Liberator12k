use <../../../Meta/slookup.scad>;

function ChamberSpec(name) = slookup(name, CHAMBERS);

/*************************
 * Spec Lookup Functions *
 *************************/
function ChamberLength(profile) = profile[len(profile)-1][0];
function ChamberBoreDiameter(profile) = profile[len(profile)-2][1];
function ChamberBoreRadius(profile) = ChamberBoreDiameter(profile)/2;

function ChamberBaseDiameter(profile) = profile[1][1];
function ChamberBaseRadius(profile) = ChamberBaseDiameter(profile)/2;

/******************
 * Chamber Shapes *
 ******************/
module Chamber(profile) {
	rotate_extrude()
	rotate(90)
	scale([1,0.5])
	polygon(profile);
}

module ChamberProfile(profile, height, center=true) {
  rotate([0,-90,0])
  linear_extrude(height, center=center)
  scale([1,0.5])
  polygon(profile);
}

/*****************
 * Chamber Specs *
 *****************

SAMMI_Chamber_CARTRIDGE = [
 [0,0],
 ...
 [OFFSET FROM BREECH FACE, DIAMETER],
 ...
 [BORE DIAMETER, 0]
];
*/

SAAMI_Chamber_300_AAC_Blackout = [
	[0.000,  0.000 ],
	[0.000,  0.3804],
	[0.200,  0.3769],
	[0.800,  0.3630],
	[1.0664, 0.3618],
	[1.0789, 0.3512],
	[1.0956, 0.3370],
	[1.3780, 0.3350],
	[1.3910, 0.3090],
	[1.5650, 0.3090],
	[1.7368, 0.300 ],
	[1.7368, 0.000 ]
];

/**************
 * Spec Index *
 **************/
CHAMBERS = [
  ["300 AAC Blackout", SAAMI_Chamber_300_AAC_Blackout]
];
