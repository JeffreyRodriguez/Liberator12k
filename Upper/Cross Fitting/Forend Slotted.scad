use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Manifold.scad>;
use <../../Components/Semicircle.scad>;

use <../../Vitamins/Double Shaft Collar.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Reference.scad>;

use <../../Lower/Trigger.scad>;
use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Lower.scad>;

use <../../Ammo/Cartridges/Cartridge.scad>;
use <../../Ammo/Cartridges/Cartridge_12GA.scad>;

use <Frame.scad>;
use <Cross Upper.scad>;
use <Forend.scad>;

function ForendSlottedLength() = 3;
function ForendUnslottedLength() = 0.25;

module ForendSlotter(cartridgeSpec=Spec_Cartridge_12GAx3(), length=1, slotAngles=[0]) {

  semiAngle=60;

  render()
  difference() {
    children();

    for(slotAngle = slotAngles)
    rotate([slotAngle,0,0]) {
      translate([-ManifoldGap(),-CartridgeRimRadius(cartridgeSpec)-0.05,0])
      cube([length+ManifoldGap(2), CartridgeRimDiameter(cartridgeSpec)+0.1, 2]);

      rotate([0,90,0])
      translate([0,0,-ManifoldGap()])
      linear_extrude(height=length+ManifoldGap(2))
      rotate(-180+(semiAngle/2))
      semidonut(major=4, minor=CartridgeRimDiameter(cartridgeSpec), angle=semiAngle);
    }
  }
}

module ForendSlotted(cartridgeSpec=Spec_Cartridge_12GAx3(), slotAngles=[0,180]) {
  translate([LowerMaxX(),0,0])
  ForendSlotter(length=ForendSlottedLength(), slotAngles=slotAngles)
  Forend(length=ForendSlottedLength());
}


Reference();

Frame();

UpperReceiverFront();
UpperReceiverBack();

translate([0,0,-ReceiverCenter()]) {
  Lower(showTrigger=true);
}

ForendSlotted();
ForendBaseplate();


!scale(25.4)
rotate([0,90,0])
translate([-LowerMaxX()-ForendSlottedLength(),0,0])
ForendSlotted();
