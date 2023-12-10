/*

Copyright (c) 2023 Bernd Zeimetz

LICENSE:
    Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License
    
Wet Stone Sharpening Guides

Requires the awesome Round-Anything library
        https://github.com/Irev-Dev/Round-Anything
*/

width = 35;
length = 50;
angles = [ 10, 12, 15, 17, 20, 25, 30 ];


include <Round-Anything/polyround.scad>

$fn = $preview ? 16 : 128;

module guide(angle, length, width) {
    alpha = angle;
    
    rad = 0.5;
    beta = 180 - 90 - alpha;
    extra_length = 2*rad * tan(beta);
    
    c = length + extra_length;
    // c^2 = a^2 + b^2;
    //c^2 = a^2 + sin(alpha)^2 * c^2;
    // a^2 = (1 - (sin(alpha)^2) * c^2;
    a = sqrt((1-(sin(alpha)^2)) * c^2);
    h = sin(alpha) * a;
    c2 = cos(alpha) * a;

    c1 = (c - c2);



    A = [ 0,0, 2*rad ];
    B = [ c, 0, rad ];
    C = [ c1, h, 2*rad ];


    
    difference() {
        linear_extrude(width) difference() {
            polygon(polyRound([A,B,C], fn=32));
            translate([c/6,(c/6)/2/3]) circle(d = c/6);
        }

        translate([ length /2 + length/12, 1, width /2]) rotate([90,0,0]) linear_extrude(2) text(str(angle), size = min(length/3, width/2), halign = "center", valign="center");
    }

}
rotate([90,0,0]) for (a = [ 0 : len(angles) - 1 ]) {
    translate([0,0, a*(width + 5)]) guide(angles[a], length, width);
}