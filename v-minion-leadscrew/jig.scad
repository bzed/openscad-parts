module j() {
    import("3060MGN15_V-Minion_alignment_jig_leadscrew_.stl", 3);
}
 
union() {
difference() {
j();
translate([35,0,-25]) cube([50,50,50]);
}

translate([20,0,0]) difference() {
    j();
    translate([35-50,-10,-25]) cube([50,100,50]);
}

translate([55,0,0]) rotate([0,-90,0])
linear_extrude(20) projection(cut=true) rotate([0,90,0]) translate([-35,0,0]) j();
}
