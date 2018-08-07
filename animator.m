function animator(action)
switch(action)
case 'start',
     set(gcbf,'WindowButtonMotionFcn','animator move')
     set(gcbf,'WindowButtonUpFcn','animator stop')
case 'move'
     l1 = findobj('tag','Line1');
     set(l1,'Selected','on')
     XData = get(l1,'Xdata');
     YData = get(l1,'Ydata');
     currPt=get(gca,'CurrentPoint');   
     X = currPt(1,1);
     Y = currPt(1,2);
         FinalX = X-XData(3);
         FinalY = Y-YData(3);
         XData(2:3) = XData(2:3) + FinalX;
         YData(3:4) = YData(3:4) + FinalY;
         set(l1,'Xdata',XData)
         set(l1,'Ydata',YData)
case 'stop'
     set(gcbf,'WindowButtonMotionFcn','')
     set(gcbf,'WindowButtonUpFcn','')
     l1 = findobj('tag','Line1');
     set(l1,'selected','off')
end