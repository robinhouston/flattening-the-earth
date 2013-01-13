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

parametric {
    function { cos(u)*cos(v*(1-clock))*Radius }
    function { sin(v)*Radius }
    function { sin(u)*cos(v*(1-clock))*Radius }

    <0,-pi/2>, <2*pi,pi/2>
    contained_by { box{-1.1*Radius, 1.1*Radius} }
    accuracy 0.0001
    precompute 10 x,y,z
    texture {
        pigment {
            image_map {
                jpeg "BigEarth.jpg"
                map_type 1
                interpolate 0
            }
        }
    }
    translate <0, Radius, 0>
    rotate <0, 180, 0>
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


