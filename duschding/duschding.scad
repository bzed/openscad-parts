
$fn = $preview ? 16 : 128;

FAST_RCYLINDER = $preview ? true : false;

RCYLINDER_FLATBOTTOM = [false,true];
RCYLINDER_FLATTOP = [true,false];

module rcylinder(h=2,d=1,r=0.1,rd=[true,true]) {
    if(FAST_RCYLINDER)
       cylinder(d=d,h=h);
    else
       hull() { 
          translate([0,0,r]) 
             if(len(rd) && rd[0]) torus(do=d,di=r*2); else translate([0,0,-r]) cylinder(d=d,h=r);          
          translate([0,0,h-r]) 
             if(len(rd) && rd[1]) torus(do=d,di=r*2); else cylinder(d=d,h=r);
       }
 }

 module torus(do=2,di=0.1,a=360) {
    rotate_extrude(convexity=10,angle=a) {
       translate([do/2-di/2,0,0]) circle(d=di);
    }
 }

difference() {

    translate([0,0,0.1]) rcylinder(h=26.9, d=4+22.6, r=3);

    union() {
        cylinder(h=11, d=22.6);
        cylinder(h=13, d=9);
        cylinder(h=23, d=5.6);
    }
}