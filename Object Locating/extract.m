fileFolder=fullfile('./cls/');
dirOutput=dir(fullfile(fileFolder,'*.mat'));
fileNames={dirOutput.name}';
fileNames=strrep(fileNames,'.mat','');
number = size(fileNames);
number = number(1);
npos = 1;
nneg = 1;
bboxspos = cell(0);
filespos = cell(0);
bboxsneg = cell(0);
filesneg = cell(0);
for i = 1 : number
    bboxpos = zeros(1,4);
    bboxneg = zeros(1,4);
    load(strcat('./cls/',fileNames{i},'.mat'))
    c = GTcls.CategoriesPresent;
    if ismember(7,c)
        b = GTcls.Boundaries{7};
        b = full(b);
        bboxpos = getbbox(b);
        bboxspos{npos,1} = bboxpos;
        filespos{npos,1} = strcat('./img/',fileNames{i},'.png');
        npos = npos + 1;
        fprintf('[%d/300]\n',npos)
        if npos > 300
            break;
        end
    elseif nneg < 1000
        % b = GTcls.Boundaries{c(1)};
        % b = full(b);
        % bboxneg = getbbox(b);
        % bboxsneg{nneg,1} = bboxneg;
        % filesneg{nneg,1} = strcat('./img/',fileNames{i},'.png');
        % nneg = nneg + 1;
        im = imread(strcat('./img/',fileNames{i},'.png'));
        imwrite(im,strcat('./neg/',fileNames{i},'.png'))
        nneg = nneg + 1;
    end
end
posImage = table(filespos,bboxspos);
negImage = table(filesneg,bboxsneg);
save('carLabels','posImage','negImage')
negImageFolder = fullfile('./neg/');
negativeImages = imageDatastore(negImageFolder);
trainCascadeObjectDetector('carDetect.xml',posImage,negImageFolder,'FalseAlarmRate',0.1,'NumCascadeStages',5);