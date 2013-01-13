// Persistence of Vision Ray Tracer Scene Description File
// File: .pov
// Vers: 3.5
// Desc:
// Date:
// Auth: based on work by Mike Williams http://www.econym.demon.co.uk

#version 3.5;
#include "param.inc"
global_settings {assumed_gamma 1.0}

#macro pLathe(Spline)
  #local __S=function{spline{Spline}}
  Parametric(
    function(x,y){(__S(u).x * sin(v)/2)},
    function(x,y){u},
    function(x,y){(__S(u).x * cos(v)/2)},
    <0,0>, <1,2*pi>,
    20,20,""
  )
#end

camera { location  <0, 0.5, -5> look_at <0, 0.5, 0> angle 30 }

light_source { <500,500,-500> rgb <1,0.9,0.8> }
light_source { <-100,100,-500> rgb <0.3,0.3,0.5> }

#declare Spl =spline {
  cubic_spline
  -1 , < 1, 0, 0>,
  0  , < 1, 0, 0>,
  0.3, < 0.2, 0, 0>,
  0.7, < 0.2, 0, 0>,
  1.0, < 1, 0, 0>,
  2  , < 1, 0, 0>
}

object{ 
   pLathe(Spl)
   uv_mapping
   pigment {rgb 1}
}    
  
  