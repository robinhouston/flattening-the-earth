// Persistence of Vision Ray Tracer Include File
// File: makemesh.inc
// Vers: 3.5
// Desc: Macros and functions used in builing mesh2 objects.
// Date: 2002/04/27
// Auth: Ingo Janssen

// Rev 2002/10/23 : Added the CheckFileName macro.
//                  Added the option to write Wavefront *.obj files.
//                  Added the option to write *.pcm files, for Chris Colefax' Compressed Mesh Macros.
//                  Added the option to write *.arr files, this writes only the arrays to a file.
//

#version 3.5;
#ifndef(MAKEMESH_INC_TEMP)
   #declare MAKEMESH_INC_TEMP = version;
   #ifdef(View_POV_Include_Stack)
      #debug "including makemesh.inc\n"
   #end


//====== Macros and Functions ======//

/*==============
LInterpolate() : Linear interpolatio of a vector or float between Min and Max.
Min : minimal float value or vector.
Max : Maximal float value or vector.
Val : A float in the range 0 - 1.
*/   
   #macro LInterpolate(Val, Min, Max)
      (Min+(Max-Min)*Val) 
   #end


/*=========
RangeMM() : Adjusts input values in the range [RMin, RMax] to fit in the range
[Min, Max].
Val : A float value in the range [Rmin, Rmax].
*/   
   #declare RangeMM=function(Val,Rmin,Rmax,Min,Max){
      (((Val-Rmin)/(Rmax-Rmin))*(Max-Min)+Min)
   }

/*=================
  If Return has a value of 0 the mesh will not be build,
  but it will be parsed from file. 
*/
#macro CheckFileName(FileName)
   #local Len=strlen(FileName);
   #if(Len>0)
      #if(file_exists(FileName))
         #if(Len>=4)
            #local Ext=strlwr(substr(FileName,Len-3,4))
            #if (strcmp(Ext,".obj")=0 | strcmp(Ext,".pcm")=0 | strcmp(Ext,".arr")=0)
               #local Return=99;
            #else
               #local Return=0;
            #end  
         #else
            #local Return=0;
         #end
      #else
         #if(Len>=4)
            #local Ext=strlwr(substr(FileName,Len-3,4))
            #if (strcmp(Ext,".obj")=0 | strcmp(Ext,".pcm")=0 | strcmp(Ext,".arr")=0)
               #if (strcmp(Ext,".obj")=0)
                  #local Return=2;
               #end
               #if (strcmp(Ext,".pcm")=0)
                  #local Return=3;
               #end
               #if (strcmp(Ext,".arr")=0)
                  #local Return=4;
               #end
            #else
               #local Return=1;
            #end  
         #else
            #local Return=1;
         #end
      #end
   #else
      #local Return=1;
   #end
   (Return)
#end

/*================= 
BuildWriteMesh2() : Builds and optionally writes a mesh2 object based on 3 input
arrays, the number of quads in U and V direction and a filename.
VecArr   : The array that contains the vertices of the triangles in the mesh.
NormArr  : The array with the normal vectors that go with the vertices.
UVArr    : The array containing the uv_vectors.
U        : The amount of subdivisions of the surface in the u-direction.
V        : The amount of subdivisions in the v-direction.
           Based on the U and V values the face_indices of the  triangles in the
           mesh are calculated.
FileName : The name of the file to whitch the mesh will be written. If is an
           empty string (""), no file will be written.
           If the file extension is 'obj' a Wavefront objectfile will be written.
           If the extension is 'pcm' a compressed mesh file is written.
           If a file name is given, the macro will first check if it already exists.
           If that is so, it will try to parse the existing file unless it's a '*.obj',
           '*.pcm' or '*.arr' file as POV-Ray can not read them directly. In this case a new
           mesh will be generated, but the existing files will _not_ be over-written.
*/
   #macro BuildWriteMesh2(VecArr, NormArr, UVArr, U, V, FileName)
      #if(strlen(FileName)!=0)
         #local Write=CheckFileName(FileName);
         #if(Write=99)
            #local Write=0;
         #end
         #if (Write=0)
            #debug concat(
               "\n\n The exis","ting file: '", FileName ,"' will not be over-written\n",
               " The mesh2 will not be parsed from the ", FileName," file",
               "\n   - vertex_vectors\n")   
         #else
            #debug concat(
               "\n\n Building mesh2 & Writing file: '", FileName , 
               "'\n   - vertex_vectors\n"
            )
            #fopen MeshFile FileName write
            #switch (Write)
               #case(1)
                  #write(
                     MeshFile,
                     "#declare Surface = mesh2 {\n"
                  )
               #break
               #case(2)
                  #write(
                     MeshFile,
                     "# File: ",FileName,"\n",
                  )
               #break
               #case(3)
                  #write(
                     MeshFile,
                     "\"PCM1\",\n"
                  )
               #break
               #case(4)
                  #write(
                     MeshFile,
                     "// Arrays for building a mesh2{} object.\n",
                     "// the arrays are declared with the following names:\n",
                     "// VertexVectors, NormalVectors, UVVectors and FaceIndices.\n\n"
                  )
               #break
            #end
         #end
      #else
         #local Write=0;
         #debug concat("\n\n Building mesh2: \n   - vertex_vectors\n")   
      #end
     
      #local NumVertices=dimension_size(VecArr,1);
      #switch (Write)
         #case(1)
            #write(
               MeshFile,
               "  vertex_vectors {\n",
               "    ", str(NumVertices,0,0),"\n    "
            )
         #break
         #case(2)
            #write(
               MeshFile,
               "# Vertices: ",str(NumVertices,0,0),"\n"
            )
         #break
         #case(3)
            #write(
               MeshFile,
               str(2*NumVertices,0,0),",\n"
            )
         #break
         #case(4)
            #write(
               MeshFile,
               "#declare VertexVectors= array[",str(NumVertices,0,0),"] {\n  "
            )
         #break
      #end
      mesh2 {
         vertex_vectors {
            NumVertices
            #local I=0;
            #while (I<NumVertices)
               VecArr[I]
               #switch(Write)
                  #case(1)
                     #write(MeshFile, VecArr[I])
                  #break
                  #case(2)
                     #write(
                        MeshFile,
                        "v ", VecArr[I].x," ", VecArr[I].y," ", VecArr[I].z,"\n"
                     )
                  #break
                  #case(3)
                     #write(
                        MeshFile,
                        VecArr[I].x,",", VecArr[I].y,",", VecArr[I].z,",\n"
                     )
                  #break
                  #case(4)
                     #write(MeshFile, VecArr[I])
                  #break
               #end
               #local I=I+1;
               #if(Write=1 | Write=4)
                  #if(mod(I,3)=0)
                     #write(MeshFile,"\n    ")
                  #end
               #end 
            #end
            #switch(Write)
               #case(1) 
                  #write(MeshFile,"\n  }\n")
               #break
               #case(2)
                  #write(MeshFile,"\n")
               #break
               #case(3)
                  // do nothing
               #break
               #case(4) 
                  #write(MeshFile,"\n}\n")
               #break
            #end
         }
   
         #debug concat("   - normal_vectors\n")     
         #local NumVertices=dimension_size(NormArr,1);
         #switch(Write)
            #case(1)
               #write(
                  MeshFile,
                  "  normal_vectors {\n",
                  "    ", str(NumVertices,0,0),"\n    "
               )
            #break
            #case(2)
               #write(
                  MeshFile,
                  "# Normals: ",str(NumVertices,0,0),"\n"
               )
            #break
            #case(3)
               // do nothing
            #break
            #case(4)
               #write(
                  MeshFile,
                  "#declare NormalVectors= array[",str(NumVertices,0,0),"] {\n  "
               )
            #break
         #end
         normal_vectors {
            NumVertices
            #local I=0;
            #while (I<NumVertices)
               NormArr[I]
               #switch(Write)
                  #case(1)
                     #write(MeshFile NormArr[I])
                  #break
                  #case(2)
                     #write(
                        MeshFile,
                        "vn ", NormArr[I].x," ", NormArr[I].y," ", NormArr[I].z,"\n"
                     )
                  #break
                  #case(3)
                     #write(
                        MeshFile,
                        NormArr[I].x,",", NormArr[I].y,",", NormArr[I].z,",\n"
                     )
                  #break
                  #case(4)
                     #write(MeshFile NormArr[I])
                  #break
               #end
               #local I=I+1;
               #if(Write=1 | Write=4) 
                  #if(mod(I,3)=0)
                     #write(MeshFile,"\n    ")
                  #end
               #end 
            #end
            #switch(Write)
               #case(1)
                  #write(MeshFile,"\n  }\n")
               #break
               #case(2)
                  #write(MeshFile,"\n")
               #break
               #case(3)
                  //do nothing
               #break
               #case(4)
                  #write(MeshFile,"\n}\n")
               #break
            #end
         }
         
         #debug concat("   - uv_vectors\n")   
         #local NumVertices=dimension_size(UVArr,1);
         #switch(Write)
            #case(1)
               #write(
                  MeshFile, 
                  "  uv_vectors {\n",
                  "    ", str(NumVertices,0,0),"\n    "
               )
             #break
             #case(2)
               #write(
                  MeshFile,
                  "# UV-vectors: ",str(NumVertices,0,0),"\n"
               )
             #break
             #case(3)
               // do nothing, *.pcm does not support uv-vectors
             #break
             #case(4)
                #write(
                   MeshFile,
                   "#declare UVVectors= array[",str(NumVertices,0,0),"] {\n  "
                )
             #break
         #end
         uv_vectors {
            NumVertices
            #local I=0;
            #while (I<NumVertices)
               UVArr[I]
               #switch(Write)
                  #case(1)
                     #write(MeshFile UVArr[I])
                  #break
                  #case(2)
                     #write(
                        MeshFile,
                        "vt ", UVArr[I].u," ", UVArr[I].v,"\n"
                     )
                  #break
                  #case(3)
                     //do nothing
                  #break
                  #case(4)
                     #write(MeshFile UVArr[I])
                  #break
               #end
               #local I=I+1; 
               #if(Write=1 | Write=4)
                  #if(mod(I,3)=0)
                     #write(MeshFile,"\n    ")
                  #end 
               #end
            #end 
            #switch(Write)
               #case(1)
                  #write(MeshFile,"\n  }\n")
               #break
               #case(2)
                  #write(MeshFile,"\n")
               #break
               #case(3)
                  //do nothing
               #break
               #case(4)
                  #write(MeshFile,"\n}\n")
               #break
            #end
         }
   
         #debug concat("   - face_indices\n")   
         #declare NumFaces=U*V*2;
         #switch(Write)
            #case(1)
               #write(
                  MeshFile,
                  "  face_indices {\n"
                  "    ", str(NumFaces,0,0),"\n    "
               )
            #break
            #case(2)
               #write (
                  MeshFile,
                  "# faces: ",str(NumFaces,0,0),"\n"
               )
            #break
            #case(3)
               #write (
                  MeshFile,
                  "0,",str(NumFaces,0,0),",\n"
               )
            #break
            #case(4)
               #write(
                  MeshFile,
                  "#declare FaceIndices= array[",str(NumFaces,0,0),"] {\n  "
               )
            #break
         #end
         face_indices {
            NumFaces
            #local I=0;
            #local H=0;
            #local NumVertices=dimension_size(VecArr,1);
            #while (I<V)
               #local J=0;
               #while (J<U)
                  #local Ind=(I*U)+I+J;
                  <Ind, Ind+1, Ind+U+2>, <Ind, Ind+U+1, Ind+U+2>
                  #switch(Write)
                     #case(1)
                        #write(
                           MeshFile,
                           <Ind, Ind+1, Ind+U+2>, <Ind, Ind+U+1, Ind+U+2>
                        )
                     #break
                     #case(2)
                        #write(
                           MeshFile,
                           "f ",Ind+1,"/",Ind+1,"/",Ind+1," ",Ind+1+1,"/",Ind+1+1,"/",Ind+1+1," ",Ind+U+2+1,"/",Ind+U+2+1,"/",Ind+U+2+1,"\n",
                           "f ",Ind+U+1+1,"/",Ind+U+1+1,"/",Ind+U+1+1," ",Ind+1,"/",Ind+1,"/",Ind+1," ",Ind+U+2+1,"/",Ind+U+2+1,"/",Ind+U+2+1,"\n"
                        )
                     #break
                     #case(3)
                        #write(
                           MeshFile,
                           Ind,",",Ind+NumVertices,",",Ind+1,",",Ind+1+NumVertices,",",Ind+U+2,",",Ind+U+2+NumVertices,",\n"
                           Ind+U+1,",",Ind+U+1+NumVertices,",",Ind,",",Ind+NumVertices,",",Ind+U+2,",",Ind+U+2+NumVertices,",\n"
                        )
                     #break
                     #case(4)
                        #write(
                           MeshFile,
                           <Ind, Ind+1, Ind+U+2>, <Ind, Ind+U+1, Ind+U+2>
                        )
                     #break
                  #end
                  #local J=J+1;
                  #local H=H+1;
                  #if(Write=1 | Write=4)
                     #if(mod(H,3)=0)
                        #write(MeshFile,"\n    ")
                     #end 
                  #end
               #end
               #local I=I+1;
            #end
         }
         #switch(Write)
            #case(1)
               #write(MeshFile, "\n  }\n}")
               #fclose MeshFile
               #debug concat(" Done writing\n")
            #break
            #case(2)
               #fclose MeshFile
               #debug concat(" Done writing\n")
            #break
            #case(3)
               #fclose MeshFile
               #debug concat(" Done writing\n")
            #break
            #case(4)
               #write(MeshFile, "\n}\n}")
               #fclose MeshFile
               #debug concat(" Done writing\n")
            #break
         #end
      }
   #end

//====== End of Macros and Functions ======//

#end //ifndef
