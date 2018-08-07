function canny_thresholding(filename)
%%
if nargin < 1
    input('What is the filename (including extension) of the movie? ',filename);
elseif nargin == 1
    if ~ischar(filename)
        error('Input must be filename in single quotes (must be a string).');
    end
else
    error('Too many inputs.')
end
%%
lowt = 0.05; hit = .15;
numc = 64;
s = size(imread(filename));
stacks = length(imfinfo(filename));
masks = zeros(s(1),s(2),stacks,'double');
J = zeros(s(1),s(2),stacks,'uint16');
IMG = zeros(s(1),s(2),stacks,'double');
examp = floor(stacks/3);
SHOW1 = imread(filename,'Index',examp);
% SHOW1 = SHOW1(1:500,1:500);
SHOW2 = edge(SHOW1,'canny',[lowt hit],8);
SHOW2 = imfill(SHOW2,'holes');
%%
close all
fh = figure('WindowButtonDownFcn',@thresh_adj);
img_ah = axes('Units','Normalized',...
    'Position',[0 .1 1 .9]);
img_h = imshowpair(SHOW1,SHOW2);
axis equal
axis off
thresh_ah = axes('Units','Normalized',...
    'Position',[0 0 1 .1]);
imagesc(0:1/numc:1-1/numc)
frame_line(thresh_ah,lowt,[.8 0 0])
frame_line(thresh_ah,hit,[0 .6 0])
axis off
while true
    waitforbuttonpress
    if hit>lowt
        delete(img_h)
        SHOW2 = edge(SHOW1,'canny',[lowt hit],8);
        SHOW2 = imfill(SHOW2,'holes');
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
                lowt = cp(1,1);
                frame_line(thresh_ah,lowt,[.8 0 0])
            elseif strcmp(src.SelectionType,'alt')
                hit = cp(1,1);
                frame_line(thresh_ah,hit,[0 .6 0])
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