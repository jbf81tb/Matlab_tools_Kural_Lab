function mouse_test
fh = figure('units','normalized',...
    'Position',[0 0 .4 .4*1920/1080],...
    'WindowButtonDownFcn',@wbdf);
axes('units','normalized',...
    'Position',[0 0 1 1])
imagesc([1,2;3,4])
waitfor(fh,'SelectionType','alt')
close(fh)
    function wbdf(src,~)
        cp = src.CurrentPoint;
        tmpx = cp(1)*2;
        tmpy = 2-cp(2)*2;
        disp([tmpx,tmpy])
    end
end