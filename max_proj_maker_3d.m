function max_proj_maker_3d(mov_nm,tstacks,zstacks)
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
filename = [mov_nm(1:end-4) '_max_proj.tif'];
if exist(filename,'file'), delete(filename); end
for fr = 1:mlps
    tmp = zeros([size(imread(mov_nm)),zlps],'uint16');
    for st = 1:zlps
        tmp(:,:,st) = imread(mov_nm,(fr-1)*zlps+st);
    end
    imwrite(max(tmp,[],3),filename,'writemode','append')
end
end