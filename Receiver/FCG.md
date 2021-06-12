# [\#Liberator12k Manual](../README.md)
## Platform Components: Fire Control Group (FCG)

![Fire Control Group](FCG.png)

A fire control group for fixed recoil plate designs.

The FCG is designed to support slamfire via the optional disconnector.

A linear hammer strikes the firing pin, which protrudes through the recoil plate.

Works with the standard lower and trigger, receiver, and frame.

## Bill of Materials

### Printed: Fire Control Group
XXXXg, 0h00m

| File                | Part                | Print Settings   | Filament Used | Print Time |
|---------------------|---------------------|------------------|---------------|------------|
| Receiver/FCG.scad   | FCG_ChargingHandle  | Std. 3mm Shell   | -mm           | -h-m       |
| Receiver/FCG.scad   | FCG_Disconnector    | Std. 3mm Shell   | -mm           | -h-m       |
| Receiver/FCG.scad   | FCG_FiringPinCollar | Solid, Low, Slow | 1g            | 0h48m      |
| Receiver/FCG.scad   | FCG_Housing         | Std. 3mm Shell   | -mm           | -h-m       |
| Receiver/FCG.scad   | FCG_Hammer          | Solid            | -mm           | -h-m       |
| Receiver/FCG.scad   | FCG_HammerTail      | Std. 3mm Shell   | -mm           | -h-m       |

### Hardware

|Purpose| Part | Quantity |
|-|-|-|
|Stock Latch Pin| 3/32"x0.5" Music Wire|2|
|Stock Latch Pivot Pin| 3/32"x0.75" Music Wire |2|
|Firing Pin| 6Dx2" Box Nail |1|
|Firing Pin Spring| 0.22" OD 0.625" Long |1|
|Hammer| 1/4-20x5" Flat Head Bolt |1|
|Hammer Bolt| 1/4-20x5" Flat Head Bolt |1|
|Hammer Bolt Sleeve| 11/32" K&S Brass Tube |1|
|Hammer Nut| 1/4-20" Heatset Nut|1|
|Hammer Cap Nut| 1/4-20" Acorn Nut|1|
|Hammer Spring| 0.625x3" ~6.3lbs/in Compression Spring|1|
|Recoil Plate (L12k)| #Liberator12k Official Alloy Recoil Plate|1 (alt)|
|Recoil Plate (DIY)| 2x2-3/8x3/8" Mild Steel Plate|1 (alt)|

## Assembly
The *FCG Housing*, *Firing Pin Subassembly*, and *Recoil Plate* are all installed in a specific forend's *Receiver Front*.

#### Required Tools
* 2.5mm Reamer or Drill Bit
* Superglue

For a DIY recoil plate:
* Drill Press
* #8-32 Tap
* \#29 Drill Bit
* 5/16" Drill Bit
* 2.5mm Drill Bit

#### Hammer Subassembly
Install the 1/4-20" heatset nut into the rear of the hammer (the portion with the large pocket) and wait to cool.

Install the hammer bolt and slip the hammer bolt sleeve over the extended portion.
Add the hammer spring, hammer tail. Finally, install the hammer cap nut with threadlocker.

#### Firing Pin Subassembly
Prepare the firing pin by cutting the 6D box nail to 1.535" in length. Cut generously, file flush and gently round the outer edge of the end. Sand smooth with 220 grit or finer.

Ream the firing pin collar hole to 2.5mm and install into the firing pin collar from the rear, the flared portion is forward.

Install the firing pin spring into the flared portion of the firing pin collar.

#### Charging Handle
Install the \#8-32 heatset nut into the charging handle and allow to cool.

Before installing the \#8-32x1/4" Socket Cap Screw, chuck it up in a drill and file/sand the side of the bolt cap smooth. Then install the bolt into the charging handle from the underside.

#### Recoil Plate
If you haven't purchased a recoil plate from the Liberator12k.com store, you'll
have to make your own from 2x3/8" mild bar stock - you can find this at Home Depot, Ace, and Lowes in addition to metals suppliers.

The full How To is incomplete, but at a high level:

1. Print a Recoil Plate template (TODO).
2. Mark the holes with a punch and drill to specified size.
3. Tap the holes for the tension rods and FCG Housing holes with #8-32.