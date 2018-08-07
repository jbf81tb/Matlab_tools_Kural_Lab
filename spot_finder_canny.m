function spots = spot_finder_canny(filename)
%Finds spots using canny edge detection.
%% Setting Variables and Parsing Arguments
ss = imread(filename);
s = size(ss);
frames = length(imfinfo(filename));
J = zeros(s(1),s(2),frames,'uint16');
IMG = zeros(s(1),s(2),frames,'double');
spots = zeros(0,3);
movnm = [filename(1:end-4) '_big_movie.tif'];
if exist(movnm,'file'), delete(movnm); end
%% Find Spots
for j=1:frames
    IMG(:,:,j) = imread(filename,j);
    J(:,:,j) = edge(IMG(:,:,j),'canny',[.075 .12],8);
    J(:,:,j) = imfill(J(:,:,j),'holes');
end
spot_count = 1;
dens = 0; mlist = 0;
for k=1:frames
    [B,L,n] = bwboundaries(J(:,:,k),'noholes');
    for m=1:n
        xb = min(B{m}(:,2))-32; xt = max(B{m}(:,2))+32;
        yb = min(B{m}(:,1))-32; yt = max(B{m}(:,1))+32;
        if xb<=0 || yb<=0 || xt>s(2) || yt>s(1), continue; end
        spots(spot_count,1) = k;
        smIMG = IMG(yb:yt,xb:xt,j);
        smL = L(yb:yt,xb:xt);
        tmp = smIMG.*(smL~=m);
        tmp = sort(nonzeros(tmp),'ascend');
        minimg = tmp(ceil(0.3*length(tmp)));
        spots(spot_count,2) = sum(reshape(smL==m,[],1));
        if spots(spot_count,2)<350, continue; end
        spots(spot_count,3) = sum(nonzeros(reshape(smIMG.*(smL==m),[],1)))...
                              -...
                              spots(spot_count,2)*minimg;
        dens(spot_count) = spots(spot_count,3)/spots(spot_count,2);
        mlist(spot_count) = m;
        spot_count = spot_count + 1;
    end
end
save spots.mat spots
logint = real(log(spots(:,3)));
maxc = max(IMG(:)); minc = min(IMG(:));
maxa = max(spots(:,2)); mina = min(spots(:,2));
maxi = max(logint);
maxd = max(dens); mind = min(dens);
close
figure('units','pixels','position',[1 1 1000 1000])
ah1 = axes('units','pixels','position',[1 501 500 500]);
ah2 = axes('units','pixels','position',[501 501 500 500]);
ah3 = axes('units','pixels','position',[1 1 500 500]);
ah4 = axes('units','pixels','position',[501 1 500 500]);
for k = 1:frames
    axes(ah1)
    imagesc(IMG(:,:,k),[minc maxc])
    axis equal
    axis off
    
    [imga,imgi,imgd] = deal(zeros(s,'uint16'));
    [~,L,n] = bwboundaries(J(:,:,k),'noholes');
    for m=1:n
        cond = spots(:,1)==k & (mlist==m)';
        if ~any(cond), continue; end
        tmpa = uint16((L==m)*(2^16-1)*(spots(cond,2)-mina)/(maxa-mina));
        tmpi = uint16((L==m)*(2^16-1)*(logint(cond)/maxi));
        tmpd = uint16((L==m)*(2^16-1)*(dens(cond)-mind)/(maxd-mind));
        imga = imga+tmpa;
        imgi = imgi+tmpi;
        imgd = imgd+tmpd;
    end
    
    axes(ah2)
    imagesc(imgi)
    axis equal
    axis off
    
    axes(ah3)
    imagesc(imga)
    axis equal
    axis off
    
    axes(ah4)
    imagesc(imgd)
    axis equal
    axis off
    
    F = getframe(gcf);
    imwrite(F.cdata,movnm,'tif','writemode','append');
end