// Persistence of Vision Ray Tracer Scene Description File
// File: lathe.pov
// Vers: 3.5
// Desc:
// Date: 2001-11-09
// Auth: Ingo Janssen

#version 3.5;
#include "lathe.inc"

global_settings {assumed_gamma 1.0}
camera {location <0,2,-5.5> look_at <0,2,0>}
light_source {<500,500,-500> rgb <0.8,0.9,1>}
light_source {<-10,3,0> rgb <1,1,0.8>}

#declare S1=spline{
   cubic_spline
  -0.1, <-1.50,0,0>
   0, < 0.00, 0.00,0>
   0.1, < 0.90, 0.00, 0>
   0.2, < 1.00, 0.00, 1>
   0.3, < 0.80, 0.05, 0>
   0.4, < 0.20, 0.10, 0>
   0.5, < 0.05, 1.00, 0>
   0.6, < 0.15, 1.70, 0>
   0.7, < 0.70, 2.00, 0>
   0.8, < 1.50, 2.50, 0>
   0.9, < 0.70, 3.50, -0.3>
   1.0, < 0.00, 4.00, 0>
   1.1, <-0.01, 4.00, 0>
}

object {
   Lathe(S1, 100, -250, 50, "")
   uv_mapping 
   pigment{checker color rgb <0,0,0.2> color rgb <1,0.85,0.85> scale 0.05}
   finish{specular 0.4}
}

