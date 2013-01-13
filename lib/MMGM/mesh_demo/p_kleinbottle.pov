// Persistence of Vision Ray Tracer Include File
// File: param.inc
// Vers: 3.5
// Desc: Klein Bottle 
// Date: 2001-11-03
// Auth: Ingo Janssen

#version 3.5;
#include "param.inc"
global_settings {assumed_gamma 1.0}
camera {location <2,-6,-25> look_at <4,-2,0>} 
light_source { <-500,20,-100> rgb <0.3,0.3,0.5>*0.75 }
light_source { 
  <5,-10,-16>
  rgb <1,0.9,0.8>
}


//Klein-bottle
#declare R=function(u){4*(1-cos(u)/2)}
#declare F1=function(u,v){ 
  select(
    u<=pi,
    (6*cos(u)*(1+sin(u))+(R(u)*cos(v+pi))),  
    (6*cos(u)*(1+sin(u))+(R(u)*cos(v+pi))),  
    (6*cos(u)*(1+sin(u))+(R(u)*cos(u)*cos(v)))
  )
}
#declare F2=function(u,v){ 
  select(
    u<=pi,
    (16*sin(u)),  
    (16*sin(u)),  
    (16*sin(u)+(R(u)*sin(u)*cos(v)))
  )
}
#declare F3=function(u,v){R(u)*sin(v)}
object {
   Parametric(
      F1, F2, F3,
      <0, 0>,
      <2*pi, 2*pi>,
      75,75,""
   )
   texture {
      crackle
      texture_map {
         [0.05, pigment{crackle color_map{[0,rgb 0][1,rgb 0]}}finish{specular 0.01 roughness 0.5}]
         [0.05, pigment{crackle color_map{[0,rgb 0][1,rgb 0]}}finish{specular 0.2}]
      }
   }
   
   rotate <0,95,0>
   rotate <65,0,0>
   rotate <0,-35,0>
}