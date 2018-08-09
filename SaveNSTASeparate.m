function SaveNSTASeparate(exp_name,descript,nsta)

md = fullfile(exp_name,'movies');
mdir = dir(fullfile(md,'*.tif'));
for i=1:length(mdir)
    movies{i}=strcat(descript,mdir(i).name(1:end-4),'.mat');
    NSTA=nsta{i};
    save(movies{i},'NSTA')
end