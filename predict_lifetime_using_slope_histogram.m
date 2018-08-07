frames = cell2mat({tmpst.frame}');
slopes = cell2mat({tmpst.sl}');
tmp1 = cellfun(@gt,{tmpst.frame},repmat({0},size(tmpst)),'UniformOutput',false);
tmp2 = num2cell([tmpst.lt]);
tmp3 = num2cell([tmpst.class]);
lt = cell2mat(cellfun(@mtimes,tmp1,tmp2,'UniformOutput',false)');
class = cell2mat(cellfun(@mtimes,tmp1,tmp3,'UniformOutput',false)');

vec = [-inf -0.045:0.03:.045 inf];
frrad = 10;
ml = max(frames);
ltpf = zeros(ml,1);
slpf = zeros(ml,length(vec)-1);
for fr = frrad+1:ml-frrad
    ltpf(fr) = mean(lt(abs(frames-fr)<frrad&class<4));
    slpf(fr,:) = histcounts(nonzeros(slopes(abs(frames-fr)<frrad)),vec,'normalization','probability');
end

close
figure
W = slpf\ltpf;
plot(ltpf)
hold on
plot(slpf*W)
xlim([frrad ml-frrad])
set(gca,'ylimmode','auto')
yl = get(gca,'ylim');
for i = 1:length(breaks);
    plot(breaks(i)*[1 1],yl,'k')
end
xlim([frrad ml-frrad])
%%
close
figure
for fr = 1:ml
    plot(slpf(fr,:))
    pause(.05)
end