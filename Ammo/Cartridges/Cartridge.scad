// Cartridge Specification
CartridgeBulletDiameterMin = 2;
CartridgeBulletDiameterMax = 3;
CartridgeNeckDiameter      = 4;
CartridgeBaseDiameter      = 5;
CartridgeRimDiameter       = 6;
CartridgeRimThickness      = 7;
CartridgeCaseLength        = 8;
CartridgeOverallLength     = 9;

function CartridgeBulletDiameterMin(spec=undef) =  lookup(CartridgeBulletDiameterMin, spec);
function CartridgeBulletDiameterMax(spec=undef) =  lookup(CartridgeBulletDiameterMax, spec);
function CartridgeNeckDiameter(spec=undef)      =  lookup(CartridgeNeckDiameter,      spec);
function CartridgeBaseDiameter(spec=undef)      =  lookup(CartridgeBaseDiameter,      spec);
function CartridgeRimDiameter(spec=undef)       =  lookup(CartridgeRimDiameter,       spec);
function CartridgeRimThickness(spec=undef)      =  lookup(CartridgeRimThickness,      spec);
function CartridgeCaseLength(spec=undef)        =  lookup(CartridgeCaseLength,        spec);
function CartridgeOverallLength(spec=undef)     =  lookup(CartridgeOverallLength,     spec);

/**************************************************
 * Cartridge Spec Template                        *
 **************************************************

// NAME
Cartridge_NAME = [
  [CartridgeBulletDiameterMin, =  00000000],
  [CartridgeBulletDiameterMax, =  00000000],
  [CartridgeNeckDiameter,      =  00000000],
  [CartridgeBaseDiameter,      =  00000000],
  [CartridgeRimDiameter,       =  00000000],
  [CartridgeRimThickness,      =  00000000],
  [CartridgeCaseLength,        =  00000000],
  [CartridgeOverallLength,     =  00000000]
];
function Spec_Cartridge_NAME() = Cartridge_NAME;

***************************************************/
