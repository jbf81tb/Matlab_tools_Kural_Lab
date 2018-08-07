function ssr = SSR(y_r,y_d)
%SSR Sum of the Squares of the Regression
ssr = 0;
ly = length(y_d);
my = sum(y_d)/ly; %mean of the distribution
for i = 1:ly
    ssr = ssr + (y_r(i)-my)^2;
end
end