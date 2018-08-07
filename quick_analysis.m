frame_time = 3; %in seconds
background = 400; %the default value (it should represent the smallest intensity of a real spot)
lifetime_bin_vector = [0 19.5:3:199.5 inf];
slope_bin_vector = [-inf -.145:.01:.145 inf];
%%

%double click the .mat file you're interested in. This will load a variable
% called Threshfxyc into your workspace

%these two functions put the data into a useful structure
%you may want to change the variable name if you're trying to compare two sets of data
tmpst = fxyc_to_struct(Threshfxyc);
tmpst = slope_finding(tmpst, frame_time, background);
%%

%these functions make the plots
figure
cond1 = [tmpst.class]==3;
histogram([tmpst(cond1).lt]*3,lifetime_bin_vector,...
          'normalization','probability')

figure
cond2 = [tmpst.class]<=3;
histogram(nonzeros(cell2mat({tmpst(cond2).sl}')),slope_bin_vector,...
          'normalization','probability')