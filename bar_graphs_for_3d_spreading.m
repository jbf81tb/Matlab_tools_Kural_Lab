for i = 1:length(nsta)
    tmpst = nsta{i};
    tmpst([tmpst.class]==4|[tmpst.class]==7) = [];
    zpos = cell2mat({tmpst.st}');
    maxz = max(zpos);
    vec = [1:maxz inf];
    close
    figure
    histogram(zpos,vec)
    set(gca,'xtick',1:maxz)
    pause(10)
end
close
%%
foldir = 'D:\Josh\Matlab\cmeAnalysis_movies\170705_bsc_spread\movies';
movfol = dir(foldir);
movfol(cellfun(@strncmp,{movfol.name}',repmat({'.'},size(movfol)),repmat({1},size(movfol)))) = [];
for cn = 1:4
switch cn
    case 1
        cell = 1:3;
    case 2
        cell = 4:5;
    case 3
        cell = 6:7;
    case 4
        cell = 9:11;
end
vec = [-inf -.045:.03:.045 inf];
hcond = {'normalization','probability'};
yct = zeros(2*length(cell),5);
for j = 1:length(cell)
    i = cell(j);
    tmpst = nsta{i};
    tmpst([tmpst.class]==4|[tmpst.class]==7) = [];
    zpos = cell2mat({tmpst.st}');
    slopes = cell2mat({tmpst.sl}');
    msknm = fullfile(foldir, movfol(i).name,'Mask.tif');
    if exist(msknm,'file')
        msk = ~imread(msknm);
        xpos = cell2mat({tmpst.xpos}');
        ypos = cell2mat({tmpst.ypos}');
        inmsk = msk(sub2ind(size(msk),ceil(ypos),ceil(xpos)));
        yct(j,:) = histcounts(nonzeros(slopes(inmsk&zpos>ranges(i,1)&zpos<ranges(i,2))),vec,hcond{:});
    else
        yct(j,:) = histcounts(nonzeros(slopes(zpos>ranges(i,1)&zpos<ranges(i,2))),vec,hcond{:});
    end
end
for j = 1:length(cell)
    i = cell(j);
    tmpst = nsta{i};
    tmpst([tmpst.class]==4|[tmpst.class]==7) = [];
    zpos = cell2mat({tmpst.st}');
    slopes = cell2mat({tmpst.sl}');
    msknm = fullfile(foldir, movfol(i).name,'Mask.tif');
    if exist(msknm,'file')
        msk = ~imread(msknm);
        xpos = cell2mat({tmpst.xpos}');
        ypos = cell2mat({tmpst.ypos}');
        inmsk = msk(sub2ind(size(msk),ceil(ypos),ceil(xpos)));
        yct(j+length(cell),:) = histcounts(nonzeros(slopes(inmsk&zpos>ranges(i,2))),vec,hcond{:});
    else
        yct(j+length(cell),:) = histcounts(nonzeros(slopes(zpos>ranges(i,2))),vec,hcond{:});
    end
end
close
figure
b = bar(yct');
for j = 1:length(cell)
    b(j).FaceColor = 'blue';
end
for j = 1:length(cell)
    b(j+length(cell)).FaceColor = 'red';
end
legend([b(1) b(length(cell)+1)],'bottom','top')
axis off
F = getframe;
imwrite(F.cdata,[movfol(cell(1)).name(1:end-5) '_bar_graph.tif'])
end
close