function [fst,integ] = twoDgaussianFitting_theta(img, disp)
% c(1) = background
% c(2) = amplitude
% c(3) = x center
% c(4) = y center
% c(5) = theta about z axis
% c(6) = sd_x
% c(7) = sd_y
[ydata, xdata] = meshgrid(1:size(img,2), 1:size(img,1));
F = @(back, amp, x0, y0, th, sx, sy, x, y)back+amp*exp(-( ...
    (cos(th)^2/(2*sx^2)+sin(th)^2/(2*sy^2))*(x-x0).^2 + ...
    (sin(2*th)/(4*sy^2)-sin(2*th)/(4*sx^2))*(x-x0).*(y-y0) + ...
    (sin(th)^2/(2*sx^2)+cos(th)^2/(2*sy^2))*(y-y0).^2));
c0 = double([mean(min(img)) max(img(:))-mean(min(img))    ceil(size(img,2)/2) ceil(size(img,1)/2) pi   1             1]);
low = double([min(img(:))   mean(img(:))-min(img(:))      c0(3)/2             c0(4)/2             0    0             0]);
up = double([mean(img(:))   1.1*(max(img(:))-min(img(:))) 3*c0(3)/2           3*c0(4)/2           2*pi size(img,2)/4 size(img,1)/4]);
xdata = double(xdata); ydata = double(ydata); img = double(img);
gfit = fit([xdata(:), ydata(:)], img(:), F, 'StartPoint', c0, 'Lower', low, 'Upper', up);
if disp
    fh_gauss_fit = figure('Name','Right click to close');
    plot(gfit, [xdata(:), ydata(:)], img(:));
    try
        waitfor(fh_gauss_fit,'SelectionType','alt')
        close(fh_gauss_fit)
    catch
    end
end

c = coeffvalues(gfit);
fst.background = c(1);
integ = quad2d(gfit,0.5,size(img,1)+.5,0.5,size(img,2)+.5)-c(1)*size(img,1)*size(img,2);
fst.amp = c(2);
fst.xpos = c(3);
fst.ypos = c(4);
fst.theta = c(5);
fst.sdx = c(6);
fst.sdy = c(7);
end