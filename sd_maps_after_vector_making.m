spc = 4;
rad = 50;
frrad = 5;
ml = max(frames);
ss = [512,512];
[sdmap,img,msk,dens] = deal(cell(1,ml));
st = tmpst;
mxp = cell2mat({st.xpos}');
myp = cell2mat({st.ypos}');
for fr = frrad+1:frrad:ml-frrad
%     img{fr} = imread(fullfile('movies',movnms{mov},'max_proj.tif'));
%     msk{fr} = imread(fullfile('movies',movnms{mov},'Mask.tif'));
    sdmap{fr} = zeros(ss);
    for ix = 1:spc:ss(2)
        for iy = 1:spc:ss(1)
            trin = sqrt((mxp(abs(frames-fr)<frrad)-ix).^2+...
                        (myp(abs(frames-fr)<frrad)-iy).^2 ...
                       ) < rad;
            tmp = nonzeros(slopes(trin));
            ct = sum(trin);
            if ct<50, continue; end
            for j = 0:spc-1
                for k = 0:spc-1
                    sdmap{fr}(iy+j,ix+k) = std(tmp);
                    dens{fr}(iy+j,ix+k) = ct;
                end
            end
        end
    end
    sdmap{fr}(sdmap{fr}==0) = min(nonzeros(sdmap{fr}(:)));
    disp(100*fr/ml);
end
sdmap(cellfun(@isempty,sdmap)) = [];
dens(cellfun(@isempty,dens)) = [];
return

%%
close
figure('color','k')
colormap('parula')
ah = tight_subplot(1,2,.001,.001,.001);
axes(ah(1))
imagesc(img{movs(whch)})
axis equal
axis off
axes(ah(2))
sdmap{movs(whch)}(sdmap{movs(whch)}==0)=min(nonzeros(sdmap{movs(whch)}(:)));
imagesc(255*sdmap{movs(whch)}/max(sdmap{movs(whch)}(:)))
axis equal
axis off
% hold on
% imagesc(msk{movs(whch)},'alphaData',.2)
F = getframe(gcf);
imwrite(F.cdata,fullfile('sdmaps',[num2str(movs(whch)) '.tif']),'tif')
%%
close
figure('color','k')
colormap('gray')
ah = tight_subplot(1,2,.001,.001,.001);
for i = 1:length(sdmap)
    if isempty(sdmap{i}),continue; end
    axes(ah(1))
    imagesc(dens{i})
    axis equal
    axis off
    axes(ah(2))
    sdmap{i}(sdmap{i}==0)=min(nonzeros(sdmap{i}(:)));
    imagesc(sdmap{i})
    axis equal
    axis off
    F = getframe(gcf);
    imwrite(F.cdata,fullfile('sdmaps',[num2str(i) '.tif']),'tif')
end
close
%%
close
figure('color','k')
colormap('gray')
ah = tight_subplot(1,2,.001,.001,.001);
for i = 1:length(sdmap)
    if isempty(dens{i}),continue; end
    axes(ah(1))
    imagesc(img{i})
    axis equal
    axis off
    axes(ah(2))
    dens{i}(dens{i}==0)=min(nonzeros(dens{i}(:)));
    imagesc(dens{i})
    axis equal
    axis off
    pause(2)
end
close