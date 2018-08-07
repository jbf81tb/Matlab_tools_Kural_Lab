st = tmpst3;
ml = max(cellfun(@max,{st.frame}));
slopes = cell(1,ml);
frw = 10;
frr = frw/2;
for fr = frr:frw:ml-frr+1
    for i = 1:length(st)
        frind = find(st(i).frame==fr);
        if isempty(frind), continue; end
        slopes{fr} = [slopes{fr} st(i).sl(max(1,frind-frr):min(length(st(i).frame),frind+frr))'];
    end
    slopes{fr} = nonzeros(slopes{fr});
end
%%
close
figure
axh = axes;
if exist('tmp.tif','file'), delete('tmp.tif'); end
for fr = frr:frw:ml-frr+1
    [y,~] = histcounts(slopes{fr},[-inf -0.145:.01:0.145 inf],'normalization','probability');
    x = -.15:.01:.15;
    plot(x,y)
    xlim([-.155 .155])
    ylim([0 .3])
    frame = getframe(axh);
    imwrite(frame.cdata,'tmp.tif','writemode','append')
end