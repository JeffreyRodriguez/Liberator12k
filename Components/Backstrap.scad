include <../Vitamins/Angle Stock.scad>;

module backstrap(stock=AngleStockThreeQuartersByOneEighthInch,
                 thicknessClearance=AngleStockThicknessClearanceLoose,
                 widthClearance=AngleStockWidthClearanceLoose,
                 length=1, trough=0.5, wall_thickness = 1/4,
                 infill_width=1.45, infill_length=1) {
  difference() {


    union() {

      // 3/4" Angle Stock Mount, with a bit of rounding-off
      translate([wall_thickness*sqrt(2), 0, 0])
      rotate([0,0,135]) {
        intersection() {
          translate([lookup(AngleStockWidth, stock) - 1/8,lookup(AngleStockWidth, stock) - 1/8, - 0.1])
          cylinder(r=lookup(AngleStockWidth, stock), h=length + 0.2, $fn=20);

          cube([
            3_4_angle_stock_width + wall_thickness*2,
            3_4_angle_stock_width + wall_thickness*2,
            length]);
        }
      }

      translate([-infill_length -lookup(AngleStockHeight, stock),-infill_width/2,0])
      cube([infill_length, infill_width, length]);
    }

    // 3/4" Angle Stock
    translate([0,0,-0.1])
    rotate([0,0,135])
    AngleStock(stock=stock, length=length + 0.2, trough=trough, thicknessClearance=thicknessClearance, widthClearance=widthClearance);
  }
}
