module c(r,x,y){
    translate([x,y])circle(r=r,$fn=32);
}
module s(h,w,x,y){
    translate([x,y])square([h,w]);
}
module z(){
    z1 = [[0,0],[0,13.1],[2.76,13.1],[3.56,12.3],[3.56,3.97],[4.35,3.18],[14.7,3.18],[15.49,3.97],[15.49,10.68],[17.08,13.43],[23.91,17.37],[24.34,17.73],[28.51,22.7],[29.12,22.99],[33.95,22.99],[35.11,22.07],[39.9,1.75],[39.31,.8],[36.99,.25],[20.26,0]];    
    z2 = [[36.99,0],[36.99,.25],[36.03,.84],[34,9.46],[26.5,14.21],[18.46,12.5],[18.68,8.59],[20.26,7],[20.26,0]];
    difference(){
        union(){
            polygon(z1);
            c(.79,2.76,12.3);
            c(3.18,18.67,10.68);
            c(.79,29.12,22.19);
            c(1.19,33.95,21.8);
            c(.79,39.12,1.57);
        }
        c(.79,4.35,3.99);
        c(.79,14.7,3.99);
        c(1.59,23.12,18.75);
        c(1.98,18.88,10.56);
        c(6.35,27.82,8);
        polygon(z2);
    }
    c(.79,36.81,1.03);
    c(1.59,18.67,7);
}
module y(){
    difference(){
        s(22.43,12.45,0,0);
        hull(){
            s(1,1,21.43,0);
            c(5.93,5.3,6.5);
            c(5.93,5.3,5.81);
            c(5.93,17.46,6.64);
        }
    }
    c(.79,23.1,10.32);
    s(1.59,2.13,22.3,10.32);
}
module x(){
    difference(){
        s(.4,.4,-12.45,20.24);
        c(.4,-12.05,20.64);
    }
    hull(){
        s(1,1,-12.7,19.24);
        s(3.18,1,-12.7,0,0);
        c(1.59,-11.11,18.65);
    }
}

difference(){
    linear_extrude(height=12.446){z();}
    rotate([90,0,0])
    translate([0,0,-23])
    linear_extrude(height=23)
    y();
    
    translate([23.1,0,0])
    rotate([0,90,0])
    linear_extrude(height=17)
    x();
}