function genVideo(foldername)
    mkdir(foldername)
    load('../Integration/Data/Param.mat')
    num = load(strcat('../Video/',foldername,'/num.txt'));
    for n = 2 : num
        filename = num2str(n);
        I1 = imread(strcat('../Video/',foldername,'/R/',filename,'.jpg'));
        I2 = imread(strcat('../Video/',foldername,'/L/',filename,'.jpg'));
        [J1,J2] = rectifyStereoImages(I1,I2,stereoParams,'OutputView','valid');
        imwrite(J1,strcat('./',foldername,'/',filename,'.jpg'))
    end
end