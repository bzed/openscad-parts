machine_foot_width = 15;
rope_diameter = 1.5;
length = 120;


$fn = 72;
rope_holder_width = machine_foot_width *2;
pin_diameter = rope_diameter * 2;
pin_space_diameter = pin_diameter + (rope_diameter *4);

runout_space = 10;



circle_diameter = min(pin_space_diameter*4, rope_holder_width);

module pin_cutout() {
    difference() {
        linear_extrude(height=rope_diameter) circle(d=pin_space_diameter);
        linear_extrude(height=rope_diameter) circle(d=pin_diameter);
    }
}

module half_circle_with_text(d, height) {
    translate([0,0,height]) {
        difference() {
            linear_extrude(height=height) circle(d=d);
            translate([-d/2,-d/2,0]) cube([d,d/2,height]);
        }
        translate([0,d/4,height]) linear_extrude(height=height/2) text(str(rope_diameter), font = "Nimbus Sans Narrow:style=Regular", size=5, valign="center",halign="center");
        linear_extrude(height=height) circle(d=pin_diameter);
    }
    linear_extrude(height=height) circle(d=d);
    
}

difference() {
    union(){
        translate([-rope_holder_width/2,0,0]) cube([rope_holder_width, length-(circle_diameter/2), rope_diameter]);
        translate([0,length-(circle_diameter/2), 0]) half_circle_with_text(d=circle_diameter, height=rope_diameter);
        translate([-rope_holder_width/2,0,rope_diameter]) {
            hull() {
                cube([rope_holder_width, 1, rope_diameter]);
                translate([0,runout_space-1,0]) cube([rope_holder_width, 1, 0.1]);
            }
        }
    }
    union(){
        ce=(length-circle_diameter/2);
        translate([-rope_diameter,0,0]) cube([2*rope_diameter, ce-pin_diameter/2, rope_diameter]);
        translate([0,ce,0]) pin_cutout();
    }
        
}
