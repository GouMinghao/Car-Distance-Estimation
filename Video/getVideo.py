import numpy as np
# python(python3) getVideo.py dirname
import cv2
import sys
import os

def mkdir(path):  
    folder = os.path.exists(path)  
    if not folder:
        os.makedirs(path)


dir = sys.argv[1]
mkdir('./'+dir)
mkdir('./'+dir+'/L')
mkdir('./'+dir+'/R')

cap2 = cv2.VideoCapture(0)
cap2.set(cv2.CAP_PROP_FRAME_WIDTH,320)
cap2.set(cv2.CAP_PROP_FRAME_HEIGHT,240)
cap3 = cv2.VideoCapture(2)
cap3.set(cv2.CAP_PROP_FRAME_WIDTH,320)
cap3.set(cv2.CAP_PROP_FRAME_HEIGHT,240)
i = 1
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
    if ret2 and ret3:
        cv2. imwrite('./'+dir+'/R/'+str(i)+'.jpg',frame2)
        cv2. imwrite('./'+dir+'/L/'+str(i)+'.jpg',frame3)
        print(i)
        i += 1
cap2.release()
cap3.release()
cv2.destroyAllWindows()
file = open('./'+dir+'/num.txt','w')
file.write(str(i-1))