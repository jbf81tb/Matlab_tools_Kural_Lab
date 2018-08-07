movnm = 'well1_c1 - SRRF_No_Int.tif';
rad = 8;

for i = 1:length(tracest)
    for ifr = 1:length(tracest(i).frame);
        fr = tracest(i).frame(ifr);
        img = imread(movnm,fr);
        xp = tracest(i).xpos(ifr);
        yp = tracest(i).ypos(ifr);
        img = img(floor(yp-rad):floor(yp+rad),floor(xp-rad):floor(xp+rad));
        [xhave, yhave] = meshgrid(1:size(img,2),1:size(img,1));
        [xwant, ywant] = meshgrid(1:.1:size(img,2),1:.1:size(img,1));
        int_img = griddata(xhave(:),yhave(:),double(img(:)),xwant,ywant,'v4');
        tracest(i).radiality(ifr) = max(int_img(:));
    end
end
%%

rad = 15;

for i = 1:length(mbcdst)
    celln = mbcdst(i).cell;
    movnm = ['well' celln(1) '_c' celln(2) '_avg.tif'];
    close
fh = figure('SelectionType','Alt');
    for ifr = 1:length(mbcdst(i).frame)
        fr = mbcdst(i).frame(ifr);
        img = imread(movnm,fr);
        xp = mbcdst(i).xpos(ifr);
        yp = mbcdst(i).ypos(ifr);
        img = img(floor(yp-rad):floor(yp+rad),floor(xp-rad):floor(xp+rad));
        if ifr == 1, mbcdst(i).avgClip = []; end
        mbcdst(i).avgClip(:,:,ifr) = img;
    end
end