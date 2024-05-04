/*

Copyright (c) 2024 Bernd Zeimetz

LICENSE:
    Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License

 Triggerpoint massage tool (customizable)
 
*/


height = 45;
diameter = 15;


$fn = $preview ? 16 : 128;

hull() {
translate([0,0,- diameter/2 + height]) sphere( r = diameter/2);
translate([0,0, (height-diameter)/2]) sphere( r = diameter/8);
}



base_diameter = max(50, min(height*0.75, 80));
distance = base_diameter/2;

upper_diameter = diameter/8;
upper_distance = upper_diameter*2;

upper_height = height - diameter/4*3;

union() {

    hull() {
        rotate([0,0,-120]) {
            translate([0,upper_distance,upper_height]) cylinder(d=upper_diameter, h=0.01);
        }
        rotate([0,0,-120]) {
            translate([0,distance,0]) cylinder(d=base_diameter, h=0.01);
        }
        translate([0,0, (height-diameter)/2]) sphere( r = diameter/8);
    }

    hull() {
        rotate([0,0,120]) {
            translate([0,upper_distance,upper_height]) cylinder(d=upper_diameter, h=0.01);
        }
        rotate([0,0,120]) {
            translate([0,distance,0]) cylinder(d=base_diameter, h=0.01);
        }
        translate([0,0, (height-diameter)/2]) sphere( r = diameter/8);
    }

    hull() {
        rotate([0,0,0]) {
            translate([0,upper_distance,upper_height]) cylinder(d=upper_diameter, h=0.01);
        }
        rotate([0,0,0]) {
            translate([0,distance,0]) cylinder(d=base_diameter, h=0.01);
        }
        translate([0,0, (height-diameter)/2]) sphere( r = diameter/8);
    }
}