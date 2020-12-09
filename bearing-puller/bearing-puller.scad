/*
Copyright © 2018 Bernd Zeimetz <bernd@bzed.de>
License: Creative Commons Attribution-ShareAlike 4.0 International
*/

/*
bearing configuration. 26/10/8 is a standard 6000 bearing
*/
bearing_outer_diameter = 26;
bearing_inner_diameter = 10;
bearing_height = 8;

/*
If you own a bike like the Cube Stereo 120 HPA MY2015
where the frame design was obviously done by somebody
who will never ever remove the pivot bearings on their own,
you can enable this workaround to produce a bearing removal
tool which will fit on the frame.

Might also work for other frames/parts where there is not enough
space for the full circle of the tool to sit on the frame/part.
*/
enable_cube_stereo_120_workaround = false;
cube_stereo_120_workaround_height = 1.4;

/*
you should not have to change these options, but
feel free to do if necessary.
*/
$fn=360;
space_for_bearing_height = bearing_height * 1.25;
space_for_bearing_diameter = bearing_outer_diameter*1.0385;
wall_thickness = 3;
outer_diameter = space_for_bearing_diameter + (2*wall_thickness);
outer_cylinder_height = space_for_bearing_height + wall_thickness;

translate(v=[0,0,outer_cylinder_height]) {
    rotate(a=[180,0,0]) {
        difference() {
        
            cylinder(
                h=outer_cylinder_height,
                d=outer_diameter
            );
            union() {
                cylinder(
                    h=space_for_bearing_height,
                    d=space_for_bearing_diameter
                );
                cylinder(
                    h=outer_cylinder_height*1.5,
                    d=bearing_inner_diameter
                );
                if (enable_cube_stereo_120_workaround) {
                    cube(
                        [
                            outer_diameter,
                            outer_diameter,
                            cube_stereo_120_workaround_height
                        ],
                        false
                    );
                }
            }
        };
    };
};
