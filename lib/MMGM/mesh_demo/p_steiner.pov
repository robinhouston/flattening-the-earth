#version 3.5;
#include "param.inc"

global_settings {assumed_gamma 1.0}

camera {location <0,5,-17> look_at <0,-2, 0>} 
light_source { <500,500,-500> rgb <1,0.9,0.8>}
light_source { <-100,100,-500> rgb <0.3,0.3,0.5>}

//steiner
#declare F1= function(u,v){2*u*cos(v)*(pow((1-pow(u,2)),0.5))}
#declare F2= function(u,v){2*u*sin(v)*(pow((1-pow(u,2)),0.5))}
#declare F3= function(u,v){1-2*(pow(u,2))*(pow(cos(v),2))}      

object{ 
   Parametric(
      F1, F2, F3,
      <FromU(0), FromV(0)>, <ToU(1), 2*pi>,
      50, 100, ""
   )
   uv_mapping
   pigment {
      marble
      turbulence <0.3,0,0>
      translate <-0.5,0,0>
      scale <0.05,1,1>
      rotate <0,0,90>
      warp {repeat 0.5*x flip x}
      warp {repeat 0.5*y flip y}
      scale <1,pi/2,1>
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
   scale 7
   rotate <135,0,0>
   rotate <0,-25,0>
}


