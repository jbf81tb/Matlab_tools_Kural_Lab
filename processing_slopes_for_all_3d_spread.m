cam = 'D:\Josh\Matlab\cmeAnalysis_movies';
movd = dir(cam);
movd(~[movd.isdir]) = [];
toss = true(size(movd));
for i = 1:length(movd);
    if regexp(movd(i).name,'bsc_spread')
        if exist(fullfile(cam,movd(i).name,'nsta.mat'),'file')
            toss(i) = false;
        end
    end
end
movd(toss) = [];
ebslope = [];
lbslope = [];
etslope = [];
ltslope = [];
for i = 1:length(movd)
    tmpd = dir(fullfile(cam,movd(i).name,'movies'));
    tmpd(~[tmpd.isdir]) = [];
    tmpd(cellfun(@strncmp,{tmpd.name},repmat({'.'},size({tmpd.name})),repmat({1},size({tmpd.name})))) = [];
    tfirst = false(1,length(tmpd));
    tlast = false(1,length(tmpd));
    for j = 1:length(tmpd)
        if regexp(tmpd(j).name,'t001')
            tfirst(j) = true;
            if sum(tfirst)>1, tlast(j-1) = true; end
        end
    end
    tlast(end) = true;
    tfirst = find(tfirst);
    tlast = find(tlast);
    load(fullfile(cam,movd(i).name,'nsta.mat'))
    load(fullfile(cam,movd(i).name,'ranges.mat'))
    for j = 1:length(tfirst)
        k = tfirst(j);
        tmpst = nsta{k};
        tmpst([tmpst.class]==4|[tmpst.class]==7) = [];
        zpos = cell2mat({tmpst.st}');
        slopes = cell2mat({tmpst.sl}');
        msknm = fullfile(cam,movd(i).name,'movies',tmpd(k).name,'Mask.tif');
        if exist(msknm,'file')
            msk = ~imread(msknm);
            xpos = cell2mat({tmpst.xpos}');
            ypos = cell2mat({tmpst.ypos}');
            inmsk = msk(sub2ind(size(msk),ceil(ypos),ceil(xpos)));
            ebslope = [ebslope; nonzeros(slopes(inmsk&zpos>ranges(k,1)&zpos<ranges(k,2)))];
            etslope = [etslope; nonzeros(slopes(inmsk&zpos>ranges(k,2)))];
        else
            ebslope = [ebslope; nonzeros(slopes(zpos>ranges(k,1)&zpos<ranges(k,2)))];
            etslope = [etslope; nonzeros(slopes(zpos>ranges(k,2)))];
        end
        disp([movd(i).name filesep tmpd(k).name])
    end
    for j = 1:length(tlast)
        k = tlast(j);
        tmpst = nsta{k};
        tmpst([tmpst.class]==4|[tmpst.class]==7) = [];
        zpos = cell2mat({tmpst.st}');
        slopes = cell2mat({tmpst.sl}');
        msknm = fullfile(cam,movd(i).name,'movies',tmpd(k).name,'Mask.tif');
        if exist(msknm,'file')
            msk = ~imread(msknm);
            xpos = cell2mat({tmpst.xpos}');
            ypos = cell2mat({tmpst.ypos}');
            inmsk = msk(sub2ind(size(msk),ceil(ypos),ceil(xpos)));
            lbslope = [lbslope; nonzeros(slopes(inmsk&zpos>ranges(k,1)&zpos<ranges(k,2)))];
            ltslope = [ltslope; nonzeros(slopes(inmsk&zpos>ranges(k,2)))];
        else
            lbslope = [lbslope; nonzeros(slopes(zpos>ranges(k,1)&zpos<ranges(k,2)))];
            ltslope = [ltslope; nonzeros(slopes(zpos>ranges(k,2)))];
        end
        disp([movd(i).name filesep tmpd(k).name])
    end
end
%%
vec = [-inf -.145:.01:.145 inf];
hcond = {'normalization','probability'};
xvals = -.15:.01:.15;
ebc = histcounts(ebslope,vec,hcond{:})';
lbc = histcounts(lbslope,vec,hcond{:})';
etc = histcounts(etslope,vec,hcond{:})';
ltc = histcounts(ltslope,vec,hcond{:})';
plot(xvals,ebc,'Color',hsv2rgb([0 1 1]))
hold on
plot(xvals,lbc,'Color',hsv2rgb([1/2 1 1]))
plot(xvals,etc,'Color',hsv2rgb([1/4 1 1]))
plot(xvals,ltc,'Color',hsv2rgb([3/4 1 1]))
legend('early bottom','late bottom','early top','late top')
%%
vec = [-inf -.045:.03:.045 inf];
hcond = {'normalization','probability'};
xvals = -.15:.01:.15;
ebc = histcounts(ebslope,vec,hcond{:})';
lbc = histcounts(lbslope,vec,hcond{:})';
etc = histcounts(etslope,vec,hcond{:})';
ltc = histcounts(ltslope,vec,hcond{:})';
tmp = [ebc lbc etc ltc];
%%
cam = 'D:\Josh\Matlab\cmeAnalysis_movies';
movd = dir(cam);
movd(~[movd.isdir]) = [];
toss = true(size(movd));
for i = 1:length(movd);
    if regexp(movd(i).name,'bsc_spread')
        if exist(fullfile(cam,movd(i).name,'nsta.mat'),'file')
            toss(i) = false;
        end
    end
end
movd(toss) = [];
[ebstd, lbstd, etstd, ltstd] = deal([]);

for i = 1:length(movd)
    tmpd = dir(fullfile(cam,movd(i).name,'movies'));
    tmpd(~[tmpd.isdir]) = [];
    tmpd(cellfun(@strncmp,{tmpd.name},repmat({'.'},size({tmpd.name})),repmat({1},size({tmpd.name})))) = [];
    tfirst = false(1,length(tmpd));
    tlast = false(1,length(tmpd));
    for j = 1:length(tmpd)
        if regexp(tmpd(j).name,'t001')
            tfirst(j) = true;
            if sum(tfirst)>1, tlast(j-1) = true; end
        end
    end
    tlast(end) = true;
    tfirst = find(tfirst);
    tlast = find(tlast);
    load(fullfile(cam,movd(i).name,'nsta.mat'))
    load(fullfile(cam,movd(i).name,'ranges.mat'))
    for j = 1:length(tfirst)
        k = tfirst(j);
        tmpst = nsta{k};
        tmpst([tmpst.class]==4|[tmpst.class]==7) = [];
        zpos = cell2mat({tmpst.st}');
        slopes = cell2mat({tmpst.sl}');
        msknm = fullfile(cam,movd(i).name,'movies',tmpd(k).name,'Mask.tif');
        if exist(msknm,'file')
            msk = ~imread(msknm);
            xpos = cell2mat({tmpst.xpos}');
            ypos = cell2mat({tmpst.ypos}');
            inmsk = msk(sub2ind(size(msk),ceil(ypos),ceil(xpos)));
            ebstd(end+1) = std(nonzeros(slopes(inmsk&zpos>ranges(k,1)&zpos<ranges(k,2))));
            etstd(end+1) = std(nonzeros(slopes(inmsk&zpos>ranges(k,2))));
        else
            ebstd(end+1) = std(nonzeros(slopes(zpos>ranges(k,1)&zpos<ranges(k,2))));
            etstd(end+1) = std(nonzeros(slopes(zpos>ranges(k,2))));
        end
        disp([movd(i).name filesep tmpd(k).name])
    end
    for j = 1:length(tlast)
        k = tlast(j);
        tmpst = nsta{k};
        tmpst([tmpst.class]==4|[tmpst.class]==7) = [];
        zpos = cell2mat({tmpst.st}');
        slopes = cell2mat({tmpst.sl}');
        msknm = fullfile(cam,movd(i).name,'movies',tmpd(k).name,'Mask.tif');
        if exist(msknm,'file')
            msk = ~imread(msknm);
            xpos = cell2mat({tmpst.xpos}');
            ypos = cell2mat({tmpst.ypos}');
            inmsk = msk(sub2ind(size(msk),ceil(ypos),ceil(xpos)));
            lbstd(end+1) = std(nonzeros(slopes(inmsk&zpos>ranges(k,1)&zpos<ranges(k,2))));
            ltstd(end+1) = std(nonzeros(slopes(inmsk&zpos>ranges(k,2))));
        else
            lbstd(end+1) = std(nonzeros(slopes(zpos>ranges(k,1)&zpos<ranges(k,2))));
            ltstd(end+1) = std(nonzeros(slopes(zpos>ranges(k,2))));
        end
        disp([movd(i).name filesep tmpd(k).name])
    end
end