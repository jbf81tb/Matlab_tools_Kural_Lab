function img = max_proj_maker(mov_nm,varargin)
if nargin == 1
    write = false;
else
    write = varargin{1};
end
filename = [mov_nm(1:end-4) '_max_proj.tif'];
mov_sz = [size(imread(mov_nm)), length(imfinfo(mov_nm))];
sum_img = zeros(mov_sz(1:2));
if exist(filename,'file'), delete(filename); end
for fr = 1:mov_sz(3)
    tmp = imread(mov_nm,fr);
    sum_img = sum_img + double(tmp);
end
img = mean(sum_img,3);
if write
    imwrite(img,filename,'writemode','append')
end
end