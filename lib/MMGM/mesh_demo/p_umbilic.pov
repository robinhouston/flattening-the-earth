// Persistence of Vision Ray Tracer Scene Description File
// File: p_umbilic.pov
// Vers: 3.5
// Desc: Demo scene showing various ways of generating a
//       parametric surface. An umbilic torus
// Date: 2002/10/20
// Auth: Ingo


#version 3.5;

#include "param.inc"

global_settings {assumed_gamma 1.0}
camera {location <0,0.5,-20> look_at <-1,0,0>} 
light_source {<500,500,-500> rgb <1,0.9,0.8>}
light_source {<-100,100,-500> rgb <0.3,0.3,0.5>}


#declare Set=1; //1, 2, 3 or 4

#switch (Set)
  #case (1)
    // The set of functions is not declared, but directly defined in Parametric.
  #break
  
  #case (2)
    // Set below is for use with Parametric. 
    #declare F1= function(u,v){sin((u/3)-(2*v)) + 2*sin((u/3)+v)}
    #declare F2= function(u,v){cos(u)*((7+cos((u/3)-(2*v))+(2*cos((u/3)+v))))}
    #declare F3= function(u,v){sin(u)*((7+cos((u/3)-(2*v))+(2*cos((u/3)+v))))}
  #break
  
    // The two sets below are for use with Paramcalc. The functions or macros
    // need to have the names __Fx, __Fy, __Fz.
  #case (3)
    #declare __Fx= function(u,v){sin((u/3)-(2*v)) + 2*sin((u/3)+v)}
    #declare __Fy= function(u,v){cos(u)*((7+cos((u/3)-(2*v))+(2*cos((u/3)+v))))}
    #declare __Fz= function(u,v){sin(u)*((7+cos((u/3)-(2*v))+(2*cos((u/3)+v))))}
  #break
  
  #case (4)
    #macro __Fx(U,V)sin((U/3)-(2*V)) + 2*sin((U/3)+V)#end               
    #macro __Fy(U,V)cos(U)*((7+cos((U/3)-(2*V))+(2*cos((U/3)+V))))#end
    #macro __Fz(U,V)sin(U)*((7+cos((U/3)-(2*V))+(2*cos((U/3)+V))))#end
  #break
#end


object {
  
  #if (Set=1) 
    Parametric(
      function(u,v){sin((u/3)-(2*v)) + 2*sin((u/3)+v)}             
      function(u,v){cos(u)*((7+cos((u/3)-(2*v))+(2*cos((u/3)+v))))}
      function(u,v){sin(u)*((7+cos((u/3)-(2*v))+(2*cos((u/3)+v))))}
      <-pi, -pi>, < pi, pi>,
      50,50,""
    )
  #end

  #if (Set=2) 
    Parametric(
      F1, F2, F3,
      <-pi, -pi>, < pi, pi>,
      50,50,""
    )
  #end
    
  #if (Set=3 | Set=4)
    Paramcalc(
       <-pi, -pi>, < pi, pi>,
       50,50,""
    )
  #end
  
  pigment {rgb 1}
  rotate <0,55,0>
  rotate <25,0,0>
}