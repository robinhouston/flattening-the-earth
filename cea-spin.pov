#include "colors.inc"

#declare Radius = 7;
#declare Standard_Parallel = 0; //radians(44.138);

#default {
    finish {
        ambient 0.3
        diffuse 0.7
        specular 0.6 metallic
        reflection 0.1
    }
}

camera {
    location<25, 17, 0>
    look_at <0, Radius+1, 0>
}

cylinder {
    <0, 0, 0>, <0, 1, 0>, cos(Standard_Parallel) open
    
    texture {
        pigment {
            image_map {
                jpeg "textures/earthmap10k.reduced-Peters.jpg"
                map_type 2
                interpolate 2
            }
            rotate <0, 180, 0>
        }
    }
    scale <Radius, 2*Radius, Radius>
    rotate <0, 360*sin(clock*pi/2)*sin(clock*pi/2), 0>
}

light_source {
    <100, 100, 0>
    color White
    area_light <5, 0, 0>, <0, 0, 5>, 5, 5
}
