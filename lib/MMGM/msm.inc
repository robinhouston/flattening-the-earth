// Persistence of Vision Ray Tracer Include File
// File: msm.inc
// Vers: 3.5
// Desc: 
// Date: 2002/04/27
// Auth: Ingo Janssen

#version 3.5;
#include "makemesh.inc"


/*======   
The uv_coordinates come from the square <0,0> - <1,1>.

           The spline is evaluated from t=0 to t=1. For the normal calculation,
           it is required that all splines (also linear_spline) have one extra
           point before t=0 and after t=1.
*/
#macro BuildSpline(Arr, SplType)
   #local Ds=dimension_size(Arr,1);
   #local Asc=asc(strupr(SplType));
   #if(Asc!=67 & Asc!=76 & Asc!=81) 
      #local Asc=76;
      #debug "\nWrong spline type defined (C/c/L/l/N/n/Q/q), using default linear_spline\n"
   #end
   spline {
      #switch (Asc)
         #case (67) //C  cubic_spline
            cubic_spline
         #break
         #case (76) //L  linear_spline
            linear_spline
         #break
         #case (78) //N  linear_spline
            natural_spline
         #break
         #case (81) //Q  Quadratic_spline
            quadratic_spline
         #break
      #end
      #local Add=1/((Ds-2)-1);
      #local J=0-Add;
      #local I=0;
      #while (I<Ds)
         J 
         Arr[I]
         #local I=I+1;
         #local J=J+Add;
      #end
   }      
#end

#macro MSM(SplineArray, SplRes, Interp_type,  InterpRes, FileName)
   #declare Build=CheckFileName(FileName);
   #if(Build=0)
      #debug concat("\n Parsing mesh2 from file: ", FileName, "\n")
      #include FileName
      object{Surface}
   #else
      #local NumVertices=(SplRes+1)*(InterpRes+1);
      #local NumFaces=SplRes*InterpRes*2;
      #debug concat("\n Calculating ",str(NumVertices,0,0)," vertices for ", str(NumFaces,0,0)," triangles\n\n")
      #local VecArr=array[NumVertices]
      #local NormArr=array[NumVertices]
      #local UVArr=array[NumVertices]
      #local N=dimension_size(SplineArray,1);
      #local TempSplArr0=array[N];
      #local TempSplArr1=array[N];
      #local TempSplArr2=array[N];
      #local PosStep=1/SplRes;
      #local InterpStep=1/InterpRes;
      #local Count=0;
      #local Pos=0;
      #while(Pos<=1)   
         #local I=0;
         #if (Pos=0)
            #while (I<N)
               #local Spl=spline{SplineArray[I]}
               #local TempSplArr0[I]=<0,0,0>+Spl(Pos);
               #local TempSplArr1[I]=<0,0,0>+Spl(Pos+PosStep);
               #local TempSplArr2[I]=<0,0,0>+Spl(Pos-PosStep);
               #local I=I+1;
            #end
            #local S0=BuildSpline(TempSplArr0, Interp_type)
            #local S1=BuildSpline(TempSplArr1, Interp_type)
            #local S2=BuildSpline(TempSplArr2, Interp_type)
         #else
            #while (I<N)
               #local Spl=spline{SplineArray[I]}
               #local TempSplArr1[I]=<0,0,0>+Spl(Pos+PosStep);
               #local I=I+1;
            #end
            #local S1=BuildSpline(TempSplArr1, Interp_type)
         #end
         #local J=0;
         #while (J<=1)
            #local P0=<0,0,0>+S0(J);
            #local P1=<0,0,0>+S1(J);
            #local P2=<0,0,0>+S2(J);
            #local P3=<0,0,0>+S0(J+InterpStep);
            #local P4=<0,0,0>+S0(J-InterpStep);
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
            #local UVArr[Count]=<J,Pos>;
            #local J=J+InterpStep;
            #local Count=Count+1;
         #end
         #local S2=spline{S0}
         #local S0=spline{S1}
         #debug concat("\r Done ", str(Count,0,0)," vertices : ", str(100*Count/NumVertices,0,2)," %")
         #local Pos=Pos+PosStep;
      #end
      BuildWriteMesh2(VecArr, NormArr, UVArr, InterpRes, SplRes, FileName)
   #end
#end
