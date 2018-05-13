import numpy as np
import time
import cv2
# cap1 = cv2.VideoCapture(0)

cap2 = cv2.VideoCapture(1)
cap2.set(cv2.CAP_PROP_FRAME_WIDTH,320)
cap2.set(cv2.CAP_PROP_FRAME_HEIGHT,240)
cap3 = cv2.VideoCapture(2)
cap3.set(cv2.CAP_PROP_FRAME_WIDTH,320)
cap3.set(cv2.CAP_PROP_FRAME_HEIGHT,240)
i = 40
while(True):

    ret3, frame3 = cap3.read()
    ret2, frame2 = cap2.read()

    if ret2:
        cv2.imshow('frame2',frame2)
    if ret3:
        cv2.imshow('frame3',frame3)
    key = cv2.waitKey(1)
    if key & 0xFF == ord('q'):
        break

    if key & 0xFF == ord('c'):
       cv2. imwrite('./catimages/R/'+str(i)+'.jpg',frame2)
       cv2. imwrite('./catimages/L/'+str(i)+'.jpg',frame3)
       print(i)
       i += 1
cap2.release()
cap3.release()
# When everything done, release the capture
cv2.destroyAllWindows()