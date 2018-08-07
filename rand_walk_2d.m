%% GENERATE RANDOM WALK
% close
[D2,MSS] = deal(zeros(1,1000));
fprintf('Percent complete: %03u',0);
for trial = 1:1000
lw = 1000;
ss = 1;
[ix,iy] = deal(zeros(1,lw+1));
stepangle = 2*pi*rand(1,lw);
% stepdir = rand(1,lw);
% stepdis = rand(1,lw);
for i = 1:lw
    ix(i+1) = ix(i)+cos(stepangle(i))*ss;
    iy(i+1) = iy(i)+sin(stepangle(i))*ss;
%     if stepdir(i)>.5
%         if stepdis(i)>.5
%             ix(i+1) = ix(i)+ss*;
%         else
%             ix(i+1) = ix(i)-ss;
%         end
%         iy(i+1) = iy(i);
%     else
%         if stepdis(i)>.5
%             iy(i+1) = iy(i)+ss;
%         else
%             iy(i+1) = iy(i)-ss;
%         end
%         ix(i+1) = ix(i);
%     end
end
% plot(ix,iy)
% axis equal
%% MEAN SQUARED DISPLACEMENT
numsp = floor(lw/3);
numv = 6;
msd = zeros(numv,numsp);
[gv,Dv] = deal(zeros(1,numv));
for v = 1:numv
    for dt = 1:numsp
        msd(v,dt) = sum(sqrt((ix(dt+1:end)-ix(1:end-dt)).^2+...
                       (iy(dt+1:end)-iy(1:end-dt)).^2).^v)...
                   /(lw-dt);
    end
    tmp = polyfit(log(1:numsp),log(msd(v,:)),1);
    gv(v) = tmp(1);
    Dv(v) = (1/(2*v))*exp(tmp(2));
end
tmp = polyfit(1:numv,gv,1);
% title(sprintf('MSS slope = %f -- Diff Coef = %f',tmp(1),Dv(2)))
D2(trial) = Dv(2);
MSS(trial) = tmp(1);
fprintf('\b\b\b%03u',trial/1000);
end
fprintf('\b\b\b%03u',100);