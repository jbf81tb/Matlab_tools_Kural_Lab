% Hist2D(X,Y,edgex,edgey)
% author: Nathan Willy 8/19/2015
% ruined by: Josh Ferguson 12/15/2015
% 
% creates a 2D histogram of given data pairs
% input X: the vector of coordinates to be plotted on the horizontal axis
% input Y: the vector of coordinates to be plotted on the vertical axis
% input edgex: defines the bin edges on the x-axis. any value less than 
%               edgex(1) will be binned in the first pixel. any value
%               greater than edgex(1) but less than edgex(2) will be binned
%               in the second pixel and so on.  Any value greater than
%               edgex(end) will be binned in a final pixel.  Thus the x
%               dimension of the resultant image will be length(edgex)+1.
% input edgey: same as edgex but for the y coordinate
% 
% return img: the matrix containing the counts in the bins defined by edgex
%             and edgey.  img is displayed in what is hoped to be the least
%             confusing way possible when this function is run.


function [img] = Hist2D(X,Y,edgex,edgey,show)

img=zeros(length(edgey)+1,length(edgex)+1);

for(i=1:min(length(X),length(Y)))
    posx=length(edgex)+1;
    posy=length(edgey)+1;
    
%     determine the proper x bin
    for(j=1:length(edgex))
        if(X(i)<=edgex(j))
            posx=j;
            break;
        end
    end
%     determine the proper y bin
    for(j=1:length(edgey))
        if(Y(i)<=edgey(j))
            posy=j;
            break;
        end
    end
% increment bin
    img(posy,posx)=img(posy,posx)+1;
end
if show
    tmp = sort(nonzeros(img(:)),'ascend');
    cmin = tmp(ceil(0.01*end));
    cmax = tmp(ceil(0.99*end));
imagesc(img,[cmin,cmax]);
% axis equal
colorbar
set(gca,'YDir','normal')

xticklabels = horzcat(edgex(1:10^(floor(log10(length(edgex)))-1):end),[inf]);
xticks = linspace(1, size(img, 2), numel(xticklabels));
set(gca, 'XTick', xticks, 'XTickLabel', xticklabels)

yticklabels = horzcat(edgey(1:10^(floor(log10(length(edgey)))-1):end),inf);
yticks = linspace(1, size(img, 1), numel(yticklabels));
set(gca, 'YTick', yticks, 'YTickLabel', yticklabels)
end

end