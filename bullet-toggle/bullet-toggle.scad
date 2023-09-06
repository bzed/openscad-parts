
/*

Copyright (c) 2023 Bernd Zeimetz

LICENSE:
    Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License

 customizable bullet toggle
*/

diameter_middle = 10.15;
diameter_side = 6;
length = 27.5;

diameter_holes = 5.25;


//

$fn=128;


module half_toggle() {
    difference() {
        hull() {
            linear_extrude(height=length/4) circle(d=diameter_middle);
            translate([0,0,(length/2)-0.1]) linear_extrude(height=0.1) circle(d=diameter_side);
        }

        translate([0,diameter_middle,diameter_holes*3/4]) rotate([90,0,0]) linear_extrude(height=diameter_middle*2) circle(d=diameter_holes);
    }
}

union() {
    half_toggle();
    mirror(v=[0,0,1]) half_toggle();
}
