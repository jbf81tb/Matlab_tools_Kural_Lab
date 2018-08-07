%% LOADING THE FILE AND REMOVING OUTSIDE POINTS
%you must work with the script while you are in a directory with .mat files
num = '1';
load(['00' num '.mat']) %string concatenation, load .mat file
data_structure = slope_finding(fxyc_to_struct(Threshfxyc),3,400); %nested functions
mask = imread(['Mask_00' num '.tif'])>0; %read tif file for mask as a 2D array
                                         % and convert mask to logical
exclude = false(size(data_structure)); %predefine logical array
%loop over structure
for i = 1:length(data_structure)
    if mask(round(mean(data_structure(i).ypos)),round(mean(data_structure(i).xpos))) %if true
        exclude(i) = true;                                                           %then
    end
end
data_structure(exclude) = []; %points for which exclude=true are removed from the structure

%% GENERATING 1D ARRAYS FOR SCALARS IN THE STRUCTURE
% I'm including this here for you to reference the notation. Because it is
% so easy to type, it's probably not worth making unique variables for most
% of the time.
lifetimes = [data_structure.lt];
classes = [data_structure.class];

%% GENERATING 1D ARRAYS FOR VECTORS IN THE STRUCTURE (EVERY VALUE IN EVERY TRACE)
% generate array full of true values. This is a placeholder for other
% possible conditions you might want to apply. As it is currently
% implemented, everything will be included.
    cond = true(size(data_structure)); %condidition (use ctrl+r to comment out a line)
    % cond = classes==3;   %example (use ctrl+t to uncomment a line)
% Matlab doesn't care about whitespace
% Here we will generate 1-D arrays all of equal size. These are useful for
% matching values to frames
slopes = cell2mat({data_structure(cond).sl}');
frames = cell2mat({data_structure(cond).frame}');
ints = cell2mat({data_structure(cond).int}');
% these first three should be easy to understand, the rest are more
% advanced manipulations. adjints stands for adjusted intensities. It is all
% of the intensity values divided by the maximum intensity value in the
% trace. cell2mat concatenates a cell array into a 1D array. cellfun
% applies a function to each cell in a cell array. rdivide is just the name
% of the normal division operator (i.e. "/"). we need to use the name because
% we are using a function handle (@), which relates to a function similarly to
% how a memory address relates to a variable. num2cell turns a 1D array
% into a cell array where each cell is a scalar. I need to do this because
% cellfun can only operate on cells, and I want to divide one cell by
% another. In this way, I am dividing each intensity cell, by the maximum
% value in that cell. I think it would be easy for you to understand how
% this is done in a for loop, but I do it in this way to show you the power
% of matlab to do things in one line. The "..." symbol I use is in order to
% work on the next line. I do this for clarity, occasionally, because
% Matlab doesn't care about whitespace.
adjints = cell2mat(...
         cellfun(@rdivide,...
                 {data_structure.int},...
                 num2cell(cellfun(@max,{data_structure.int})),...
                 'UniformOutput',false)');
% Next, we are going to take a bunch of values which are scalars in our
% structure and stretch them out into the length of the trace. Again, this
% is useful for performing comparisons with respect to frames. tmp1
% generates a cell array full of 1D arrays that are all ones and of equal
% length as the traces. The other tmp values are cells full of scalars, so
% we can operate on them with cellfun. We are basically doing 
%         number*[1 1 1 ... 1] = [number number number ... number]
% for each cell.
tmp1 = cellfun(@gt,{data_structure.frame},repmat({0},size(data_structure)),'UniformOutput',false);
tmp2 = num2cell([data_structure.lt]);
tmp3 = num2cell([data_structure.class]);
tmp5 = num2cell(1:length(data_structure));
% lt is a lifetime vector, of equal length to the slopes, frames, and ints
% vector above. class is a class vector of the same length, and tp stands
% for time point. The timp point starts at 1 for each trace and counts up.
% I include this incase you would like to look at traces with respect to
% their beginnings, rather than with respect to their actual frame
lt = cell2mat(cellfun(@mtimes,tmp1,tmp2,'UniformOutput',false)');
class = cell2mat(cellfun(@mtimes,tmp1,tmp3,'UniformOutput',false)');
tp = cell2mat(cellfun(@find,{data_structure.frame},'UniformOutput',false)'); %timepoint
% I don't think you will need the below variable, I just included in case
% it was important for working in excel. idx stands for index, it is just
% the number of each trace. 
idx = cell2mat(cellfun(@mtimes,tmp1,tmp5,'UniformOutput',false)'); %trace number

%% MAKING HISTOGRAMS
lt_bin_vector = [0:5:100 inf]; % default vector for lifetime histogram
slope_bin_vector = [-inf -.045:.03:.045 inf]; %default vector for 5-bin slope histogram
squish_frame = 100; %arbitrary. You must find from the movie. 
% You should probably go through all the movies and write down the frames
% where the squish happens.

% I include these first two lines just to make sure I'm generating the
% figure in a new window. That way I don't have to hunt for the figure if
% the window pops up in the background of my desktop.
close %close all currently open figures
figure(1) %make a new figure
histogram(nonzeros(slopes(frames<squish_frame)),bin_vector,'Normalization', 'Probability')
xlim([-.075 .075]) %give the graph nice x limits
% Including 'normalization', 'probability' (capitalization doesn't actually
% matter) means that all of the bins will sum up to 1. This allows us to
% compare different data sets which contain a different number of points. 
% Also remember, whenever looking at slopes you need to use the nonzeros
% function in order to remove all of the zeros that were acting as padding
% in the slope vectors.
legend(['Before squish. N = ' num2str(sum(frame<squish_frame))])
% The above is an example of how to include a legend, which is important
% when you want to graph multiple values. the num2str function turns a
% number into a string, and that number, in this case, is the sum of the
% logical array generated by the above condition. remember true=1, false=0
figure(2) %make a second figure
histogram(lifetimes(classes==3),lt_bin_vector,'Normalization', 'Probability')
legend(['Lifetimes N = ' num2str(sum(classes==3))]) 
%because we made a second figure, that is now the "Current Figure". the
%legend and histogram functions know that and will draw on it. If you were to
%click on figure 1, however, that would make figure 1 the current figure.
%(There is not actually a way for you to do that in the middle of the
%script, however.)

%% PLOTTING AVERAGES OVER TIME
% This is something that I did not show you before, but it could be useful
% for you.
ml = max(frames); %ml stands for movie length. In otherwords, the max frame
avg_lt = zeros(1,ml); %initialize array for average lifetimes
%initializing arrays is only important for loops. Matlab can deal
%with arrays which grow arbitrarily, however it will be much slower.
for fr = 1:ml %for frames going from 1 to movie length
    avg_lt(fr) = mean(lt(frames==fr & class==3));
end
%notice I used 'class' instead of 'classes' and 'lt' instead of 'lifetimes'. 
%This is because 'class' is the same length as lt and frames, which is
%different from lifetimes and classes, which are the same length as
%data_structure
close
figure
plot(1:ml, avg_lt) %plot(x,y)
hold on %I want to draw something else to this figure
yl = get(gca,'ylim'); %get from the current axes the y limits (return a 1D array [ymin ymax])
line([squish_frame squish frame], yl, 'k') 
% plot a vertical line ([x1 x2], [y1 y2] x1=x2, so it is vertical)
% In this way we have a line on the graph for where the squish happened.
% The 'k' argument just makes the line blac'k'.
    