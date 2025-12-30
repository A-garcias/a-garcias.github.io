function [t, x, v, Fx]= calculateSystemResponse(m, k, a, B, c, uN, w, Y, h, t_f)
%takes in the mass of the system (m), the spring parameters of the spring constant (k),
% and the non-linear spring coefficients (a and B), the damper parameters of the damping 
% coefficient (c), and the damper friction force (uN) the base motion parameters of 
% frequency (w) and amplitude (Y), the solver settings of time step (h) and
% the final time (t_f) 
% Outputs the time (t), the position (x), the velocity (v),
% and the total force (Fx)
x_1_0 = 0  ;                                         %from ppt slides
x_2_0 = 0  ;                                        %from ppt slides

%x1 = x 
%x2 = x'
%x1' = x' = x2
%x2' = long formula (call f2Prime)

f1Prime = @(t,x1,x2)(x2);
f2Prime = @(t, x1, x2)((-1*k.*(x1-Y.*sin(w.*t)+a*(x1-Y.*sin(w.*t))^B)-(c.*(x2-(Y*w.*cos(w.*t)))+sign(x2 - (Y*w.*cos(w.*t))).*uN))./m);

[t,x,v]= coupledRKutta4Order(f1Prime, f2Prime, x_1_0, x_2_0, h, t_f);

y = Y.*sin(w.*t); 
d = x - y;


F_spring = calculateSpringForce(d, k, a, B);
F_damper = calculateDamperForce(v, c, uN);   
Fx = F_spring + F_damper;
end 
