gaus = @(A,m,s,c,x)A*exp(-(x-m).^2/(2*s^2))+c;
window = 4;
nth = 24;
nr = 2*window;
nr = 2*floor(nr/2); %nr must be even
movie = '004.tif';
tic
for i = 1:length(nsta)
    xpos = nsta(i).xpos;
    ypos = nsta(i).ypos;
    frame = nsta(i).frame;
%     if ~any(frame==455), continue; end
    % close
    % figure
    % for fr = 1:length(frame);
    % tmpimg = imread(movie,frame(fr));
    % imagesc(tmpimg)
    % hold on
    % scatter(xpos(fr),ypos(fr),100,'r')
    % pause(.1)
    % end
    % close
    
    if min(xpos)<window+1 || min(ypos)<window+1 || max(xpos) > size(tmpimg,2)-window || max(ypos) > size(tmpimg,1)-window
        disp('out of window')
        continue;
    end
    img = cell(1,length(frame));
    for fr = 1:length(frame);
        y1 = round(ypos(fr))-window;
        y2 = round(ypos(fr))+window;
        x1 = round(xpos(fr))-window;
        x2 = round(xpos(fr))+window;
        img{fr} = imread(movie,frame(fr));
        img{fr} = img{fr}(y1:y2,x1:x2);
        %     img{fr} = double(img{fr})/max(double(img{fr}(:)));
    end
    
    r = cell(1,length(frame));
    for fr = 1:length(frame)
        [mimg,mi] = max(img{fr}(:));
        [midy,midx] = ind2sub(size(img{fr}),mi);
        r{fr} = zeros(nth,2*nr+1);
        ith = 0;
        for th = 0:pi/nth:(nth-1)*pi/nth
            ith = ith+1;
            ido = 0;
            for id = nr:-1:1
                ido = ido + 1;
                y = round(midy+window/nr*sin(pi+th)*id);
                x = round(midx+window/nr*cos(pi+th)*id);
                if x<1 || x>2*window+1 || y<1 || y>2*window+1
                    continue;
                end
                r{fr}(ith,ido) = img{fr}(y,x);
            end
            r{fr}(ith,nr+1) = mimg;
            ido = ido+1;
            for id = 1:nr
                ido = ido + 1;
                y = round(midy+window/nr*sin(th)*id);
                x = round(midx+window/nr*cos(th)*id);
                if x<1 || x>2*window+1 || y<1 || y>2*window+1
                    continue;
                end
                r{fr}(ith,ido) = img{fr}(y,x);
            end
        end
    end
    dia = zeros(2*nr+1,length(frame));
    for fr = 1:length(frame)
        dia(:,fr) = mean(r{fr});
    end
    vals = zeros(4,length(frame));
    
    for fr = 1:length(frame)
        f = fit((1:2*nr+1)',dia(:,fr),gaus,...
            'StartPoint',[1.0*(max(dia(:,fr))-min(dia(:,fr)))  nr+1  2  1.0*min(dia(:,fr))],...
            'Lower',     [0.8*(max(dia(:,fr))-min(dia(:,fr)))  nr-1  0  0.8*min(dia(:,fr))],...
            'Upper',     [1.2*(max(dia(:,fr))-min(dia(:,fr)))  nr+3  6  1.2*min(dia(:,fr))]);
        vals(:,fr) = coeffvalues(f);
        nsta(i).vals = vals;
    end
    if mod(i,100)==0
        toc
        disp(100*i/length(nsta))
        tic
    end
end
toc
save with_gaus_fit.mat nsta
%%
close
figure
for fr = 1:length(frame)
    plot(mean(r{fr}))
    ylim([0 max(cellfun(@max,cellfun(@(x)x(:),r,'UniformOutput',false)))])
    pause(.2)
end
close
%%
close
figure
for fr = 1:length(frame)
    subplot(1,2,1)
    imagesc(img{fr})
    colormap(gray)
    axis equal
    subplot(1,2,2)
    imagesc(imresize(img{fr},50))
    colormap(gray)
    axis equal
    pause(.1)
end
close
%%
r = cell(1,length(frame));
nth = 48;
nr = 20;
for fr = 1:length(frame)
    [~,mi] = max(img{fr}(:));
    [midy,midx] = ind2sub(size(img{fr}),mi);
    r{fr} = zeros(nth,nr+1);
    ith = 0;
    for th = 0:2*pi/nth:(2*nth-1)*pi/nth
        ith = ith+1;
        for id = 1:nr
            y = round(midy+(window/nr)*sin(th)*id);
            x = round(midx+(window/nr)*cos(th)*id);
            if x<1 || x>2*window+1 || y<1 || y>2*window+1
                continue;
            end
            r{fr}(ith,id+1) = img{fr}(y,x);
        end
        r{fr}(ith,1) = 1;
    end
end

close
figure
for fr = 1:length(frame)
    plot(mean(r{fr}))
    ylim([0 1])
    pause(.2)
end
