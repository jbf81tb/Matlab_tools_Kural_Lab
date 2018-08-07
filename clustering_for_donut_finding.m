ml = size(mov,3);
[x,y,fr] = deal(cell(1,ml));
for i = 1:ml
    img = mov(:,:,i);
    [~,x{i},y{i}] =  find_donuts(img,10);
    fr{i} = i*ones(1,length(x{i}));
    disp(i)
end
%%
xv = cell2mat(x');
yv = cell2mat(y');
frv = .3*cell2mat(fr);
distvec = [xv yv frv'];
%%
Z = linkage(distvec,'ward','euclidean');
Y = inconsistent(Z);
%%
c = cluster(Z,'cutoff',3,'criterion','distance');
scatter3(xv,yv,frv,10,c,'filled')
axis equal