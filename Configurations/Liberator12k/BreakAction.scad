include <../../Meta/Animation.scad>;

use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Lower.scad>;

use <../../Upper/Cross/Reference.scad>;
use <../../Upper/Cross/Cross Upper.scad>;
use <../../Upper/Cross/Forend/Forend.scad>;
use <../../Upper/Cross/Forend/Forend Slotted.scad>;
use <../../Upper/Cross/Forend/Single/Pivot/Forend Pivoted.scad>;

use <Base.scad>;

module Liberator12k_BreakAction(barrelLength=18, alpha=1) {
  ForendPivotedAssembly();
}

Liberator12k_Base(lowerLeft=false, lowerRight=false);
Liberator12k_Stock(alpha=0.1);
Liberator12k_CoupledFrame(length=PivotedForendFrameLength(), couplerAlpha=0.5);

//Liberator12k_PlainFrame(length=9.85);

Liberator12k_BreakAction();