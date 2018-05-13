"carDetector.xml" is the the object locator.  
Loading it by:  
```matlab
detector = vision.CascadeObjectDetector('carDetector2.xml');
img = imread('???.jpg');
bbox = step(detector,img);
detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'Car');
```
"Param.mat" is the params of the stereo camera.  
Using it by:  
```matlab
[J1,J2] = rectifyStereoImages(I1,I2,stereoParams,'OutputView','valid');
```
