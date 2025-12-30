function [X] = calculateDisplacementAmplitude(m, k, a, B, c, uN, w_test, Y, h_0, t_f, t_ss, Es_x)
%takes in the mass of the system (m), the spring parameters of the spring
%constant (k), and the non-linear spring coefficients (a and B), the damper
%parameters of the damping coefficient (c), and the damper friction force
%(uN), the base motion parameters of frequency (w), and amplitude (Y), and 
%the initial time step (h_0), the final time (t_f), and the steady-state 
%time (t_ss), and the displacement error tolerance (Es_x)

%Outputs the Displacement Amplitude (X) 


for ii = 1:length(w_test)
    [t_conv, x_conv, ~, ~, ~, ~] = calculateConvergedSystemResponse(m, k, a, B, c, uN, w_test(ii), Y, h_0, t_f, Es_x);
                                                            %find t and x at converged h for the tested Frequency 
    mask = t_conv >= t_ss;
    x_above = x_conv(mask);                                  %x-values at t index above t_ss
    X(ii) = (max(x_above) - min(x_above))/2;                 % find X and place in vector 
end 
