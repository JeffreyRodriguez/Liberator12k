include <../../Vitamins/Pipe.scad>;
include <../../Vitamins/Rod.scad>;
use <../../Forend Rail.scad>;

// TODO: Make automatic scaling of the handle holes better
module ForendWrench(receiverTee=TeeThreeQuarterInch, forendRods=RodFiveSixteenthInch, height = 3/8, wall=1/4, $fn=40,
                    handleWidth=1, handleLength=5) {


  handleRadius = handleWidth/2;

  render(convexity=2)
  linear_extrude(height=height)
  difference() {

    // Main body
    hull() {
      // Body
      *circle(r=TeeRimRadius(receiverTee) + wall);

      // Handle Tip
      translate([-handleLength,0,0])
      circle(r=handleWidth/2);

      ForendRail(railRod=forendRods, angles=[50,-50], wall=wall);
    }

    // Forend holes
    ForendRods(railRod=forendRods, railClearance=RodClearanceSnug);

    // Handle Holes
    #for (i = [[handleRadius*.7, handleLength],
               [handleRadius*1.1, handleLength*.71],
               [handleRadius*1.5, handleLength*.37],
               [handleRadius*1.5, -0.1]]) {
      translate([-i[1],0,0])
      circle(r=i[0]);
    }
  }

}

scale([25.4, 25.4, 25.4])
ForendWrench();
