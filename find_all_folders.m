cleanDirOut = @(x)(x(~cellfun(@strcmp,cellfun(@(y)y(1),{x.name},'UniformOutput',false),repmat({'.'},size({x.name})))));

main_fol = 'Y:\Janelia\Kural_SIM';
maxF = 100;
folder_list = cell(maxF,1);
folder_list{1} = {main_fol};
index_list = ones(maxF,1);
depth = 1;
done = false;
%%%%%%%%%%%%%%%% your own variables
count_ap2 = 0;
count_calm = 0;
%%%%%%%%%%%%%%%%
while true
    cd(folder_list{depth}{index_list(depth)});
    tmpd = cleanDirOut(dir(folder_list{depth}{index_list(depth)}));
    tmpd(~[tmpd.isdir]) = [];
    if isempty({tmpd.name})
        %% Put your own code here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if endsWith(folder_list{depth}{index_list(depth)},'_done')
            
            load(fullfile(folder_list{depth}{index_list(depth)},'tracest_488.mat'),'tracest')
            tracest([tracest.ishot]|[tracest.ispair]) = [];
            if contains(folder_list{depth}{index_list(depth)},'CALM')
                count_calm = count_calm+length(tracest);
            elseif contains(folder_list{depth}{index_list(depth)},'AP2')
                count_ap2 = count_ap2+length(tracest);
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        while index_list(depth) == length(folder_list{depth})
            index_list(depth) = 1;
            depth = depth-1;
            if depth==0
                cd(folder_list{1}{1})
                return;
            end
        end
        index_list(depth) = index_list(depth) + 1;
        continue
    end
    depth = depth+1;
    if index_list(depth)==1
        folder_list{depth} = cellfun(@fullfile,{tmpd.folder},{tmpd.name},'UniformOutput',false);
    end
end