fl_nm = 'D:\Josh\Matlab\cmeAnalysis_movies\good_bricks\160603_bsc_brick_squish\orig_movies\004';
load([fl_nm '.mat'],'Threshfxyc');

tmpst = fxyc_to_struct(Threshfxyc);
tmpst = slope_finding(tmpst,2,400);

%%
mov_nm = [fl_nm '.tif'];
ml = length(imfinfo(mov_nm));
nt = length(tmpst);
[xpos,ypos,sl] = deal(cell(1,ml));
[xvals,yvals] = deal(zeros(ml,5));
for fr  = 2:ml-231
    num = sum(cellfun(@any,cellfun(@eq,{tmpst.frame},repmat({fr+230},[1 nt]),'uniformoutput',false)));
    [xpos{fr},ypos{fr},sl{fr}] = deal(zeros(1,num));
    k = 1;
    for i = 1:nt
        fr_ind = find(tmpst(i).frame==(fr+230));
        if isempty(fr_ind), continue; end
        xpos{fr}(k) = tmpst(i).xpos(fr_ind);
        ypos{fr}(k) = tmpst(i).ypos(fr_ind);
        sl{fr}(k) = tmpst(i).sl(fr_ind);
        k = k+1;
    end
    vec = [-inf,-.045:.03:.045,inf];
    if isempty(nonzeros(sl{fr})), continue; end
    xvals(fr,:) = -.06:.03:.06;
    [yvals(fr,:),~] = histcounts(nonzeros(cell2mat(sl(fr-1:fr+1))),vec,'normalization','probability');
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
if exist(['.' filesep 'tmp'],'dir'), rmdir('tmp','s'); end
mkdir('tmp');
for fr = 4:ml-231
    close
    figure('units','pixels','position',[0 0 1000 1000],'color',[1 1 1])
    ah = tight_subplot(2,2,.05,[.035 .01],[.045 0.01]);
    img = imread(mov_nm,fr+230);
    bwimg = max(img(:))-img;
    
    axes(ah(1))
    imagesc(bwimg,[max(bwimg(:))/2 max(bwimg(:))])
    colormap(ah(1),gray);
    axis off
    
    axes(ah(2))
    imagesc(bwimg,[0 2*max(bwimg(:))])
    hold on
    sl_to_col = double(max(bwimg(:)))+(sl{fr}+abs(min(sl{fr})))*double(range(bwimg(:)))/range(sl{fr});
    scatter(xpos{fr}(sl{fr}~=0),ypos{fr}(sl{fr}~=0),16,sl_to_col(sl{fr}~=0),'filled')
%     scatter(xpos{fr}(sl{fr}==0),ypos{fr}(sl{fr}==0),10,'k')
    colormap(ah(2),[gray; rainbow]);
    axis off
    
    vec = [-inf,-0.145:.01:0.145,inf];
    xtmp = -0.15:.01:0.15;
    axes(ah(3))
    [ytmp,~] = histcounts(nonzeros(cell2mat(sl(fr-1:fr+1))),vec,'normalization','probability');
    pxval = [(-.15:(.3/64):(.15-.3/64))', ((-.15+.3/64):(.3/64):.15)',...
             ((-.15+.3/64):(.3/64):.15)', (-.15:(.3/64):(.15-.3/64))'];
    pyval = repmat([0 0 .3 .3],64,1);
    p = patch(pxval',pyval',(1:64)');
    colormap(rainbow);
    set(p,'facealpha',.5,'edgecolor','none');
    hold on
    plot(xtmp, ytmp,'k','linewidth',6)
    set(ah(3),'xtick',-.15:.05:.15,'ytick',0:.05:.3,'ylim',[0 .3],'xlim',[-.15 .15],'fontsize',14)
    
    axes(ah(4))
    hold on
    bar(xvals(3:fr,1)+.03*(0:(fr-3))'/(ml-4),yvals(3:fr,1),1,'facecolor',[.4 .0 .8],'edgecolor','none')
    bar(xvals(3:fr,2)+.03*(0:(fr-3))'/(ml-4)+.01,yvals(3:fr,2),1,'facecolor',[.0 .0 .8],'edgecolor','none')
    bar(xvals(3:fr,3)+.03*(0:(fr-3))'/(ml-4)+.02,yvals(3:fr,3),1,'facecolor',[.0 .8 .0],'edgecolor','none')
    bar(xvals(3:fr,4)+.03*(0:(fr-3))'/(ml-4)+.03,yvals(3:fr,4),1,'facecolor',[.8 .4 .0],'edgecolor','none')
    bar(xvals(3:fr,5)+.03*(0:(fr-3))'/(ml-4)+.04,yvals(3:fr,5),1,'facecolor',[.8 .0 .0],'edgecolor','none')
    set(ah(4),'xtick',[],'ytick',[0 .25 .5 .75],'ylim',[0 .75],'xlim',[-.07 .14],'fontsize',14)
    
    frame = getframe(gcf);
    imwrite(frame.cdata,['tmp' filesep sprintf('%03u',fr), '.tif'],'tif')
end
close