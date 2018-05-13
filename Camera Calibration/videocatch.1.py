import numpy as np
import time
import cv2
from multiprocessing import Pool


def capture(i):
    cap = cv2.VideoCapture(i)
    cap.set(cv2.CAP_PROP_FRAME_WIDTH,640)
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT,480)
    k = 0
    print('begin')
    while(True):
        ret, frame = cap.read()

        if ret:
            cv2.imshow('frame'+str(i),frame)
        else:
            print(i,'does not return')
        key = cv2.waitKey(1)
        if key & 0xFF == ord('q'):
            break

        if key & 0xFF == ord('c'):
            print(k)
            k += 1
    # When everything done, release the capture
    cv2.destroyAllWindows()

capture(2)