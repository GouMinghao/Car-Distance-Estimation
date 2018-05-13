function genVideo(foldername)
    mkdir(foldername)
    num = load(strcat('../Video/',foldername,'/num.txt'));
    load('../Integration/Data/Param.mat')
    detector = vision.CascadeObjectDetector('../Integration/data/carDetector2.xml');
    for n = 2 : num
        filename = num2str(n);
        I1 = imread(strcat('../Video/',foldername,'/L/',filename,'.jpg'));
        I2 = imread(strcat('../Video/',foldername,'/R/',filename,'.jpg'));
        [J1,J2] = rectifyStereoImages(I1,I2,stereoParams,'OutputView','valid');
        d = disparity(rgb2gray(J1),rgb2gray(J2),'BlockSize',9,'Method','SemiGlobal');
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

        
%         subplot(3,1,2)
%         imshow(d0/50)
%         subplot(3,1,1)
%         imshow(J1)
%         title('left')
%         subplot(3,1,3)
%         imshow(J2)
%         title('right')

        % figure(2)
        % subplot(2,1,1)
        % pcolor(5 * d0)
        % colorbar
        % view(0,-90)
        % shading flat

        xyzPoints = reconstructScene(d,stereoParams);
        Z = xyzPoints(:,:,3)/1000;
        % subplot(2,1,2)
        % surf(Z)
        % colorbar
        % shading flat
        % view(0,-90)


        img = J1;
        bbox = step(detector,img);
        detectedImg = img;

        [h,w] = size(bbox);
        cars = cell(h);
        distances = cell(h);
        distance = zeros(h,1);
        for i = 1 : h
            cars{i} = img(bbox(i,2):bbox(i,2) + bbox(i,4),bbox(i,1):bbox(i,1) + bbox(i,3));
            distances{i} = Z(bbox(i,2):bbox(i,2) + bbox(i,4),bbox(i,1):bbox(i,1) + bbox(i,3));
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
            % figure(i + 2)
            % imshow(cars{i})
            detectedImg = insertObjectAnnotation(detectedImg,'rectangle',bbox(i,:),strcat('Car ',num2str(i)));
            detectedImg = insertObjectAnnotation(detectedImg,'rectangle',[1,20 * (i - 1) + 1,1,1],strcat(num2str(distance(i)),'m'));
        end


        imshow(detectedImg)
        imwrite(detectedImg,strcat('./',foldername,'/',num2str(n-1),'.jpg'));
    end
end