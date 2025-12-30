function [x, y] = RKutta4OProj(f, x_0, y_0, h, x_max);
%Takes in a function handle for a derivative (f), initial x and y-values (x_0, y_0), a step
%size (h) and a the maximum value of the independent variable 
x_i = x_0;
y_i = y_0;
x_next = x_0                                                        %initializes that the first x we test is the intial value 
while x_next < x_max;                                               %confirms that the independent value is less than the max we want (the last y_next calculated 
                                                                    %would be at the x we want bc it would be the next calculation). 
   
    k1 = f(x_i,y_i);                                                %calculates k1 by plugging in current x and y-value (der at this point)
    
    xk2 = x_i + (0.5*h);
    yk2 = y_i + (0.5*k1*h);                                         
    k2 = f(xk2, yk2);                                               %calculates k2 by pluggin in correct x and y-value adjustments 

    xk3 = x_i + (0.5*h);
    yk3 = y_i + (0.5*k2*h);
    k3 = f(xk3, yk3);                                               %calculates k3 by pluggin in correct x and y-value adjustments 

    xk4 = x_i + h ;
    yk4 = y_i + (k3*h);
    k4 = f(xk4,yk4);                                                %calculates k3 by pluggin in correct x and y-value adjustments 

    x_next = x_i + h;                                               %adds the step size to the current x (finds the next x_i)
    x_i = x_next;                                                   %resets the value of x_i to the next x-value (the next step)
    y_next = y_i + (1/6)*(k1 + 2*k2 +2*k3 +k4)*h;                   %calculates the next y_i (the y at the next x_i)
    y_i = y_next;                                                   %resets the value of y_i to be the most recent approximation/calculation
    
end 
x = x_i   
y = y_next
