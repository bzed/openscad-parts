/*

Copyright (c) 2024 Bernd Zeimetz

LICENSE:
    Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License

 Triggerpoint massage tool (customizable)
 
*/

height = 70;
width_upper = 57;
width_lower = 73;

upper_dia = 7;
lower_dia = 6;

thickness = 21;

cutout_x = 29;
cutout_y = 40;
cutout_z = 17.5;

back_x = 39;
back_z = 11;

$fn = $preview ? 16 : 128;

/*
module base() {
        translate([0,0,-thickness]) linear_extrude(height=thickness * 2) hull() {

        translate([(width_upper - upper_dia)/2, height/2-upper_dia/2]) circle(d=upper_dia);
        translate([-(width_upper - upper_dia)/2, height/2-upper_dia/2]) circle(d=upper_dia);

        translate([(width_lower - lower_dia)/2, -(height/2-lower_dia/2)]) circle(d=lower_dia);
        translate([-(width_lower - lower_dia)/2, -(height/2-lower_dia/2)]) circle(d=lower_dia);
    }
}
*/

module screwhole() {
    cylinder(d=13, h=100);
    translate([0,0,-100]) cylinder(d=6.35, h=200);
}



module round_base(h = thickness - back_z) {
    hull() {

            translate([(width_upper - upper_dia)/2, height/2-upper_dia/2, upper_dia/2]) sphere(d=upper_dia);
            translate([-(width_upper - upper_dia)/2, height/2-upper_dia/2, upper_dia/2]) sphere(d=upper_dia);

            translate([(width_lower - lower_dia)/2, -(height/2-lower_dia/2), lower_dia/2]) sphere(d=lower_dia);
            translate([-(width_lower - lower_dia)/2, -(height/2-lower_dia/2), lower_dia/2]) sphere(d=lower_dia);
        
        
            translate([(width_upper - upper_dia)/2, height/2-upper_dia/2, h - upper_dia/2]) sphere(d=upper_dia);
            translate([-(width_upper - upper_dia)/2, height/2-upper_dia/2, h - upper_dia/2]) sphere(d=upper_dia);

            translate([(width_lower - lower_dia)/2, -(height/2-lower_dia/2), h - lower_dia/2]) sphere(d=lower_dia);
            translate([-(width_lower - lower_dia)/2, -(height/2-lower_dia/2), h - lower_dia/2]) sphere(d=lower_dia);
     }
 }
 
 module base() {
     translate([0,0,back_z]) round_base();
     translate([0,0,+back_z/4]) cube([back_x, height, back_z * 2.5], center=true);
     translate([0,0,-cutout_z]) round_base(cutout_z);
 }
 
 module mount() {
    difference() {
        union() {
            difference() {

                base();
                translate([-cutout_x/2,-cutout_y+height/2,thickness - cutout_z]) cube([cutout_x, cutout_y+2, cutout_z+2]);
                
            }

            translate([-(cutout_x+4)/2,height/2-6,0]) hull() {
                translate([0,5.99,0])cube([cutout_x+4, 0.01, 6 ]);
                cube([cutout_x+4, 0.01, 8]);
            }
        }
        translate([0,-height/4,0]) screwhole();
        translate([0,height/4,-4.5]) screwhole();
    }
}

mount();