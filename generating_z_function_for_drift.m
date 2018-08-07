frames = cell2mat({tmpst.frame}');
zpos = cell2mat({tmpst.st}');
img = Hist2D(frames,zpos,min(frames):1:max(frames),min(zpos):1:max(zpos),true);
%%
ml = max(frames);
[medz,mnz] = deal(zeros(1,ml));
for fr = 1:ml
    medz(fr) = median(zpos(frames==fr));
    mnz(fr) = mean(zpos(frames==fr));
end
hold on
plot(1:ml,medz,1:ml,mnz)
%%
hold on
x = 1:191;
plot(x,-(x.^2-215^2)/(215^2/7.1),'linewidth',2)
%%
% vz = (-4/196)*frame+5.8