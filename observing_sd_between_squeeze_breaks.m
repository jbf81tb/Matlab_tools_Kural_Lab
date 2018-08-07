breaks = [220,455,690];
ml = max(cellfun(@max,{nsta.frame}));
[sd, A, ints] = deal(cell(1,length(breaks)+1));
ct = 0; ctl = 0;
for i = 1:length(nsta)
    if ~any(nsta(i).frame==breaks(2)), continue; end
    if isempty(nsta(i).vals), continue; end
    fr = nsta(i).frame;
    s = nsta(i).vals(3,:);
    int = nsta(i).vals(1,:);
    intr = nsta(i).int';
    sd{1} =   [sd{1}   s(fr<breaks(1))];
    A{1} =    [A{1}    int(fr<breaks(1))];
    ints{1} = [ints{1} intr(fr<breaks(1))];
    for ib = 2:length(breaks)
        sd{ib} =   [sd{ib}   s(fr>breaks(ib-1)&fr<breaks(ib))];
        A{ib} =    [A{ib}    int(fr>breaks(ib-1)&fr<breaks(ib))];
        ints{ib} = [ints{ib} intr(fr>breaks(ib-1)&fr<breaks(ib))];
    end
    sd{end} =   [sd{end}   s(fr>breaks(end)&fr<ml)];
    A{end} =    [A{end}    int(fr>breaks(end)&fr<ml)];
    ints{end} = [ints{end} intr(fr>breaks(end)&fr<ml)];
    ct = ct+1;
    ctl = ctl+length(fr);
end

vec = 0:0.1:6;
% vec = 400:100:10000;
leg = {};
close
figure
axes
hold on
for i = 2:3
    histogram(sd{i}(ints{i}>1000),vec,'normalization','probability')
    leg{end+1} = num2str(i);
end
legend(leg)
