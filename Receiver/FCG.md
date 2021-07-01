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

| Purpose               | Part                                                 | Metric Alternative                                   | Quantity |
|-----------------------|------------------------------------------------------|------------------------------------------------------|----------|
| Stock Latch Pin       | 3/32"x0.5" Music Wire                                | None                                                 | 2        |
| Stock Latch Pivot Pin | 3/32"x0.75" Music Wire                               | None                                                 | 2        |
| Firing Pin            | 6Dx2" Box Nail                                       | 2.5x50mm Nail                                        | 1        |
| Firing Pin Spring     | 0.22" OD 0.625" Long (0.02" wire)                    | 0.5mm Wire, 6mm OD, 20mm Length Spring (Cut to 16mm) | 1        |
| Hammer                | 1/4-20x5" Flat Head Bolt                             | **DIN7991** M6x130 Countersunk Bolt                  | 1        |
| Hammer Bolt           | 1/4-20x5" Flat Head Bolt                             | **DIN7991** M6x130 Countersunk Bolt                  | 1        |
| Hammer Bolt Sleeve    | 11/32" K&S Brass Tube (1/4" ID)                      | 6mm ID Sleeve for _Hammer Bolt_                      | 1        |
| Hammer Nut            | 1/4-20" Heatset Nut (Short)                          | M6 Heatset Nut (**M6xD9.5xL6**)                      | 1        |
| Hammer Cap Nut        | 1/4-20" Acorn Nut                                    | **DIN1587** M6 Domed Hex Cap Nut                     | 1        |
| Hammer Spring         | 0.625x3" ~6.3lbs/in Compression Spring (0.052" wire) | 1.4mm Wire, 16mm OD, 80mm Length Spring              | 1        |
| Recoil Plate (L12k)   | #Liberator12k Official Alloy Recoil Plate            | None                                                 | 1 (alt)  |
| Recoil Plate (DIY)    | 2x2-3/8x3/8" Mild Steel Plate                        | 10mm Thickness 50.80x60.325mm Mild Steel Plate       | 1 (alt)  |

## Assembly

The *FCG Housing*, *Firing Pin Subassembly*, and *Recoil Plate* are all installed in a specific forend's *Receiver
Front*.

#### Required Tools

* 2.5mm Reamer or Drill Bit
* Superglue

For a DIY recoil plate:

| Item             | Metric Alternative |
|------------------|--------------------|
| Drill Press      | None               |
| #8-32 Tap        | M4 Tap             |
| #29 Drill Bit    | 3.5mm Drill Bit    |
| 5/16" Drill Bit  | 8mm Drill Bit      |
| 2.5mm Drill Bit  | None               |

#### Hammer Subassembly

Install the 1/4-20" heatset nut into the rear of the hammer (the portion with the large pocket) and wait to cool.

Install the hammer bolt and slip the hammer bolt sleeve over the extended portion. Add the hammer spring, hammer tail.
Finally, install the hammer cap nut with threadlocker.

#### Firing Pin Subassembly

Prepare the firing pin by cutting the 6D box nail to 1.535" in length. Cut generously, file flush and gently round the
outer edge of the end. Sand smooth with 220 grit or finer.

Ream the firing pin collar hole to 2.5mm and install into the firing pin collar from the rear, the flared portion is
forward.

Install the firing pin spring into the flared portion of the firing pin collar.

#### Charging Handle

Install the \#8-32 heatset nut into the charging handle and allow to cool.

Before installing the \#8-32x1/4" Socket Cap Screw, chuck it up in a drill and file/sand the side of the bolt cap
smooth. Then install the bolt into the charging handle from the underside.

#### Recoil Plate

If you haven't purchased a recoil plate from the Liberator12k.com store, you'll have to make your own from 2x3/8" mild
bar stock - you can find this at Home Depot, Ace, and Lowes in addition to metals suppliers.

The full How To is incomplete, but at a high level:

1. Print a Recoil Plate template (TODO).
2. Mark the holes with a punch and drill to specified size.
3. Tap the holes for the tension rods and FCG Housing holes with #8-32.

### Technical Notes and Alternatives

##### Recoil Plate
2" wide (fits between the frame bolts)
and 2.375" high - this covers the tension rods and provides room for the revolver spindle pin.

3/8" thick

That's for mild steel
If you're getting it cut out of 4130, go ahead and use the 1/4"
0.25" :)

Really, even mild .25 would probably do at this point.
It was bowing slightly in the middle, mostly because it's fairly unsupported there
ABS didn't mind, PLA did
So I widened it to 2" to put the corners of the plate over the tension rods

Yeah.. any decent steel will give exactly zero fucks


10mm thick parameter The requirements for that job are pretty minimal.
But it's the most important job in the whole gun

##### Firing Pin
When the hammer is in the full forward position, the back of the *Firing Pin*
will be flush with the back of the *FCG Housing*, meaning anything beyond 1.5"
will stick out of front of the recoil plate.

However... nails have a pointed tip - and you have to cut that off..
plus a little deformed metal rear of the tip. So plan for some loss.
A bare minimum of, 40mm worth of nail to work with.

The nail is intended to be glued into the collar, and the collar is indexed with
wide flats, so it can't rotate - making it rimfire-friendly.

##### Hammer Spring
There's some flexibility here. "If it fits, I sits." >5/16" ID and < 5/8" OD.

You shouldn't need a stupid strong spring - 10lb is probably too much,
but it shouldn't ever be an issue for the FCG. The hammer tail would probably 
fail first, or the charging handle bolt. If you can't charge it by hand, it's
too strong.

##### Trigger Pull
The coefficient of friction for oiled steel/steel is ~0.16, the trigger has a
mechanical advantage of 1.5. Give or take, trigger pull is 10% of hammer spring.

Plastic-on-plastic friction probably contributes much more to trigger pull than
the hammer spring does.