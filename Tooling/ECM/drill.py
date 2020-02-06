#!/usr/bin/env python

depth=60
resolution=100
burnUnits=20
flushUnits=40
pumpLowPower=50
pumpHighPower=255

print("G90 # Absolute Coordinates")
print("M83 # Extruder Relative Coordinates")


print("# Begin Cutting")

for X in range(0,depth*resolution):
    # Position Cutter
    print('G0 X{}'.format(float(X)/resolution))

    # Pumps: Low
    print("M106 S{}".format(pumpLowPower))

    # Enable burn
    print("M42 S255")

    # Rotate workpiece while we burn
    print('G0 E{}'.format(burnUnits))

    # Disable burn
    print("M43")

    # Pumps: High
    print("M106 S{}".format(pumpHighPower))

    # Turn and flush
    print('G0 E{}'.format(flushUnits))

    if (X % resolution == 0):
        # Show position
        print('M114');


