#!/usr/bin/python3

import os
import cv2
import numpy as np
import sys

def compute_distance(a, b):
    return np.sum( np.absolute( np.subtract(a, b) ) )


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


def readlist(fn):
    lines = [line.strip() for line in open(fn)]
    features = []
    features_mini = []
    avgs = []

    for fn in lines:
        img = cv2.imread(fn);
        resized = cv2.resize(img, (DEST_ROWS, DEST_COLS) )
        features.append(resized);

        resized = cv2.resize(resized, (DEST2_ROWS, DEST2_COLS) )
        gray = cv2.cvtColor(resized, cv2.COLOR_BGR2GRAY)
        avgs.append(np.average(gray))
        features_mini.append(resized);
    return zip(lines, avgs, features, features_mini)


if __name__ == "__main__":
#    test_compute_distance()

    DEST_COLS = 120;
    DEST_ROWS = 90

    DEST2_COLS = 30;
    DEST2_ROWS = 15

    list1 = readlist(sys.argv[1])
    list2 = list(readlist(sys.argv[2]))


    for fn1, avg1, feature1, feature1s in list1:
        for fn2, avg2, feature2, feature2s  in list2:

            if fn1 == fn2: # skip same filenames
                print (fn1, fn2, 0, "same filename");
                continue;

            distance = compute_distance(feature1s, feature2s)
            if distance > 50000:
                print (fn1, fn2, distance, "#");
                continue;

            distance = compute_distance(feature1, feature2)
            if distance < 32400:
                print (fn1, fn2, distance, "1");
            elif distance < 64000:
                print (fn1, fn2, distance, "2");
            elif distance < 128000:
                print (fn1, fn2, distance, "3");
            elif distance < 256000:
                print (fn1, fn2, distance, "4");
            elif distance < 512000:
                print (fn1, fn2, distance, "5");
            elif distance < 1024000:
                print (fn1, fn2, distance, "6");
            elif distance < 2048000:
                print (fn1, fn2, distance, "7");
            elif distance < 4096000:
                print (fn1, fn2, distance, "8");
            elif distance < 8192000:
                print (fn1, fn2, distance, "9");
            else:
                print (fn1, fn2, distance, "%");

