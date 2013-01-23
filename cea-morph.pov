#include "colors.inc"
#include "param.inc"

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
    // Lift the camera up as the sphere opens out into a cylinder
    location<25, 10 + 7*Easing(clock), 0>
    look_at <0, Radius+1, 0>
}

#macro __Fx(U,V)
    cos(U)*( cos(V)*(1-Easing(clock)) + cos(Standard_Parallel)*Easing(clock) )
#end

#macro __Fy(U,V)
    (sin(V)+1)/2
#end

#macro __Fz(U,V)
    sin(U)*( cos(V)*(1-Easing(clock)) + cos(Standard_Parallel)*Easing(clock) )
#end

object {
    // u is longitude and v is latitude, both in radians
    Paramcalc (
        <-pi, -pi/2>, <ToU(pi), pi/2>,
        100, 50, ""
    )
    
    texture {
        pigment {
            image_map {
                jpeg "textures/earthmap10k.reduced-Peters.jpg"
                map_type 2
                interpolate 2
                // filter all 0.95
            }
            rotate <0, 180, 0>
        }
    }
    scale <Radius, 2*Radius, Radius>
}


light_source {
    <100, 100, 0>
    color White
    area_light <5, 0, 0>, <0, 0, 5>, 5, 5
}

