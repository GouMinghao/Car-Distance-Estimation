function dispar(root,filename)
    load('param.mat')
    I1 = imread(strcat(root,'/L/',filename,'.jpg'));
    I2 = imread(strcat(root,'/R/',filename,'.jpg'));
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
    figure(1)
    subplot(3,1,2)
    imshow(d0/50)
    subplot(3,1,1)
    imshow(J1)
    title('left')
    subplot(3,1,3)
    imshow(J2)
    title('right')



    figure(2)
    subplot(2,1,1)
    pcolor(5 * d0)
    colorbar
    view(0,-90)
    shading flat


    xyzPoints = reconstructScene(d,stereoParams);
    Z = xyzPoints(:,:,3);
    mask = repmat(Z > 3000 & Z < 3700,[1,1,3]);
    J1(~mask) = 0;
    subplot(2,1,2)
    pcolor(Z)
    colorbar
    shading flat
    view(0,-90)
    % imshow(J1,'InitialMagnification',50);
    

    figure(3)
    plot3(xyzPoints(:,:,1),xyzPoints(:,:,2),xyzPoints(:,:,3),'.')
end