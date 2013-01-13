// Persistence of Vision Ray Tracer Include File
// File: msm.inc
// Vers: 3.5
// Desc: 
// Date: 2001/11/09
// Auth: Ingo Janssen

#version 3.5;
#include "msm.inc"

global_settings {assumed_gamma 1.0}
camera {location <0,3.5,-12> look_at <0,1.5,0> angle 40}
light_source {<500,500,-500> rgb <0.8,0.9,1>}

#declare A1=spline {
   cubic_spline
   -0.5, < 1,-1, 0>
    0.0, < 1, 0, 0>
    0.5, < 2, 1, 0>
    1.0, < 1, 2, 0>
    1.5, < 1, 3, 0>
}
#declare A2=spline {
   cubic_spline
   -0.5, < 0,-1, 1>
    0.0, < 0, 0, 1>
    0.5, < 0, 1, 2>
    1.0, < 0, 3, 1>
    1.5, < 0, 4, 1>
}
#declare A3=spline {
   cubic_spline
   -0.5, <-1,-1, 0>
    0.0, <-1, 0, 0>
    0.5, <-2, 1, 0>
    1.0, <-1, 3, 0>
    1.5, <-2, 3, 0>
}
#declare A4=spline {
   cubic_spline
   -1/3, < 0,-1,-1>
    0.0, < 0, 0,-1>
    1/3, < 0, 1,-0.5>
    2/3, < 0, 2,-1.6>
    1.0, < 0, 2.5,-1.5>
    4/3, < 0, 3,-1>
}
#declare An=array[7]{
   spline{A4},
   spline{A1}, //first point
   spline{A2},
   spline{A3},
   spline{A4},
   spline{A1}, //last point (closes the shape)
   spline{A2}
}
object {
   MSM(An, 100, "c",  100, "")
   uv_mapping
   pigment {checker color rgb <0,0,0.6> rgb <1,0.7,0.7> scale <0.05,0.1,1>}
   finish{specular 0.5}
   rotate <0,45,0>
   translate <2,0,0>
} 

//uncomment to view splines:
#declare N=dimension_size(An,1);
#declare M=500;
#declare I=0;
union {
  #while (I<N)
     #declare Spl=spline{An[I]};
     #declare J=0;
     #while (J<=M)
        sphere {Spl(J/M), 0.04 no_shadow pigment {rgb 1}}
        #declare J=J+1;
     #end
     #declare I=I+1;
  #end
  rotate <0,45,0>
  translate <-2,0,0>
}

#declare N=dimension_size(An,1);

#declare TempSplArr=array[N];
#declare Pos=0.0;
union {
  #while(Pos<=1)   
     #declare I=0;
     #while (I<N)
        #declare Spl=spline{An[I]}
        #declare PP=<0,0,0>+Spl(Pos);
        #declare TempSplArr[I]=PP;
        #declare I=I+1;
     #end
     #declare S1=BuildSpline(TempSplArr, "c")
     #declare J=0;
     #declare M=500;
     #while (J<=M)
        sphere {S1(J/M), 0.02 no_shadow pigment {rgb <1,0,0>}}
        #declare J=J+1;
     #end
     #declare Pos=Pos+0.05;
  #end
  rotate <0,45,0>
  translate <-2,0,0>
}

