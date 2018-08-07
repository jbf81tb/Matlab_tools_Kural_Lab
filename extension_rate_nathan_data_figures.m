[masks, thresh] = spread_cell_thresholding('original_movie_with_masks_applied.tif');
%%
frames = cell2mat({tmpst.frame}');
tp = cell2mat(cellfun(@find,{tmpst.frame},'UniformOutput',false)');
tmp1 = cellfun(@gt,{tmpst.frame},repmat({0},size(tmpst)),'UniformOutput',false);
tmp2 = num2cell([tmpst.lt]);
lt = cell2mat(cellfun(@mtimes,tmp1,tmp2,'UniformOutput',false)');

ml = max(frames);
[conc,init] = deal(zeros(1,ml));
frame_rate = 3;
for fr = 1:ml
    area = sum(reshape(masks(:,:,fr),[],1))*.16*.16;
    initsum = sum(tp(frames==fr)==1);
    concsum = sum(tp(frames==fr)==lt(frames==fr));
    init(fr) = initsum/frame_rate/area;
    conc(fr) = concsum/frame_rate/area;
end
    

%%
rad = 0.025;
i = 1;
vec = (-.5-rad):rad:(1-rad);
[initmn, initer, concmn, concer] = deal([]);
for ner = vec
    in = abs(ext-ner)<=rad;
    initmn(i) = mean(init(in));
    initer(i) = std(init(in));
    concmn(i) = mean(conc(in));
    concer(i) = std(conc(in));
    i = i+1;
end
rmnan = isnan(initer)|isnan(concer);
vec(rmnan) = [];
initmn(rmnan) = [];
initer(rmnan) = [];
concmn(rmnan) = [];
concer(rmnan) = [];
%%
close
figure('color','white')

patch('faces',1:2*length(vec)+1,...
      'vertices',[vec' (initmn+initer)';...
                  vec(end:-1:1)' (initmn(end:-1:1)-initer(end:-1:1))';...
                  vec(1)' (initmn(1)+initer(1))'],...
      'facecolor',[.4 .4 .4],...
      'edgecolor','none',...
      'facealpha',.3)
  hold on
plot(vec,initmn,'k','linewidth',2)
plot([0 0], [-.2 1],'k:')
ylim([-.2 1])
xlim([-.35 1])
set(gca,'ticklength',[0.002 0.002],'fontsize',12,'linewidth',2,...
        'xtick',[-.35 0 .5 1],'ytick',-.2:.2:1)
xlabel('Normalized Extension Rate','Fontsize',14)
ylabel('Normalized Initiation Density','Fontsize',14)
%%
close
figure('color','white')

patch('faces',1:2*length(vec)+1,...
      'vertices',[vec' (concmn+concer)';...
                  vec(end:-1:1)' (concmn(end:-1:1)-concer(end:-1:1))';...
                  vec(1)' (concmn(1)+concer(1))'],...
      'facecolor',[.4 .4 .4],...
      'edgecolor','none',...
      'facealpha',.3)
  hold on
plot(vec,concmn,'k','linewidth',2)
plot([0 0], [-.2 1],'k:')
ylim([-0.2 1])
xlim([-.35 1])
set(gca,'ticklength',[0.002 0.002],'fontsize',12,'linewidth',2,...
        'xtick',[-.35 0 .5 1],'ytick',-.2:.2:1)
xlabel('Normalized Extension Rate','Fontsize',14)
ylabel('Normalized Conclusion Density','Fontsize',14)