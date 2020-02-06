### Pre-Alpha
I already told you it isn't done... But I know you want to poke around anyway.
Here's a few landmarks... enough to get you lost - and you're on your own!

If you don't know anything about OpenSCAD or Git, you're gonna have a bad time.

If you do know what you're doing:
Please contribute issues and pull requests with Unlicensed code.
This has been a one-man show :)

Questions via issues are probably best, so I can build a FAQ.

### OpenSCAD in a Nutshell

#### WARNING
Rendering the revolver takes a *hell* of a long time the first time. Read the rest of this guide, then open the revolver forend file. Render that assembly first. Go out to dinner or a happy hour, especially if your machine is slow.

Anytime you change parameters, it'll take it's sweet ass time to render.

#### Download

You will need to download [OpenSCAD](http://www.openscad.org) to open the files and render them as printable STLs.


#### Customizer
OpenSCAD has a "Customizer" feature you may need to enable from the View menu. I recently added support for this, and it's the only reason you have a chance at printing this right now :P

It'll show up on the right-hand side and has a few sections, depending on what file you're looking at.

Under the *What to Render* section, the *Assembly* view is selected by default - this is how I normally work with the design. The dropdown contains the individual parts; positioned for printing. Select a part to render then push F6.. or from the *Design* menu, select *Render*.

Once you've rendered a part for printing, you need to export the STL. Push F7 or File -> Export -> Export as STL. Save it with a unique filename (whatever is in the dropdown is a good name). Viola, you have an STL.

Also: 
You'll notice some of the design is parameterized, like bolts, barrel diameter, and clearances. This doesn't work everywhere, but it's a start.


### Printing basics
I use ABS almost exclusively, MOST of it can be printed in PLA just fine. A few parts that weld onto the receiver tube must be ABS.

### Three Waypoints

You need all the printable parts in each of these files.

Let me recommend:
* Lots of 1/4" mild steel square rod
* a few 8-32 spiral taps
* 1/2"-13 bolts, 10" long and nuts to match.

#### Universal Receiver

##### Receiver Tube
[Receiver.scad](../Receiver/Receiver.scad) can render all the receiver parts

The coupling and buttstock tab must be printed in ABS, Polycarbonate, or some
other weld-compatible material.

The default receiver tube is 1-1/2" COEX ABS DWV pipe from Home Depot.
Cut a section 12-15" long for the receiver. Use 3/4" PVC for the hammer spacer.

Speaking of the hammer... that's in the middle of some changes, so good luck :P

##### Lower
[Lower.scad](../Receiver/Lower/Lower.scad)

#### Forend
As mentioned, the L12k is a platform... and supports interchangeable forends all on the same receiver.

Pretty much all of these are works in progress or something I've tried... None of them are guaranteed to work, and some of them might even hurt you if you naively print one out... especially the pump AR.

[Revolver.scad](../Receiver/Forend/Revolver.scad)

[Top Break.scad](../Receiver/Forend/Top%20Break.scad)

