#!/usr/bin/python3

import os
import cv2
import numpy as np
import sys

def compute_distance(a, b):
    return np.sum( np.absolute( np.subtract(a, b) ) )

def compute_distance2(a, b):
    distance = 0

    rows = a.shape[0]
    cols = a.shape[1]
    channels = a.shape[2]

    for y in range( rows ):
        for x in range( cols ):
            for i in range( channels ):
                distance = distance + abs( int( a[ y, x, i ] ) - int( b[ y, x, i ] ) )
    return distance


def test_compute_distance():
    red = [ 255, 0, 0 ];
    green = [ 0, 255, 0 ];
    a = np.array([
            [ red, red, red, red ],
            [ red, red, red, red ],
            [ red, red, red, red ],
            [ red, red, red, red ],
        ]
    )
    b = np.array([
            [ red, red, red, green ],
            [ red, red, red, red ],
            [ red, red, red, red ],
            [ red, red, red, red ],
        ]
    )
    c = np.array([
            [ green, red, red, red ],
            [ red, green, red, red ],
            [ red, red, green, red ],
            [ red, red, red, green ],
        ]
    )
    print( compute_distance(a, b))
    print( compute_distance2(a, b))
    print( compute_distance(a, c))
    print( compute_distance2(a, c))
    print( compute_distance(b, c))
    print( compute_distance2(b, c))
    assert(compute_distance(a, b) == 510)


if __name__ == "__main__":

#    test_compute_distance()

    if (len(sys.argv) != 3) :
        print( "usage: {0} image1.jpg image2.jpg".format( sys.argv[0] ) )
        sys.exit(1)

    inA_filename = sys.argv[1]
    inB_filename = sys.argv[2]

    # jpg 8-bit 3 kanaly

    inA = cv2.imread(inA_filename)
    inB = cv2.imread(inB_filename)

    # prevest na [120, 90]

    cols = 120
    rows = 90
    channels = 3

    resizedA = cv2.resize( inA, ( cols, rows ) )
    resizedB = cv2.resize( inB, ( cols, rows ) )


    # pro kazdy pixel spocitat absolutni hodnotu 
    # [ 0 ; 3 * 255 ] pro jeden pixel
    # pro obrazek 120, 90 [0 ; 8 262 000 ]

    distance = compute_distance(resizedA, resizedB)
    print(distance)

