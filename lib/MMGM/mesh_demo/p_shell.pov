#version 3.5;

#include "param.inc"

global_settings {assumed_gamma 1.0}

camera {
   location  <0,5,-10>
   look_at   <0,1.5,0>
   angle 50
} 

light_source { <500,500,-500> rgb <1,0.9,0.8> }
light_source { <-100,100,-500> rgb <0.3,0.3,0.5> }

#declare Tex1=texture {
   pigment {
      marble
      turbulence <0.1,0,0>
      translate <-0.5,0,0>
      scale <0.05,1,1>
      rotate <0,0,90>
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

//shell
#declare a=0.3; #declare b=1; 
#declare c=0.2; #declare n=3;
#declare F1= function(u,v){(a*(1-v/(2*pi))*cos(n*v)*(1+cos(u))+c*cos(n*v))} 
#declare F2= function(u,v){(a*(1-v/(2*pi))*sin(n*v)*(1+cos(u))+c*sin(n*v))} 
#declare F3= function(u,v){(b*v/(2*pi)+a*(1-v/(2*pi))*sin(u))}

object{ 
   Parametric(
      F1, F2, F3,
      <0, 0>, <2*pi, ToV(2*pi)>,
      50,100,""
   )
   uv_mapping
   texture{Tex1}
   scale 5
   rotate <-90,0,0> 
   rotate <0,120,0>
   rotate <0,0,-25>
   rotate <20,0,0>
}