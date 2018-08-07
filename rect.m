function rect(x)
if nargin <1 
     x = 'start';
end
switch x
case 'start'
     figure;
     axes('nextplot','replacechildren')
     axis([0 5 0 5])
     x = [0 1 1 0 0];
     y = [0 0 1 1 0];
     l1 = line(x,y);
     set(l1,'Tag','Line1')
     set(l1,'Buttondownfcn','animator(''start'')')
     set(gca,'ButtonDownFcn','rect(''gcf_bdf'')')
case 'gcf_bdf'
     l1 = findobj('tag','Line1');
     % set(l1,'Selected','on')
     A = get(gca,'CurrentPoint');
     X = A(1,1);
     Y = A(1,2);
     XData = get(l1,'Xdata');
     YData = get(l1,'Ydata');
     [dX,Ix] = min(abs(XData-X));
     [dY,Iy] = min(abs(YData-Y));
     FinalX = X-XData(Ix);
     FinalY = Y-YData(Iy);
     XData = XData + FinalX;
     YData = YData + FinalY;
     set(l1,'Xdata',XData)
     set(l1,'Ydata',YData)
end