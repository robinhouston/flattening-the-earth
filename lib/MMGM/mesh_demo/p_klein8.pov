#version 3.5;
#include "param.inc"

global_settings {assumed_gamma 1.0}

camera {location <0,0.5,-7> look_at <0,-0.3,0>} 
light_source { <500,500,-500> rgb <1,0.9,0.8> }
light_source { <-100,100,-500> rgb <0.3,0.3,0.5> }

#declare a=2;
#declare F1= function(u,v){(a+cos(u/2)*sin(v)-sin(u/2)*sin(2*v))*cos(u)}
#declare F2= function(u,v){(a+cos(u/2)*sin(v)-sin(u/2)*sin(2*v))*sin(u)}
#declare F3= function(u,v){sin(u/2)*sin(v)+cos(u/2)*sin(2*v)}

object{ 
   Parametric(
      F1, F2, F3,
      <-pi, -pi>, < pi, pi>,
      100,100,""
   )
   uv_mapping
   pigment {
      marble
      scale <0.1,0.25,1>
      rotate <0,0,90>
      warp {repeat 0.5*x flip x}
      warp {repeat 0.5*y flip y}
      translate<-0.5,-0.5,0>
      colour_map {
         [0, rgbf 0.0]
         [1, rgbf <1,1,1,0.8>]
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
   rotate<40,0,0>
   rotate<0,33,0>
}

