$fn=64;

$id=12;
$add = 0.6*2*4;
difference() {
    union() {
        hull() {
            cylinder(h=60, d=32+$add);
            translate([0,0,70]) cylinder(h=10, d=$id + $add);
        }
        translate([0,0,80]) cylinder(h=10, d=$id + $add);
    }
    union() {
        hull() {
            cylinder(h=60, d=32);
            translate([0,0,70]) cylinder(h=10, d=$id);
        }
        translate([0,0,80]) cylinder(h=10, d=$id);
    }
}