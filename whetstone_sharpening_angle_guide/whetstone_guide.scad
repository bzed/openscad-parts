/*

Copyright (c) 2023 Bernd Zeimetz

LICENSE:
    Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License
    
Whetstone Sharpening Guides
    https://github.com/bzed/openscad-parts/tree/main/whetstone_sharpening_angle_guide

Requires the awesome Round-Anything library
        https://github.com/Irev-Dev/Round-Anything
*/


/* [Guides] */

width = 35; // [20:1:100]
length = 40; // [20:1:100]
angles = [ 10, 12, 15, 17, 20, 25, 30 ]; // [ 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35 ]
text_depth = 0.4; // [0.1:0.1:2]

/* [Hidden] */
$fn = $preview ? 16 : 128;

include <Round-Anything/polyround.scad>



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
