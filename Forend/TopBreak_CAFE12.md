# 2b: CAFE12 Forend
![CAFE12 Forend Assembly](TopBreak_CAFE12/Assembly_htmldoc.jpg)

A 12ga Top Break variant based on the venerable pipe shotgun.

This version uses Schedule 40 3/4" and 1" pipe.
Read the [Chapter 2a: CAFE12+ Forend](TopBreak_CAFE12+.md) for the
better, faster, stronger 4130 tube forend.

## Partial Kit
You can still buy a Partial CAFE kit from the [\#Liberator12k store](https://liberator12k.com/store/).

It has all the nuts, bolts, and custom parts already completed for you, just no barrel.
If you want to DIY everything, see [Appendix: Top-Break Common - Machining](TopBreak_Machining.md).

<!-- NEW PAGE -->
## Prints
STL Files Location: `Forend/TopBreak_CAFE12/Prints/`

|ReceiverFront|Forend|BarrelCollar|Extractor|
|-|-|-|-|
|![](TopBreak_CAFE12/Prints/ReceiverFront_thumb.jpg)|![](TopBreak_CAFE12/Prints/Forend_thumb.jpg)|![](TopBreak_CAFE12/Prints/BarrelCollar_thumb.jpg)|![](TopBreak_CAFE12/Prints/Extractor_thumb.jpg)|

|LatchTab|Cluster|Vertical Foregrip|Sightpost|
|-|-|-|-|
|![](TopBreak_CAFE12/Prints/LatchTab_thumb.jpg)|![](TopBreak_CAFE12/Prints/Cluster_thumb.jpg)|![](TopBreak_CAFE12/Prints/VerticalForegrip_thumb.jpg)|![](TopBreak_CAFE12/Prints/Sightpost_thumb.jpg)|
<br/>

**These numbers are wrong, TODO: Redo them.** Copied from CAFE12+, ballpark accurate.

| Part              | Filament Used | Print Time @ 0.4mm |
|-------------------|-------------: |------------------: |
| ReceiverFront     | 57g           |   07h17m           |
| Forend            | 189g          | 1d01h10m           |
| BarrelCollar      | 114g          |   15h00m           |
| Extractor         | 14g           |    1h55m           |
| LatchBlock        | 114g          |   15h00m           |
| Cluster           | ?g            |   ?h?m             |
| Vertical Foregrip | ?g            |   ?h?m             |
| **Total**         | 420g          |           2d08h09m |
<br/>

## Vitamins
### Inch BOM
This build uses the [Top-Break Common BOM](TopBreak_BOM.md) in addition to the following components.

| Component                | Purpose                | Part                                 | Quantity |
|--------------------------|------------------------|--------------------------------------|----------|
| Forend/Barrel            | Trunnion Adhesive      | 2-part Epoxy                         | 1        |
| Forend/Barrel            | Trunnion Bolts         | #8-32x1/2" Socket Head Screw         | 3        |
| Forend/Barrel            | Trunnion               | 1" NPT Schedule 40 Pipe 8" Long      | 1        |
| Forend/Barrel            | Barrel                 | 3/4" NPT Schedule 40 Pipe 18.5" Long | 1        |
<br/>

### Schedule 40 Pipe
These Schedule 40 galvanized pipes are common in every single hardware store in
the United States. They'll be in the plumbing section, with a silvery finish.

#### Pipe Seam
Pipes have a seam - this is not a good thing for many reasons, but it is what it is.
You'll have to file the seam out of the 3/4" pipe near the chamber area, and out of the entire 1" pipe.

#### 1" Pipe Nipples
"Pipe nipples" - they're just short pipes threaded on both ends.
They're more expensive per foot, but they tend to be smoother on the inside and will require less filing.

### Metric BOM
TODO


<!-- NEW PAGE -->
## Post-Processing
If you purchased a kit all the machining is already done for you.

### Foregrip Cluster Heatset
Install the *Foregrip Bolt Nut* on the inside of the *Cluster*.

### Trunnion Machining
The *Trunnion* has several \#8-32 holes drilled along the top.
These holes are used to secure the *BarrelCollar* to the *Trunnion*
and the *Foregrip Cluster* to the *Trunnion* and *Barrel*.

#### DIY Fixture
**DO NOT DRILL THE BARREL**

A fixture located at `Forend/TopBreak_CAFE12/Fixtures/TrunnionFixture.stl`
can be used to help you drill and tap your own *Trunnion*.

Using a \#8-32 tap, add threads to the hole in the middle.
Use a 1.5" \#8-32 to hold the *Trunnion* in place like a set screw.
Now you're ready to drill and tap the holes.

**DO NOT DRILL THE BARREL**

Drill the holes out with a \#29 wire bit, start out very slowly so the drill bit doesn't
walk on the round surface.Be sure to clear your chips early and often, use lots of cutting fluid.

Once you've finished drilling and tapping, ensure the inside of the *Trunnion* is
clear of any chips and debris.

#### Extractor Slot Machining
File out a 1/4" wide slot in the 6-O'clock position for the extractor bit.
Aim for a 45 degree angle 1/8" deep.

File this same notch in a matching location on the barrel. This is easiest
if you wait until you've installed the *Cluster*.

#### Latch Bars Machining
Drill and tap the the *Latch Rods* 1" from the end -

### Barrel Subassembly
Install the *Barrel* into the *Trunnion*, add the *Cluster* and *Foregrip*.
The *Foregrip Bolt Nut* and *Cluster Bolts* should act as set screws to secure
the *Barrel* into the *Trunnion*.

### Barrel Collar: Extractor Subassembly
1. Insert the *Extractor Bit* into the *Extractor*.
2. Drop the *Extractor Spring* into the *Barrel Collar*'s large rectangular hole.
3. Insert the *Extractor* into the hole, and install the *Extractor Retainer* from the large round hole for the barrel.

### Barrel Collar: Latch Subassembly
1. Insert the *Latch Springs* into the small square holes in the *Barrel Collar*.
2. Insert the *Latch Bars* into the square holes in the *Barrel Collar*.
3. Ensure the *Latch Bars* slide smoothly - file the holes if necessary.
4. Insert the two rectangular tabs of the *Latch* into the underside of the *Barrel Collar
5. Depress the *Latch Bars* while you install the *Latch Screws*.
6. Lube the slots and bars.

### Forend Subassembly
1. Rotate the *Barrel Collar* up into the *Forend*.
2. Install the Barrel with the sleeve
