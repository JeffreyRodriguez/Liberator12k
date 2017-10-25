use <../../../Meta/Resolution.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;

use <ECM Boring Cap Female NPT.scad>;

//Spec_RodOneQuarterInch(),
//Spec_RodOneHalfInch(),
//Spec_RodThreeQuarterInch(),
//Spec_RodOnePointZeroInch(),
//Spec_RodOnePointOneTwoFiveInch()

module ECM_QuickCap(pipeSpec, rodSpec) {
  scale(25.4)
  ECM_BoringCap_FemaleNPT(
      pipeDiameter=PipeOuterDiameter(pipeSpec, undef),
      rodDiameter=RodDiameter(rodSpec, undef),
      $fn=PipeFn(pipeSpec));
}

!ECM_QuickCap(Spec_TubingZeroPointSevenFive(),Spec_RodThreeSixteenthInch());
ECM_QuickCap(Spec_TubingOnePointOneTwoFive(),Spec_RodThreeSixteenthInch());
ECM_QuickCap(Spec_TubingOnePointSixTwoEight(),Spec_RodThreeQuarterInch());
