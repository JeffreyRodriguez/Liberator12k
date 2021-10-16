# Introduction

Welcome to the \#Liberator12k project.

This manual contains all the documentation for the weapons, ammunition,
and tools in the project. The first few chapters are a build guide: starting
with the Minuteman receiver then a CAFE12 break-action 12ga forend.
This is a good starting point - a simple, safe, affordable firearm.

The Minuteman receiver is reusable in several other configurations similar
to how you might swap AR15 uppers.

### Supporting the Project
This has been an ambitious one-man operation from the start.
The project has cost tens of thousands of dollars and years of my time.
Now we have a modular weapons platform, ammunition, and a suite of ECM tooling.
I dedicate it to the public domain to secure self-defense for everyone, forever.

I didn't start this to get rich, but I wouldn't mind help.
Research and Development (R&D) doesn't pay the bills, it only comes with them.
Making new guns and ECM machines full-time is the dream - so if you want to show
your appreciation and help continue this work there are a few ways you can help.

### Liberator12k.com Store
The [Liberator12k.com Store](https://liberator12k.com/store/) has complete
hardware kits. The hardware can be sourced and fabricated yourself if you have
the equipment.

I'm asking the community to support the project by buying directly, or from
official vendors - check the website.
It's all public domain, so I'm counting on you to do the "encouraging".

Manufacturing is not my field and my time would be better spent in R&D.
Contact me via email [jeff@liberator12k.com](mailto:jeff@liberator12k.com)
for vendor royalty agreements.

### Donations
The [Donation page](https://liberator12k.com/donate.html) on the website
has info on how to donate with crypto and more.

I also have a [Patreon](https://patreon.com/liberator12k).

### Code Contributions
The first code contributions were received June 2021, after the Alpha release.
We were able to get the Metric version of the CAFE12 setup as a result.
Code contributions are priceless, they just need to be public domain/Unlicensed.
Bug reports and improvement requests on GitHub are also a great way to help
out if you're not comfortable in OpenSCAD/Bash/Web.

### Thank YOU
Prints are the greatest encouragement of all.

I also love [likes, shares, and comments](https://liberator12k.com/social.html)
and even hatred - if you're a hater.
It's fun doing this, but it's also nice to know other people appreciate it.
Thank you so much for joining me on this journey.

### Join the Community
Chat with me and other builders! 
**\#liberator12k:matrix.org** on [Element](https://element.io)

### International Builders
This is a US-based operation. I won't knowingly ship internationally or to a
forwarder either, sorry!

There's a metric version but it's less well documented and the STLs
are not included in the release. You can render them, but it's a bit manual.

Join the chat, there's other builders around the world who can help out.

<!-- NEW PAGE -->
## How to Laugh at Danger
How do you laugh at danger? From behind a solid barrier - don't be stupid.
Everyone's a tough guy until they take a piece of shrapnel to the beanbag.

### Make at Your Own Risk
Any experienced printer can complete this build if they buy a kit from the
[Liberator12k.com Store](https://liberator12k.com/store/).
I have done my best to make sure the designs included here are safe to the user
and bystanders, but ultimately you're the one building your own gun at your own
risk.

##### WARNING
Pre-release designs *may not be safe*.
Use extreme caution and two doses of common sense.

### Bystander Care
It's one thing if you hurt yourself, it's another if you hurt someone else.
The revolver will eject dangerous shot/wadding from the gap.
Keep bystanders behind your back and maintain a safe "180 degree" line or
I'll shake *their* hand for kicking your ass, because you were warned.

### Basic Firearms Safety
 1. All guns are always loaded. 
 2. Never point the gun at anything you are not willing to destroy.
 3. Keep your finger off the trigger until your sights are on target and you have made the decision to shoot.
 4. Be sure of your target and what is beyond it.

### DIY Safety
DIY guns require special precautions and procedures that
*are not fully documented here*.

* Use a secure test rig to hold the gun pointed in a **safe direction**.
* Stand behind a bulletproof barrier, such as several feet of dirt, concrete blocks, or very large tree.
* Ensure there is no direct path from the gun to anyone or anything of value.
* Use a long string to pull the trigger from behind cover.
* Test with at least 5 of the highest pressure cartridges you can find.

### Gut Check
The power to create weapons and project lethal force hundreds of yards
is now in your hands, use it responsibly.

<!-- NEW PAGE -->
## Tools and Equipment
You can print and assemble an official kit with a couple wrenches and a
butane torch.

Reaming holes in the prints is recommended. A drill bit will work, but reamers
are a lot better. The cheap Chinese ones from Amazon are fine, buy a whole set.

### "Close Enough"
All the parts are inch-standard (or all-metric), but there are "close enough"
metric equivalents that are readily available even if you live in the US.

Sometimes it's easier and *much* cheaper to find certain parts in metric, that's
especially true for little stainless pins.
3/32" is just under 2.5mm, and a \#39 drill bit is just over 2.5mm.

### You Can DIY Everything
You can fabricate all the required parts yourself - the documentation, jigs, and
templates are included in the project files.

If you intend to DIY everything, you'll need more tools.
There's not a lot of "machining" required - a couple tapped holes in flat plate
and square rods. A cold saw or metal band saw are ideal for cutting the tubing
and rods to size.
If you're using Schedule 40 pipe, a pipe cutter is just the ticket.

I would strongly recommend a drill press if you're doing it all by yourself, but
you *could get by* with some printed fixtures, jigs, and templates.
A CNC waterjet/laser/plasma/mill will make life a lot easier later on, but with
elbow grease and determination all things are possible.

Some designs may require more advanced tooling, see that specific documentation
for more details. Notably, the revolver needs a lathe and TIG.

#### This Is Spiral Tap
Those bulk pack taps are called "hand taps" and they suck. If you scrap a part
with a broken tap, you're already worse off than if you'd just bought a good tap
in the first place.

Spend a few bucks on a Spiral Point or Spiral Flute tap.
I like spiral point, myself. You only need one, but buy two just in case.

<!-- NEW PAGE -->
### Metric and/or Inch
In general, here's how things go between inch and mm in this project:

| Purpose       | Inch    | Metric |
|---------------|---------|--------|
| Small Pins    | 3/32"   | 2.5mm  |
| Medium Pins   | 1/4"    | 6mm    |
| Small Screws  | \#8-32  | M4     |
| Medium Screws | 1/4"-20 | M6     |
| Large Screws  | 1/2"-13 | 12mm   |
| Square Rods   | 1/4"    | 6mm    |
<br/>

### Drill Bits
 * 5/16"
 * \#29
 * \#39 or 2.5mm

### Reamers
 * 11/64" - \#8-32 Clearance
 * 1/4"
 * 5/16"
 * 1/2"
 * \#39 or 2.5mm
 
### Taps
 * \#8-32

<!-- NEW PAGE -->
## How to Read the Manual
Complete assemblies are built from several reusable components.
Each component in this manual has its own fabrication instructions.
The component sub-chapters all follow the same pattern.

### Preview
The component previewed in the assembly position. Refer to the figures depicting
the complete assembly to orient yourself.

### Description
A brief description of the component and its purpose.

### Prints List
A table of parts to be printed. Includes the part name and a thumbnail view of
the model in its print orientation.

### Hardware List
A table of hardware required to complete the assembly.

### Preparation
Any preparation steps for the component. Reminders and tips before you print.

### Post-Processing
Details on how to finish the prints, hardware installation instructions, and any
notes on sub-assemblies.

### Technical Notes
Explains why certain decisions were made, what's important to consider when
building or before altering the component.

May discuss alternate hardware.
