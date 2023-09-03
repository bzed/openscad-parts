$fan_size = 40;
$screw_distance = 32;
$adxl_screw_distance = 15;
$part_height = 5.8;
$screw_head_height = 3;
$screw_head_diameter = 5.45;

$fn = 64;


module remove_parts() {
    
    $head_move = ($part_height - $screw_head_height);
    translate([-$screw_distance/2, $screw_distance/2, 0]) cylinder(h = $part_height * 2, d = 3.5, center = true);
    translate([$screw_distance/2, $screw_distance/2, 0]) cylinder(h = $part_height * 2, d = 3.5, center = true);
    
    translate([-$screw_distance/2, $screw_distance/2, $head_move]) cylinder(h = $part_height, d = $screw_head_diameter, center = true);
    translate([$screw_distance/2, $screw_distance/2, $head_move]) cylinder(h = $part_height, d = $screw_head_diameter, center = true);
    
    translate([-$adxl_screw_distance/2, $screw_distance/2 + 10, 0]) cylinder(h = $part_height * 2, d = 4, center = true);
    translate([$adxl_screw_distance/2, $screw_distance/2 + 10, 0]) cylinder(h = $part_height * 2, d = 4, center = true);

    
    cylinder(h = 20, d = $fan_size -2, center = true);
}

module add_parts() {
    hull() {
        translate([-$screw_distance/2, $screw_distance/2, 0]) cylinder(h = $part_height, d = 10, center = true);
        translate([$screw_distance/2, $screw_distance/2, 0]) cylinder(h = $part_height, d = 10, center = true);
    
        translate([-$adxl_screw_distance/2, $screw_distance/2 + 10, 0]) cylinder(h = $part_height, d = 10, center = true);
        translate([$adxl_screw_distance/2, $screw_distance/2 + 10, 0]) cylinder(h = $part_height, d = 10, center = true);
    }

}

difference() {
    add_parts();
    remove_parts();
}