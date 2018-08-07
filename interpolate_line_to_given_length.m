function interp_line = interpolate_line_to_given_length(line,len)
xwant = linspace(1,length(line),len);
interp_line = interp1(1:length(line),line,xwant,'linear');
end