function n = factorial_recur(m)
    if(m==0)
        n=1;
        return
    end
    n = m*factorial_recur(m-1);
end