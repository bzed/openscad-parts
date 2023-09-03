$d_handle = 85;
$d_mount = 20;
$d_magnet = 10;

module mount() {
    import("hive_magnet_mount.stl", convexity=3);
}


module _mount_lr(fac = 1) {
    union() {
        mount();
        translate([$d_mount/2 * fac, 0, 0]) cylinder(d=$d_magnet + 1.5);
    }
}

module mount_l() {
    _mount_lr();
}

module mount_r() {
    _mount_lr(-1);
}

union() {
translate([-($d_handle-$d_mount + $d_magnet/2)/2, 0,0]) {
    mount_l();
    translate([$d_handle - $d_mount + $d_magnet/2, 0, 0]) mount_r();
}

$mid_l = $d_handle-2*$d_mount + 8 + $d_magnet/2;
translate([$mid_l/2, 0,0]) {
    rotate([0,-90,0]) linear_extrude($mid_l) {
        projection() {
            translate([0,0,6]) rotate([0,90,0]) mount_l();
        }
    }
}
}