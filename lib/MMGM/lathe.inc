// Persistence of Vision Ray Tracer Scene Description File
// File: lathe.pov
// Vers: 3.5
// Desc: Macros to build a mesh2 lathe object from a spline
// Date: 2002/04/27
// Auth: Ingo Janssen

#version 3.5;
#include "makemesh.inc"

/*=======
Lathe(Spl, ResSpl, Rot, ResRot, FileName) : The Lathe  macro generates an
           object by rotating a two-dimensional curve about the y-axis. The
           result is a mesh2 object. The uv_coordinates come from the square
           <0,0> - <1,1>.

Spl      : The spline to be rotated.
           The spline is evaluated from t=0 to t=1. For the normal calculation,
           it is required that all splines (also linear_spline) have one extra
           point before t=0 and after t=1.
ResSpl   : The amount of triangles to be used along the spline
Rot      : The angle the spline has to be rotated.
ResRot   : The amount of triangles to be used in the circumference.
FileName : The name of the file to whitch the mesh will be written. If is an
           empty string (""), no file will be written.
           If the file extension is 'obj' a Wavefront objectfile will be written.
           If the extension is 'pcm' a compressed mesh file is written.
           If a file name is given, the macro will first check if it already exists.
           If that is so, it will try to parse the existing file unless it's a '*.obj',
           '*.pcm' or '*.arr' file as POV-Ray can not read them directly. In this case a new
           mesh will be generated, but the existing files will _not_ be over-written.
*/ 
#macro Lathe(Spl, ResSpl, Rot, ResRot, FileName)
   #declare Build=CheckFileName(FileName);
   #if(Build=0)
      #debug concat("\n Parsing mesh2 from file: ", FileName, "\n")
      #include FileName
      object{Surface}
   #else
      #local NumVertices=(ResRot+1)*(ResSpl+1);
      #local NumFaces=ResRot*ResSpl*2;
      #debug concat("\n Calculating ",str(NumVertices,0,0)," vertices for ",str(NumFaces,0,0)," triangles\n\n")
      #local I=0;
      #local VNArr=array[ResSpl+1][2]     //retreive the needed amount of points
      #while (I<=ResSpl)                  //from the spline and calculate the
         #local P0=Spl(I/ResSpl);         //normals to go with these points.
         #if (P0.x=0 & P0.z=0)            //put the result in VNArr.
            #local P0=<1e-25,P0.y,1e-25>;
         #end
         #if (I=0)
            #local P1=Spl(((I-0.5)/ResSpl));
            #local P2=Spl(((I+0.5)/ResSpl));
         #else
            #local P1=P2;
            #local P2=0+Spl(((I+0.5)/ResSpl));
         #end
         #local P3=vrotate(P0,<0,1,0>);
         #local P4=vrotate(P0,<0,-1,0>);
         #local B1=P4-P0;
         #local B2=P2-P0;
         #local B3=P3-P0;
         #local B4=P1-P0;
         #local N1=vcross(B1,B2);
         #local N2=vcross(B2,B3);
         #local N3=vcross(B3,B4);
         #local N4=vcross(B4,B1);
         #local Norm=vnormalize((N1+N2+N3+N4)*-1);
         #local VNArr[I][0]=P0;
         #local VNArr[I][1]=Norm;
         #local I=I+1;
      #end
      #local VecArr=array[NumVertices]
      #local NormArr=array[NumVertices]
      #local UVArr=array[NumVertices]
      #local R=Rot/ResRot;
      #local Dim=dimension_size(VNArr,1);
      #local Count=0;
      #local I=0;
      #while (I<=ResRot)
         #local J=0;
         #while (J<Dim)
            #local VecArr[Count]=vrotate(VNArr[J][0],<0,R*I,0>);
            #local NormArr[Count]=vrotate(VNArr[J][1],<0,R*I,0>);
            #local UVArr[Count]=<I/ResRot,J/(Dim-1)>;
            #local J=J+1;
            #local Count=Count+1;
         #end
         #debug concat("\r Done ", str(Count,0,0)," vertices : ",str(100*Count/NumVertices,0,2)," %")
         #local I=I+1;
      #end
      BuildWriteMesh2(VecArr, NormArr, UVArr, ResSpl, ResRot, FileName)
   #end
#end
