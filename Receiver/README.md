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
[Chapter 2: Forends - Choose Your Weapon](Forend/README.md) covers the different
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
The table below can be used as a checklist. **Print this page** then refer to the
sub-chapters for complete build instructions.

The STL files are located in the Liberator12k.zip file's `Receiver/` directory.
For instance: `Receiver/FCG/Prints/FCG_Hammer.stl`

| Done | Color      | Print Settings | Part                | Filament | Time     |
|:----:|:-----------|:---------------|---------------------|---------:|---------:|
| [_]  | Accent     | See Below      | FCG_FiringPinCollar |       1g |    0h48m |
| [_]  | Accent     | See Below      | FCG_Trigger         |      14g |    1h55m |
| [_]  | Accent     | See Below      | FCG_Housing         |      16g |    2h12m |
| [_]  | Accent     | See Below      | FCG_Disconnector    |       4g |      29m |
| [_]  | Accent     | See Below      | FCG_Hammer          |      34g |    4h37m |
| [_]  | Accent     | See Below      | FCG_HammerTail      |      13g |    1h38m |
| [_]  | Accent     | Standard       | FCG_TriggerMiddle   |      11g |    1h23m |
| [_]  | Accent     | Standard       | FCG_ChargingHandle  |      34g |    4h07m |
| [_]  | Accent     | Standard       | Lower_MountRear     |      23g |    2h21m |
| [_]  | Accent     | Standard       | Lower_MountFront    |      22g |    2h09m |
| [_]  | Accent     | Standard       | Lower_Middle        |      68g |    5h20m |
| [_]  | Base       | Standard       | Lower_Left          |      66g |    5h52m |
| [_]  | Base       | Standard       | Lower_Right         |      66g |    5h52m |
| [_]  | Base       | Standard       | Frame_Receiver      |     272g | 1d18h01m |
| [_]  | Base       | Standard       | Stock               |     243g | 1d08h52m |
| [_]  | Base       | Standard       | Stock_Backplate     |      95g |   12h05m |
| [_]  | TPU        | See Below      | Stock_Buttpad       |     181g |   19h31m |
|**Totals**  <td colspan=6>|
|Base Color  <td colspan=3>   | ?g |   ?d?h?m |
|Accent Color<td colspan=3> | ?g |   ?d?h?m |
<br/>

#### Standard Print Settings
Review the [Printing Guidelines](../Printing.md) from the Introduction.
Use the right accent or base color!

#### FCG Print Settings
These small FCG parts have special print settings:
* Infill: 100%
* Layer Height: 0.1mm

#### Buttpad Print Settings
I have printed Amazon-brand TPU 95 on my stock Ender 3, just select the proper
material in Cura. Be sure to **reset the material** before slicing other parts.
You can use other plastics, but TPU is softer and will absorb some recoil.

Just select *Generic TPU* for the material in Cura.
