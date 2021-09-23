/* Small Arms Cycle of Operation
1. Chambering - Placing the cartridge in the chamber.
2. Locking - Securing the bolt in place behind the cartridge
3. Firing - Squeezing the trigger so the firing pin will fire the cartridge.
4. Unlocking - Freeing the bolt from the barrel.
5. Extraction - Withdrawing the empty case
6. Ejection - Throw out the empty case
7. Cocking - Prepare the firing mechanism to fire again.
8. Feeding - Placing the next round in position for chambering
*/

// wip
/*
ANIMATION_STEP_UNSAFE        = 0;
ANIMATION_STEP_TRIGGER       = 1;
ANIMATION_STEP_STRIKER       = 2;
ANIMATION_STEP_FIRE          = 3;
ANIMATION_STEP_CHARGE        = 4;
ANIMATION_STEP_CHARGER_RESET = 6;
ANIMATION_STEP_UNLOCK        = 7;
ANIMATION_STEP_UNLOAD        = 8;
ANIMATION_STEP_EXTRACT       = 9;
ANIMATION_STEP_LOAD          = 10;
ANIMATION_STEP_LOCK          = 11;
ANIMATION_STEP_SAFE          = 12;

ANIMATION_STEPS = [
                   ANIMATION_STEP_UNSAFE,
                   ANIMATION_STEP_TRIGGER,
                   ANIMATION_STEP_STRIKER,
                   ANIMATION_STEP_FIRE,
                   ANIMATION_STEP_CHARGE,
                   ANIMATION_STEP_CHARGER_RESET,
                   ANIMATION_STEP_UNLOCK,
                   ANIMATION_STEP_UNLOAD,
                   ANIMATION_STEP_EXTRACT,
                   ANIMATION_STEP_LOAD,
                   ANIMATION_STEP_LOCK,
                   ANIMATION_STEP_SAFE
                   ];
*/


ANIMATION_STEP_TRIGGER       = 0;
ANIMATION_STEP_FIRE          = 1;
ANIMATION_STEP_CHARGE        = 2;
ANIMATION_STEP_CHARGER_RESET = 3;
ANIMATION_STEP_UNLOCK        = 4;
ANIMATION_STEP_UNLOAD        = 5;
ANIMATION_STEP_EXTRACT       = 6;
ANIMATION_STEP_LOAD          = 7;
ANIMATION_STEP_LOCK          = 8;

ANIMATION_STEPS = [
                   ANIMATION_STEP_TRIGGER,
                   ANIMATION_STEP_FIRE,
                   ANIMATION_STEP_CHARGE,
                   ANIMATION_STEP_CHARGER_RESET,
                   ANIMATION_STEP_UNLOCK,
                   ANIMATION_STEP_UNLOAD,
                   ANIMATION_STEP_EXTRACT,
                   ANIMATION_STEP_LOAD,
                   ANIMATION_STEP_LOCK
                   ];
function AnimationStepCount() = len(ANIMATION_STEPS);
function AnimationStepTime() = 1/AnimationStepCount();
function AnimationStep(t)    = ANIMATION_STEPS[floor(t / AnimationStepTime())];
function AnimationStepStart(step) = AnimationStepTime()*step;
function AnimationStepEnd(step) = (AnimationStepTime()*step)+AnimationStepTime();

function Animate(step, T=$t)       = step == AnimationStep(T)
                             ? (T/AnimationStepTime())-step
                             : (step < AnimationStep(T) ? 1 : 0);

/* The max function here serves to keep the value at zero before the start time. By subtracting the 'start' parameter
 * from the Animate(step) output, the value will be negative if the start time hasn't been reached. Therefore 0 will be
 * the max value.
 *
 * The value is then scaled to the reduced step time in the second multiplication operand.
 */
function SubAnimateStart(step, start=0) = max(0, (Animate(step)-start))*(1/(1-start));

/** The min function serves to keep the value at 1 when it exceeds 1 on the second value to min.
 * The second value to min
 */
function SubAnimateEnd(step, end=1) = min(1, (1-end+Animate(step)));

function SubAnimate(step, start=0, end=1) = min(1, max(0, (Animate(step)-start))*(1/(end-start)));

//echo("AnimationDebug(ANIMATION_STEP_CHARGE, start=0.25, end=0.75)", AnimationDebug(ANIMATION_STEP_CHARGE, start=0.25, end=0.75));

//$t = AnimationDebug(ANIMATION_STEP_CHARGE);
//$t = AnimationDebug(ANIMATION_STEP_CHARGE, start=0.25, end=0.75);
/* Debug an animation step.
 * Scale the animation step time to the full time range.
 *
 * Example: $t = AnimationDebug(ANIMATION_STEP_CHARGE);
 */
//function AnimationDebug(step, start=0, end=1) = AnimationStepStart(step)+(AnimationStepTime()*$t);
function AnimationDebug(step, start=0, end=1, T=$t) = AnimationStepStart(step)
                                                    + (AnimationStepTime()*(start+(end-start)*T));

// TODO: Add END support to subanimate, first stab:
//function SubAnimate(step, start=0, end=1) = max(0, (Animate(step)-start))*(1/(1-start));

//echo("AnimationStepStart(ANIMATION_STEP_CHARGE):", AnimationStepStart(ANIMATION_STEP_CHARGE));
//echo("AnimationStepEnd(ANIMATION_STEP_CHARGE):", AnimationStepEnd(ANIMATION_STEP_CHARGE));
//echo("SubAnimateStart(ANIMATION_STEP_CHARGE, start=0.25):", SubAnimateStart(ANIMATION_STEP_CHARGE, start=0.25));
//echo("SubAnimateEnd(ANIMATION_STEP_CHARGE, end=0.75):", SubAnimateEnd(ANIMATION_STEP_CHARGE, end=0.75));
//echo("SubAnimate(ANIMATION_STEP_CHARGE, start=0.25, end=0.75)",SubAnimate(ANIMATION_STEP_CHARGE, start=0.25, end=0.75));


// General animation debug info
echo("AnimationStep($t):", AnimationStep($t));
echo("Animate(AnimationStep($t)):", Animate(AnimationStep($t)));

// Debug-level logging, show the value of each animation step.
*for (i = [0 : AnimationStepCount() -1])
echo("Animate ", i, ":", Animate(i));

module AnimateSpin(revolutions=1) {
  rotate([0,0,360*revolutions*$t])
  children();
}
