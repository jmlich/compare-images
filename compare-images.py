#!/usr/bin/python3

import os
import cv2
import numpy as np
import sys

def compute_distance(a, b):
#    return np.sum( np.clip(np.absolute( np.subtract(a, b) ) - 3, 0, 255) )
#    return np.sum( np.clip(np.absolute( a - b ) ) )
    return np.sum( np.absolute(a - b ) > np.maximum(a, b) * 0.2)
#    return np.sum( np.absolute(a - b ) > 20)


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


def histogram_equalize2(img):
    b, g, r = cv2.split(img)
    red = cv2.equalizeHist(r)
    green = cv2.equalizeHist(g)
    blue = cv2.equalizeHist(b)
    return cv2.merge((blue, green, red))

def histogram_equalize(img):
    img_to_yuv = cv2.cvtColor(img,cv2.COLOR_BGR2YUV)
    img_to_yuv[:,:,0] = cv2.equalizeHist(img_to_yuv[:,:,0])
    return cv2.cvtColor(img_to_yuv, cv2.COLOR_YUV2BGR)

def readlist(fn):
    lines = [line.strip() for line in open(fn)]
    features = []
    features_mini = []
    avgs = []
    aspect_ratios = []

    blur_kernel = np.ones((5,5),np.float32)/25

    for fn in lines:
        img = cv2.imread(fn);
        aspect_ratios.append(img.shape[0]/img.shape[1])

        img = cv2.filter2D(img,-1,blur_kernel)
#        img = histogram_equalize2(img)
        resized = cv2.resize(img, (DEST_ROWS, DEST_COLS), 0, 0, 0, cv2.INTER_LANCZOS4)
#        resized = cv2.resize(img, (DEST_ROWS, DEST_COLS))
        features.append(resized);

#        resized = cv2.resize(resized, (DEST2_ROWS, DEST2_COLS) )
        resized = cv2.resize(img, (DEST2_ROWS, DEST2_COLS), 0, 0, 0, cv2.INTER_LANCZOS4)
        gray = cv2.cvtColor(resized, cv2.COLOR_BGR2GRAY)
        avgs.append(np.average(gray))
        features_mini.append(resized);
    return zip(lines, avgs, features, features_mini, aspect_ratios)


if __name__ == "__main__":
#    test_compute_distance()

    if len(sys.argv) != 3:
        print ("usage: {0} list1.txt list2.txt".format(sys.argv[0]))
        print ("list of images contains filenames on separate lines")
        sys.exit(1)


    DEST_COLS = 120;
    DEST_ROWS = 90;

    DEST2_COLS = 12;
    DEST2_ROWS = 9;

    list1 = readlist(sys.argv[1])
    list2 = list(readlist(sys.argv[2]))



    for fn1, avg1, feature1, feature1s, aspect1 in list1:
        for fn2, avg2, feature2, feature2s, aspect2 in list2:

            if fn1 == fn2: # skip same filenames
                print (-1, fn1, fn2, "x");
                continue;

            aspect_difference_pct = abs(aspect1-aspect2)/aspect1
            if aspect_difference_pct > 0.1:
                print(aspect_difference_pct, fn1, fn2, "~")
                continue

#            distance = compute_distance(feature1s, feature2s)
#            print (distance, fn1, fn2, "#");
#            if distance > 50000:
#                print (distance, fn1, fn2, "#");
#                continue;

            distance = compute_distance(feature1, feature2)
            print (distance, fn1, fn2, "+");
#            if distance < 4096000:
#                print (distance, fn1, fn2, "+");
#            else:
#                print (distnace, fn1, fn2, "%");