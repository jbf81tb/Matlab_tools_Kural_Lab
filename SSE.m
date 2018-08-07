function sse = SSE(y_r,y_d)
%SSR Sum of the Squares of the Regression
sse = 0;
ly = length(y_d);
for i = 1:ly
    sse = sse + (y_r(i)-y_d(i))^2;
end
end