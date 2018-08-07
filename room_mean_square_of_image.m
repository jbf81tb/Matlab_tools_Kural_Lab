movnm = '30pow_002_crop.tif';
outname = '30pow_002_crop_eucl.tif';
if exist(['.' filesep outname],'file'), delete(outname); end
ml = length(imfinfo(movnm));
ss = size(imread(movnm));
join = 3;
skip = 97;
fr = 1; k = 1;
while fr <=ml;
   img = zeros(ss);
   for i = 1:join
       img = img + double(imread(movnm,fr)).^2;
       fr = fr+1;
   end
   img = sqrt(img);
   fr = fr+skip;
   k = k+1;
   imwrite(uint16(img),outname,'tif','writemode','append')
end