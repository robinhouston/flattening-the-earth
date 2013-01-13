// Persistence of Vision Ray Tracer Include File
// File: twovarsurf.inc
// Vers: 3.5
// Desc: Generates a surface based on a function with two variables.
// Date: 2001/04/27
// Auth: Ingo Janssen

// rev. 2002/22/10: For uv-mapping the texture is now taken from <0,0>-<1,1>,
//                  this used to be <UVmin>-<UVmax>. So this may break some scenes!

/*======
TwoVarSurf(__Fuv, Urange, Vrange, Iter_U, Iter_V, FileName): Builds a mesh2 surface of
           a function with two variables (u,v).
__Fuv    : the function to be turned into a mesh2.
Urange   : A 2-D vector that gives the boundaries of u.
Vrange   : A 2-D vector that gives the boundaries of v. These are the ranges
           within whitch the surface is calculated. 
Iter_U   : Sets the resolution of the mesh in the u range.
Iter_V   : Sets the resolution of the mesh in the v range.
FileName : The name of the file to whitch the mesh will be written. If is an
           empty string (""), no file will be written.
           If the file extension is 'obj' a Wavefront objectfile will be written.
           If the extension is 'pcm' a compressed mesh file is written.
           If a file name is given, the macro will first check if it already exists.
           If that is so, it will try to parse the existing file unless it's a '*.obj',
           '*.pcm' or '*.arr' file as POV-Ray can not read them directly. In this case a new
           mesh will be generated, but the existing files will _not_ be over-written.
Use:

   #include twovar.inc
   
   #declare __Fuv=function(u,v){(10*sin((u^2+v^3)^0.5))/(2+cos((u^2+y^2)^0.5))}
   
   object {
      TwoVarSurf(<-6,6>,<-6,6>,20,20,"")
      uv_mapping
      pigment{checker color rgb <0,0,0.2> color rgb <1,0.85,0.85> scale 0.5}
      finish{specular 0.4}
      rotate <-110,45,0>
   }           
*/

#version 3.5;
#include "makemesh.inc"

#macro TwoVarSurf(__Fuv, Urange, Vrange, Iter_U, Iter_V, FileName)
   #declare Build=CheckFileName(FileName);
   #if(Build=0)
      #debug concat("\n Parsing mesh2 from file: ", FileName, "\n")
      #include FileName
      object{Surface}
   #else
      #local Umin=Urange.u;
      #local Umax=Urange.v;
      #local Vmin=Vrange.u;
      #local Vmax=Vrange.v;
      #local dU=Umax-Umin;
      #local dV=Vmax-Vmin;
      #local iU=dU/Iter_U;
      #local iV=dV/Iter_V;
      #local NumVertices=(Iter_U+1)*(Iter_V+1);
      #declare NumFaces=Iter_U*Iter_V*2;
      #debug concat("\n Calculating ",str(NumVertices,0,0)," vertices for ", str(NumFaces,0,0)," triangles\n\n")
      #local VecArr=array[NumVertices] 
      #local NormArr=array[NumVertices] 
      #local UVArr=array[NumVertices]
      #local Count=0;   
      #local I=0;  
      #while (I<Iter_V+1)
         #local V=RangeMM(I,0,Iter_V,Vmin,Vmax);
         #local J=0;
         #while (J<Iter_U+1)
            #local U=RangeMM(J,0,Iter_U,Umin,Umax);
            #if(J=0)
               #local P0=<U,V,__Fuv(U,V)>;
               #local P2=<U-iU,V,__Fuv(U-iU,V)>;
            #else
               #local P0=P1;
               #local P2=P0;
            #end
            #local P1=<U+iU,V,__Fuv(U+iU,V)>;
            #local P3=<U,V+iV,__Fuv(U,V+iV)>;
            #local P4=<U,V-iV,__Fuv(U,V-iV)>;
            #local B1=P4-P0;
            #local B2=P2-P0;
            #local B3=P3-P0;
            #local B4=P1-P0;
            #local N1=vcross(B1,B2);
            #local N2=vcross(B2,B3);
            #local N3=vcross(B3,B4);
            #local N4=vcross(B4,B1);
            #local Norm=vnormalize((N1+N2+N3+N4));
            #local VecArr[Count]=P0;  
            #local NormArr[Count]=Norm;  
            #local UVArr[Count]=<(U-Umin)/dU,(V-Vmin)/dV>;
            #local Count=Count+1;
            #local J=J+1;            
         #end
         #debug concat("\r Done ", str(Count,0,0)," vertices : ",str(100*Count/NumVertices,0,2)," %")
         #local I=I+1;
      #end
      BuildWriteMesh2(VecArr, NormArr, UVArr, Iter_U, Iter_V, FileName)
   #end
#end

