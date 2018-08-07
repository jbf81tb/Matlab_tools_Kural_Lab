tmpst = tracestAP2;
sources = string(cell({tmpst.source}));
usources = unique(sources);
count = zeros(1,length(usources));
donuts = {tmpst.donut};
frames = {tmpst.frame};
maxfrs = zeros(1,length(usources));
for i = 1:length(sources)
    for j = 1:length(usources)
        if strcmp(sources(i),usources(j))
            if any(donuts{i})
                count(j) = count(j) + 1;
            end
            if max(frames{i})>maxfrs(j)
                maxfrs(j)=max(frames{i});
            end
        end
    end
end
%%
figure
ah = axes;
bar(count)
% set(ah,'xticklabel',usources)