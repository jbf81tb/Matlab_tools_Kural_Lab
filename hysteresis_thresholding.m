function SHOW2 = hysteresis_thresholding(input_img)
if ischar(input_img)
    stacks = length(imfinfo(input_img));
    examp = ceil(stacks/3);
    SHOW1 = double(imread(input_img,'Index',examp));
else
    stacks = size(input_img,3);
    examp = ceil(stacks/3);
    SHOW1 = double(input_img(:,:,examp));
end
lowt = 4000; hit = 20000;
numc = 64;
SHOW2 = hysteresis2d(SHOW1,lowt,hit);
%%
close all
fh = figure('WindowButtonDownFcn',@thresh_adj,'Name','Double click image to close');
img_ah = axes('Units','Normalized',...
    'Position',[0 .1 1 .9]);
img_h = imshowpair(SHOW1,SHOW2);
axis equal
axis off
thresh_ah = axes('Units','Normalized',...
    'Position',[0 0 1 .1]);
imagesc(0:1/numc:1-1/numc)
frame_line(thresh_ah,lowt/max(SHOW1(:)),[.8 0 0])
frame_line(thresh_ah,hit/max(SHOW1(:)),[0 .6 0])
axis off
while true
    waitforbuttonpress
    if hit>lowt
        delete(img_h)
        SHOW2 = hysteresis2d(SHOW1,lowt,hit);
        axes(img_ah)
        img_h = imshowpair(SHOW1,SHOW2);
    end
    if strcmp(fh.SelectionType,'open')
        disp([lowt hit])
        close(fh);
        return;
    end
end
% %%
% for i = 1:stacks
%     [bx,by,mask] = thresholding(J(:,:,i),Thresh);
%     if ~isempty(mask)
%         if pastk == 3
%             [~,whch] = max(cellfun(@sum,cellfun(@sum,mask,'UniformOutput',false)));
%         else
%             whch = 1:length(mask);
%         end
%         for ind = whch
%             masks(:,:,i) = mask{ind} + masks(:,:,i);
%             if ind <= length(bx)
%                 for j = 1:length(bx{ind})
%                     masks(by{ind}(j),bx{ind}(j),i) = .5;
%                 end
%             end
%         end
%     end
% end
%%

    function thresh_adj(src,~)
        cp = src.CurrentPoint;
        if cp(1,2)<=0.1
            if strcmp(src.SelectionType,'normal')
                lowt = cp(1,1)*max(SHOW1(:));
                frame_line(thresh_ah,lowt/max(SHOW1(:)),[.8 0 0])
            elseif strcmp(src.SelectionType,'alt')
                hit = cp(1,1)*max(SHOW1(:));
                frame_line(thresh_ah,hit/max(SHOW1(:)),[0 .6 0])
            end
        end
    end

    function frame_line(src,loc,col)
        axes(src)
        tmpch = get(src,'Children');
        for chi = 1:length(tmpch)
            if strcmp(tmpch(chi).Type,'line')
                if all(tmpch(chi).Color==col)
                    delete(tmpch(chi))
                end
            end
        end
        hold on
        line(numc*[loc loc]+.5,[.5 1.5],'linewidth',1,'color',col);
        hold off
    end

end