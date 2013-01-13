#version 3.5;
#include "param.inc"

global_settings {assumed_gamma 1.0}
camera {location <0,0.5,-6> look_at <0,0,0>} 
light_source { <500,500,-500> rgb <1,0.9,0.8> }
light_source { <-100,100,-500> rgb <0.3,0.3,0.5> }

//klein-ish
#declare F1= function(u,v){cos(u)*(cos(u/2)*(sqrt(2)+cos(v))+(sin(u/2)*sin(v)*cos(v)))}
#declare F2= function(u,v){sin(u)*(cos(u/2)*(sqrt(2)+cos(v))+(sin(u/2)*sin(v)*cos(v)))}
#declare F3= function(u,v){-1*sin(u/2)*(sqrt(2)+cos(v))+cos(u/2)*sin(v)*cos(v)}

object{ 
   Parametric(
      F1, F2, F3,
      <-2*pi,-2*pi>, < 2*pi, 2*pi>,
      100,100,""
   )
   uv_mapping
   pigment{rgb 1}
   pigment {
      marble
      scale <.05,.05,.05>
      rotate <45,0,0>
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
   rotate <-90,0,0>
   rotate <0,45,0>
}


