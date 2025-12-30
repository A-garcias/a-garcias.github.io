i = 1;                                                                      %intialize counter (for me)
    for ii = 1:length(t_check)
    i = i+1;                                                                    %keeps track of index through comparing t's that match (for me)
        t_curr_index = ii; 
        Ea(i) = x(t_curr_index) - old_x(t_curr_index);                          %value of x at t minus previous value of x at t (t at index currently looping through t vector)
    end                                                                         %close loop (stop looping through time vector)
   