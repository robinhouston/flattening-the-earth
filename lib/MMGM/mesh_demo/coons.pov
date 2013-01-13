// Persistence of Vision Ray Tracer Scene Description File
// File: Coons.pov
// Vers: 3.5
// Desc:
// Date: 2002/04/27
// Auth: Ingo Janssen

#version 3.5;
#include "coons.inc"

global_settings {assumed_gamma 1}
light_source {<500,500,-500> rgb 1}
light_source {<-500,50,-250> rgb <0.4,0.3,0.3>}
camera {
   location <0,1.0,-5.5>
   look_at <0,0,0>
   angle 45
}

#ifndef(CLOCK)
   #if(clock_on=0)
      #declare CLOCK=clock;
   #else
      #declare CLOCK=0.25;
   #end
#end

#declare Point1=vrotate(<1.2, 0,0>,<0,0,-CLOCK*360>)+< 1,0,0>;
#declare Point2=vrotate(<0.0,-1,0>,<0,0, CLOCK*720>)+<-1,0,0>;

#declare Spl888=spline {
   linear_spline
  -1.00    ,<-2.0, 0.0,-1>
   0.0     ,<-1.0, 0.0,-1>   //first point = last point Spl4
   0.25    ,<-0.5,-1.0,-1>
   0.50    ,< 0.0,-0.5,-1>
   0.75    ,< 0.5,-1.0,-1>
   1.00    ,< 1.0, 0.0,-1>   //last point = first point Spl2
   2.00    ,< 2.0, 0.0,-1>
}
#declare Spl2=spline {
   natural_spline
  -1.0     ,<1, 0,-2>
   0.000001,<1, 0,-1>       //first point = last point Spl1
   0.5     ,Point1
   1.0     ,<1, 0, 1>       //last point = first point Spl3
   2.0     ,<1, 0, 2>       
}
#declare Spl3=spline {
   cubic_spline
  -1.00    ,< 2.00, 0.0, 1.0>
   0.000001,< 1.00, 0.0, 1.0>    //first point = last point Spl2
   0.25    ,< 0.50, 0.0, 1.0>
   0.40    ,< 0.20, 1.0, 0.5>
   0.50    ,< 0.00, 0.8, 0.0>
   0.60    ,<-0.20, 1.0, 0.5>
   0.75    ,<-0.50, 0.0, 1.0>
   1.00    ,<-1.00, 0.0, 1.0>    //last point = first point Spl4
   2.00    ,<-2.00, 0.0, 1.0>
}
#declare Spl4=spline {
   quadratic_spline
  -1.0     ,<-1, 0, 2>       
   0.000001,<-1, 0, 1>           //first point = last point Spl3
   0.5     ,Point2
   1.0     ,<-1, 0,-1>           //last point = first point Spl1
   2.0     ,<-1, 0,-2>
}

object {
   Coons(Spl888, Spl2, Spl3, Spl4, 50, 50, "")
   uv_mapping
   texture {
      pigment {
         marble
         turbulence <0.3,0,0>
         translate <-0.5,0,0>
         scale <0.05,1,1>
         rotate <0,0,45>
         warp {repeat 0.5*x flip x}
         warp {repeat 0.5*y flip y}
         colour_map {
            [0, rgbf 0]
            [1, rgbf <1,1,1,0.6>]
         }
      }
      finish {
         specular 0.4
         roughness 0.05
         irid {
            0.3
            thickness 0.2
            turbulence 0.1
         }      
      }
   }
}

//Show the Splines

#declare I=0;
#declare N=500;
#while(I<=N)
   sphere{
      Spl888(I/N),0.01
      no_shadow
      pigment{rgb <0,0,1>} 
   }
   sphere{
      Spl2(I/N),0.02
      no_shadow
      pigment{rgb <1,0,0>} 
   }
   sphere{
      Spl3(I/N),0.01
      no_shadow
      pigment{rgb <0,0,1>} 
   }
   sphere{
      Spl4(I/N),0.02
      no_shadow
      pigment{rgb <1,1,0>} 
   }
   #declare I=I+1;
#end
