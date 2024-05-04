/*

Copyright (c) 2023 Bernd Zeimetz

LICENSE:
    Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License

 customizable bullet toggle
*/


machine_foot_width = 12.7;
machine_foot_height = 1.75;
rope_diameter = 0.6;
length = 80;


$fn = 72;

rope_holder_minimum_width = 25;
rope_holder_width = min(max(machine_foot_width *2, rope_holder_minimum_width), rope_holder_minimum_width);

pin_diameter = rope_diameter * 2;
pin_space_diameter = pin_diameter + (rope_diameter *4);

runout_space = 3;

max_height = 3.8;

sliced_rope = true;


circle_diameter = rope_holder_width;
ce=(length-circle_diameter/2);

module pin_cutout() {
    difference() {
        linear_extrude(height=rope_diameter) circle(d=pin_space_diameter);
        linear_extrude(height=rope_diameter) circle(d=pin_diameter);
    }
}

module _text(mytext, height) {
    linear_extrude(height=height) text(mytext, font = "Nimbus Sans:style=Regular", size=5, valign="center",halign="center");
}

module half_circle_with_text(d, height) {
    difference() {
        linear_extrude(height=height) circle(d=d);
        translate([-d/2,-d/2,0]) cube([d,d/2,height]);
        translate([0,d/7,height-1]) {
            if (sliced_rope) {
                _text(str("(", str(rope_diameter),")"), height);
            } else {
                _text(str(rope_diameter), height);
            }
        }
    }
    
    linear_extrude(height=height) circle(d=pin_diameter);    
}

module foot_guide(length, width, height) {
    translate([0, length/2, height/2]) difference() {
        cube([width, length, height], center=true);
        cube([machine_foot_width, length, height], center=true);
    }
}

module holder(rope_height, rope_width) {
    _machine_foot_height = min(max_height, rope_height + machine_foot_height) - rope_height;
    difference() {
        union() {
            difference() {
                union(){
                    le=length-(circle_diameter/2);
                    
                    translate([0,0,rope_height]) foot_guide(length=le, width=rope_holder_width, height=_machine_foot_height);
                    translate([-rope_holder_width/2,0,0]) cube([rope_holder_width, le, rope_height]);
                    
                    translate([-rope_holder_width/2,0,rope_height]) {
                        hull() {
                            cube([rope_holder_width, 1, _machine_foot_height]);
                            translate([0,runout_space-1,0]) cube([rope_holder_width, 1, 0.1]);
                        }
                     }
                }
                union(){
                    
                    translate([-rope_width/2,0,0]) cube([rope_width, ce, rope_height]);
                    
                }
                    
            }
            translate([0,length-(circle_diameter/2), 0]) half_circle_with_text(d=circle_diameter, height=_machine_foot_height + rope_height);
        }
        
        
        translate([0,ce,0]) pin_cutout();
        translate([-((rope_holder_width-machine_foot_width)/2 + machine_foot_width/4) ,ce/2,rope_height + machine_foot_height -1]) rotate([0,0,90]) _text(str(length), 2);
        
        
    }
    
    
}




if (sliced_rope) {
    holder(rope_diameter * 2, rope_diameter * 2);     
} else {
    holder(rope_diameter, rope_diameter * 2);
}
