function [guess] = GoldenSearch(x_l, x_u, f, e_s)
% takes in a lower bound and upper bound and uses golden-section to
% calcluate next approximation until it is within the tolerance. 
%x_l = lower bound
%x_u = upper bound
%f = function handle
%e_s = error tolerance
%guess = approximation (xopt)
e_a = 9999999;
R = (5^(1/2)-1)/2;
d = R*(x_u-x_l);
x1 = x_u - d ;         %find x1
x2 = x_l + d ;         %find x2
f1 = f(x1);
f2 = f(x2);
x_opt = 0;
while e_a > e_s
    if f(x1) > f(x2)
    
        x_u = x2;
        x_l = x_l;
        x2 = x1;
        x_opt = x1;
        x1 = x_u - (R*(x_u-x_l));
        
    elseif f(x2) > f(x1)  
        x_u = x_u;
        x_l = x1;
        x1 = x2 ;
        x_opt = x2;
        x2 = x_l + R*(x_u-x_l);
        
    end
    e_a = abs(((1-R)*(x_u-x_l))/x_opt)*100;     %calculate approx. error  
end 
guess = x_opt;
end 

