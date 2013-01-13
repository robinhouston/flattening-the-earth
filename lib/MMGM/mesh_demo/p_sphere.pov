#version 3.5;
#include "param.inc"

global_settings {assumed_gamma 1.0}

camera {location <0,0,-3> look_at <0,0,0>} 
light_source { <500,500,-500> rgb <1,0.9,0.8> }
light_source { <-100,100,-500> rgb <0.3,0.3,0.5> }

/*#declare R=1;
#declare F1=function(u,v){R*sin(v)*cos(u)}
#declare F2=function(u,v){R*cos(v)}
#declare F3=function(u,v){R*sin(v)*sin(u)}
*/

#declare R=0.75;  //base radius of sphere
#declare D=0.5;   //depth
#declare FR=function{pattern{bozo scale 0.3}}
#declare F1=function(u,v){((FR(u,v,0)*D)+R)*sin(v)*cos(u)}
#declare F2=function(u,v){((FR(u,v,0)*D)+R)*cos(v)}
#declare F3=function(u,v){((FR(u,v,0)*D)+R)*sin(v)*sin(u)}

object { 
  Parametric (
    F1, F2, F3,
    <0, FromV(0)>, <2*pi, pi>,
    200, 100,""
  )
  pigment {uv_mapping bozo scale 0.3}
  finish{specular 0.3}
  rotate <0,0,0>
}


