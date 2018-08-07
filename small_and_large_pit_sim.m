psf = @(coord,x,y)(0.05*rand+.95)*exp(-((x-coord(1))^2+(y-coord(2))^2)/(2*150^2));

pxsz = 100;
winsz = [1500,3000];
img = zeros(winsz/pxsz);

smr = 100;
lgr = 2*smr;

smp = 100;
lgp = smp;

smcent = [750,750];
lgcent = [2250,750];
% area = [];
% for iter = 1:1000;
smcoord = zeros(smp,2);
for i = 1:smp
    fr = @(r)4*r^2/(smr^2*sqrt(smr^2-r^2));
    rr1=0; rr2=inf;
    while rr2>fr(rr1)
        rr1 = smr*rand;
        rr2 = (20/smr)*rand;
    end
    rr = rr1;
    rth = rand*2*pi;
    smcoord(i,1) = smcent(1)+rr*cos(rth);
    smcoord(i,2) = smcent(2)+rr*sin(rth);
    for imy = 1:size(img,1)
        for imx = 1:size(img,2)
            img(imy,imx) = img(imy,imx) +...
                           psf(smcoord(i,:),imx*pxsz,imy*pxsz) +...
                           randn*.1;
        end
    end
end
lgcoord = zeros(lgp,2);
for i = 1:lgp
    fr = @(r)2*r/lgr^2;
    rr1=0; rr2=inf;
    while rr2>fr(rr1)
        rr1 = lgr*rand;
        rr2 = (2/lgr)*rand;
    end
    rr = rr1;
    rth = rand*2*pi;
    lgcoord(i,1) = lgcent(1)+rr*cos(rth);
    lgcoord(i,2) = lgcent(2)+rr*sin(rth);
    for imy = 1:size(img,1)
        for imx = 1:size(img,2)
            img(imy,imx) = img(imy,imx) +...
                           psf(lgcoord(i,:),imx*pxsz,imy*pxsz) +...
                           randn*.1;
        end
    end
end

close
figure
imagesc(img)
hold on
plot(smcoord(:,1)/pxsz,smcoord(:,2)/pxsz,'r.','markersize',1)
plot(lgcoord(:,1)/pxsz,lgcoord(:,2)/pxsz,'r.','markersize',1)
% [~,area(iter)] = convexHull(delaunayTriangulation(lgcoord));
% end