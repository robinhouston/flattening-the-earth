#version 3.5;

#include "param.inc"

global_settings {assumed_gamma 1.0}
camera {
   location  <0,1,-10>
   look_at   <0,0,0>
   angle 20
} 
light_source { <500,500,-500> rgb <1,0.9,0.8> }
light_source { <-100,100,-500> rgb <0.3,0.3,0.5> }

#declare Crack= function {
  pigment {
    crackle
    colour_map{
      [0, rgb <0.3,0.5,0.8>]
      [1, rgb 1]
    }
  }
}
#declare R= function(u,v) {
  Crack(u,v,0).gray
}

#declare F1= function(u,v){R(u,v)*cos(u)} 
#declare F2= function(u,v){R(u,v)*sin(u)} 
#declare F3= function(u,v){v}

object{ 
   Parametric(
      F1, F2, F3,
      <0, -1>,
      <2*pi, 1>,
      250, 250, ""
   )
   uv_mapping
   pigment{rgb 1}
   finish{specular 0.5}
   rotate <60,0,0>
}
