module extrusion5Series(xSegments, ySegments, zLength)
scale(1/25.4) //I hate this
linear_extrude(zLength * 25.4) //I hate this too
translate([-xSegments*10, -ySegments*10])
difference(){
	square([xSegments*20, ySegments*20]);
	
	for(i = [0:1:xSegments-1])
	translate([i*20, 0]){
		translate([7, 0])
		square([6, 2]);
		
		translate([4, 2])
		polygon([[0, 0], [4, 4], [8, 4], [12, 0]]);
		
		translate([0, ySegments*20]){
			translate([7, -2])
			square([6, 2]);
			
			translate([4, -6])
			polygon([[0, 4], [4, 0], [8, 0], [12, 4]]);
		}
	}
	
	for(i = [0:1:ySegments-1])
	translate([0, i*20]){
		translate([0, 7])
		square([2, 6]);
		
		translate([2, 4])
		polygon([[0, 0], [4, 4], [4, 8], [0, 12]]);
		
		translate([xSegments*20, 0]){
			translate([-2, 7])
			square([2, 6]);
			
			translate([-6, 4])
			polygon([[4, 0], [0, 4], [0, 8], [4, 12]]);
		}
	}
}

module extrusion5SeriesCrude(xSegments, ySegments, zLength, xyClearUS = 0){ //This is intended to have simpler geometry to mimic the old 2020 model more and allow fitment to happen
	xyClear = xyClearUS * 25.4;
	scale(1/25.4) //More
	linear_extrude(zLength * 25.4) //Even MORE
	translate([-xSegments*10 + xyClear, -ySegments*10 + xyClear])
	difference(){
		square([xSegments*20 - xyClear*2, ySegments*20 - xyClear*2]);
		
		for(i = [0:1:xSegments-1])
		translate([i*20, 0]){
			translate([7, 0])
			square([6 - xyClear*2, 3]);
			
			translate([0, ySegments*20]){
				translate([7, -3])
				square([6 - xyClear*2, 3]);
			}
		}
		
		for(i = [0:1:ySegments-1])
		translate([0, i*20]){
			translate([0, 7])
			square([3, 6 - xyClear*2]);
			
			translate([xSegments*20, 0]){
				translate([-3, 7])
				square([3, 6 - xyClear*2]);
			}
		}
	}
}

extrusion5Series(1, 1, 1);

translate([1, 0])
extrusion5SeriesCrude(1, 1, 1);

translate([0, 1])
difference(){
	extrusion5SeriesCrude(1, 1, 1, 0.01);
	extrusion5Series(1, 1, 1);
}

translate([1, 1])
difference(){
	extrusion5Series(1, 1, 1);
	extrusion5SeriesCrude(1, 1, 1, 0.01);
}