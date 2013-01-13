// Persistence of Vision Ray Tracer Scene Description File
// File: prism.pov
// Vers: 3.5
// Desc: Macros to build a mesh2 prism object from a spline.
//       It is extruded along the y-axis.
// Date: 2002/04/27
// Auth: Ingo Janssen

#version 3.5;
#include "prism.inc"

global_settings {assumed_gamma 1.0}
camera {location <0,1,-4.5> look_at <0,1,0>}
light_source {<500,500,-500> rgb <0.8,0.9,1>}
light_source {<-10,3,0> rgb <1,1,0.8>*0.3}

#declare Spl_1=spline {
   cubic_spline
  -1/4, <-1,-0.5,-1>
     0, < 1, 0.0,-1>  //first point
   1/4, < 1, 0.0, 1>
   2/4, <-1, 1.5, 1>
   3/4, <-1,-0.5,-1>
   4/4, < 1, 0.0,-1>  //last point
   5/4, < 1, 0.0, 1>
}

object {
   Prism(Spl_1, 100, 2, 100, "")
   uv_mapping 
   pigment{checker color rgb <0,0,0.3> color rgb <1,0.85,0.85> scale <0.48,0.1,1>}
   finish{specular 0.4}
}
   