function SlotOffset(slots,startIndex=0, lastIndex=0) = (
    startIndex >= lastIndex
    ? slots[startIndex]
    : slots[startIndex] + SlotOffset(slots,startIndex+1,lastIndex)
  );


module TapRack(gap=0.65, wall=0.15, height=0.5) {
    slots = [1.123,
             0.902,
             0.683,
             0.7,
             0.56,
             0.434];
  linear_extrude(height=height) {
    translate([-(slots[0]/2)-wall,0])
    mirror([0,1])
    square([SlotOffset(slots, 0, len(slots)-1)
            +(slots[0]/2)
            +(gap*(len(slots)-1))+(wall), 0.5]);
    
    difference() {
      offset(r=wall)
      RackHoles(slots, gap, dCut=true, squareBack=true);
      
      RackHoles(slots, gap, frontCut=true);
    }
  }
}

module RackHoles(slots, gap, squareBack=false, dCut=false, frontCut=false) {
  for (slotIdx = [0:len(slots)-1]) {
    slot = slots[slotIdx];
    
    slotOffsetX = SlotOffset(slots, 0, slotIdx)
                - slot
                + (gap*slotIdx);
    
    translate([slotOffsetX, slot/2,0]) {
      difference() {
        hull() {
          circle(r=slot/2, $fn=ceil(slot*25.4));
          
          if (squareBack)
          mirror([0,1])
          translate([-slot/2,0])
          square([slot, slot/2]);
        }
        
        if (dCut)
        translate([-slot,slot*0.15])
        square([slot*2, slot]);
      }
              
      if (frontCut)
      translate([-slot,slot*0.25])
      square([slot*2, slot]);
    }
  }
}

scale(25.4)
render()
TapRack();