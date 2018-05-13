img = cell(0);
bboxs = cell(0);
for i = 1 : 160
im = imread(strcat('./carpos/1 (',num2str(i),').jpg'));
img{i,1} = strcat('./carpos/1 (',num2str(i),').jpg');
[h,w] = size(im(:,:,1));
bboxs{i,1} = [1,1,w-1,h-1];
end
positiveInstances = table(img,bboxs);
negativeFolder = fullfile('./carneg');
positiveFolder = fullfile('./carpos');
negativeImages = imageDatastore(negativeFolder);
trainCascadeObjectDetector('carDetector2.xml',positiveInstances, ...
negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',5);
detector = vision.CascadeObjectDetector('carDetector2.xml');