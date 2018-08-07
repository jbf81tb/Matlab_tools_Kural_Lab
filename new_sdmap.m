mov = '004';
load([mov '.mat'])
tmpst = slope_finding(fxyc_to_struct(Threshfxyc),3,400);
mask = imread(['Mask_' mov '.tif']);
outside = mask(sub2ind(size(mask),ceil(cellfun(@mean,{tmpst.ypos})),ceil(cellfun(@mean,{tmpst.xpos}))))>0;
tmpst(outside) = [];
%%
rad = 50;
frrad = 0;
vz = @(fr)(7.1/215^2)*(215^2-fr.^2);
mask = imread('tz001\Mask.tif')==0;
cond = false(1,length(tmpst));
for i = 1:length(tmpst)
    mx = mean(tmpst(i).xpos);
    my = mean(tmpst(i).ypos);
    zpos = tmpst(i).st;
    frame = tmpst(i).frame;
    if mask(ceil(my),ceil(mx))
        if sum(abs(zpos-vz(frame))<1) > ceil(.5*tmpst(i).lt)
%         if sum((zpos-vz(frame))>1) > ceil(.5*tmpst(i).lt)
            cond(i) = true;
        end
    end
end
frames = cell2mat({tmpst(cond).frame}');
xpos = cell2mat({tmpst(cond).xpos}');
ypos = cell2mat({tmpst(cond).ypos}');
slopes = cell2mat({tmpst(cond).sl}');
ints = cell2mat({tmpst(cond).int}');
ss = [512 512];
ml = max(frames);
[sdmap,count,intmap] = deal(cell(1,ml));
shift = 10;
for fr = frrad+1:frrad+1:ml-frrad
    [sqmap,sdmap{fr},count{fr},map,intmap{fr}] = deal(zeros(ss));
    xpif = ceil(xpos(abs(frames-fr)<=frrad));
    ypif = ceil(ypos(abs(frames-fr)<=frrad));
    slif = slopes(abs(frames-fr)<=frrad+shift);
    inif = ints(abs(frames-fr)<=frrad);
    count{fr}(:) = histcounts(sub2ind(ss,ypif,xpif),(0:512^2)+.5);
    filled = find(count{fr}(:)>0);
    for i = 1:length(filled)
        [iy,ix] = ind2sub(ss,filled(i));
        in = find(ix==xpif & iy==ypif)';
        for j = in
            if slif(j)==shift
                count{fr}(ypif(j),xpif(j)) = count{fr}(ypif(j),xpif(j))-1;
                continue;
            end
            sqmap(ypif(j),xpif(j)) = sqmap(ypif(j),xpif(j)) + slif(j)^2;
            map(ypif(j),xpif(j)) = map(ypif(j),xpif(j)) + slif(j);
            intmap{fr}(ypif(j),xpif(j)) = intmap{fr}(ypif(j),xpif(j)) + inif(j);
        end
    end
count{fr} = conv2(count{fr},double(fspecial('disk',rad)>0),'same');
sqmap = (count{fr}>1).*conv2(sqmap,double(fspecial('disk',rad)>0),'same');
map = (count{fr}>1).*conv2(map,double(fspecial('disk',rad)>0),'same');
sdmap{fr} = (count{fr}>1).*sqrt((sqmap-(map.^2)./count{fr})./(count{fr}-1));
sdmap{fr}(isnan(sdmap{fr})) = 0;
sdmap{fr}= real(sdmap{fr});
intmap{fr} = (count{fr}>1).*conv2(intmap{fr},double(fspecial('disk',rad)>0),'same')./count{fr};
intmap{fr}(isnan(intmap{fr})) = 0;
disp(100*fr/ml);
end
sdmap(cellfun(@isempty,sdmap)) = [];
count(cellfun(@isempty,count)) = [];
intmap(cellfun(@isempty,intmap)) = [];
maxct = max(cellfun(@max,cellfun(@(x)x(:),count,'UniformOutput',false)));
maxsd = max(cellfun(@max,cellfun(@(x)x(:),sdmap,'UniformOutput',false)));
minsd = min(cellfun(@min,cellfun(@nonzeros,cellfun(@(x)x(:),sdmap,'UniformOutput',false),'UniformOutput',false)));
for i = 1:length(sdmap)
    sdmap{i}(sdmap{i}==0)=minsd;
end
%%
if ~exist('cmap_warmmetal','var'), load('warmmetal.mat'); end
for i = 1:length(sdmap)
    subplot(1,2,1)
    imagesc(sdmap{i},[minsd maxsd])
    axis equal
    title('Standard Deviation')
    colormap(cmap_warmmetal)
    colorbar
    subplot(1,2,2)
    imagesc(count{i},[0 maxct])
    axis equal
    title('Density')
    colormap(cmap_warmmetal)
    colorbar
    pause(1/20)
end
close
%%
fname = 'sdmap_top_cell.tif';
if exist(fname,'file'), delete(fname); end

for fr = 1:length(sdmap)
    img = sdmap{fr};
    img = (img-minsd)/(maxsd-minsd);
    img = uint8(img*(2^8-1));
    imwrite(img,fname,'writemode','append')
end
%%
figure(1)
imagesc(count{end})
axis equal
figure(2)
imagesc(sqmap)
axis equal
figure(3)
imagesc(map)
axis equal
figure(4)
imagesc(sdmap{end})
axis equal
