function key_test
fh = figure('units','normalized',...
            'position',[0 0 .3 .3],...
            'keypressfcn',@keypress);
   
waitfor(fh)
    function keypress(src,event)
        disp(event.Key)
        if strcmp(event.Key,'escape')
            close(fh)
            return
        end
    end
end
