Welcome to #Liberator12k project!
=================================
Everyone's Favorite 3D Printed Shotgun.

DANGER: ART AT YOUR OWN RISK
----------------------------
Beware, this software can literally kill you and others.
This isn't one of those bullshit government-mandated warnings. If you blow your
hand or face off, I'm going to get very choked up - there could be tears.

Safety precautions and procedures *are not fully documented here*.

### Minimum Safety Standard
Before you shoot a DIY gun from your hands, test it first. You will need:

* A secure test rig to hold the gun pointed in a **safe direction**.
* A bulletproof barrier, such as several feet of dirt or very large tree.
* A string long enough to pull the trigger from behind cover.
* At least 5 of the highest pressure cartridges you can find.

Quick Start
----------
You will need to download [OpenSCAD](http://www.openscad.org) to open the files
and render them printable.

This project contains more than one gun design; check out the "Configurations"
directory for details. Start Here: [\#Liberator12k Shotgun Configuration](Configurations/Liberator12k/README.md)


Tech Levels
-----------
The original \#Liberator12k project goal was to design a safe and
functional shotgun from readily available parts, assembled with hand tools
and no drilling. I broke this no-drill rule twice - when safety *demanded* it;
I created drill-guides to aid in proper hole placement.

That original goal forbids many designs that are still very achievable for
anyone with a few power tools. As the project continues to grow, I will be
targeting advancing "tech levels", with a strong focus on simplicity and cost.

Tech Level One assumes you have the tools of Tech Level Zero.
A "Plus" tech level describes the 'better than minimal' tools for that level.

| Tech Level | Tools                                                           |
|------------|-----------------------------------------------------------------|
| Zero       | Metal Hacksaw, Metal Files,  Drill (hand or power), Hex wrenches|
| Zero Plus  | Cutoff Wheel, Bench Grinder, Drill Press, Bolt Cutters          |
| One        | 12v power supply (battery, charger, 3D printer, or lab supply)  |
| One Plus   | Lab power supply                                                |


Designing New Guns
---------------
The real "secret sauce" of this project, is the software library I developed
during the design process of these guns. I tried a lot of different ideas,
and what I came away with, is an OpenSCAD software library chock-full of
useful *configurable* objects.

If you browse through the code, you'll see the project has been grouped into
major functional areas:

  * Tooling - Printable tools for gun making
  * Vitamins - Store-bought parts, nut and bolts, etc.
  * Lower - Grip with a simple trigger.
  * Upper - Different uppers that work with the lower (maybe).
  * Ammo - Printable Ammunition
  * Meta - 3D modeling-specific code
  * Toys - Things I've tried and thrown away (maybe)

There are more directories than mentioned above, but this should give you a taste of what's in here.

Unlicense
=======
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to [unlicense.org](http://unlicense.org/)
