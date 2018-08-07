mname = '002.tif';
ml = 100;
msize = size(imread(mname));
img = zeros([msize ml],'uint16');
for fr = 1:ml
    img(:,:,fr) = uint16(imread(mname,fr));
end
%% 
nstack = 5;
img3d = zeros([msize ml nstack],'uint16');
stf = @(fr)2*sin(2*pi*fr/ml)+2.5;
gaus = @(st,fr)exp(-(st-stf(fr))^2/(2*2^2));
for fr = 1:ml
    for st = 1:nstack
        img3d(:,:,fr,st) = uint16(img(:,:,fr)*gaus(st,fr));
    end
end
%%
filenm = '.\3d_test_wide.tif';
if exist(filenm,'file'), delete(filenm); end
for fr = 1:ml
    for st = 1:nstack
        imwrite(img3d(:,:,fr,st),filenm,'tif','writemode','append')
    end
end