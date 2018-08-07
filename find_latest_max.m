function [max,ind] = find_latest_max(trace,varargin)
    switch nargin
        case 1
            tol = 0.05;
        case 2
            tol = varargin{1};
    end
    lt = length(trace);
    max = 0;
    ind = lt;
    tsince = 0;
    for i = lt:-1:1
        if trace(i)>max*(1+tol*tsince)
            max = trace(i);
            ind = i;
            tsince = 0;
        else
            tsince = tsince+1;
        end
    end
end