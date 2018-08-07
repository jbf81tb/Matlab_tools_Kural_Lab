function int_img = interpolate_image(img,scale,disp)
if nargin<3
    disp = false;
end
if nargin<2
    scale = 4;
end
[xhave, yhave] = meshgrid(1:size(img,2),1:size(img,1));
[xwant, ywant] = meshgrid(1:1/scale:size(img,2),1:1/scale:size(img,1));
int_img = griddata(xhave(:),yhave(:),double(img(:)),xwant,ywant,'v4');
if disp
    fh_gauss_fit = figure('Name','Right click to close');
    surface(xwant,ywant,int_img,'edgecolor','none')
    hold on
    scatter3(xhave(:),yhave(:),img(:),'k')
    try
        waitfor(fh_gauss_fit,'SelectionType','alt')
        close(fh_gauss_fit)
    catch
    end
end
end