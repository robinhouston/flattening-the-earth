#include "colors.inc"

#default {
    finish {
        ambient 1
        diffuse 1
        specular 1
        reflection 0
    }
}

camera {
    location <15,10,0>
    look_at <0,10,0>
}

plane {
    <0,1,0>, 0
    pigment {
        color White
    }
}

sphere {
    // The sphere must be at the origin for the texture mapping to work,
    // so we position it at the origin and then move it to <0, 10, 0> using
    // a translation.
    <0, 0, 0>, 4
    texture {
        pigment {
            image_map {
                jpeg "BigEarth.jpg"
                map_type 1
                interpolate 0
            }
        }
    }
    rotate <0, 180, 0>
    translate <0, 10, 0>
}


light_source {
    <100, 100, 0>
    color rgb<0.2,0.2,0.2>
    area_light <5, 0, 0>, <0, 0, 5>, 5, 5
    parallel
    point_at <0, 0, 0>
    rotate <0, 0, 0>
}

fog {
    distance 150
    color rgb<0.3, 0.3, 0.4>
}


