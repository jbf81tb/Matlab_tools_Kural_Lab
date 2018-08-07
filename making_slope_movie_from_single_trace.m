% tmp = randn(1,length(trace));
vec = [-inf -.045:.03:.045 inf];
% trace = tmpst(1379).int(1:3:end);
trace = randn(30,1);
modtrace = trace'/max(trace);
if exist('..\tmp.tif','file'), delete('..\tmp.tif'); end
sl = [];
frame_rate = 3;
x = (1:length(trace))*frame_rate;
prange = 12/frame_rate;
if prange<3, prange=3; end
forwardp = .25;
front = ceil(forwardp*(prange-1));
rear = floor((1-forwardp)*(prange-1));
for i = rear+1:length(modtrace)-front
    slpreg = i-rear:i+front;
    tmpy = modtrace(slpreg);
    tmpx = slpreg*frame_rate;
    mnx = mean(tmpx);
    mny = mean(tmpy);
    mnxy = mean(tmpx.*tmpy);
    mnx2 = mean(tmpx.*tmpx);
    sl(end+1) = (mnxy-mnx*mny)/(mnx2-mnx*mnx);
end
for i = rear+1:length(modtrace)-front
    close
    figure('units','normalized','outerposition',[0 0 .75 1])
    subplot(2,2,[1 2])
    hold on
    plot(x,modtrace,'-','color',[.1 .4 .8],'linewidth',3);
    slpreg = i-rear:i+front;
%     plot(x(slpreg),modtrace(slpreg),'-','color',[.6 0 0],'linewidth',5);
    xlim([min(x),max(x)])
    ylim([0, 1.1])
    tmpy = modtrace(slpreg);
    tmpx = slpreg*frame_rate;
    mnx = mean(tmpx);
    mny = mean(tmpy);
    mnxy = mean(tmpx.*tmpy);
    mnx2 = mean(tmpx.*tmpx);
%     sl(end+1) = (mnxy-mnx*mny)/(mnx2-mnx*mnx);
    intc = mny-sl(i-rear)*mnx;
    liney = tmpx*sl(i-rear)+intc;
    plot(tmpx,liney,'-','color',[1 0 0],'linewidth',3);
    subplot(2,2,3)
    plot((rear+1:i)*frame_rate,sl(1:i-rear),'.','markersize',30)
    xlim([min(x),max(x)])
    ylim([min(sl)-.1*range(sl),max(sl)+.1*range(sl)])
    subplot(2,2,4)
    histogram(sl(1:i-rear),vec)
    xlim([-.075 .075])
    frm = getframe(gcf);
    imwrite(frm.cdata,'..\tmp.tif','writemode','append')
end
close