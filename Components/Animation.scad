// wip

ANIMATION_STEP_SAFETY  = 0;
ANIMATION_STEP_TRIGGER = 1;
ANIMATION_STEP_STRIKER = 2;

ANIMATION_STEPS = [ANIMATION_STEP_SAFETY,
                   ANIMATION_STEP_TRIGGER,
                   ANIMATION_STEP_STRIKER];

function AnimationStepCount() = len(ANIMATION_STEPS);
function AnimationStepTime() = 1/AnimationStepCount();
function AnimationStep(t)    = ANIMATION_STEPS[floor(t / AnimationStepTime())];
function Animate(step)       = step == AnimationStep($t) ? ($t/AnimationStepTime())-step : (step < AnimationStep($t) ? 1 : 0);

echo("AnimationStep($t):", AnimationStep($t));
echo("Animate(AnimationStep($t)):", Animate(AnimationStep($t)));

for (i = [0 : AnimationStepCount() -1])
echo("Animate ", i, ":", Animate(i));
