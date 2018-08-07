lgr = 200;
lgcent = [300, 300];
lgp = 100;
lgcoord = zeros(lgp,2);
fname = [pwd filesep 'ground_truth.txt'];
fid = fopen(fname,'w');
fprintf(fid,'Pos_x Pos_y Pos_z n_x n_y n_z\n');
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
    fprintf(fid,'%u %u 0 0 0 1\n',round(lgcoord(i,1)),round(lgcoord(i,2)));
end
fclose(fid);