#!/usr/bin/python3

import os
import cv2
import numpy as np
import sys

if __name__ == "__main__":

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

    resizedA = cv2.resize( inA, ( cols, rows ) )
    resizedB = cv2.resize( inB, ( cols, rows ) )

    # pro kazdy pixel spocitat absolutni hodnotu 
    # [ 0 ; 3 * 255 ] pro jeden pixel
    # pro obrazek 120, 90 [0 ; 8 262 000 ]

    distance = 0

    for y in range( rows ):
        for x in range( cols ):
            for i in range( 3 ):
                distance = distance + abs( resizedA[ y, x, i ] - resizedB[ y, x, i ] )

    print(distance)

