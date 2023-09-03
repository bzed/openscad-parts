/*
MIT License

Copyright (c) 2023 Bernd Zeimetz

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for ESP-12F Wifi 4-Channel Relay
//
//  Version 2.0 (21-05-2023)
//
// This design is parameterized based on the size of a PCB.
//
//  for many or complex cutoutGrills you might need to adjust
//  the number of elements:
//
//      Preferences->Advanced->Turn of rendering at 100000 elements
//                                                  ^^^^^^
//
//-----------------------------------------------------------------------
/*

polygonShape = [  [0,0],[20,15],[30,0],[40,15],[70,15]
                 ,[50,30],[60,45], [40,45],[30,70]
                 ,[20,45], [0,45]
               ];
*/

include <YAPP_Box/library/YAPPgenerator_v20.scad>

// Note: length/lengte refers to X axis, 
//       width/breedte to Y, 
//       height/hoogte to Z

/*
            padding-back>|<---- pcb length ---->|<padding-front
                                 RIGHT
                   0    X-ax ---> 
               +----------------------------------------+   ---
               |                                        |    ^
               |                                        |   padding-right 
             ^ |                                        |    v
             | |    -5,y +----------------------+       |   ---              
        B    Y |         | 0,y              x,y |       |     ^              F
        A    - |         |                      |       |     |              R
        C    a |         |                      |       |     | pcb width    O
        K    x |         |                      |       |     |              N
               |         | 0,0              x,0 |       |     v              T
               |   -5,0  +----------------------+       |   ---
               |                                        |    padding-left
             0 +----------------------------------------+   ---
               0    X-ax --->
                                 LEFT
*/


//-- which part(s) do you want to print?
printBaseShell        = false;
printLidShell         = true;
printSwitchExtenders  = false;

//-- pcb dimensions -- very important!!!
pcbLength           = 88.5;
pcbWidth            = 93;
pcbThickness        = 1.6;
                            
//-- padding between pcb and inside wall
paddingFront        = 3;
paddingBack         = 10;
paddingRight        = 3;
paddingLeft         = 3;

//-- Edit these parameters for your own box dimensions
wallThickness       = 2.0;
basePlaneThickness  = 2.0;
lidPlaneThickness   = 2.0;

//-- Total height of box = basePlaneThickness + lidPlaneThickness 
//--                     + baseWallHeight + lidWallHeight
//-- space between pcb and lidPlane :=
//--      (bottonWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 8;
lidWallHeight       = 20;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 3.0;
ridgeSlack          = 0.2;
roundRadius         = 2.0;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 4.0;  //-- only used for showPCB
standoffPinDiameter = 4.1;
standoffHoleSlack   = 0.4;
standoffDiameter    = 10;


//-- D E B U G -----------------//-> Default ---------
showSideBySide      = false;     //-> true
onLidGap            = 0;
shiftLid            = 1;
hideLidWalls        = false;    //-> false
hideBaseWalls       = false;    //-> false
showOrientation     = true;
showPCB             = false;
showSwitches        = false;
showPCBmarkers      = false;
showShellZero       = false;
showCenterMarkers   = false;
inspectX            = 0;        //-> 0=none (>0 from front, <0 from back)
inspectY            = 0;        //-> 0=none (>0 from left, <0 from right)
inspectLightTubes   = 0;        //-> { -1 | 0 | 1 }
inspectButtons      = 0;        //-> { -1 | 0 | 1 }
//-- D E B U G ---------------------------------------


//-- pcb_standoffs  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = standoffHeight
// (3) = flangeHeight
// (4) = flangeDiam
// (5) = { yappBoth | yappLidOnly | yappBaseOnly }
// (6) = { yappHole, YappPin }
// (7) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }
pcbStands =    [
                  [3.85, 3.85, 2, 4, 12, yappBoth, yappAllCorners]
        //        , [5, 5, 4, 4, 9, yappBoth, yappBackRight]
        //        , [5, 5, 4, 4, 9, yappBaseOnly, yappFrontRight]
        //        , [5, 5, 4, 4, 9, yappBaseOnly, yappBackLeft]
               ];

//-- base plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsBase =   [
             //       [30, 0, 10, 24, yappRectangle]
             //     , [pcbLength/2, pcbWidth/2, 12, 4, yappCircle]
             //     , [pcbLength-8, 25, 10, 14, yappRectangle, yappCenter]
                ];

//-- Lid plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsLid  =   [
                [ pcbLength - 8, 15, 64, 6, 0, yappRectangle ],
             //     [20, 0, 10, 24, 0, yappRectangle]
             //   , [pcbWidth-6, 40, 12, 4, 20, yappCircle]
             //   , [30, 25, 10, 14, 45, yappRectangle, yappCenter]
                ];

//-- cutoutsGrill    -- origin is pcb[0,0,0]
// (0) = xPos
// (1) = yPos
// (2) = grillWidth
// (3) = grillLength
// (4) = gWidth
// (5) = gSpace
// (6) = gAngle
// (7) = plane { "base" | "led" }
// (7) = {polygon points}}
//
//starShape =>>> [  [0,15],[20,15],[30,0],[40,15],[60,15]
//                 ,[50,30],[60,45], [40,45],[30,60]
//                 ,[20,45], [0,45],[10,30]
//               ]
cutoutsGrill =[
              ];

//-- front plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsFront =  [
                [ 15, 2, 64, 6.5, 0, yappRectangle ],
              //      [1, -4, 37, 17, 0, yappRectangle]
              //    , [30, 7.5, 15, 9, 0, yappRectangle, yappCenter]
              //    , [0, 2, 10, 0, 0, yappCircle]
                ];

//-- back plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsBack =   [
                [ 65, (standoffHeight+pcbThickness)/2 + lidWallHeight/2 -1, 11.5, 0, 0, yappCircle],
              //      [10, 0, 10, 18, 0, yappRectangle]
              //    , [30, 0, 10, 8, 0, yappRectangle, yappCenter]
              //    , [pcbWidth, 0, 8, 0, 0, yappCircle]
                ];

//-- left plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsLeft =   [
              //    , [0, 0, 15, 20, 0, yappRectangle]
              //    , [30, 5, 25, 10, 0, yappRectangle, yappCenter]
              //    , [pcbLength-10, 2, 10, 0, 0, yappCircle]
                ];

//-- right plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsRight =  [
              //      [0, 0, 15, 7, 0, yappRectangle]
              //    , [30, 10, 25, 15, 0, yappRectangle, yappCenter]
              //    , [pcbLength-10, 2, 10, 0, 0, yappCircle]
                ];

//-- connectors 
//-- normal         : origen = box[0,0,0]
//-- yappConnWithPCB: origen = pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = pcbStandHeight
// (3) = screwDiameter
// (4) = screwHeadDiameter
// (5) = insertDiameter
// (6) = outsideDiameter
// (7) = flangeHeight
// (8) = flangeDiam
// (9) = { yappConnWithPCB }
// (10) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }
connectors   = [ 
             //   [18, 10, 5, 2.5, 5, 4.0, 6, 4, 11, yappConnWithPCB, yappFrontRight, yappBackLeft, yappBackRight]
             // , [18, 10, 5, 2.5, 5, 4.0, 6, yappConnWithPCB, yappFrontLeft]
             // , [10, 10, 5, 2.5, 5, 5.0, 6, 4, 8, yappAllCorners]
               ];

//-- base mounts -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = screwDiameter
// (2) = width
// (3) = height
// (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (5) = { yappCenter }
baseMounts   =  [
                [25, 5, 10, 5, yappLeft, yappRight ],
              //  [pcbWidth - 25, 5, 10, 5, yappBack, yappFront ],
              //      [-5, 3.3, 10, 3, yappLeft, yappRight, yappCenter]
              //    , [40, 3, 8, 3, yappBack, yappFront]
              //    , [4, 3, 34, 3, yappFront]
              //    , [25, 3, 3, 3, yappBack]
                ];

//-- snap Joins -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = width
// (2..5) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (n) = { yappSymmetric }
snapJoins   =   [
                  [pcbLength /4, 5, yappLeft, yappRight, yappSymmetric]
                //, [(pcbLength/2)+6, 3, yappLeft]
                //, [(pcbLength/2)+6, 3, yappRight]

              //    [2,               5, yappLeft, yappRight, yappSymmetric]
              //    [5,              10, yappLeft]
              //  , [shellLength-2,  10, yappLeft]
              //  , [20,             10, yappFront, yappBack]
              //  , [2.5,             5, yappBack,  yappFront, yappSymmetric]
                ];
               
//-- lightTubes  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = tubeLength
// (3) = tubeWidth
// (4) = tubeWall
// (5) = abovePcb
// (6) = througLid {yappThroughLid}
// (7) = tubeType  {yappCircle|yappRectangle}
lightTubes = [
              //--- 0,  1, 2,   3, 4, 5, 6/7
               //   [15, 20, 1.5, 5, 1, 2, yappRectangle]
               //,  [15, 30, 1.5, 5, 1, 2, yappRectangle, yappThroughLid]
              ];     

//-- pushButtons  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = capLength
// (3) = capWidth
// (4) = capAboveLid
// (5) = switchHeight
// (6) = switchTrafel
// (7) = poleDiameter
// (8) = buttonType  {yappCircle|yappRectangle}
pushButtons = [
              //-- 0,  1, 2, 3, 4, 5,   6, 7,   8
          //       [15, 30, 8, 8, 0, 1,   1, 3.5, yappCircle]
               // [15, 10, 8, 6, 2, 3.5, 1, 3.5, yappRectangle]
              ];     
             
//-- origin of labels is box [0,0,0]
// (0) = posx
// (1) = posy/z
// (2) = orientation
// (3) = depth
// (4) = plane {lid | base | left | right | front | back }
// (5) = font
// (6) = size
// (7) = "label text"
labelsPlane =   [
                    [5, 5, 0, 1, "lid", "Liberation Mono:style=bold", 5, "ESP12F Relay X4" ]
                ];


//========= MAIN CALL's ===========================================================
  
//===========================================================
module lidHookInside()
{
  //echo("lidHookInside(original) ..");
  
} // lidHookInside(dummy)
  
//===========================================================
module lidHookOutside()
{
  //echo("lidHookOutside(original) ..");
  
} // lidHookOutside(dummy)

//===========================================================
module baseHookInside()
{
  //echo("baseHookInside(original) ..");
  
} // baseHookInside(dummy)

//===========================================================
module baseHookOutside()
{
  //echo("baseHookOutside(original) ..");
  
} // baseHookOutside(dummy)




//---- This is where the magic happens ----
YAPPgenerate();
