#version 3.5;

#include "param.inc"

global_settings {assumed_gamma 1.0}

camera {
   location  <0,0,-7>
   look_at   <0,0,0>
} 

light_source { <500,500,-500> rgb <1,0.9,0.8> }
light_source { <-100,100,-500> rgb <0.3,0.3,0.5> }

#declare F1= function(u,v){u} 
#declare F2= function(u,v){v} 
#declare F3= function(u,v){0}

object{ 
   Parametric(
      F1, F2, F3,
      <-3, -3>,
      < 3, 3>,
      25,25,""
   )
   pigment{rgb 1}
}

