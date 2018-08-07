celltype = 'sum_control';
switch celltype
    case 'sum_mbcd'
        pth = 'Y:\Josh\Ema_SUM_SIM_mbcd\';
        px = 40;
    case 'sum_control'
        pth = 'Y:\Josh\Ema_SUM_SIM\';
        px = 40;
    case 'cos'
        pth = 'Y:\Josh\TIRF - SIM data_Betzig and Dong Li\COS7 cells\';
        px = 30;
    case 'bsc'
        pth = 'F:\Josh\Matlab\SRRF_movies\SIM_data\';
        px = 30;
end
img = double(imread([pth 'clipped_average_' celltype '.tif']));

img = bsc_rmov(:,:,round(ai*mai/num_plot));
oss = size(img);
[X,Y] = meshgrid(1:oss(2),1:oss(1));
scale = 10;
[Xq,Yq] = meshgrid(linspace(1,oss(2),scale*oss(2)),linspace(1,oss(1),scale*oss(1)));
img = interp2(X,Y,img,Xq,Yq,'spline');
ss = scale*oss;
%%
full = floor(-max(ss)/sqrt(2)):ceil(max(ss)/sqrt(2));
disp = false;
disp = true;
if disp
    close
    figure('units','normalized','outerposition',[0 0 1 1])
end
deg = 5;
div = 180/deg;
prof = cell(1,div+1);
k = 1;
for th = 0:pi/div:pi
    % th = 5*pi/18;
    xl = full*cos(th)+ss(2)/2;
    yl = full*sin(th)+ss(1)/2;
    cond = (xl>=1)&(xl<=ss(2))&(yl>=1)&(yl<=ss(1));
    xl = xl(cond);
    yl = yl(cond);
    prof{k} = improfile(img,xl,yl,'bicubic');
    if disp
        imagesc(img)
        axis equal
        hold on
        plot(xl,yl)
        pause(1/10)
    end
    k = k+1;
end
if disp
    close
end
%%
default = max(ceil(cellfun(@length,prof)/2));
sumprof = zeros(1,default);
count = 0;
for i = 1:length(prof)
    lp = length(prof{i});
    switch mod(lp,2)
        case 0
            mp = lp/2;
            tmp1 = prof{i}(mp+1:end);
        case 1
            mp = ceil(lp/2);
            tmp1 = prof{i}(mp:end);
    end
    tmp2 = prof{i}(mp:-1:1);
    for j = 1:mp
        sumprof(j) = sumprof(j) + tmp1(j);
        count = count+1;
        sumprof(j) = sumprof(j) + tmp2(j);
        count = count+1;
    end
end
plot(px*linspace(0,(default-1)/scale,default),sumprof/count)
title(celltype)
xlabel('radius (nm)')