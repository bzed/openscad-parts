phone_width = 65;
phone_height = 65;

usb_width = 12;
usb_height = 4;

sewing_width = usb_width + 2;
sewing_height = 40;

$fn = 40;


use <Round-Anything/polyround.scad>;

radius = 2;

ppoints = [
   [0, 0, radius],
   [0, phone_height, radius],
   [phone_width/2 - usb_width/2, phone_height, radius],
   [phone_width/2 - usb_width/2, phone_height + usb_height, radius],
   [phone_width/2 - sewing_width/2, phone_height + usb_height, radius],
   [phone_width/2 - sewing_width/2, phone_height + usb_height + sewing_height, radius],
   [phone_width/2, phone_height + usb_height + sewing_height, 0],
   [phone_width/2, 0, 0],
];

translate([-phone_width/2, 0]) polygon(polyRound(ppoints, 30));
mirror([1,0]) translate([-phone_width/2, 0]) polygon(polyRound(ppoints, 30));

