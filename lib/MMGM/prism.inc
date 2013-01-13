// Persistence of Vision Ray Tracer Scene Description File
// File: prism.inc
// Vers: 3.5
// Desc: Macros to build a mesh2 prism (extrusion) object from a spline
// Date: 2002/04/27
// Auth: Ingo Janssen 

// revision 2002/08/28: replaced some ^ by pow() 

#version 3.5;
#include "makemesh.inc"

/*======
Prism(Spl, ResSpl, Height, HRes, FileName): Extrudes the spline along the y-axis.
           The uv_coordinates come from the square <0,0> - <1,1>.

Spl      : The spline to be extruded. 
           The spline is evaluated from t=0 to t=1. For the normal calculation,
           it is required that all splines (also linear_spline) have one extra
           point before t=0 and after t=1.
ResSpl   : The amount of triangles to be used along the spline
Height   : The amount of POV-units to extrude the shape.
HRes     : The amount of triangles to be used in the height.
FileName : The name of the file to whitch the mesh will be written. If is an
           empty string (""), no file will be written.
           If the file extension is 'obj' a Wavefront objectfile will be written.
           If the extension is 'pcm' a compressed mesh file is written.
           If a file name is given, the macro will first check if it already exists.
           If that is so, it will try to parse the existing file unless it's a '*.obj',
           '*.pcm' or '*.arr' file as POV-Ray can not read them directly. In this case a new
           mesh will be generated, but the existing files will _not_ be over-written.
*/ 
#macro Prism(Spl, ResSpl, Height, HRes, FileName)
   #local __LinSpl=spline {
      linear_spline
      -1,<0,-1,0>
      1e-50, <0,0,0>
      1,<0,Height,0>
      2,<0,Height+1,0>
   }
   Prism1(Spl, ResSpl, __LinSpl, HRes,FileName)
#end

/*======
Prism1(Spl, ResSpl, PSpl, PRes, FileName): Extrudes the spline along the y-axis.
           In every step the spline is scaled by the 'relative' distance from the
           y-axis of the second spline (PSpl).
           The uv_coordinates come from the square <0,0> - <1,1>.

Spl      : The spline to be extruded.
           The spline is evaluated from t=0 to t=1. For the normal calculation,
           it is required that all splines (also linear_spline) have one extra
           point before t=0 and after t=1.
ResSpl   : The amount of triangles to be used along the spline.
PSpl     : The spline that determines by what amount the extrusion is scaled in
           each step. The scaling is based on the relative distance from the y-axis.
           That is, at t=0 the scale is always 1, so that the start of the shape is 
           identical to the spline Spl.
           PSpl also sets the height of the resulting shape (its y-value at t=1).
           The spline is evaluated from t=0 to t=1. For the normal calculation,
           it is required that all splines (also linear_spline) have one extra
           point before t=0 and after t=1.
FileName : The name of the file to whitch the mesh will be written. If is an empty
           string (""), no file will be written. If a file name is given, the macro
	        will first check if it already exists. If that is so, it will expect a
	        mesh2 with the name "Surface" and try to parse the existing file.
*/

#macro Prism1(Spl, ResSpl, PSpl, PRes, FileName)
   #declare Build=CheckFileName(FileName);
   #if(Build=0)
      #debug concat("\n Parsing mesh2 from file: ", FileName, "\n")
      #include FileName
      object{Surface}
   #else
      #local NumVertices=(PRes+1)*(ResSpl+1);
      #local NumFaces=PRes*ResSpl*2;
      #debug concat("\n Calculating ",str(NumVertices,0,0)," vertices for ", str(NumFaces,0,0)," triangles\n\n")
      #local VecArr=array[NumVertices]
      #local NormArr=array[NumVertices]
      #local UVArr=array[NumVertices]
      #local H=PSpl(0);
      #local Scale=pow( pow(H.x,2) + pow(H.z,2), 0.5);
      #local H=H.y;
      #local P=Spl(0);
      #local P=pow( pow(P.x,2) + pow(P.z,2), 0.5);
      #local Corr=(P-Scale);
      #local IStep=1/PRes;
      #local JStep=1/ResSpl;
      #local Count=0;
      #local I=0;
      #while(I<=1)
         #local Scale0=PSpl(I);
         #local H0=<0,Scale0.y-H,0>;
         #local Scale1=PSpl(I+IStep);
         #local H1=<0,Scale1.y-H,0>;
         #local Scale2=PSpl(I-IStep);
         #local H2=<0,Scale2.y-H,0>;
         #local Scale0=RangeMM( pow( pow(Scale0.x,2)+ pow(Scale0.z,2), 0.5)+(Corr), 0,P,0,1);
         #local Scale1=RangeMM( pow( pow(Scale1.x,2)+ pow(Scale1.z,2), 0.5)+(Corr), 0,P,0,1);
         #local Scale2=RangeMM( pow( pow(Scale2.x,2)+ pow(Scale2.z,2), 0.5)+(Corr), 0,P,0,1);
         #local J=0;
         #while (J<=1)
            #local P0=(Spl(J)*Scale0)+H0;
            #local P1=(Spl(J)*Scale1)+H1;
            #local P2=(Spl(J)*Scale2)+H2;
            #local P3=(Spl(J+JStep)*Scale0)+H0;
            #local P4=(Spl(J-JStep)*Scale0)+H0;
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
            #local UVArr[Count]=<J,I>;
            #local J=J+JStep;
            #local Count=Count+1;
         #end
         #debug concat("\r Done ", str(Count,0,0)," vertices : ", str(100*Count/NumVertices,0,2)," %")
         #local I=I+IStep;
      #end
      BuildWriteMesh2(VecArr, NormArr, UVArr, ResSpl, PRes, FileName)
   #end
#end
