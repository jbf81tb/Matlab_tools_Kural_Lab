rainbow(1,:) = [.4 0 .8];
for i = 2:64
    if i>1 && i<=16
        rainbow(i,:) = [.4-.4*((i-1)/15) 0 .8];
    elseif i>16 && i<=32
        rainbow(i,:) = [0 0+.8*((i-16)/16) .8-.8*((i-16)/16)];
    elseif i>32 && i<=48
        rainbow(i,:) = [.0+.8*((i-32)/16) .8-.4*((i-32)/16) .0];
    elseif i>48 && i<=64
        rainbow(i,:) = [.8 .4-.4*((i-49)/15) .0];
    end
end