include <Cartridge.scad>

// .22LR
Cartridge_22LR = [
  [CartridgeBulletDiameterMin, 0.2255],
  [CartridgeBulletDiameterMax, 0.223],
  [CartridgeNeckDiameter,      0.226],
  [CartridgeBaseDiameter,      0.226],
  [CartridgeRimDiameter,       0.278],
  [CartridgeRimThickness,      0.043],
  [CartridgeCaseLength,        0.613],
  [CartridgeOverallLength,     1.000]
];

function Spec_Cartridge_22LR() = Cartridge_22LR;

cartridge=Spec_Cartridge_22LR();
echo("Loaded Spec: Cartridge_22LR", cartridge);
