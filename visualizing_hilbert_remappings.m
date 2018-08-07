[x,y] = hilbert(9);
hrm = sub2ind([512 512],(y+.5)*512+.5,(x+.5)*512+.5);
[sdremap,intremap] = deal(zeros(length(hrm),length(sdmap)));
for fr = 1:length(sdmap)
    sdremap(:,fr) = sdmap{fr}(hrm);
    intremap(:,fr) = intmap{fr}(hrm);
end
%%
if ~exist('cmap_warmmetal','var'), load('warmmetal.mat'); end
close
figure(1)
imagesc(sdremap,[0.01 0.05])
set(gca,'units','normalized','position',[.04 .06 .9 .9])
colormap(cmap_warmmetal)
xlabel('Time (s)')
ylabel('Hilbert mapping of space (px)')
title('Standard deviation of slope')
figure(2)
imagesc(intremap,[0 3500])
set(gca,'units','normalized','position',[.04 .06 .9 .9])
colormap(cmap_warmmetal)
xlabel('Time (s)')
ylabel('Hilbert mapping of space (px)')
title('Average Intensity')
%%
zpos = cell2mat({tmpst.st}');
zhist = zeros(6,ml);
for fr = 1:ml
    zhist(:,fr) = histcounts(zpos(frames==fr),.5:6.5);
end
%%
close
figure
imagesc(meanz)
axis xy
xlabel('Time (s)')
ylabel('Z Position (stack=300nm)')
title('Histogram of trace z positions')
%%
meanz = zeros(1,ml);
chops = 10;
pz = zeros(chops,ml);
for fr = 1:ml
    meanz(fr) = mean(zpos(frames==fr));
    szpf = sort(zpos(frames==fr),'ascend');
    for i = 1:chops
        pz(i,fr) = mean(szpf(1+ceil((i-1)*length(szpf)/chops):ceil(i*length(szpf)/chops)));
    end
end
%%
close
figure
plot(1:ml,meanz,'k','linewidth',2)
hold on
leg = {'Average of all z'};
for i = 1:3%chops
    plot(1:ml,pz(i,:))
    leg(end+1) = {sprintf('Average of %uth to %uth percentile',round(100*(i-1)/chops),round(100*i/chops))};
end
legend(leg{:},'Location','southwest')
xlabel('Time (s)')
ylabel('Z position (stack=300nm)')
title('Z position in percentiles')