function movegraph(h,opt,tool)
% function movegraph(h,option)
%
% INPUTS:      h = handle to a line object (e.g. created by a plot command)
%         option = [  'x' | 'y' | {'xy'} | 'axy' ]
%
% This function, once enabled, allows the user to manipulate the coordinates of any
% point in a line object specified by handle h, simply by clicking and moving the mouse.
%
% If the function is invoked with no option, or with the option 'xy', then clicking the mouse 
% over the line will allow the user to drag the point to a new x- and y- coordinate, as long 
% as the new x coordinate is between the two adjacent points.  If the function is invoked 
% with the option 'x' or 'y' then the point will only move in the specified coordinate, 
% leaving the other coordinate fixed. 
%
% If the function is called with the option 'x' or with the option 'axy', the x-coordinate 
% will not be limited to values between adjacent points.
%
% When the button is released, the point will take on the new values.
%
% EXAMPLE:
% >> h = plot(x, sin(x));
% >> movegraph(h,'xy')
% >>
%
% If the function is invoked on a line which already uses the movegraph function, then the
% function will be disabled.  If the function is called on a line with z-data, then the
% function will return an error and not be invoked.
%
% The function can also be disabled by calling it with the opt argument equal to 'off'.
%
% EXAMPLE:
% >> movegraph(h,'off')
% >>
%
% This function makes use of the current axes' 'userdata' property, which must be made available
% to it.  During the immediate execution of the function (i.e. as long as the button is being held down), 
% the axes' 'userdata' property is unavailable; however, upon the release of the mouse button, the
% function restores the axes' userdata to its initial value.
%
% Written by Brandon Kuczenski for Kensington Labs
% brandon_kuczenski@kensingtonlabs.com
% 17 September 2001
%
% Modified to restore button functions to original state
% And test for double-click to end movegraph action
% Alex Woo, woo@geomi.com
% 26 February 2002
%

switch nargin
case 0
    error('Must Specify a handle to a line object')
case 1
    opt='xy';
case 2
    if ~any(strcmp(opt,{'x','y','xy','axy','a','off'}))
        error(['Second argument ''' opt ''' is an unknown command option.'])
    end
end

if nargin<3  % i.e. user-invoked.
    b = [];
    if strcmp(opt,'a')
        opt='axy';
    end
    if isempty(b) % only assign original values to marker struct if function is being called the first time
        k.m=get(h,'marker');set(h,'marker','o');
        k.ms=get(h,'markersize');set(h,'markersize',4);
        k.mfc=get(h,'nodecolor');set(h,'nodecolor',get(h,'edgecolor'));
    else
        k=get(gca,'userdata'); %#ok<NASGU>
    end
%     k.opt=opt;
%     k.bdfcn=get(h,'buttondownfcn') % save the current buttondownfcn before reset
    set(gca,'buttondownfcn',['movegraph(h,''' opt ''',1)'],...
        'XLimMode','manual','YLimMode','manual');
    set(findobj('children',h),'units','pixels')
else  % i.e. self-invoked
    if strcmp(get(gcf,'selectiontype'),'open')
        movegraph(h,'off');
    else
        switch tool
        case 1 % line's buttondownfcn invoked
            cp=get(gca,'currentpoint');
            k=get(gca,'userdata');
            y=abs(get(h,'ydata')-cp(2,2));x=abs(get(h,'xdata')-cp(1,1)); % determine which point the user clicked on
            % just use the distance function
            d=sqrt(y.^2+x.^2);
            k.index=find(d==min(d));
%             k.axesdata=get(gca,'userdata');
            k.doublebuffer=get(gcf,'doublebuffer');
            k.winbmfcn = get(gcf,'windowbuttonmotionfcn');  %  save current window motion function
            k.winbupfcn = get(gcf,'windowbuttonupfcn');  %  save current window up function
            k.winbdfcn = get(gcf,'windowbuttondownfcn');  %  save current window down function
            
            set(gca,'userdata',k);
            set(gcf,'windowbuttonmotionfcn',['movegraph(h,''' opt ''',2)'],'doublebuffer','on');
%             set(gca,'userdata',h);
            set(gcf,'windowbuttonupfcn',['movegraph(h,''' opt ''',3)']);
            
            %         end    
        case 2 % button motion function
            k=get(gca,'userdata');
            cp=get(gca,'currentpoint');
            x=get(h,'xdata');
            y=get(h,'ydata');
            switch opt
            case 'x'
                x(k.index)=cp(1,1);
            case 'y'
                y(k.index)=cp(2,2);
            case {'xy','axy'}
                x(k.index)=cp(1,1);
                y(k.index)=cp(2,2);
            end
            
            set(h,'xdata',x,'ydata',y)
            % test to see if it moved off the screen - update limits
            fgx=get(gca,'xlim');
            fgy=get(gca,'ylim');
            if any(opt=='y')&&cp(2,2)>fgy(2)
                set(gca,'ylim',[fgy(1) cp(2,2)])
            end
            if any(opt=='y')&&cp(2,2)<fgy(1)
                set(gca,'ylim',[cp(2,2) fgy(2)])
            end
            if any(opt=='x')&&cp(1,1)>fgx(2)
                set(gca,'xlim',[fgx(1) cp(1,1)])
            end
            if any(opt=='x')&&cp(1,1)<fgx(1)
                set(gca,'xlim',[cp(1,1) fgx(2)])
            end
            
        case 3 % button up - we're done
            k=get(gca,'userdata');
%             set(gca,'userdata',k.axesdata); % restore axes data to its previous value
            set(gcf,'windowbuttonmotionfcn',k.winbmfcn,'windowbuttonupfcn',k.winbupfcn,'doublebuffer',k.doublebuffer)
        end
    end
end

