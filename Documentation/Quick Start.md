# Read it all or cry :P

Welcome to the project. There's a lot of reasons you might be here. ECM, Revolver, BARBB, E-Primers, Printed Ammo - lots going on. This document is currently mostly about making a revolver or break-action L12k.

### Chat!
There's a "liberator12k" team on [Keybase](https://keybase.io)... You'd do well to join and check in on the current state of things. For instance, you're probably on the `master` branch of this document... I'm working in `RevolverP3`. What's a *branch*? [Watch a GitHub crashcourse](https://www.youtube.com/watch?v=0fKg7e37bQE), and come chat on keybase.

### Pre-Alpha
I already told you it isn't done... But I know you want to poke around anyway.
Here's a few landmarks... enough to get you lost, and you're on your own!

If you don't know anything about Git, GitHub, or OpenSCAD you're gonna have a bad time, you're a little too early, but read-on anyway. _Please_ contribute issues and pull requests with Unlicensed code. This has been a one-man show :) Questions via issues are probably best, so I can build a FAQ.

### OpenSCAD in a Nutshell

#### WARNING
Rendering the revolver takes a *hell* of a long time the first time. Read the rest of this guide, then open the revolver forend file. Render that assembly first. Go out to dinner or a happy hour, especially if your machine is slow.

Anytime you change parameters, it'll take it's sweet-ass time to render. Ideally, just, keep OpenSCAD open. It's the worst problem of this whole project.

#### Download
You will need to download [OpenSCAD](http://www.openscad.org) to render the source as printable STLs.


#### Customizer
OpenSCAD has a "Customizer" feature you may need to enable from the View menu. I recently added support for this, and it's the only reason you have a chance at printing this right now :P

It'll show up on the right-hand side and has a few sections, depending on what file you're looking at.

Under the *What to Render* section, the *Assembly* view is selected by default - this is how I normally work with the design. The dropdown contains the individual parts; positioned for printing. Select a part to render then push F6.. or from the *Design* menu, select *Render*.

Once you've rendered a part for printing, you need to export the STL. Push F7 or File -> Export -> Export as STL. Save it with a unique filename (whatever is in the dropdown is a good name). Viola, you have an STL.

Also: 
You'll notice some of the design is parameterized, like bolts, barrel diameter, and clearances. This doesn't work everywhere, but it's a start.


### Printing basics
I use ABS almost exclusively, MOST of it can be printed in PLA just fine. A few parts that weld onto the receiver tube must be ABS.

It's designed to work with a 1.5mm nozzle. If you weren't aware, bigger nozzles print *way in the hell faster*. It's worth your time to swap out, just for these prints, you won't want to go back.

3mm thick walls and 30% infill

### Three Waypoints

You need all the printable parts in each of these files.

#### Universal Receiver

**[Receiver.scad](../Receiver/Receiver.scad)**
The following parts must all be ABS/ASA/PC.
* ReceiverCoupling
* ReceiverLugCenter
* ReceiverLugFront
* ReceiverLugRear
* ButtstockTab

Any material:
* Buttstock
* ReceiverBack - under development

The default receiver tube is 1-1/2" COEX ABS DWV pipe from Home Depot.
Cut a section 12-15" long for the receiver. Use 3/4" PVC for the hammer spacer.

Speaking of the hammer... that's in the middle of some changes, so good luck :P

**[Lower.scad](../Receiver/Lower/Lower.scad)**
* LowerRight
* LowerMiddle
* LowerLeft
* TriggerRight
* TriggerMiddle
* TriggerLeft

#### Forend
As mentioned, the L12k is a platform... and supports interchangeable forends all on the same receiver.

Pretty much all of these are works in progress or something I've tried... None of them are guaranteed to work, and some of them might even hurt you if you naively print one out... especially the pump AR.

**[Revolver.scad](../Receiver/Forend/Revolver.scad)**
Parts list is in flux, but generally:
* RevolverCylinder
* ReceiverFront
* FrameSpacer
* Foregrip (broken)

**[Top Break.scad](../Receiver/Forend/Top%20Break.scad)**
* ReceiverFront
* ReceiverForend
* BarrelCollar
* Extractor
* Latch
* Foregrip


##### Bill of Materials
This is incomplete and a work-in-progress. Most of this is available at Home Depot, Lowes, or Ace. Otherwise Amazon or McMaster.

If you're outside the US look for:
* 4mm taps/nuts/bolts instead of #8-32
* 6mm taps/nuts/bolts instead of 1/4-20
* 12mm taps/nuts/bolts instead of 1/2-13
* 7mm square rod instead of 1/4"
* 8mm round rod instead of 5/16"

###### US-Based Shopping List
* 1/4" mild steel square rod, the 36" long sticks. You'll cut these down to under 12"
* #8-32 spiral point or flute taps (Amazon) YG-1 is a good brand.  Spiral Point is preferred.
* 1/2"-13 hex bolts, 10" long and hex nuts to match. At least a pair of each.
* 1-1/2" COEX ABS DWV Pipe (10ft or 2ft length)
* 3/4" Schedule 40 steel pipe (Galvanized is ideal)
* 3/4" Schedule 40 PVC pipe (
* 1" Schedule 40 steel pipe nipple, 8-12" long.
* Epoxy - JB Weld or similar.
* #8-32x1/4" Socket Head Bolts
* #8-32x1/2" Flat Head Bolts
* 1/4-20x2" Flat Head Bolts (2pcs)
