function binary = near_to_center_max_fill_binarize(img,varargin)
switch nargin
    case 1
        tol = 0.05;
    case 2
        tol = varargin{1};
end
cx = ceil(size(img,2)/2);
cy = ceil(size(img,1)/2);
maxi = 0;
step = 0;
for r = 0:ceil(sqrt(cx^2+cy^2))
    [x, y] = meshgrid(1:size(img,2),1:size(img,1));
    x = x-cx;
    y = y-cy;
    mask = round(sqrt(x.^2+y.^2))==r;
    if sum(mask(:))==0, break; end
    tmpimg = mask.*img;
    if max(tmpimg(:))>(maxi*(1+tol*step))
        maxi = max(tmpimg(:));
        [my,mx] = find(tmpimg==maxi,1);
        step = 0;
    else
        step = step+1;
    end
end
saved = false(size(img));
cx = mx;
cy = my;
saved(cy,cx) = true;
tmpimg = img;
nx = cx; ny = cy;
% fh = figure;
% axes
% axis equal
while true
    for i = -1:1
        for j = -1:1
            if i==0 && j==0, continue; end
            if saved(cy+j,cx+i), continue; end
            try
                dif = tmpimg(cy,cx)-tmpimg(cy+j,cx+i);
                if dif>=0
                    nx(end+1) = cx+i;
                    ny(end+1) = cy+j;
                end
            catch
            end
        end
    end
    saved(cy,cx) = true;
%     imagesc(saved)
%     pause(.05)
    rm_ind = nx==cx&ny==cy;
    nx(rm_ind) = [];
    ny(rm_ind) = [];
    if isempty(nx) && isempty(ny), break; end
    cx = nx(end);
    cy = ny(end);
end
binary = imfill(saved,'holes');
% close(fh)
end