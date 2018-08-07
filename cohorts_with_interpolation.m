numind = 10; %number of cohorts
cl = 10; %cohort time width in seconds
cohort = cell(1,numind);
sum_cell = cell(1,numind);
tmptracest = bsctracest;
for i = 1:length(tmptracest)
    fr = tmptracest(i).fr;
    ind = ceil(length(tmptracest(i).frame)*fr/cl);
    if ind>numind || ind<1, continue; end
    len = ind*cl;
    line = tmptracest(i).int;
    line = line/max(line);
    line = interpolate_line_to_given_length(line,length(line)*fr);
%     line = line/max(line);
    xhave = 1:length(line);
    xwant = linspace(1,length(line),len);
    interp_line = interp1(xhave,line,xwant,'spline');
    if isempty(cohort{ind}) 
        cohort{ind} = zeros(1,len); 
        sum_cell{ind} = 0;
    end
    cohort{ind} = cohort{ind} + interp_line;
    sum_cell{ind} = sum_cell{ind} + 1;
end
cohort = cellfun(@rdivide,cohort,sum_cell,'uniformoutput',false);
toss = cellfun(@isempty, cohort);
cohort(toss) = [];
sum_cell(toss) = [];
toss = cellfun(@lt,sum_cell,repmat({4},size(sum_cell)));
cohort(toss) = [];
sum_cell(toss) = [];
numind = length(cohort);
close
figure
ah = axes;
co = colormap(parula(numind));
set(ah,'ColorOrder',co)
hold on
for i = 1:length(cohort)
    plot(cohort{i},'linewidth',3)
end
xlabel('time (s)')
legend(cellfun(@num2str,sum_cell,'UniformOutput',false))

