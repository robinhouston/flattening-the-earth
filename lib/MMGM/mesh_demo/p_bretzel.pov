// Persistence of Vision Ray Tracer Include File
// File: param.inc
// Vers: 3.5
// Desc: An include file to generate a mesh2 of smooth_triangles 
//       with uv_vectors from a set of parametric functions. 
// Date: 2001-11-03
// Auth: Ingo Janssen

#version 3.5;

#include "param.inc"

global_settings {assumed_gamma 1.0}

camera {
   location  <0,10,-16>
   look_at   <0,0,0>
} 

light_source { <500,500,-500> rgb <1,0.9,0.8> }
light_source { <-100,100,-500> rgb <0.3,0.3,0.5> }

#declare R=function(u,v){cos(v)*1.5}
#declare F1= function(u,v){(4+R(u,v)*cos(u)+4*pow(cos(v*0.5),2))*cos(2*v)} 
#declare F2= function(u,v){(4+R(u,v)*cos(u)+4*pow(cos(v*0.5),2))*sin(2*v)} 
#declare F3= function(u,v){R(u,v)*sin(u)+(4*sin(v))}

object { 
   Parametric(
      F1, F2, F3,
      <0, FromV(0)>,
      <2*pi, 2*pi>,
      50,200,""
   )
   uv_mapping
   texture {
      pigment {
         marble
         turbulence <0.3,0,0>
         translate <-0.5,0,0>
         scale <0.05,1,1>
         rotate <0,0,45>
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
   rotate <90,0,0>
}
