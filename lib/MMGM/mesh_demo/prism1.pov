// Persistence of Vision Ray Tracer Scene Description File
// File: prism1.pov
// Vers: 3.5
// Desc: Macro to build a mesh2 prism object from a spline.
//       It is extruded along the y-axis and uses a second 
//       spline for scaling the steps of the extrusion.
// Date: 200204/27
// Auth: Ingo Janssen

#version 3.5;
#include "prism.inc"

global_settings {assumed_gamma 1.0}
camera {location <0,1,-5> look_at <0,1,0> /*orthographic*/}
light_source {<500,500,-500> rgb <0.8,0.9,1>}
light_source {<-10,3,0> rgb <1,1,0.8>}

#declare Spl_1=spline {
   cubic_spline
   -1/2, < 0, 0,-1>
    0.0, < 1, 0, 0>  //first point
    1/2, < 0, 0, 1>
    2/2, <-1, .5, 0>  //last point
    3/2, < 0, 1,-1>
}

#declare Spl_2=spline {
   linear_spline
   -1/4, < 0.0, 1.0, 0>
    0.0, < 1.0, 0.0, 0>  //first point
    1/4, < 2.0, 1.0, 0>
    2/4, < 1.0, 3.0, 0>
    3/4, < 0.5, 1.0, 0>
    4/4, < 1.0, 0.0, 0>  //last point
    5/4, < 2.0, 1.0, 0>
}

//Spl_1 is extruded along the y-axis and
//is scaled depending on Spl_2
object {
   Prism1(Spl_1, 50, Spl_2, 50,"")
   uv_mapping
   pigment{checker color rgb<0,0,0.2> color rgb <1,0.85,0.85> scale <0.025,0.2,1>}
   finish{specular 0.4}
}

//Show Splines
#declare I=0;
#declare N=500;
#while(I<=N)
   sphere{
      Spl_1(I/N),0.05
      no_shadow
      pigment{rgb <0,0,1>} 
   }
   sphere{
      Spl_2(I/N),0.05
      no_shadow
      pigment{rgb <1,0,0>} 
   }
   #declare I=I+1;
#end
