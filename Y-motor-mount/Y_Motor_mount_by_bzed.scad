/*  
    This work is dual licensed under the GPL 3.0 and the GNU Lesser General Public License as per http://creativecommons.org/licenses/LGPL/2.1/
    
    Copyright (C) 2020 Bernd Zeimetz <bernd@bzed.de>
*/




use <MCAD/motors.scad>;
use <MCAD/boxes.scad>;
include <MCAD/math.scad>;
use <utils/build_plate.scad>;


 
/* [Motor] */
nema_standard = 17; // [17, 23]
//extra space to move motor up and down
slide_distance = 3;
//height of the belt over the extrusion
belt_height = 23;
//tolerance of the motor screw holes
tolerance = 0.15;
//outside diameter of gt2 pulley; 12.22 is 20t
gt2_pulley_outside_diameter = 12.22;


/* [Mount] */
//diameter of the screw head or washers
screw_head_diameter = 11;
//diameter of the screw hole
screw_hole_diameter = 5.5;
//thickness of the plate that holds the motor. At least 6mm recommended if you want to move a larger print bed.
motor_mount_thickness = 6;

//distance between the screws
screw_distance = 30; //[20:200]
//width of the mounting bracket
bracket_width = 60; //[30:200]
//thickness of the mounting bracket. Beware: your belt needs to fit over it!
bracket_thickness = 6;

//height of the extrusion you want to mount the bracket on. Sizes for common v-slot extrusions.
extrusion_height = 40; //[20, 40, 60, 80, 100, 30, 60, 90, 120]
//depth of the extrusion you want to mount the bracket on. Sizes for common v-slot extrusions.
extrusion_depth = 40;  //[20, 40, 60, 80, 100, 30, 60, 90, 120]
//distance of the slots on the extrusion
extrusion_screw_distance = 20; //[20,30]

//size of the lower strength enhancement
hull_size = 4; //[1:6]

hull_size_factor = hull_size / 6;

/* [Buildplate] */

//show buildplate
show_buildplate = false; // [true, false]
//for display only, doesn't contribute to final object
build_plate_selector = 3; //[0:Replicator 2,1: Replicator,2:Thingomatic,3:Manual]
//when Build Plate Selector is set to "manual this controls the build plate x dimension
build_plate_manual_x = 400; //[100:500]
//when Build Plate Selector is set to "manual" this controls the build plate y dimension
build_plate_manual_y = 400; //[100:500]


/* [OpenSCAD settings] */
$fa = 1;
$fs = 0.2;


/* [Hidden] */
faceplate_connection_space = 1;
faceplate_size = nema_standard / 10 * mm_per_inch;
distance_extrusion_to_mount = bracket_thickness * 1.25;
pulley_diameter_with_belt = gt2_pulley_outside_diameter + 2*(1.36-0.76); // GT2 20t with belt
motor_height = belt_height - (pulley_diameter_with_belt / 2);


module motor_mount(nema_standard, slide_distance = 0, motor_mount_thickness = 2, faceplate_size = 100, bracket_thickness = 0) {
    
    
    difference() {
        translate([bracket_thickness/2,bracket_thickness/2,motor_mount_thickness/2]) {
            roundedBox(
                [
                    faceplate_size + (faceplate_connection_space * 2) + bracket_thickness,
                    faceplate_size + slide_distance + (faceplate_connection_space * 2) + bracket_thickness,
                    motor_mount_thickness
                ],
                5,
                true
            );
        }
        linear_extrude(height = motor_mount_thickness + 5) {
            stepper_motor_mount(nema_standard, slide_distance, true, tolerance);
        }
    }
}

module _positioned_motor_mount() {
    translate([0,faceplate_size/2 + distance_extrusion_to_mount, motor_height])
        rotate([-90,0,-90])
            motor_mount(nema_standard, slide_distance, motor_mount_thickness, faceplate_size, bracket_thickness);
}

module _bracket_base(size_factor = 1) {

    translate([0, -extrusion_depth, 0])
        cube([bracket_width * size_factor, (extrusion_depth) + bracket_thickness, bracket_thickness]);

    translate([0, 0, -extrusion_height])
        cube([bracket_width * size_factor, bracket_thickness, extrusion_height]);
}


module _lower_connection() {
    hull() difference() {
        union() {
            _positioned_motor_mount();
            _bracket_base(hull_size_factor);
        }
        translate([-250,-250,-(faceplate_size/2) + motor_height + faceplate_connection_space + slide_distance/2]) cube([500,500,500]);
    }
}

function __hole_counts(w, d) = floor(w / d);
function hole_counts(w,d) = 
    w - ((__hole_counts(w, d) - 1) * d) < d
        ? (__hole_counts(w, d) - 1) : (__hole_counts(w, d));
function hole_start(w,d,c) = (w - (( c - 1) * d)) / 2;


module screw_holes(x_width, x_distance, y_width, y_distance, screw_hole_diameter = screw_hole_diameter, screw_head_diameter = screw_head_diameter) {
    
    x_count = hole_counts(x_width, x_distance);
    x_start = hole_start(x_width, x_distance, x_count);
    y_count = hole_counts(y_width, y_distance);
    y_start = hole_start(y_width, y_distance, y_count);
    h = 500;
    for (y = [0:1:y_count-1]) {
        for (x = [0:1:x_count-1]) {
            union() {
                translate([x_start + x*x_distance, y_start + y*y_distance, 0]) cylinder(h=h/2, r = screw_head_diameter/2, center=false);
                translate([x_start +  x*x_distance, y_start + y*y_distance, 0]) cylinder(h=h, r = screw_hole_diameter/2, center=true);
            }
        }
    }
}


module mount() {
    difference() {
        union() {
            _positioned_motor_mount();
            _bracket_base();
            _lower_connection();
        }

        translate([0,-extrusion_depth,bracket_thickness])
            screw_holes(bracket_width,  screw_distance, extrusion_depth, extrusion_screw_distance, screw_hole_diameter, screw_head_diameter);

        translate([0, bracket_thickness, 0]) rotate([-90,0,0]) screw_holes(bracket_width,  screw_distance, extrusion_height, extrusion_screw_distance, screw_hole_diameter, screw_head_diameter);
    }
}


 if (show_buildplate) {
    build_plate(build_plate_selector,build_plate_manual_x,build_plate_manual_y);
 }
rotate([0,-90,0]) mount();