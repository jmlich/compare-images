#!/usr/bin/python3

import os
import cv2
import numpy as np
import sys

def threshold_slow(T, image):
    # grab the image dimensions
    h = image.shape[0]
    w = image.shape[1]

    mask = image >= T
    image[mask] = 1
    image[np.logical_not(mask)] = 0

    return image

if __name__ == "__main__":

    if (len(sys.argv) != 3) :
        print ("usage: {0} in/mask001.png out/mask001.png".format(sys.argv[0]))
        sys.exit(1)

    inA_filename = sys.argv[1]
    inB_filename = sys.argv[2]

    inA = cv2.imread(inA_filename)
    inB = cv2.imread(inB_filename)

    # jpg 8-bit 3 kanaly

    # prevest na [100, 100]

    # pro kazdy pixel spocitat absolutni hodnotu 
    # [ 0 ; 3 * 255 ] pro jeden pixel
    # pro obrazek 100x100 [0 ; 7 650 000 ]


#    mask_out = threshold_slow(100, mask_in_gray )

    distance=300
    print(distance)

