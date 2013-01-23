#include "colors.inc"

#declare Radius = 7;

#default {
    finish {
        ambient 0.3
        diffuse 0.7
        specular 0.6 metallic
        reflection 0.1
    }
}

camera {
    location<25, 10, 0>
    look_at <0, Radius+1, 0>
}

sphere {
    <0, 0, 0>, 1
    
    texture {
        pigment {
            image_map {
                jpeg "textures/earthmap10k.reduced.jpg"
                map_type 1
                interpolate 2
            }
            rotate <0, 180, 0>
        }
    }
    scale <Radius, Radius, Radius>
    translate <0, Radius, 0>
    rotate <0, 360*sin(clock*pi/2)*sin(clock*pi/2), 0>
}


light_source {
    <100, 100, 0>
    color White
    area_light <5, 0, 0>, <0, 0, 5>, 5, 5
}
