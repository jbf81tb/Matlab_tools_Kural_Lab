movnm = 'F:\cmos_sum_2\orig_movies\AVG_2p_20fps_1s_w8c001.tif';
ml = length(imfinfo(movnm));
ss = size(imread(movnm));
mov = zeros([ss ml]);
for fr = 1:ml
    mov(:,:,fr) = double(imread(movnm,fr));
end
s = sort(mov(:),'ascend');
medc = s(ceil(0.3*length(s)));
maxc = s(end);
clear s
%%
close
fh = figure('selectiontype','alt');
for fr = 1:ml
    hold off
    imagesc(mov(:,:,fr),[medc maxc])
    axis equal
    hold on
    x = []; y = [];
    for i = 1:length(tracks)
        if tracks(i).lifetime_s<20, continue; end
        frind = find(tracks(i).f==fr);
        if isempty(frind), continue; end
%         if isnan(tracks(i).isPSF(frind)), continue; end
%         if ~tracks(i).isPSF(frind), continue; end
        x(end+1) = tracks(i).x(frind);
        y(end+1) = tracks(i).y(frind);
    end
    if ~isempty(x)
        try
            scatter(x,y,100,'r')
            waitfor(fh,'selectiontype','normal')
            set(fh,'selectiontype','alt')
        catch
            return;
        end
    end
end
%%
close
fh = figure('selectiontype','alt');
for fr = 1:ml
    hold off
    imagesc(mov(:,:,fr),[medc maxc])
    axis equal
    hold on
    x = []; y = [];
    for i = 1:length(tracks2)
        if tracks2(i).lifetime_s<20, continue; end
        if ~tracks2(i).isCCP, continue; end
        frind = find(tracks2(i).f==fr);
        if isempty(frind), continue; end
%         if isnan(tracks2(i).isPSF(frind)), continue; end
%         if ~tracks2(i).isPSF(frind), continue; end
        x(end+1) = tracks2(i).x(frind);
        y(end+1) = tracks2(i).y(frind);
    end
    if ~isempty(x)
        try
            scatter(x,y,100,'r')
            waitfor(fh,'selectiontype','normal')
            set(fh,'selectiontype','alt')
        catch
            return;
        end
    end
end