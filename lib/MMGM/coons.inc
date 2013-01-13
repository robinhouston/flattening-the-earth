// Persistence of Vision Ray Tracer Include File
// File: coons.inc
// Vers: 3.5
// Desc: Macro that creates a bilinear interpolated "coons surface". The result
//       is a mesh2 object.
// Date: 2002/04/27
// Auth: Ingo Janssen

#version 3.5;
#include "makemesh.inc"

/*======
Coons(Spl1, Spl2, Spl3, Spl4, Iter_U, Iter_V, FileName): Generates a "coons
           surface". The surface is defined by four splines, all attached head
           to tail to the previous / next one.
           The uv_coordinates come from the square <0,0> - <1,1>.

Spl1 - 4 : The four spline that define the surface.
           The splines are evaluated from t=0 to t=1.
Iter_U   : The resolution for the splines 1 and 3.
Iter_V   : The resolution for the splines 2 and 4.
FileName : The name of the file to whitch the mesh will be written. If is an
           empty string (""), no file will be written.
           If the file extension is 'obj' a Wavefront objectfile will be written.
           If the extension is 'pcm' a compressed mesh file is written.
           If a file name is given, the macro will first check if it already exists.
           If that is so, it will try to parse the existing file unless it's a '*.obj',
           '*.pcm' or '*.arr' file as POV-Ray can not read them directly. In this case a new
           mesh will be generated, but the existing files will _not_ be over-written.
*/

#macro Coons(Spl1, Spl2, Spl3, Spl4, Iter_U, Iter_V, FileName)
   #declare Build=CheckFileName(FileName);
   #if(Build=0)
      #debug concat("\n Parsing mesh2 from file: ", FileName, "\n")
      #include FileName
      object{Surface}
   #else
      #local NumVertices=(Iter_U+1)*(Iter_V+1);
      #local NumFaces=Iter_U*Iter_V*2;
      #debug concat("\n Calculating ", str(NumVertices,0,0), " vertices for ",str(NumFaces,0,0), " triangles\n\n")
      #declare VecArr=array[NumVertices]   
      #declare NormArr=array[NumVertices]   
      #local UVArr=array[NumVertices]      
      #local Spl1_0=Spl1(0);
      #local Spl2_0=Spl2(0);
      #local Spl3_0=Spl3(0);
      #local Spl4_0=Spl4(0);
      #local UStep=1/Iter_U;
      #local VStep=1/Iter_V;
      #local Count=0;
      #local I=0;
      #while (I<=1)
         #local Im=1-I;
         #local J=0;
         #while (J<=1)
            #local Jm=1-J;
            #local C0=Im*Jm*(Spl1_0)+Im*J*(Spl2_0)+I*J*(Spl3_0)+I*Jm*(Spl4_0);
            #local P0=LInterpolate(I, Spl1(J), Spl3(Jm)) + 
               LInterpolate(Jm, Spl2(I), Spl4(Im))-C0;
            #declare VecArr[Count]=P0;
            #local UVArr[Count]=<J,I>;
            #local J=J+UStep;
            #local Count=Count+1;
         #end
         #debug concat(
            "\r Done ", str(Count,0,0)," vertices :         ",
            str(100*Count/NumVertices,0,2)," %"
         )
         #local I=I+VStep;
      #end
      #debug "\r Normals                                  "
      #local Count=0;
      #local I=0;
      #while (I<=Iter_V)
         #local J=0;
         #while (J<=Iter_U)
            #local Ind=(I*Iter_U)+I+J;
            #local P0=VecArr[Ind];
            #if(J=0)
               #local P1=P0+(P0-VecArr[Ind+1]);
            #else
               #local P1=VecArr[Ind-1];
            #end
            #if (J=Iter_U)
               #local P2=P0+(P0-VecArr[Ind-1]);
            #else
               #local P2=VecArr[Ind+1];
            #end
            #if (I=0)
               #local P3=P0+(P0-VecArr[Ind+Iter_U+1]);
            #else
               #local P3=VecArr[Ind-Iter_U-1];                       
            #end
            #if (I=Iter_V)
               #local P4=P0+(P0-VecArr[Ind-Iter_U-1]);
            #else
               #local P4=VecArr[Ind+Iter_U+1];
            #end
            #local B1=P4-P0;
            #local B2=P2-P0;
            #local B3=P3-P0;
            #local B4=P1-P0;
            #local N1=vcross(B1,B2);
            #local N2=vcross(B2,B3);
            #local N3=vcross(B3,B4);
            #local N4=vcross(B4,B1);
            #local Norm=vnormalize((N1+N2+N3+N4));      
            #declare NormArr[Count]=Norm;
            #local J=J+1;
            #local Count=Count+1;
         #end
         #debug concat("\r Done ", str(Count,0,0)," normals : ",str(100*Count/NumVertices,0,2), " %")
         #local I=I+1;
      #end
      BuildWriteMesh2(VecArr, NormArr, UVArr, Iter_U, Iter_V, FileName)
   #end
#end
