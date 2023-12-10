/*

Copyright (c) 2023 Bernd Zeimetz

LICENSE:
    Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License
    
Wet Stone Sharpening Guides
    https://github.com/bzed/openscad-parts/tree/main/wet_stone_angle_guide

Requires the awesome Round-Anything library
        https://github.com/Irev-Dev/Round-Anything
*/

width = 30;
length = 35;
angles = [ 10, 12, 15, 17, 20, 25, 30 ];
text_depth = 0.4;

include <Round-Anything/polyround.scad>

$fn = $preview ? 16 : 128;

module guide(angle, length, width, text_depth) {
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


    coutout_d = length/8;
    
    difference() {
        linear_extrude(width) difference() {
            polygon(polyRound([A,B,C], fn=32));
            translate([coutout_d * 1.5,(coutout_d)/2/3]) circle(d = coutout_d);
        }

        translate([ length /2 + length/12, text_depth, width /2]) rotate([90,0,0]) linear_extrude(1 + text_depth) text(str(angle), size = min(length/3, width/2), halign = "center", valign="center");
    }

}
rotate([90,0,0]) for (a = [ 0 : len(angles) - 1 ]) {
    translate([0,0, a*(width + 5)]) guide(angles[a], length, width, text_depth);
}