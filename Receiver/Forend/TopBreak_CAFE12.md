# [\#Liberator12k Manual](../../README.md)

## Platform Configuration: CAFE12

### Cheap As Fuck Edition 12ga

A 12ga [Top Break](TopBreak.md) variant based on the venerable pipe shotgun.

This is the gun I set out to make when I started the project; better than a slamfire in two big ways: It has an
extractor and a trigger. Additionally, the barrel isn't a separate piece you need 3 hands to reload. Since it's built
with \#Liberator12k platform components it features:

* Optics-ready Picatinny Rail
* QD Sling
* MLOK
* Modular components
* Ambidextrous

<!-- blank line -->
<figure class="video_container">
  <video width="640" loop="true" preload="auto" controls="false" allowfullscreen="true" poster="Frame.png">
    <source src="TopBreak.mp4" type="video/mp4">
  </video>
</figure>
<!-- blank line -->

## Bill of Materials

### Printed: CAFE12 Forend

420g, 2d08h09m @ 0.4mm

| File                          | Part                   | Preset | Print Settings | Filament Used | Print Time @ 0.4mm |
|-------------------------------|------------------------|--------|----------------|---------------|--------------------|
| Receiver/Forend/TopBreak.scad | TopBreak_ReceiverFront | CAFE12 | Std. 3mm Shell | 57g           |   07h17m           |
| Receiver/Forend/TopBreak.scad | TopBreak_Forend        | CAFE12 | Std. 3mm Shell | 189g          | 1d01h10m           |
| Receiver/Forend/TopBreak.scad | TopBreak_BarrelCollar  | CAFE12 | Std. 3mm Shell | 114g          |   15h00m           |
| Receiver/Forend/TopBreak.scad | TopBreak_Extractor     | CAFE12 | Std. 3mm Shell | 14g           |    1h55m           |
| Receiver/Forend/TopBreak.scad | TopBreak_Latch         | CAFE12 | Std. 3mm Shell | 46g           |    6h47m           |

### Hardware

| Part                                       | Metric Alternative | Source | Quantity | Print Time |
|--------------------------------------------|--------------------|--------|----------|------------|
| 1" NPT Schedule 40 Galv. Pipe 8" Long      | None               | HWS    | 1        | $2         |
| 3/4" NPT Schedule 40 Galv. Pipe 18.5" Long | None               | HWS    | 1        | $2         |

### Required Components
| Part                                 | Preview                                      | 
|--------------------------------------|----------------------------------------------|
| [Frame](../Frame.md)                 | ![Frame](../Frame_thumb.png)                 | 
| [Stock](../Stock.md)                 | ![Stock](../Stock_thumb.png)                 | 
| [Lower](../Lower/Lower.md)           | ![Lower](../Lower/Lower_thumb.png)           |
| [LowerMount](../Lower/LowerMount.md) | ![LowerMount](../Lower/LowerMount_thumb.png) | 
| [Trigger](../Lower/Trigger.md)       | ![Trigger](../Lower/Trigger_thumb.png)       | 
| [FCG](../FCG.md)                     | ![FCG](../FCG_thumb.png)                     |



### Master Vitamin List

| Imperial Part                          | Metric Part                    | Quantity | Comment                                                          |
|----------------------------------------|--------------------------------|----------|------------------------------------------------------------------|
| **_Pipe_**                             |                                |          |                                                                  |
| 1" NPT Sched. 40 Galv. Pipe            | ============================== | 2        |                                                                  |
| 3/4" NPT Sched. 40 Galv. Pipe          | ============================== | 2        |                                                                  |
| **_#8-32_**                            | **_M4_**                       |          |                                                                  |
| #8-32x12 Threaded Rod                  | DIN975   M4x305                | 4        | Add to openscad M4 threaded rod                                  |
| #8-32 Washer                           | DIN125   M4                    | 4        | Check implementation of washer in openscad                       |
| #8-32 Acorn Nut                        | DIN1587  M4                    | 4        | Check openscad for M4 Acorn nut                                  |
| #8-32 SS Flat-Head Bolt                | DIN7991  M4x35 A2/A4           | 5        |                                                                  |
| #8-32 Threaded Insert                  | M4xD6xL8 Threaded Insert       | 4+5      | check if long or short                                           |
| **_1/4-20_**                           | **_M6_**                       |          |                                                                  |
| 1/4-20x3-1/2" Flat Head Screw          | DIN7991      M6x90             | 2        | Check if 90mm fits                                               |
| 1/4-20x5"     Flat Head Screw          | DIN7991      M6x130            | 1+1      | Check if 130mm fits                                              |
| 1/4-20"       Acorn Nut                | DIN1587      M6                | 1        | Check openscad for M6 Acorn nut                                  |
| 1/4-20        Heatset Nut              | M6xD9.5xL9.5 Threaded Insert   | 2+1      | check if long or short                                           |
| **_1/2-13_**                           | **_M12_**                      |          |                                                                  |
| 1/2-13x10 Hex Bolt                     | DIN931/DIN933 M12x260/M12x250  | 2        |                                                                  |
| 1/2-13 Hex Nut                         | DIN934 M12                     | 4        |                                                                  |
| **_Music Wire_**                       |                                |          |                                                                  |
| 3/32"x0.5" Music Wire                  | ?????????????????????????????? | 1+2      | Is this in openscad?                                             |
| 3/32"x0.75" Music Wire                 | ?????????????????????????????? | 2+2      | Is this in openscad?                                             |
| 3/32"x1" Music Wire                    | ?????????????????????????????? | 2        | Is this in openscad?                                             |
| 3/32"x1.5" Music Wire                  | ?????????????????????????????? | 2        | Is this in openscad?                                             |
| 0.22" OD x 2" Long Spring              | ?????????????????????????????? | 2        | Is this in openscad?                                             |
| **_Springs_**                          |                                |          |                                                                  |
| Spring 0.25"OD 0.02"WG 1.25"L          | ?????????????????????????????? | 1        |                                                                  |
| Spring 0.22"OD 0.625"L                 | ?????????????????????????????? | 1        |                                                                  |
| 0.625x3" ~6.3lbs/in Compression Spring |                                | 1        |                                                                  |
| **_Miscellaneous_**                    |                                |          |                                                                  |
| Universal Clevis Pin 1/4x2"            | M6x50? Clevis Pin              | 1        | Check if 50 is good enough? Check din for universal clevis pin   |
| 1/4"x1.67" Steel Square Rod            | ?????????????????????????????? | 1        |                                                                  |
| 6Dx2" Box Nail                         |                                | 1        |                                                                  |
| 11/64" K&S Brass Tube                  |                                | 1        |                                                                  |
| Recoil Plate (2x2-3/8x3/8" Mild Steel) |                                | 1        |                                                                  |

