%% LOADING THE FILE AND REMOVING OUTSIDE POINTS
num = '1';
load(['00' num '.mat']) %string concatenation, load .mat file
tmpst = slope_finding(fxyc_to_struct(Threshfxyc),3,400); %nested functions
mask = imread(['Mask_00' num '.tif'])>0; %read tif file for mask as a 2D array
                                         % and convert mask to logical
exclude = false(size(tmpst)); %predefine logical array
%loop over structure
for i = 1:length(tmpst)
    if mask(round(mean(tmpst(i).ypos)),round(mean(tmpst(i).xpos))) %if true
        exclude(i) = true;                                                           %then
    end
end
tmpst(exclude) = []; %points for which exclude=true are removed from the structure

%% GENERATING ARRAYS
otmpst = tmpst;
% cond = ~blobs & [tmpst.class]~=4 & [tmpst.class]~=7;
cond = true(size(otmpst));
tmpst = otmpst(cond);
ns = length(tmpst);
lifetimes = [tmpst.lt];
classes = [tmpst.class];
slopes = cell2mat({tmpst.sl}');
frames = cell2mat({tmpst.frame}');
ints = cell2mat({tmpst.int}');
adjints = cell2mat(...
         cellfun(@rdivide,...
                 {tmpst.int},...
                 num2cell(cellfun(@max,{tmpst.int})),...
                 'UniformOutput',false)');
sumints = cellfun(@sum,{tmpst.int});
tmp1 = cellfun(@gt,{tmpst.frame},repmat({0},size(tmpst)),'UniformOutput',false);
tmp2 = num2cell([tmpst.lt]);
tmp3 = num2cell([tmpst.class]);
tmp5 = num2cell(1:ns);
lt = cell2mat(cellfun(@mtimes,tmp1,tmp2,'UniformOutput',false)');
classification = cell2mat(cellfun(@mtimes,tmp1,tmp3,'UniformOutput',false)');
tp = cell2mat(cellfun(@find,{tmpst.frame},'UniformOutput',false)');
idx = cell2mat(cellfun(@mtimes,tmp1,tmp5,'UniformOutput',false)'); %trace number
clear tmp1 tmp2 tmp3 tmp5
disp(length(otmpst)-length(tmpst))
%% EXCLUSION CRITERIA
[~,si] = sort(sumints,'descend');
blobs = false(size(sumints));
blobs(si(1:floor(5*ns/100))) = true;

%% MAKING HISTOGRAMS
lt_bin_vector = [0:5:100 inf]; % default vector for lifetime histogram
slope_bin_vector = [-inf -.045:.03:.045 inf]; %default vector for 5-bin slope histogram
squish_frame = 100; 
close %close all currently open figures
figure(1) %make a new figure
histogram(nonzeros(slopes(frames<squish_frame)),bin_vector,'Normalization', 'Probability')
xlim([-.075 .075]) 
legend(['Before squish. N = ' num2str(sum(frame<squish_frame))])
histogram(lifetimes(classes==3),lt_bin_vector,'Normalization', 'Probability')
legend(['Lifetimes N = ' num2str(sum(classes==3))]) 

%% PLOTTING AVERAGES OVER TIME
ml = max(frames); %ml stands for movie length. In otherwords, the max frame
avg_lt = zeros(1,ml); 
for fr = 1:ml %for frames going from 1 to movie length
    avg_lt(fr) = mean(lt(frames==fr & classification==3));
end
close
figure
plot(1:ml, avg_lt) %plot(x,y)
hold on %I want to draw something else to this figure
yl = get(gca,'ylim'); %get from the current axes the y limits (return a 1D array [ymin ymax])
line([squish_frame squish frame], yl, 'k') 
    