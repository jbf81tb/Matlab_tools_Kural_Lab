mov_nm = 'D:\Josh\Matlab\cmeAnalysis_movies\170610_sum_magbead\movies\tz001.tif';
tstacks = [];
zstacks = 26;
torb = 't';
if isempty(tstacks)
    mlps = length(imfinfo(mov_nm))/zstacks;
    zlps = zstacks;
elseif isempty(zstacks)
    zlps = length(imfinfo(mov_nm))/tstacks;
    mlps = tstacks;
else
    mlps = tstacks;
    zlps = zstacks;
end
if strcmp(torb,'t');
    filename = [mov_nm(1:end-4) '_max_proj_top.tif'];
elseif strcmp(torb,'b')
    filename = [mov_nm(1:end-4) '_max_proj_bottom.tif'];
end
vz = @(fr)(7.1/215^2)*(215^2-fr.^2);
if exist(filename,'file'), delete(filename); end
for fr = 1:mlps
    tmp = zeros([size(imread(mov_nm)),zlps],'uint16');
    if strcmp(torb,'t');
        minst = min(ceil(vz(fr)+2),zlps);
        maxst = zlps;
    elseif strcmp(torb,'b')
        minst = max(1,floor(vz(fr)-1));
        maxst = min(ceil(vz(fr)+1),zlps);
    end
    for st = minst:maxst
        tmp(:,:,st) = imread(mov_nm,(fr-1)*zlps+st);
    end
    imwrite(max(tmp,[],3),filename,'writemode','append')
end