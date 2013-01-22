#include "colors.inc"
#include "param.inc"

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
    #if (clock < 1)
        // Lift the camera up as the sphere opens out into a cylinder
        location<25, 10 + 7*clock, 0>
    #else
        // Pull the camera back and down as we unfurl the cylinder
        location<5 + 20*clock, 17 + (clock - 1) * (Radius+1 - 17), 0>
    #end
    look_at <0, Radius+1, 0>
}

#macro __Fx(U,V)
    #if (clock < 1)
        cos(U)*( cos(V)*(1-clock) + cos(Standard_Parallel)*clock )
    #else
       #if (U < -pi * (clock-1))
            cos(U + pi * (clock-1)) * cos(Standard_Parallel)
       #else
           #if (U > pi * (clock-1))
                ( cos(U - pi * (clock-1)) ) * cos(Standard_Parallel)
           #else
                cos(Standard_Parallel)
           #end
       #end
    #end
#end

#macro __Fy(U,V)
    (sin(V)+1)/2
#end

#macro __Fz(U,V)
#       if (clock < 1)
            sin(U)*( cos(V)*(1-clock) + cos(Standard_Parallel)*clock )
#       else
#           if (U <  -pi * (clock-1))
                ( sin(U + pi * (clock-1)) - pi * (clock-1) ) * cos(Standard_Parallel)
#           else
#               if (U > pi * (clock-1))
                    ( sin(U - pi * (clock-1)) + pi * (clock-1) ) * cos(Standard_Parallel)
#               else
                    U * cos(Standard_Parallel)
#               end
#           end
#       end
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

// fog {
//     distance 150
//     color rgb<0.3, 0.3, 0.4>
// }


