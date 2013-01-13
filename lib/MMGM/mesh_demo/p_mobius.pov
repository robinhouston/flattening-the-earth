#include "param.inc"
global_settings {assumed_gamma 1.0}

light_source {<500,500,-500> rgb <0.90,0.90,1>}
light_source {<-100,100,-500> rgb <0.5,0.4,0.4>}

camera {
   right x*image_width/image_height
   location <0,0,-3.2>
   look_at <0.1,0,0>
}

#declare Mob=text {
   ttf "timrom.ttf"
   " moebius"
   1,0
   translate -0.5*z
   rotate <0,0,90>
}

#declare Min=min_extent(Mob);
#declare Max=max_extent(Mob);
#debug vstr(3,Max,", ",0,-1)
#debug vstr(3,Min,", ",0,-1)
#declare dX=Max.x-Min.x;
#declare dY=Max.y-Min.y;

#declare Mob_pigm=pigment {
      object{Mob color rgbf 1 color rgb 1}
      translate <dX,0,0>
      scale 1/dY 
      warp {repeat x/4}
      warp {repeat y}
}

#declare F1=function(u,v){cos(u)+v*cos(u/2)*cos(u)}
#declare F2=function(u,v){sin(u)+v*cos(u/2)*sin(u)}
#declare F3=function(u,v){v*sin(u/2)}              

object{ 
   Parametric(
      F1, F2, F3,
      <0, -0.5>, <2*pi, 0.5>,
      50, 100, ""
   )
   no_shadow
   uv_mapping
   pigment {Mob_pigm scale <1/(2*pi),1,1>}
   rotate <0,55,0>
   rotate <25,0,0>
}





 