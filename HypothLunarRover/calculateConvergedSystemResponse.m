function [t, x, v, Fx, h, Ea_x] = calculateConvergedSystemResponse(m, k, a, B, c, uN, w, Y, h_0, t_f, Es_x)
% takes into account the mass of the system (m), the spring parameters of the 
% spring constant (k), and the non-linear spring coefficients (a and B), the 
% damper parameters of the damping coefficient (c) and the damper friction 
% force (uN), the base motion parameters of frequency (w) and amplitude (Y), 
% the initial time step,h_0, the final time, t_f, and the displacement error 
% tolerance, Es_x

% Outputs: time (t), the position (x), the velocity (v), the total force
% (Fx), the solution convergence parameters of time steps (h_j), and 
% the approximate errors (Ea_x)

j = 1;

Ea_x = 100;                                                                   %initialize Ea_x vector (cant use zero method bc don't know how many step sizes I'll go through before getting Ea low enough)
    
[t, x, v, Fx] = calculateSystemResponse(m, k, a, B, c, uN, w, Y, h_0, t_f);     %initialize with first h to get first set of data (t, x, v, m) 
h = h_0;                                                                        %initialize h value also 

while Ea_x(end) > Es_x                                                          %continue looping until Ea_x is below Es we want 
    j = j+1;                                                                    %keeps track of how many h's we've changed (for me)
    old_t = t;                                                                  %store old values
    old_x = x;

    h = h/2;                                                                    %change h (halving it)

    [t, x, v, Fx] = calculateSystemResponse(m, k, a, B, c, uN, w, Y, h, t_f);   %plug in with new h, will output new t,x,v,s
                                                                               
    [t_match] = ismember(t, old_t);                                             %find where t's overlap in order to compare (will basically be t_old bc it has less values) 
    
    x_new = x(t_match); 

   
    Ea = x_new - old_x ;                                                   %intialize counter (for me)
    worst_Ea = abs(Ea);

    Ea_x(j) = max(worst_Ea);                                                   %Ea_x = max value of all approximate errors of t vector (biggest x disparity, regardless of time)
    
end                                                                             %close while loop (small enough time step, h, has been reached so that Ea is below Es)
Ea_x(1) = 0;

steps = zeros( 1, j);
steps(1) = NaN;

for ii = 2:j
    exp = 2^(ii-1);
    steps(ii) = h_0/exp;
end
h = steps;
end                                                                             %close function
