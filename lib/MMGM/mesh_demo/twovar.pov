// Persistence of Vision Ray Tracer Scene Description File
// File: twovarturf.pov
// Vers: 3.5
// Desc: Basic Scene Example
// Date: 2002/04/27
// Auth: Ingo Janssen
//

#version 3.5;
#include "twovar.inc"

global_settings {assumed_gamma 1.0}
camera { location  <0, 4.5, -14.0> look_at <0,-1.5,0>}
light_source {<500,500,-500> rgb 1}

#declare F1=function{pattern{wood sine_wave turbulence 0.2}}
#declare F2=function(u,v){F1(u/3,v/3,0)}

object {
   TwoVarSurf(F2,<-6,6>,<-6,6>,200,200,"")
   uv_mapping
   pigment{checker color rgb <0,0,0.2> color rgb <1,0.85,0.85> scale 1/6}
   finish{specular 0.4}
   rotate <-110,45,0>
}

