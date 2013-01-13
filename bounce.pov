#include "colors.inc"

#declare Radius = 7;

#macro SphereHeight(T)
#   if (T < 0.5)
        20 * (1 - T*T*4) + Radius
#   else
        20 * (1 - (1-T)*(1-T)*4) + Radius
#   end
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
    location <20,10,0>
    look_at <0, Radius+1, 0>
}

plane {
    <0,1,0>, 0
    pigment {
        color White
    }
    finish {
        ambient 0.8
    }
}

sphere {
    // The sphere must be at the origin for the texture mapping to work,
    // so we position it at the origin and then move it to <0, 10, 0> using
    // a translation.
    <0, 0, 0>, Radius
    texture {
        pigment {
            image_map {
                jpeg "textures/BigEarth.jpg"
                map_type 1
                interpolate 0
            }
        }
    }
    rotate <0, 360*clock, 0>
    translate <0, SphereHeight(clock), 0>
}


light_source {
    <100, 100, 0>
    color White
    area_light <5, 0, 0>, <0, 0, 5>, 5, 5
   // parallel
    //point_at <0, 0, 0>
    rotate <0, 0, 0>
}

fog {
    distance 150
    color rgb<0.3, 0.3, 0.4>
}


