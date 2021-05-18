# [\#Liberator12k Manual](README.md)
## About

Self-defense is an individual imperative and weapons are the means of self-defense.
The guns are real. They work. You can make them yourself.

* Please do not hurt people who've done you no harm.
* Please do not damage or take stuff from other people.
* Please do be responsible when shooting.
* Please do use for self-defense, sport, and fun.

## Modularity Weapons Platform
One receiver, multiple forends. A driving force in \#Liberator12k weapon design is reuse of the same receiver.

Similar to the AR15 modular lower/upper concept, the L12k is conceptually split into receiver/forend.

The real "secret sauce" of this project, is the software library I developed
during the design process of these guns. I tried a lot of different ideas,
and what I came away with, is an OpenSCAD software library chock-full of
useful *configurable* objects.

If you browse through the code, you'll see the project has been grouped into
major functional areas:

  * Ammo - Printable Ammunition
  * Documentation - All sorts of docs; including barrel wall calculator.
  * Meta - 3D modeling-specific code
  * Receiver - Lower+Universal Receiver; interchangeable Forends
  * Tooling - Printable tools for gun making
  * Vitamins - Store-bought parts, nut and bolts, collars, etc.
  * Toys - Things I've tried and thrown away (maybe)

There are more directories than mentioned above, but this should give you a taste of what's in here.

#### Simplicity and Availability
Firearm operating mechanisms should be simple to understand and produce by
people with minimal tools and access to materials.

Ideally materials should be available from a brick and mortar hardware, grocery, and garden stores in cash. Home Depot, Ace, Tractor Supply, Lowes, Walmart, etc.

These stores do not carry alloy steel tubing suitable for pistol and rifle barrels. At best, Ace Hardware carries Grade 8 bolts which have excellent potential for
pistol barrels. Lots of quality metal is available on Amazon, Aliexpress, McMaster, Grainger, eBay, and OnlineMetals.

A printer and power drill are the only tools absolutely required. Drill bits and taps notwithstanding. A drill press will *greatly* simplify some processes.

## DIY Tooling
The project took on a tooling aspect when Electrochemical Machining (ECM) entered the picture.

## Tech Levels
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
