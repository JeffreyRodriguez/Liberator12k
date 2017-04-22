//$t=0.7267;
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

Liberator12k_Base();
//color("Silver", 0.1)
Liberator12k_Stock();
Liberator12k_BreakAction();
//color("Silver", 0.25)
Liberator12k_CoupledFrame(length=6.5);
//Liberator12k_PlainFrame(length=9.55);
