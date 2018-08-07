function sst = SST(y_d)
%SST Sum of the Squares about the mean
sst = 0;
ly = length(y_d);
my = sum(y_d)/ly; %mean of the distribution
for i = 1:ly
    sst = sst + (y_d(i)-my)^2;
end
end

