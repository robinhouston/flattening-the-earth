#include "colors.inc"

#declare Radius = 7;
#declare Standard_Parallel = 0; //radians(44.138);

#macro Easing(T)
    sin(T*pi/2)*sin(T*pi/2)
#end

#default {
    finish {
        ambient 0.3
        diffuse 0.7
        specular 0.6 metallic
        reflection 0.1
    }
}

camera {
    location<25 + 16*Easing(clock), 17*(1-Easing(clock)) + (Radius+1)*Easing(clock), 0>
    look_at <0, Radius+1, 0>
}

#if (clock = 1)
box {
    <0, 0, 0>,
    <1, 1, 0>
    texture {
        pigment {
            image_map {
                jpeg "textures/earthmap10k.reduced-Peters.jpg"
                map_type 0
                interpolate 2
                once
            }
        }
    }
    translate <-0.5, 0, 0>
    rotate <0, -90, 0>
    translate <cos(Standard_Parallel), 0, 0>
    scale <Radius, 2*Radius, Radius*2*pi>
}
#else
cylinder {
    <0, 0, 0>, <0, 1, 0>, 1 open
    clipped_by {plane { -x, cos(pi*Easing(clock)) } }
    
    texture {
        pigment {
            image_map {
                jpeg "textures/earthmap10k.reduced-Peters.jpg"
                once
                interpolate 2
            }
            scale <(1-Easing(clock)), 1, 1>
            translate <Easing(clock)/2, 0, 0>
            warp { cylindrical }
            
            rotate <0, 180, 0>
        }
    }
    scale <Radius, 2*Radius, Radius*cos(Standard_Parallel)/(1-Easing(clock))>
}
#end

light_source {
    <100, 100, 0>
    color White
    area_light <5, 0, 0>, <0, 0, 5>, 5, 5
}
