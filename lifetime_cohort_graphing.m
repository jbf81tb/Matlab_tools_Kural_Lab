function lifetime_cohort_graphing(varargin)
global tmpst
switch nargin
    case 0
        flnm = 'E:\Josh\Matlab\cmeAnalysis_movies\160406_no_coat_big_tips\orig_movies\03pre.mat';
    case 1
        flnm = varargin{1};
    otherwise
        error('Argument must be path to .mat file');
end
load(flnm);
tmpst = slope_finding(fxyc_to_struct(Threshfxyc),2,400);

f = figure('MenuBar','None');
mh = uimenu(f,'Label','Choose Graph','HandleVisibility','off');
smh1 = uimenu(mh,'Label','Lifetime Cohort');
simh = uimenu(smh1,'Label','Intensity Based');
uimenu(simh,'Label','Max Intensity','Callback',@max_int);
uimenu(simh,'Label','Avg Intensity','Callback',@avg_int);
uimenu(simh,'Label','First 3 Frames of Intensity','Callback',@early_int);
uimenu(smh1,'Label','Slopes','Callback',@slopes);
uimenu(smh1,'Label','Frames','Callback',@frames);
uimenu(smh1,'Label','Classes','Callback',@classes);
smh2 = uimenu(mh,'Label','Lifetime Based');
uimenu(smh2,'Label','Max Intensity Cohorts','Callback',@lifetime)

end

function max_int(hObject,callbackdata) %#ok<*INUSD>
global tmpst
clf
ah = tight_subplot(2,3,0.05,[0.03 0.03],[0.03 0.01]);
[~,srtlt] = sort([tmpst.lt]);
for i = 1:6
    axes(ah(i)) %#ok<*LAXES>
    cond = srtlt(ceil((i-1)*length(srtlt)/6)+1:ceil(i*length(srtlt)/6));
    [y,x] = histcounts(cellfun(@max,{tmpst(cond).int}),100:200:max(cellfun(@max,{tmpst.int})));
    x = (x(1:end-1)+x(2:end))/2;
    plot(x,y)
    xlim([0 max(cellfun(@max,{tmpst.int}))])
    title(['lt from ' num2str(min([tmpst(cond).lt])*2) ' to ' num2str(max([tmpst(cond).lt])*2)])
end
end

function avg_int(hObject,callbackdata)
global tmpst
clf
ah = tight_subplot(2,3,0.05,[0.03 0.03],[0.03 0.01]);
[~,srtlt] = sort([tmpst.lt]);
for i = 1:6
    axes(ah(i))
    cond = srtlt(ceil((i-1)*length(srtlt)/6)+1:ceil(i*length(srtlt)/6));
    [y,x] = histcounts(cellfun(@mean,{tmpst(cond).int}),100:200:max(cellfun(@mean,{tmpst.int})));
    x = (x(1:end-1)+x(2:end))/2;
    plot(x,y)
    xlim([0 max(cellfun(@mean,{tmpst.int}))])
    title(['lt from ' num2str(min([tmpst(cond).lt])*2) ' to ' num2str(max([tmpst(cond).lt])*2)])
end
end

function early_int(hObject,callbackdata)
global tmpst
clf
ah = tight_subplot(2,3,0.05,[0.03 0.03],[0.03 0.01]);
[tmp,srtlt] = sort([tmpst.lt]);
srtlt = srtlt(tmp>2);
for i = 1:6
    axes(ah(i))
    cond = srtlt(ceil((i-1)*length(srtlt)/6)+1:ceil(i*length(srtlt)/6));
    vals = cell2mat(cellfun(@(v)v(1:3),{tmpst(cond).int},'UniformOutput',false)');
    [y,x] = histcounts(vals,100:200:max(cell2mat(cellfun(@(v)v(1:3),{tmpst([tmpst.lt]>2).int},'UniformOutput',false)')));
    x = (x(1:end-1)+x(2:end))/2;
    plot(x,y)
    xlim([0 max(cell2mat(cellfun(@(v)v(1:3),{tmpst([tmpst.lt]>2).int},'UniformOutput',false)'))])
    title(['lt from ' num2str(min([tmpst(cond).lt])*2) ' to ' num2str(max([tmpst(cond).lt])*2)])
end
end

function slopes(hObject,callbackdata)
global tmpst
clf
ah = tight_subplot(2,3,0.05,[0.03 0.03],[0.03 0.01]);
[tmp,srtlt] = sort([tmpst.lt]);
srtlt = srtlt(tmp>6);
csm = cumsum(tmp(tmp>6));
for i = 1:6
    axes(ah(i))
    [~,st] = min(abs(csm-(i-1)*max(csm)/6));
    [~,en] = min(abs(csm-i*max(csm)/6));
    cond = srtlt(st:en);
    vals = nonzeros(cell2mat({tmpst(cond).sl}'));
    [y,~] = histcounts(vals,[-inf -0.145:0.01:0.145 inf]);
    yg = 0;
    for dum = 1:10
        [tmp,~] = histcounts(std(vals)*randn(length(vals),1),[-inf -0.145:0.01:0.145 inf]);
        yg = yg+tmp;
    end
    yg = yg/10;
%     axis off
plot(-0.15:.01:0.15,y)
hold on
plot(-0.15:.01:0.15,yg)
% hold on
% plot([-0.15 0.15],[1 1],'k')
ysc = get(gca,'ylim');
plot([0 0], ysc,'k')
    xlim([-0.15 0.15])
    title(['lt from ' num2str(min([tmpst(cond).lt])*2) ' to ' num2str(max([tmpst(cond).lt])*2)])
    legend('Data','Gaussian with equal Std Dev')
end
end

function classes(hObject,callbackdata)
global tmpst
clf
ah = tight_subplot(2,3,0.05,[0.03 0.03],[0.03 0.01]);
[~,srtlt] = sort([tmpst.lt]);
for i = 1:6
    axes(ah(i))
    cond = srtlt(ceil((i-1)*length(srtlt)/6)+1:ceil(i*length(srtlt)/6));
    [y,x] = histcounts([tmpst(cond).class]);
    x = (x(1:end-1)+x(2:end))/2;
    bar(x,y)
    xlim([0 8])
    title(['lt from ' num2str(min([tmpst(cond).lt])*2) ' to ' num2str(max([tmpst(cond).lt])*2)])
end
end

function lifetime(hObject,callbackdata)
global tmpst
clf
ah = tight_subplot(2,3,0.05,[0.03 0.03],[0.03 0.01]);
[~,srtint] = sort(cellfun(@max,{tmpst.int}));
for i = 1:6
    axes(ah(i))
    cond = srtint(ceil((i-1)*length(srtint)/6)+1:ceil(i*length(srtint)/6));
    [y,x] = histcounts([tmpst(cond).lt],.5:(max([tmpst.lt]))+.5);
    x = (x(1:end-1)+x(2:end))/2;
    plot(x,y)
    xlim([0 max([tmpst.lt])])
    title(['intensity from ' num2str(round(max(tmpst(cond(1)).int))) ' to ' num2str(round(max(tmpst(cond(end)).int)))])
end
end

function frames(hObject,callbackdata)
global tmpst
clf
ah = tight_subplot(2,3,0.05,[0.03 0.03],[0.03 0.01]);
[tmp,srtlt] = sort([tmpst.lt]);
csm = cumsum(tmp);
for i = 1:6
    axes(ah(i))
    [~,st] = min(abs(csm-(i-1)*max(csm)/6));
    [~,en] = min(abs(csm-i*max(csm)/6));
    cond = srtlt(st:en);
    vals = cell2mat({tmpst(cond).frame}');
    [y,x] = histcounts(vals,.5:max(cellfun(@max,{tmpst.frame})));
    x = (x(1:end-1)+x(2:end))/2;
    plot(x,y)
    xlim([0 max(cellfun(@max,{tmpst.frame}))])
    title(['lt from ' num2str(min([tmpst(cond).lt])*2) ' to ' num2str(max([tmpst(cond).lt])*2)])
end
end