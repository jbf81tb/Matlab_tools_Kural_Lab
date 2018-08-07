tmpd = dir('*after.mat');
frl = [41];
for fi = 1:length(tmpd)
    load(tmpd(fi).name)
    ml = max(reshape(Threshfxyc(:,1,:),[],1));
    brkpt = frl(fi)*(1:(ml/frl(fi))-1);
    [frame,xpos,ypos,int] = deal(cell(1,size(Threshfxyc,3)));
    class = zeros(1,size(Threshfxyc,3));
    k = 1;
    for i = 1:size(Threshfxyc,3)
        frame{k} = nonzeros(Threshfxyc(:,1,i));
        xpos{k} = nonzeros(Threshfxyc(:,2,i));
        ypos{k} = nonzeros(Threshfxyc(:,3,i));
        class(k) = Threshfxyc(1,4,i);
        int{k} = nonzeros(Threshfxyc(:,5,i));
        newst = [];
        num = 1;
        for j = brkpt
            if any(frame{k}<=j) && any(frame{k}>j)
                newst{num} = find(frame{k}>j,1);
                num = num+1;
            end
        end
        if isempty(newst), k = k+1; continue; end
        for j = 1:length(newst)
            if j == length(newst)
                en = length(frame{k});
            else
                en = newst{j+1}-1;
            end
            frame{k+j} = frame{k}(newst{j}:en);
            xpos{k+j} = xpos{k}(newst{j}:en);
            ypos{k+j} = ypos{k}(newst{j}:en);
            class(k+j) = 0;
            int{k+j} = int{k}(newst{j}:en);
        end
        
        frame{k}(newst{1}:end) = [];
        xpos{k}(newst{1}:end) = [];
        ypos{k}(newst{1}:end) = [];
        class(k) = 0;
        int{k}(newst{1}:end) = [];
        
        k = k+length(newst)+1;
    end
    newthresh = zeros(frl(fi),5,length(frame));
    for i = 1:size(newthresh,3)
        for j = 1:length(frame{i})
            newthresh(j,1,i) = frame{i}(j);
            newthresh(j,2,i) = xpos{i}(j);
            newthresh(j,3,i) = ypos{i}(j);
            newthresh(j,4,i) = class(i);
            newthresh(j,5,i) = int{i}(j);
        end
    end
    save(tmpd(fi).name,'Threshfxyc','newthresh')
end