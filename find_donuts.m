%finds donut-like pixels in an image

% inputs:
%     img: the image you would like donuts found in
%     num: the number of donuts you would like returned
% 
% outputs:
%     result: the image giving the "donut value" of each pixel
%     x,y: the x and y positions of the top num number of pixels.
%         you will actually get fewer than num because it reconciles
%         pixels which are close together
% 
% how it works:
%     it finds pixels who have bright neightboring pixels, but which are dimmer than a large number of its 8 neighbors.
% 
% more specifically:
%     for it each pixel, it counts the number of the 8 neighboring pixels which are at least brightness_thresh brighter
%     it.  It then multiplies this number by the summed brightness of the pixel's 8 neighboars. It find the num number 
%     of pixels with the highest values. It then goes through those and finds the center point of such pixels which are 
%     within reconciliation_radius of each other.

function [x,y] = find_donuts(img)
    mnimg = mean(img(:));
    stdimg = std(img(:));
    brightness_thresh=2*stdimg;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% 3x3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    kernels = cell(1,8);
    kernels{1} = [0,-1,1];
    kernels{2} = kernels{1}';
    kernels{3} = flipud(kernels{2});
    kernels{4} = kernels{3}';
    kernels{5} = [0  0 1;...
                  0 -1 0;...
                  0  0 0];
    kernels{6} = fliplr(kernels{5});
    kernels{7} = flipud(kernels{6});
    kernels{8} = fliplr(kernels{7});
    
    result = zeros(size(img),'uint8');
    for i=1:length(kernels)
        result = result + uint8((conv2(img,kernels{i},'same')-brightness_thresh)>0);
    end
    result = result.*uint8(result>=(3*length(kernels)/4));
    result = result.*uint8(img>mnimg);

    [y,x] = find(result>0);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% 3x4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    kernels = cell(1,10);
    kernels{1} = [0  0   0  0;...
                  0 -.5 -.5 0;...
                  1  0   0  0];
    kernels{2} = fliplr(kernels{1});
    kernels{3} = flipud(kernels{2});
    kernels{4} = fliplr(kernels{3});
    kernels{5} = [0  0   0  0;...
                  0 -.5 -.5 0;...
                  0  1   0  0];
    kernels{6} = fliplr(kernels{5});
    kernels{7} = flipud(kernels{6});
    kernels{8} = fliplr(kernels{7});
    kernels{9} = [1 -.5 -.5 0];
    kernels{10} = fliplr(kernels{9});
    
    result = zeros(size(img),'uint8');
    for i=1:length(kernels)
        result = result + uint8((conv2(img,kernels{i},'same')-brightness_thresh)>0);
    end
    result = result.*uint8(result>=(3*length(kernels)/4));
    result = result.*uint8(img>mnimg);
    [ty,tx] = find(result>0);
    y = [y; ty];
    x = [x; tx];
    %%%%%%%%%%%%%%%%%%%%%%%%%% 4x3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    kernels = cell(1,10);
    kernels{1} = [0  0  0;...
                  1 -.5 0;...
                  0 -.5 0;...
                  0  0  0];
    kernels{2} = fliplr(kernels{1});
    kernels{3} = flipud(kernels{2});
    kernels{4} = fliplr(kernels{3});
    kernels{5} = [1  0  0;...
                  0 -.5 0;...
                  0 -.5 0;...
                  0  0  0];
    kernels{6} = fliplr(kernels{5});
    kernels{7} = flipud(kernels{6});
    kernels{8} = fliplr(kernels{7});
    kernels{9} = [1;-.5;-.5;0];
    kernels{10} = flipud(kernels{9});
    
    result = zeros(size(img),'uint8');
    for i=1:length(kernels)
        result = result + uint8((conv2(img,kernels{i},'same')-brightness_thresh)>0);
    end
    result = result.*uint8(result>=(3*length(kernels)/4));
    result = result.*uint8(img>mnimg);
    [ty,tx] = find(result>0);
    y = [y; ty];
    x = [x; tx];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% 4x4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    kernels = cell(1,12);
    kernels{1} = [0   0    0  0;...
                  0 -.25 -.25 0;...
                  0 -.25 -.25 0;...
                  1   0    0  0];
    kernels{2} = fliplr(kernels{1});
    kernels{3} = flipud(kernels{2});
    kernels{4} = fliplr(kernels{3});
    kernels{5} = [0   0    0  0;...
                  0 -.25 -.25 0;...
                  0 -.25 -.25 0;...
                  0   1    0  0];
    kernels{6} = fliplr(kernels{5});
    kernels{7} = flipud(kernels{6});
    kernels{8} = fliplr(kernels{7});
    kernels{9} = [0   0    0  0;...
                  0 -.25 -.25 0;...
                  1 -.25 -.25 0;...
                  0   0    0  0];
    kernels{10} = fliplr(kernels{9});
    kernels{11} = flipud(kernels{10});
    kernels{12} = fliplr(kernels{11});
    
    result = zeros(size(img),'uint8');
    for i=1:length(kernels)
        result = result + uint8((conv2(img,kernels{i},'same')-brightness_thresh)>0);
    end
    result = result.*uint8(result>=(3*length(kernels)/4));
    result = result.*uint8(img>mnimg);
    [ty,tx] = find(result>0);
    y = [y; ty];
    x = [x; tx];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% cross %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    kernels = cell(1,16);
    kernels{1} = [0  0   0   0  0;...
                  1  0  -.2  0  0;...
                  0 -.2 -.2 -.2 0;...
                  0  0  -.2  0  0;...
                  0  0   0   0  0];
    kernels{2} = fliplr(kernels{1});
    kernels{3} = flipud(kernels{2});
    kernels{4} = fliplr(kernels{3});
    kernels{5} = [0  0   0   0  0;...
                  0  1  -.2  0  0;...
                  0 -.2 -.2 -.2 0;...
                  0  0  -.2  0  0;...
                  0  0   0   0  0];
    kernels{6} = fliplr(kernels{5});
    kernels{7} = flipud(kernels{6});
    kernels{8} = fliplr(kernels{7});
    kernels{9} = [0  1   0   0  0;...
                  0  0  -.2  0  0;...
                  0 -.2 -.2 -.2 0;...
                  0  0  -.2  0  0;...
                  0  0   0   0  0];
    kernels{10} = fliplr(kernels{9});
    kernels{11} = flipud(kernels{10});
    kernels{12} = fliplr(kernels{11});
    kernels{13} = [0  0   1   0  0;...
                  0  0  -.2  0  0;...
                  0 -.2 -.2 -.2 0;...
                  0  0  -.2  0  0;...
                  0  0   0   0  0];
    kernels{14} = flipud(kernels{13});
    kernels{15} = kernels{14}';
    kernels{16} = fliplr(kernels{15});
    
    result = zeros(size(img),'uint8');
    for i=1:length(kernels)
        result = result + uint8((conv2(img,kernels{i},'same')-brightness_thresh)>0);
    end
    result = result.*uint8(result>=(3*length(kernels)/4));
    result = result.*uint8(img>mnimg);
    [ty,tx] = find(result>0);
    y = [y; ty];
    x = [x; tx];

end