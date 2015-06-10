module stock_spacer(length=1, od=0.75, id=0.5, $fn=20) {
  difference() {
    cylinder(r=od/2, h=length);

    translate([0,0,-0.1])
    cylinder(r=id/2, h=length+0.2);
  }
}




/*
 * Stock spacers are stackable, print in whatever size is needed.
 *
 * E = Depth of the stock, from the front of the extension pipe to the rope guide.
 * 
 * T = Depth of the receiver tee, from the back of the breech bushing to the rear tee rim.
 *
 * S = Length of the striker stack (excluding the firing pin): body-washers-cap-spring-cap
 *
 * StockSpacing = E + T - S
 *
 * Example: 12.5in + 1.128in - 8.2in = 5.43in of spacing
 *
 */
scale([25.4, 25.4, 25.4]) {
  stock_spacer(length=4);
  translate([2,2,0])
  *stock_spacer(length=1.5);
  translate([0,2,0])
  *stock_spacer(length=2);
}
