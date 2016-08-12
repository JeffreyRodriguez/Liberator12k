include <Cartridge.scad>

// 12 Gauge, 3"
function Spec_Cartridge_12GAx3() = [
  [CartridgeBulletDiameterMin, 0.780],
  [CartridgeBulletDiameterMax, 0.780],
  [CartridgeNeckDiameter,      0.780],
  [CartridgeBaseDiameter,      0.780],
  [CartridgeRimDiameter,       0.870],
  [CartridgeRimThickness,      0.070],
  [CartridgeCaseLength,        2.970],
  [CartridgeOverallLength,     3.000]
];

cartridge=Spec_Cartridge_12GAx3();
echo("Loaded Spec: Cartridge_12GAx3", cartridge);
