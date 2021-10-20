# 1: The "Minuteman" Receiver

![Minuteman](Preview_Minuteman.jpg)
*Figure 1: The Minuteman Receiver*

To get very technical this is a *Large Frame Receiver with a Stock*.
That's a mouthful, so I call it the
[Minuteman](https://en.wikipedia.org/wiki/Minutemen). It works with
most of the designs in the project.
There are other ways to configure the receiver,
but we'll save that for a future build.

After the receiver is assembled, first-time builders can continue on to building
a CAFE12 forend.
[Chapter 2: Choose Your Weapon](Forend/README.md) covers the different
forend configurations in detail, but for now lets focus on the receiver.

## Components
Each of the following components has its own subchapter.
Familiarize yourself with figures 1-5, this is your map. You can complete these
components in any order and assemble them all at the end.

* Large Framed Receiver
* Fire Control Group (FCG)
* Lower
* Stock

<!-- NEW PAGE -->
### Large Framed Receiver
This is "the gun" in the US. I can sell you everything **except** one of these.
It's just one marathon print - almost two days at 0.4mm or just 20h at 1.0mm.

![](Preview_Frame.jpg)
*Figure 2: Large Framed Receiver*

<!-- NEW PAGE -->
### Fire Control Group
Abbreviated "FCG" - the most involved of all the components.
Literally all the moving parts are here.

![](Preview_FCG.jpg)
*Figure 3: Fire Control Group*


<!-- NEW PAGE -->
### Lower
The grip for the gun, also holds the trigger from the FCG.

![](Preview_Lower.jpg)
*Figure 4: Lower*


<!-- NEW PAGE -->
### Stock
A spacer and buttpad for your receiver. Another of the major prints that will
benefit greatly from a large nozzle.

![](Preview_Stock.jpg)
*Figure 5: Stock*

<!-- NEW PAGE -->
## Preparing to Print

### Pick Your Colors
Two-tone is canon - that means it's official.

#### Spool 1: Base Color
We'll be using a full 1kg spool for the base color. Most of the "big" parts will
be printed with this filament.

#### Spool 2: Accent Color
The accent prints will take about 500g of plastic, or half a typical spool.
Accent parts are often smaller and bear some kind of load, so if you want to
splurge - do it here.

#### Spool 3: TPU For Your Buttpad
The buttpad was designed to be printed with "90D" TPU filament.
90D TPU is a semi-flexible filament, and takes some of the sting out of the shot
because it's rubbery. The 90D stuff will run in a stock Ender 3. Lower than 90D
is not advised as it requires printer modifications not documented here.

You may not find TPU that matches your base color, keep that in mind when you
choose your colors.
You can print the buttpad in any filament, but it may be more punishing than
necessary.

### Configure Cura and Preheat
Next we need to print the receiver parts. The STL files are located in
the Liberator12k zip file where you found this PDF or from
[Liberator12k.com](https://liberator12k.com/).

Configure Cura according to the [Printing Guidelines](Printing.md) in the
Introduction and slice each part for printing.

The models are already in the proper orientation for printing, so leave the
bottom side down.
You are free to position them on the build plate however you like.

Printing one part at a time will produce higher quality prints,
but it will take longer. You should know your machine.

<!-- NEW PAGE -->
### Minuteman Receiver Complete Print List
| Part                | Settings    | Filament | Time     | Color      |
|---------------------|-------------|----------|----------|------------|
| FCG_FiringPinCollar | 100% Infill |       1g |    0h48m | Accent     |
| FCG_Hammer          | 100% Infill |      34g |    4h37m | Accent     |
| FCG_TriggerMiddle   | 100% Infill |      11g |    1h23m | Accent     |
| FCG_Trigger         | 100% Infill |      14g |    1h55m | Accent     |
| FCG_Housing         | 100% Infill |      16g |    2h12m | Accent     |
| FCG_Disconnector    | 100% Infill |       4g |      29m | Accent     |
| FCG_HammerTail      | 100% Infill |      13g |    1h38m | Accent     |
| FCG_ChargingHandle  | Standard    |      34g |    4h07m | Accent     |
| Lower_MountRear     | Standard    |      23g |    2h21m | Accent     |
| Lower_MountFront    | Standard    |      22g |    2h09m | Accent     |
| Lower_Middle        | Standard    |      68g |    5h20m | Accent     |
| Lower_Left          | Standard    |      66g |    5h52m | Base       |
| Lower_Right         | Standard    |      66g |    5h52m | Base       |
| Frame_Receiver      | Standard    |     272g | 1d18h01m | Base       |
| Stock               | Standard    |     243g | 1d08h52m | Base       |
| Stock_Backplate     | Standard    |      95g |   12h05m | Base       |
| Stock_Buttpad       | Standard    |     181g |   19h31m | Base (TPU) |
The table below can be used as a checklist. **Print this page.**

The STL files are located in the Liberator12k.zip file's `Receiver/` directory.
For instance: `Receiver/FCG/Prints/FCG_Hammer.stl`

<br/>

 * Base Color: 663g
 * Accent Color: 319g
 * Total Printer Time: 5d12h10m

Total Printer Time - 0.4mm nozzle: 5d12h10m

#### Filament Used
| Color  | Weight | 
|--------|--------|
| Base   | 663g   |
| Accent | 319g   |

<!-- NEW PAGE -->
## Bill of Materials
Full hardware list for the Minuteman receiver.

| Purpose                     | Part                                         | Quantity | 
|-----------------------------|----------------------------------------------|----------|
| Tension Bolt                | #8-32x12 Threaded Rod                        | 4        |
| Tension Bolt Nut            | #8-32 Heatset Nut (Long)                     | 4        |
| Tension Bolt Washer         | #8-32 Washer                                 | 4        |
| Tension Bolt Acorn Nut      | #8-32 Acorn Nut                              | 4        |
| Lower Pin                   | Universal Clevis Pin 1/4x2"                  | 1        |
| Lower Pin Retaining Pin     | 6Dx2" Box Nail                               | 1        |
| Frame Bolt                  | 1/2-13x10 Hex Bolt                           | 2        |
| Frame Nut                   | 1/2-13 Hex Nut                               | 4        |
| Stock Pin                   | Universal Clevis Pin 1/4x2"                  | 1        |
| Stock Pin Retaining Pin     | 6Dx2" **Box** Nail                           | 1        |
| Stock Backplate Nut         | 1/4-20 Heatset Nut (Short)                   | 2        |
| Stock Buttpad Bolt          | 1/4-20x3-1/2" Flat Head Screw                | 2        |
| Firing Pin                  | 6Dx2" Box Nail, cut flush to 1.54" OAL       | 1        |
| Firing Pin Spring           | 0.22" OD 0.625" Long (0.02" wire)            | 1        |
| Hammer                      | 1/4-20x5" Flat Head Bolt                     | 1        |
| Hammer Bolt                 | 1/4-20x5" Flat Head Bolt                     | 1        |
| Hammer Bolt Sleeve          | 9/32"x3.5" K&S Brass Tube                    | 1        |
| Hammer Nut                  | 1/4-20" Heatset Nut (Short)                  | 1        |
| Hammer Cap Nut              | 1/4-20" Acorn Nut                            | 1        |
| Hammer Spring               | 0.052x0.625x3" ~6.3lbs/in Compression Spring | 1        |
| Recoil Plate (L12k)         | #Liberator12k Official Alloy Recoil Plate    | 1\*      |
| Recoil Plate (DIY)          | 2x2-3/8x3/8" Mild Steel Plate                | 1\*      |
| Sear                        | 1/4"x1.67" Steel Square Rod                  | 1        |
| Sear Cross-Pin              | 3/32"x1/2" Music Wire                        | 1        |
| Sear Return Spring          | 0.02" Wire, 0.25"x1.25"                      | 1        |
| Recoil Plate Center Bolts   | #8-32x1.5 SS Flat-Head Bolt                  | 2        |
| Recoil Plate Side Bolts     | #8-32x0.5 SS Flat-Head Bolt                  | 4        |
| Lower Nut                   | #8-32 Heatset Nut (Short)                    | 5        |
| Lower Bolt                  | #8-32x1.25 SS Flat-Head Bolt                 | 5        |

\* Pick one, these parts have alternates.

<!-- NEW PAGE -->
## Metric BOM
Full hardware list for the Minuteman receiver.

| Purpose                   | Part                                                 | Quantity |
|---------------------------|------------------------------------------------------|----------|
| Tension Bolt              | **DIN795** M4x305 Threaded Rod                       | 4        |
| Tension Bolt Nut          | M4 Heatset Nut (**M4xD7xL8**)                        | 4        |
| Tension Bolt Washer       | **DIN125** M4 Washer                                 | 4        |
| Tension Bolt Acorn Nut    | **DIN1587** M4 Domed Hex Cap Nut                     | 4        |
| Lower Pin                 | None                                                 | 1        |
| Lower Pin Retaining Pin   | 2.5x50mm Nail                                        | 1        |
| Frame Bolt                | **DIN931** M12x260 Hex Head Bolt                     | 2        |
| Frame Nut                 | **DIN934** M12 Hex Nut                               | 4        |
| Stock Pin                 | None                                                 | 1        |
| Stock Pin Retaining Pin   | 2.5x50mm Nail                                        | 1        |
| Stock Backplate Nut       | M6 Heatset Nut (**M6xD9.5xL6**)                      | 2        |
| Stock Buttpad Bolt        | **DIN7991** M6x90 Countersunk Bolt                   | 2        |
| Firing Pin                | 2.5x50mm Nail, , cut flush to 40mm OAL               | 1        |
| Firing Pin Spring         | 0.5mm Wire, 6mm OD, 20mm Length Spring (Cut to 16mm) | 1        |
| Hammer                    | **DIN7991** M6x130 Countersunk Bolt                  | 1        |
| Hammer Bolt               | **DIN7991** M6x130 Countersunk Bolt                  | 1        |
| Hammer Bolt Sleeve        | 6mm ID Sleeve for _Hammer Bolt_                      | 1        |
| Hammer Nut                | M6 Heatset Nut (**M6xD9.5xL6**)                      | 1        |
| Hammer Cap Nut            | **DIN1587** M6 Domed Hex Cap Nut                     | 1        |
| Hammer Spring             | 1.4mm Wire, 16mm OD, 80mm Length Spring              | 1        |
| Recoil Plate (L12k)       | None                                                 | 1\*      |
| Recoil Plate (DIY)        | 6mm Thickness 50.80x60.325mm AISI 4140 Steel Plate   | 1\*      |
| Sear                      | 6mm x 42.42mm Steel Square Rod                       | 1        |
| Sear Cross-Pin            | None                                                 | 1        |
| Sear Return Spring        | 0.5mm Wire, 6.5mm OD, 35mm Length Spring             | 1        |
| Recoil Plate Center Bolts | **DIN7991** M4x40 A2/A4 Countersunk Bolt             | 2        |
| Recoil Plate Side Bolts   | **DIN7991** M4x40 A2/A4 Countersunk Bolt             | 4        |
| Lower Nut                 | M4 Heatset Nut (**M4xD7xL5**)                        | 5        |
| Lower Bolt                | **DIN7991** M4x35 A2/A4 Countersunk Bolt             | 5        |

\* Pick one, these parts have alternates.