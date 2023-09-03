/*

Copyright (c) 2023 Bernd Zeimetz

LICENSE:
    Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License

 Heltec Wireless Stick (Lite) v3 case
*/

$fn = $preview ? 16 : 128;

pcb_x = 58.7;
pcb_y = 22.85;
pcb_z = 1.6;
antenna_cable_dia = 1.2;
pcb_z_space = 5.4 - pcb_z + antenna_cable_dia;
pcb_extra_space = 0.1;

pcb_standoff_length = 17 * 2.56;
pcb_standoff_depth = 2;
pcb_standoff_x = 9;


case_x_extra_space = 20;

screw_dia = 3;
screw_head_dia = 5.5;
insert_hole_dia = 4;
insert_height = 6;
base_height = 2;
top_height = 3;

antenna_screw_size = 9.5;
antenna_socket_dia = 6.25;
antenna_socket_flat_dia = 5.8;

button_x = 4.5;
button_z = 2;
button_base_extra = 1;

display_pcb_x =  35.5;
display_pcb_y = 10;
display_x = 13;
display_y = 6.5;

wireless_stick_lite = false;

show_base = true;
show_mid = true;
show_top = true;
show_button = false;

// ================================================================================ //

_pcb_x = pcb_x + 2 * pcb_extra_space;
_pcb_y = pcb_y + 2 * pcb_extra_space;
_pcb_z = pcb_z + 2 * pcb_extra_space;
_pcb_z_space = pcb_z_space + pcb_extra_space;
_insert_dia = 2 * insert_hole_dia;

_button_y = _insert_dia/2 - (25 - pcb_y)/2;

_case_x_extra_space = case_x_extra_space - _insert_dia;

_full_height = base_height + insert_height + _pcb_z_space + top_height;
echo(_full_height);

module base(height, pcb_space = true, holes = true, inserts = true, screw_heads = false,  rounded = "none", extra_x_space = 0, extra_y_space = 0) {
    x1 = _insert_dia/2;
    x2 = 2*_insert_dia + _case_x_extra_space + _pcb_x;
    y1 = _insert_dia/2;
    y2 = y1  + _pcb_y + extra_y_space;
    hole_dia = inserts ? insert_hole_dia : screw_dia * 1.05;
    dia_diff = (_insert_dia - hole_dia) / 2;
    
    difference() {

        translate([-_insert_dia, -_insert_dia/2 - extra_y_space/2, 0]) hull() {

            
            if (rounded == "top") {
                translate([_insert_dia/2, _insert_dia/2, height]) rotate([0,90,0]) cylinder(d = height/2, h=x2-x1);
                translate([_insert_dia/2, y2, height]) rotate([0,90,0]) cylinder(d = height/2, h=x2-x1);
                translate([x1, y1, 0]) cylinder(d = _insert_dia, h = height/2);
                translate([x2, y1, 0]) cylinder(d = _insert_dia, h = height/2);
                translate([x2, y2, 0]) cylinder(d = _insert_dia, h = height/2);
                translate([x1, y2, 0]) cylinder(d = _insert_dia, h = height/2);
            }
            else {
                translate([x1, y1, 0]) cylinder(d = _insert_dia, h = height);
                translate([x2, y1, 0]) cylinder(d = _insert_dia, h = height);
                translate([x2, y2, 0]) cylinder(d = _insert_dia, h = height);
                translate([x1, y2, 0]) cylinder(d = _insert_dia, h = height);
            }
        }
        
        if (holes) {
            translate([-_insert_dia, -_insert_dia/2 - extra_y_space/2, -0.5]) {
                translate([x1, y1, 0]) cylinder(d = hole_dia, h = height + 1);
                translate([x2, y1, 0]) cylinder(d = hole_dia, h = height + 1);
                translate([x2, y2, 0]) cylinder(d = hole_dia, h = height + 1);
                translate([x1, y2, 0]) cylinder(d = hole_dia, h = height + 1);
            }
        }
        
        if(pcb_space) {
            translate([0,0,-0.5]) cube([_pcb_x, _pcb_y, height + 1]);
        }
        if(extra_x_space > 0) {
            translate([_pcb_x -0.1,0,-0.5]) cube([extra_x_space+0.1, _pcb_y, height + 1]);
        }
        if (screw_heads) {
            translate([-_insert_dia, -_insert_dia/2 - extra_y_space/2, 0]) {
                translate([x1, y1, height/2]) cylinder(d = screw_head_dia, h = height);
                translate([x2, y1, height/2]) cylinder(d = screw_head_dia, h = height);
                translate([x2, y2, height/2]) cylinder(d = screw_head_dia, h = height);
                translate([x1, y2, height/2]) cylinder(d = screw_head_dia, h = height);
            }
        }
    }
}

module standoffs(height) {
    translate([pcb_standoff_x, 0, 0]) cube([pcb_standoff_length, pcb_standoff_depth, height]);
    translate([pcb_standoff_x, _pcb_y - pcb_standoff_depth, 0]) cube([pcb_standoff_length, pcb_standoff_depth, height]);
}


 
module antenna_socket(height = 50) {
    union() {
        difference() {
            cylinder(d = antenna_socket_dia + 0.1, h = height, center = true);
            translate([antenna_socket_flat_dia/2 + 0.1 + antenna_socket_dia, 0, 0]) cube([antenna_socket_dia * 2, antenna_socket_dia * 2, height * 2], center = true);
        }
        translate([0,0,-height/3]) cylinder(d = (_full_height - base_height - top_height), h=height / 3, center=true);
        cylinder(d=antenna_screw_size + 0.1, h=2, center=true);
    }
    
    //antenna_screw_size + 0.1;
    //antenna_socket_flat_dia + 0.1;
    
}

/*
button_x = 4.5;
button_z = 2;
button_base_extra = 2;
_button_y
*/

module button() {
    translate([(button_x - 0.3)/2, _button_y/2, (button_z - 0.3)/2]) {
        cube([button_x - 0.3, _button_y, button_z - 0.3], center=true);
        translate([0,(button_base_extra - 0.3)/2 - _button_y/2, 0]) 
            cube([button_x + 2*button_base_extra - 0.3, button_base_extra - 0.3, button_z + 2*button_base_extra -0.3], center=true);
    }
}

module usb(width = 9.2, height = 3.3, depth = 7.5) {
    rotate([-90,0,90]) translate([height/2, -height/2, -depth]) hull() {
        cylinder(d = height, h = depth);
        translate([(width - height), 0, 0]) cylinder(d = height, h = depth);
    }
}



difference() {
    union() {

        if (show_base) {
            union() {
                standoffs(insert_height - _pcb_z);
                base(insert_height, holes=true, pcb_space=true, inserts=true);
                translate([0,0,-base_height]) base(base_height, holes=false, pcb_space=false);
            }
        }
        if (show_mid) {
            translate([0,0, insert_height]) {
                union() {
                    base(_pcb_z_space, holes=true, pcb_space=true, inserts = false, extra_x_space=case_x_extra_space/2);
                    standoffs(_pcb_z_space);
                }
                
            }
        }
        
        if (show_top) {
            difference() {
                union() {
                    if ( ! wireless_stick_lite) {
                        translate([display_pcb_x - 1.5, display_pcb_y -1.5, -antenna_cable_dia + insert_height + _pcb_z_space]) cube([display_x + 3, display_y + 3, top_height + antenna_cable_dia]);
                    }
                    translate([0,0,insert_height + _pcb_z_space]) base(top_height, holes=true, inserts = false, pcb_space=false, screw_heads = true, rounded="top");
                }
                if ( ! wireless_stick_lite) {
                    translate([display_pcb_x, display_pcb_y, -2 *antenna_cable_dia + insert_height + _pcb_z_space]) cube([display_x, display_y, top_height + 3*antenna_cable_dia]);
                }
                
                translate([0,0,insert_height + _pcb_z_space - 0.1]) {
                    if ( ! wireless_stick_lite) {
                        translate([2,5.55,0]) cylinder(d=3, h=top_height - 0.8);
                        translate([55.55,20.75,0]) cylinder(d=3, h=top_height - 0.8);
                    } else {
                        translate([11,6.5,0]) cylinder(d=4, h=top_height - 0.8);
                    }
                }
            }
        }
    }
    translate([_pcb_x + case_x_extra_space, _pcb_y/2, (_full_height - base_height - top_height)/2]) rotate([0,90,0]) antenna_socket();
    
    translate([0,0, insert_height]) {
        translate([1,-50,-0.5]) cube([button_x,100,button_z]);
        translate([1-button_base_extra,(_pcb_y - (25 + 2*button_base_extra))/2,-(0.5 + button_base_extra)])
            cube([button_x + 2*button_base_extra, 25 + 2*button_base_extra, button_z + 2*button_base_extra]);
    }
    translate([-_insert_dia - 1,_pcb_y/2 - 5, insert_height - 0.35]) {
        usb(width = 10, height = 4, depth = _insert_dia + 2);
    }
    translate([-_insert_dia -0.1,_pcb_y/2 - (13/2), insert_height - 4 + 2]) {
        usb(width = 13, height = 8, depth = _insert_dia - 1.25 + 0.1);
    }
}
%translate([0,0, insert_height]) {
    translate([1.1,-1,-0.4]) mirror([0,1,0]) button();
}
%translate([0,_pcb_y + 2, insert_height]) {
    translate([1.1,-1,-0.4]) button();
}

if (show_button) button();
