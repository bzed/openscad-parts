/*
    This work is dual licensed under the GPL 3.0 and the GNU Lesser General Public License as per http://creativecommons.org/licenses/LGPL/2.1/
    Copyright (C) 2021 Bernd Zeimetz <bernd@bzed.de>
*/


// requires https://github.com/Irev-Dev/Round-Anything
use <Round-Anything/MinkowskiRound.scad>;

t = 2.5; //line thickness
s = 2.5; //material (space) thickness
ml = 17; //mask space
hl = 27; //helmet space
ho = 2.5; //helmet opening
mo = 5; //mask opening
h = 2.5; //height

hh1 = t + ml + t + (s + t);
hh2 = t + ml + t;
hh3 = hh2 + (hl/3*2);
hh4 = hh2 + hl;
hh5 = hh4 + t;
hh6 = hh1 + hl/3;

mh1 = t + ml;
mh2 = mh1 - mo;

t1 = t + s/2;
t2 = t + s;
t3 = t + s + t;

r = (t + h) / 8;

ppoints = [
    [0,0],
    [0,hh1],
    [t,hh1],
    [t,hh2],
    [t2,hh2],
    [t2,hh3],
    [t1,hh4],
    [t,hh3],
    [t,hh2],
    [t,hh6],
    [0,hh6],
    [0,hh5],
    [t3,hh5],
    [t3,mh1],
    [t,mh1],
    [t,t],
    [t2,t],
    [t2,mh2],
    [t3,mh2],
    [t3,0]
];

minkowskiOutsideRound(r, true, [200,200,200]) {
     linear_extrude(height=h) {
         polygon(ppoints);
     }
 }