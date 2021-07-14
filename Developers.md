# [\#Liberator12k Manual](README.md)
## Developers

If you're running Linux/Mac and have `make` available, there's a Makefile to do it all. Otherwise, you'll have to render the individual STLs.

This doc also explains how to customize the designs to fit the materials you
have on hand or to change things like gauge or caliber completely.

### Download
[OpenSCAD](http://www.openscad.org) is required to render printable STLs.

You will also need the complete source code ZIP for the project, if you're reading this you should have a copy already. If not, download the source from [the website](https://Liberator12k.com).

### How to render STLs from OpenSCAD
OpenSCAD has a "Customizer" pane which can be enabled from the View menu. Only
very advanced users and developers need to touch the source code - everything
else can be done with the customizer panel:

![Customizer](.manual/customizer.png)

Some of the designs have other presets, like the break-action:

![Customizer Preset](.manual/customizer_preset.png)

#### Print
![Customizer Print Section](.manual/customizer_print.png)

1. Choose the part you want and push F6 to render it, or from the *Design* menu, select *Render*.
2. Once you've rendered a part for printing, you need to export the STL.
3. Push F7 or *File* -> *Export* -> *Export as STL*.
4. Save it with a unique filename based on the part name.stl

For instance:
 * ReceiverFront.stl
 * ReceiverForend.stl
 * BarrelCollar.stl
 * Extractor.stl
 * Latch.stl
 * Foregrip.stl

#### Assembly
![Customizer Assembly Section](.manual/customizer_assembly.png)

When you preview (F5), you will see the complete assembly of all the related parts.
This section lets you show/hide parts, cutaway parts, and control transparency.

#### Vitamins
![Customizer Vitamins Section](.manual/customizer_vitamins.png)

Customize the nuts, bolts, tubes, rods, etc used to render the model. This is a
great way to customize a design to your own uses/materials.

#### Fine Tuning
![Customizer Fine Tuning Section](.manual/customizer_fine_tuning.png)

Allows customizing some of the parameters of a model. Useful for customizing.

#### Branding
![Customizer Branding Section](.manual/customizer_branding.png)

Control the branding text by model.
