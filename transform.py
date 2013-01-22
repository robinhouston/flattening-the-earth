from __future__ import division
import math

import Image

CELL_WIDTH = 8
CELL_HEIGHT = 8

def transform(latitude, longitude):
    return math.asin(latitude*2/math.pi), longitude

def transform_rect((x1, y1, x2, y2), width, height):
    def f(x, y):
        longitude = (x/width - 0.5) * 2*math.pi
        latitude = (y/height - 0.5) * math.pi
        
        latitude, longitude = transform(latitude, longitude)
        
        return (
            ((longitude / (2*math.pi) + 0.5)) * width,
            ((latitude  / (math.pi) + 0.5)) * height,
        )
        
    return f(x1, y1) + f(x1, y2) + f(x2, y2) + f(x2, y1)

def generate_grid(width, height):
    xs = range(0, width, CELL_WIDTH  ) + [width]
    ys = range(0, height, CELL_HEIGHT) + [height]
    
    return [
        (xs[i], ys[j], xs[i+1], ys[j+1])
        for i in range(len(xs) - 1)
        for j in range(len(ys) - 1)
    ]

def generate_mesh((width, height)):
    return [
        (rect, transform_rect(rect, width, height))
        for rect in generate_grid(width, height)
    ]

image = Image.open("textures/earthmap10k.reduced.jpg")
image.transform( image.size, Image.MESH, generate_mesh(image.size)) \
    .save("textures/earthmap10k.reduced-Peters.jpg")
