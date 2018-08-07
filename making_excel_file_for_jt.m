num = '1';
load(['00' num '.mat'])
jtst = slope_finding(fxyc_to_struct(Threshfxyc),3,400);
mask = imread(['Mask_00' num '.tif'])>0;
exclude = false(size(jtst));
for i = 1:length(jtst)
    if mask(round(mean(jtst(i).ypos)),round(mean(jtst(i).xpos)))
        exclude(i) = true;
    end
end
jtst(exclude) = [];
%%
frames = cell2mat({jtst.frame}');
int = cell2mat({jtst.int}');
slopes = cell2mat({jtst.sl}');
adjint = cell2mat(cellfun(@rdivide,{jtst.int},num2cell(cellfun(@max,{jtst.int})),'UniformOutput',false)');
tmp1 = cellfun(@gt,{jtst.frame},repmat({0},size(jtst)),'UniformOutput',false);
tmp2 = num2cell([jtst.lt]);
tmp3 = num2cell([jtst.class]);
tmp5 = num2cell(1:length(jtst));
lt = cell2mat(cellfun(@mtimes,tmp1,tmp2,'UniformOutput',false)');
class = cell2mat(cellfun(@mtimes,tmp1,tmp3,'UniformOutput',false)');
tp = cell2mat(cellfun(@find,{jtst.frame},'UniformOutput',false)'); %timepoint
idx = cell2mat(cellfun(@mtimes,tmp1,tmp5,'UniformOutput',false)'); %trace number


excel1 = [idx, frames, tp, lt, int, adjint, class, slopes];
excel2 = [(1:length(jtst))', [jtst.lt]', [jtst.class]'];