fl_nm = 'D:\Josh\Matlab\cmeAnalysis_movies\good_bricks\160701_bsc_brick\orig_movies\002';
load([fl_nm '.mat'],'Threshfxyc');
mask = ~imread('002_Mask.tif');
tmpst = fxyc_to_struct(Threshfxyc);
tmpst = slope_finding(tmpst,2,400);

%%
mov_nm = [fl_nm '.tif'];
% ml = length(imfinfo(mov_nm));
ml = 600;
nt = length(tmpst);
[xpos,ypos,sl,lt] = deal(cell(1,ml));
[xvals,yvals] = deal(zeros(ml,5));
mlt = zeros(1,ml);
for fr  = 1:ml
    num = sum(cellfun(@any,cellfun(@eq,{tmpst.frame},repmat({fr},[1 nt]),'uniformoutput',false)));
    [xpos{fr},ypos{fr},sl{fr}] = deal(zeros(1,num));
    k = 1;
    for i = 1:nt
        fr_ind = find(tmpst(i).frame==(fr));
        if isempty(fr_ind), continue; end
        tmpx = tmpst(i).xpos(fr_ind);
        tmpy = tmpst(i).ypos(fr_ind);
        if mask(ceil(tmpy),ceil(tmpx)), continue; end
        xpos{fr}(k) = tmpx;
        ypos{fr}(k) = tmpy;
        sl{fr}(k) = tmpst(i).sl(fr_ind);
        lt{fr}(k) = 2*tmpst(i).lt;
        k = k+1;
    end
    if fr>=3
        mlt(fr-1) = median(nonzeros(cell2mat(lt(fr-2:fr))));
        vec = [-inf,-.045:.03:.045,inf];
        if isempty(nonzeros(cell2mat(sl(fr-2:fr)))), continue; end
        xvals(fr-1,:) = -.06:.03:.06;
        [yvals(fr-1,:),~] = histcounts(nonzeros(cell2mat(sl(fr-2:fr))),vec,'normalization','probability');
    end
end
%%
rainbow(1,:) = [.4 0 .8];
for i = 2:64
    if i>1 && i<=16
        rainbow(i,:) = [.4-.4*((i-1)/15) 0 .8];
    elseif i>16 && i<=32
        rainbow(i,:) = [0 0+.8*((i-16)/16) .8-.8*((i-16)/16)];
    elseif i>32 && i<=48
        rainbow(i,:) = [.0+.8*((i-32)/16) .8-.4*((i-32)/16) .0];
    elseif i>48 && i<=64
        rainbow(i,:) = [.8 .4-.4*((i-49)/15) .0];
    end
end
%%
if exist('.\tmp','dir'), rmdir('tmp','s'); end
mkdir('tmp');
for fr = 4:ml-3
    close
    figure('units','pixels','position',[0 0 1180 1000],'color',[1 1 1])
    img = imread(mov_nm,fr);
    bwimg = max(img(:))-img;

    imah = axes('units','pixels',...
         'position',[10 10 600 980]);
    imagesc(bwimg,[0 2*max(bwimg(:))])
    hold on
    sl_to_col = double(max(bwimg(:)))+(sl{fr}+abs(min(sl{fr})))*double(range(bwimg(:)))/range(sl{fr});
    scatter(xpos{fr}(sl{fr}~=0),ypos{fr}(sl{fr}~=0),20,sl_to_col(sl{fr}~=0),'filled')
%     scatter(xpos{fr}(sl{fr}==0),ypos{fr}(sl{fr}==0),10,'k')
    colormap(imah,[gray; rainbow]);
    xlim([100 410])
    axis off
    
    ltah = axes('units','pixels',...
         'position',[660 70 490 440]);
    plot(6:2:2*fr,mlt(3:fr),'k','linewidth',2)
    xlabel('Frame (s)')
    set(ltah,'xtick',0:200:1200,'xlim',[0 1200],'ytick',0:50:250,'ylim',[0 250],'fontsize',14)
    
    shah = axes('units','pixels',...
         'position',[660 550 490 430]);
    hold on
    bar(xvals(3:fr,1)+.03*(0:(fr-3))'/(ml-4),yvals(3:fr,1),1,'facecolor',[.4 .0 .8],'edgecolor','none')
    bar(xvals(3:fr,2)+.03*(0:(fr-3))'/(ml-4)+.01,yvals(3:fr,2),1,'facecolor',[.0 .0 .8],'edgecolor','none')
    bar(xvals(3:fr,3)+.03*(0:(fr-3))'/(ml-4)+.02,yvals(3:fr,3),1,'facecolor',[.0 .8 .0],'edgecolor','none')
    bar(xvals(3:fr,4)+.03*(0:(fr-3))'/(ml-4)+.03,yvals(3:fr,4),1,'facecolor',[.8 .4 .0],'edgecolor','none')
    bar(xvals(3:fr,5)+.03*(0:(fr-3))'/(ml-4)+.04,yvals(3:fr,5),1,'facecolor',[.8 .0 .0],'edgecolor','none')
    set(shah,'xtick',[],'ytick',[0 .25 .5 .75],'ylim',[0 .75],'xlim',[-.07 .14],'fontsize',14)
     
    frame = getframe(gcf);
    imwrite(frame.cdata,['tmp' filesep sprintf('%03u',fr), '.tif'],'tif')
    fprintf('                               %f\n',100*fr/ml)
end
close