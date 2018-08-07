function fxyc_struct = slope_finding_point_skip(fxyc_struct,frame_rate,bkgrd,skip)
ints = {fxyc_struct.int}; %reduce text in code.
prange = 12/frame_rate; %develop a frame range of 12 seconds
if prange<3, prange=3; end
forwardp = .25;
front = ceil(forwardp*(prange-1)); %frames forward in time
rear = floor((1-forwardp)*(prange-1)); %frame backward in time
for i = 1:length(ints)
    int = ints{i}; %reduce text in code.
    lint = length(int);
    intdif = zeros(lint,1);
    if lint<=prange %if the trace is too short, skip it.
        fxyc_struct(i).sl = single(intdif);
        continue;
    end
    %this is where we perform manual least-squares fitting
    for j = (rear+1):(lint-front)
        sub = (j-rear):(j+front);
        curmax = max(int)-bkgrd;
        tmp = (int(sub)-bkgrd)/curmax;
        tmpx = sub*frame_rate;
        tmpy = tmp';
        numer = length(tmpx)*sum(tmpx.*tmpy)-sum(tmpx)*sum(tmpy);
        denom = length(tmpx)*sum(tmpx.^2)-sum(tmpx)^2;
        intdif(j) = numer/denom;
    end
    fxyc_struct(i).sl = single(intdif); %add data to existing structure.
end
frame_rate = frame_rate*skip;
prange = 12/frame_rate; %develop a frame range of 12 seconds
if prange<3, prange=3; end
front = ceil(forwardp*(prange-1)); %frames forward in time
rear = floor((1-forwardp)*(prange-1)); %frame backward in time
for start = 1:skip
    for i = 1:length(ints)
        int = ints{i}(start:skip:end); %reduce text in code.
        lint = length(int);
        intdif = zeros(lint,1);
        if lint<=prange %if the trace is too short, skip it.
            fxyc_struct(i).sl = single(intdif);
            continue;
        end
        %this is where we perform manual least-squares fitting
        for j = (rear+1):(lint-front)
            sub = (j-rear):(j+front);
            curmax = max(int)-bkgrd;
            tmp = (int(sub)-bkgrd)/curmax;
            tmpx = sub*frame_rate;
            tmpy = tmp';
            numer = length(tmpx)*sum(tmpx.*tmpy)-sum(tmpx)*sum(tmpy);
            denom = length(tmpx)*sum(tmpx.^2)-sum(tmpx)^2;
            intdif(j) = numer/denom;
        end
        fxyc_struct(i).(['sl' num2str(start)]) = single(intdif); %add data to existing structure.
    end
end
end