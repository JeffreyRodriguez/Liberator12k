// wip

ANIMATION_STEP_UNSAFE        = 0;
ANIMATION_STEP_TRIGGER       = 1;
ANIMATION_STEP_STRIKER       = 2;
ANIMATION_STEP_FIRE          = 3;
ANIMATION_STEP_CHARGE        = 4;
ANIMATION_STEP_TRIGGER_RESET = 5;
ANIMATION_STEP_CHARGER_RESET = 6;
ANIMATION_STEP_UNLOCK        = 7;
ANIMATION_STEP_UNLOAD        = 8;
ANIMATION_STEP_EXTRACT       = 9;
ANIMATION_STEP_LOAD          = 10;
ANIMATION_STEP_LOCK          = 11;
ANIMATION_STEP_SAFE          = 12;

ANIMATION_STEPS = [ANIMATION_STEP_UNSAFE,
                   ANIMATION_STEP_TRIGGER,
                   ANIMATION_STEP_STRIKER,
                   ANIMATION_STEP_FIRE,
                   ANIMATION_STEP_CHARGE,
                   ANIMATION_STEP_TRIGGER_RESET,
                   ANIMATION_STEP_CHARGER_RESET,
                   ANIMATION_STEP_UNLOCK,
                   ANIMATION_STEP_UNLOAD,
                   ANIMATION_STEP_EXTRACT,
                   ANIMATION_STEP_LOAD,
                   ANIMATION_STEP_LOCK,
                   ANIMATION_STEP_SAFE];

function AnimationStepCount() = len(ANIMATION_STEPS);
function AnimationStepTime() = 1/AnimationStepCount();
function AnimationStep(t)    = ANIMATION_STEPS[floor(t / AnimationStepTime())];
function Animate(step)       = step == AnimationStep($t) ? ($t/AnimationStepTime())-step : (step < AnimationStep($t) ? 1 : 0);
function SubAnimate(step, start=0) = max(0, (Animate(step)-start))*(1/(1-start)); // Last known good


// TODO: Add END support to subanimate, first stab:
//function SubAnimate(step, end=1) = min(1, (Animate(step)+end))/(1/(1+end));
//function SubAnimate(step, start=0, end=1) = max(0, (Animate(step)-start))*(1/(1-start));

echo("AnimationStep($t):", AnimationStep($t));
echo("Animate(AnimationStep($t)):", Animate(AnimationStep($t)));

// Debug-level logging, show the value of each animation step.
*for (i = [0 : AnimationStepCount() -1])
echo("Animate ", i, ":", Animate(i));

module AnimateSpin() {
  rotate([0,0,360*$t])
  children();
}
