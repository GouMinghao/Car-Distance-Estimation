function genVideoraw(foldername)
    mkdir(foldername)
    num = load(strcat('../Video/',foldername,'/num.txt'));
    myObj = VideoWriter(strcat('./',foldername,'/',foldername,'-undistort'),'MPEG-4');%初始化一个avi文件
    myObj.FrameRate = 10;
    open(myObj);
    for n = 2 : num
        filename = num2str(n);
        I1 = imread(strcat('../Undistort/',foldername,'/',filename,'.jpg'));
        writeVideo(myObj,I1);

    end
    close(myObj);
end