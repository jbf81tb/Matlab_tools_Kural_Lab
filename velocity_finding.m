function st = velocity_finding(st)
   if isfield(st,'st')
       dim = 3;
   else
       dim = 2;
   end
   for i = 1:length(st)
       lst = length(st(i).frame);
       st(i).vel = zeros(lst,dim);
       st(i).speed = zeros(lst,1);
       if lst<=3, continue; end
       
       st(i).vel(1,1) = (st(i).xpos(2)-st(i).xpos(1));
       st(i).vel(1,2) = (st(i).ypos(2)-st(i).ypos(1));
       if dim == 2
           st(i).speed(1) = sqrt(st(i).vel(1,1)^2+st(i).vel(1,2)^2);
       elseif dim==3
           st(i).vel(1,3) = (st(i).st(2)-st(i).st(1));
           st(i).speed(1) = sqrt(st(i).vel(1,1)^2+st(i).vel(1,2)^2+st(i).vel(1,3)^2);
       end
       
       for j = 2:lst-1
           st(i).vel(j,1) = (st(i).xpos(j+1)-st(i).xpos(j-1))/2;
           st(i).vel(j,2) = (st(i).ypos(j+1)-st(i).ypos(j-1))/2;
           if dim == 2
               st(i).speed(j) = sqrt(st(i).vel(j,1)^2+st(i).vel(j,2)^2);
           elseif dim==3
               st(i).vel(j,3) = (st(i).st(j+1)-st(i).st(j-1))/2;
               st(i).speed(j) = sqrt(st(i).vel(j,1)^2+st(i).vel(j,2)^2+st(i).vel(j,3)^2);
           end
       end
       
       st(i).vel(lst,1) = (st(i).xpos(lst)-st(i).xpos(lst-1));
       st(i).vel(lst,2) = (st(i).ypos(lst)-st(i).ypos(lst-1));
       if dim == 2
           st(i).speed(lst) = sqrt(st(i).vel(lst,1)^2+st(i).vel(lst,2)^2);
       elseif dim==3
           st(i).vel(lst,3) = (st(i).st(lst)-st(i).st(lst-1));
           st(i).speed(lst) = sqrt(st(i).vel(lst,1)^2+st(i).vel(lst,2)^2+st(i).vel(lst,3)^2);
       end
   end
end