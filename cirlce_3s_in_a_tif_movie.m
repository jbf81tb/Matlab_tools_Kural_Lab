mvnm = 'F:\Josh\Matlab\SRRF_movies\SIM_data\3svids\data1\orig_movies\AVG_raw.tif';
% mvnm = 'D:\Josh\Matlab\cmeAnalysis_movies\SRRF_test\cell001_SRRF.tif';
% flnm = 'D:\Josh\Matlab\cmeAnalysis_movies\SRRF_test\orig_movies\AVG_cell001.mat';
% masks = spread_cell_thresholding(mvnm);
flnm = [mvnm(1:end-4) '.mat'];
load(flnm);
tmpst = fxyc_to_struct(Threshfxyc);
% tmpst = st4;

ml = length(imfinfo(mvnm));
if exist('tmp.tif','file'), delete('tmp.tif'); end
close
figure('units','pixels','position',[10 10 1024 1024])
colormap('gray')
axes('units','pixels','position',[1 1 1024 1024])
hold on
for fr = 1:ml
    img = imread(mvnm,fr);
    ih = imagesc(img);
    x = []; y = [];
    xe = []; ye = [];
%     tmpmsk = conv2(double(masks(:,:,fr)==.5),fspecial('disk',5),'same');
    for i = 1:length(tmpst)
        if tmpst(i).class > 3, continue; end
%         if tmpst(i).lt <= 6, continue; end
        if max(tmpst(i).int)<500, continue; end
        fr_ind = find(tmpst(i).frame == fr,1);
        if isempty(fr_ind), continue; end
        x(end+1) = tmpst(i).xpos(fr_ind);
        y(end+1) = tmpst(i).ypos(fr_ind);
%         if tmpmsk(round(y(end)),round(x(end)))>0
%             xe(end+1) = x(end);
%             ye(end+1) = y(end);
%         end
    end
    x2 = []; y2 = []; 
    for i = 1:length(tmpst)
        if tmpst(i).class <= 3, continue; end
%         if tmpst(i).lt > 6, continue; end
        if max(tmpst(i).int)>=500, continue; end
        fr_ind = find(tmpst(i).frame == fr,1);
        if isempty(fr_ind), continue; end
        x2(end+1) = tmpst(i).xpos(fr_ind);
        y2(end+1) = tmpst(i).ypos(fr_ind);
    end
    sh = scatter(x,y,100,'g');
    sh2 = scatter(x2,y2,100,'r');
    axis ij
    axis equal
    axis off
    F = getframe(gca);
    imwrite(F.cdata,'tmp.tif','writemode','append')
    delete(ih); delete(sh); if exist('sh2','var'), delete(sh2); end
%     pause
end
close