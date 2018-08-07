movnm = 'cell002_during.tif';
outname = 'cell002_during_eucl.tif';
if exist(['.' filesep outname],'file'), delete(outname); end
ml = length(imfinfo(movnm));
ss = size(imread(movnm));
num = 50;
fr = 0;
while fr < ml;
   img = zeros(ss);
   for i = [1, floor(num/2), num]
       img = img + double(imread(movnm,fr+i)).^2;
   end
   img = sqrt(img);
   fr = fr+num;
   imwrite(uint16(img),outname,'tif','writemode','append')
end