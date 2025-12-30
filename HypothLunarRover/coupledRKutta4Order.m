function [t, x1, x2] = coupledRKutta4Order (f1, f2, x_1_0, x_2_0, h, t_max)
%takes in fucntion handles for x1 and x2, the intial conditions for x1 and
%x2, a step size and a maximum time (final value of the independent value).
%This outputs vectors of the independent and dependent variables, t, x1 & x2, as outputs
t = 0:h:t_max;                                   %finds the vector for time based on step sizes
N = length(t) - 1;                               %finds the number of steps

x1 = zeros(1, N +1);                             %create a vector for x1 (to later be filled in with loop)
x1(1) = x_1_0;                                   %initialize x1 pos vector 
x2 = zeros(1, N+1);                              %create a vector for x2 (to lster be filled in with loop)
x2(1) = x_2_0;                                   %initialize x2 pos vector 


for ii = 1:N
    t_1 = t(ii);                                 %curr value of time
    x1_1 = x1(ii);                               %curr value of x1 and x2
    x2_1 = x2(ii);
                                                                      
   
    k11 = f1(t_1, x1_1,x2_1);                    %calculates k1 for x1 by plugging in current x and y-value (der at this point)
    k21 = f2(t_1, x1_1,x2_1);                    %calculates k1 for x2 by plugging in current x and y-value (der at this point)


    t_12 = t_1 + (0.5*h);                        %midpoint update for approx time
    x1_2 = x1_1 + (0.5*k11*h);                   %midpoint update for approx x1
    x2_2 = x2_1 + (0.5*k21*h);                   %midpoint update for approx x2                               
    k12 = f1(t_12, x1_2, x2_2);                  %calculates k2 for x1 + 1/2 by pluggin in correct x and y-value adjustments
    k22 = f2(t_12, x1_2, x2_2);                  %calculates k2 for x2 + 1/2 by pluggin in correct x and y-value adjustments


    t_12 = t_1 + (0.5*h);                        %midpoint update for approx time (already done above)
    x1_3 = x1_1 + (0.5*k12*h);                   %midpoint update for approx x1
    x2_3 = x2_1 + (0.5*k22*h);                   %midpoint update for approx x2
    k13 = f1(t_12, x1_3, x2_3);                  %calculates k13 by pluggin in correct x and y-value adjustments 
    k23 = f2(t_12, x1_3, x2_3);                  %calculates k23 by pluggin in correct x and y-value adjustments 




    t_2 = t_1 + h;                               %next time value approx
    x1_4 = x1_1 + (k13*h);                       %x1 point approx based on k13
    x2_4 = x2_1 + (k23*h);                       %x2 point approx based on k23
    k14 = f1(t_2, x1_4, x2_4);                   %calculates k14 by pluggin in correct x and y-value adjustments 
    k24 = f2(t_2, x1_4, x2_4);                   %calculates k24 by pluggin in correct x and y-value adjustments 

    phi_x1 = (1/6)*(k11 + 2*k12+ 2*k13 + k14);
    phi_x2 = (1/6)*(k21 + 2*k22+ 2*k23 + k24);

    x1(ii+1) = x1(ii) + phi_x1*h;                %calculate next value final approximation for x1
    x2(ii+1) = x2(ii) + phi_x2*h;                %calculate next value final approximation for x2
end

end 