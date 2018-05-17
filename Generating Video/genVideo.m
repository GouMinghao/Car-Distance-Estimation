function genVideo(foldername)
    mkdir(foldername)
    num = load(strcat('../Video/',foldername,'/num.txt'));
    load('../Integration/Data/Param.mat')
    detector = vision.CascadeObjectDetector('../Integration/data/carDetector2.xml');
    myObj = VideoWriter(strcat('./',foldername,'/',foldername),'MPEG-4');%初始化一个avi文件
    myObj.FrameRate = 10;
    videoDepth = VideoWriter(strcat('./',foldername,'/depth-',foldername),'MPEG-4');%初始化一个avi文件
    videoDepth.FrameRate = 10;
    open(myObj);
    open(videoDepth);
    for n = 2 : num
        filename = num2str(n);
        I1 = imread(strcat('../Video/',foldername,'/R/',filename,'.jpg'));
        I2 = imread(strcat('../Video/',foldername,'/L/',filename,'.jpg'));
        [J1,J2] = rectifyStereoImages(I1,I2,stereoParams,'OutputView','valid');
        d = disparity(rgb2gray(J1),rgb2gray(J2),'BlockSize',15,'Method','SemiGlobal');
        [height,width] = size(d);
        d0 = zeros(height,width);
        for i = 1:height
            for j = 1:width
                if d(i,j)<0
                    d0(i,j) = 0;
                else
                    d0(i,j) = d(i,j);
                end
            end
        end


        xyzPoints = reconstructScene(d,stereoParams);
        Z = xyzPoints(:,:,3)/1000;

        img = J1;
        bbox = step(detector,img);
        detectedImg = img;

        [h,w] = size(bbox);
        % cars = cell(1);
        distances = cell(1);
        distance = zeros(h,1);
        for i = 1 : h
            % cars{i} = img(round(bbox(i,2) + 1/3* bbox(i,4)):round(bbox(i,2) + 2/3* bbox(i,4)),round(bbox(i,1) + 1/3* bbox(i,3)):round(bbox(i,1) + 2/3* bbox(i,3)),:);
            distances{i} = Z(round(bbox(i,2) + 1/3* bbox(i,4)):round(bbox(i,2) + 2/3* bbox(i,4)),round(bbox(i,1) + 1/3* bbox(i,3)):round(bbox(i,1) + 2/3* bbox(i,3)));
            dis=distances{i};
            [hd,wd] = size(dis);
            s = 1;
            nonandis = zeros(1,hd * wd);
            for p = 1 : hd
                for q = 1 : wd
                    if (1- isnan(dis(p,q)))
                        nonandis(s) = dis(p,q);
                        s = s + 1;
                    end
                end
            end
            distance(i) = median(median(nonandis(1:s-1)));
            detectedImg = insertObjectAnnotation(detectedImg,'rectangle',bbox(i,:),strcat(num2str(distance(i)),'m'));
        end
        % save(strcat('./',foldername,'/',num2str(n)),'cars','distances')

        imshow(d0/15.0)
        writeVideo(videoDepth,d0/(max(max(d0))));   
        writeVideo(myObj,detectedImg);

    end
    close(myObj);
end