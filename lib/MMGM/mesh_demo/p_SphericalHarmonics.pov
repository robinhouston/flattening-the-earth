#version 3.5;
#include "param.inc"
global_settings {assumed_gamma 1.0}

//info: http://astronomy.swin.edu.au/pbourke/geometry/sphericalh/
//lots of examples:    http://www.lifesmith.com/spharmin.html

//#declare M=array[8]{1,1,4,4,1,1,1,1}
//#declare M=array[8]{1,1,4,4,1,9,2,5}
//#declare M=array[8]{1,3,4,4,1,4,4,1}
//#declare M=array[8]{1,2,3,7,7,0,3,3}
//#declare M=array[8]{5,3,5,3,5,3,5,3}
//#declare M=array[8]{3,4,3,2,6,3,0,1}
#declare M=array[8]{0,4,3,1,0,1,3,2}
//#declare M=array[8]{0,1,2,2,2,4,1,2}

#declare R=function(phi,theta){
    (pow(sin(M[0]*phi),  M[1])
    +pow(cos(M[2]*phi),  M[3])
    +pow(sin(M[4]*theta),M[5])
    +pow(cos(M[6]*theta),M[7]))
}

#declare F1= function(phi,theta){(1+R(phi,theta)) * sin(phi) * cos(theta)}
#declare F2= function(phi,theta){(1+R(phi,theta)) * cos(phi)}
#declare F3= function(phi,theta){(1+R(phi,theta)) * sin(phi) * sin(theta)}

camera {location <0,6,-17> look_at <0,0,0> angle 45} 
light_source { <500,500,-500> rgb <1,0.9,0.8> }
light_source { <-100,100,-500> rgb <0.3,0.3,0.5> }

object{ 
   Parametric(
      F1, F2, F3,
      <0, FromV(0)>, <pi, 2*pi>,
      50,100,""
   )
   uv_mapping
   pigment{
      gradient y 
      colour_map {
         [0, rgb <1,0,0>]
         [0.5, rgb <0,0,1>]
         [1, rgb <1,0,0>]
      }
   }
   finish {specular 0.4}
   rotate <0,-25,0>
}

