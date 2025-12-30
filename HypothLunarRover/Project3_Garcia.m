%% ME 2016 
%% Task 1 
%% Data calculation
d = linspace(-1,1,10000); %creates d points to later plot
v = linspace(-1,1,10000);
k = 1 ;
c = 0.05;            %Linear damping coefficient N * s/m
m = 0.5 ;            %mass, kg

% linear components
linear_spring = calculateSpringForce(d, k, 0, 0);
linear_damper = calculateDamperForce(v,c, 0);

a = -1;              %Non-linear spring coefficients
B = 5;
uN = 0.05;          %nonlinear damping force, N 

% non linear components
nonl_spring = calculateSpringForce(d, k, a, B) ; 
nonl_damper = calculateDamperForce(v,c, uN) ; 

%% Plotting the Spring Force
% Plots the linear and non-linear spring force versus spring displacement
% for -1 ≤ d ≤ 1

f1 = figure; %spring force 
plot(d, linear_spring)                                          %plot linear spring force
hold on 
plot(d,nonl_spring);                                            %plot non-linear spring force 
grid on; xlabel('Spring Displacement (m)'); ylabel('Spring Force (N/m)');
title('Spring Force vs Spring Displacement'); legend('linear','nonlinear')
hold off

%% Plotting the damper forces
% Plots the linear and non-linear damper force versus damper velocity for
% −1 ≤ v ≤ 1 (m/s)

f2 = figure ;
plot(v,linear_damper)                                            %plots linear damper force
hold on 
plot(d,nonl_damper);                                             %plots non-linear damper force
grid on; xlabel('Damper Velocity (m/s)'); ylabel('Damper Force ((N*s)/m)');
title('Damper Force vs Damper Velocity'); legend('linear','nonlinear')
hold off


%% TASK 2
%% Simulation Model
w = sqrt(2);
h = 1;
t_f = 150;
Y = 0.1;

%nonlinear
[t_nonlinear, x_nonlinear, v_nonlinear, Fx_nonlinear] = calculateSystemResponse(m, k, a, B, c, uN, w, Y, h, t_f);


%linear
[t_linear, x_linear, v_linear, Fx_linear] = calculateSystemResponse(m, k, 0, 0, c, 0, w, Y, h, t_f);

%base function
t_vec=0:h:t_f;
y = Y.*sin(w.*t_vec) ;

%% Plotting the System Response 
% plots linear and nonlinear system response  versus time 

f3 = figure;
plot(t_linear, x_linear,'c','LineWidth',1)                          %plots linear position response
hold on; grid on; title('System Response vs Time')
plot(t_nonlinear, x_nonlinear,'b', 'LineWidth', 1)                  %plots nonlinear position response
plot(t_vec, y, 'r','LineWidth', 1)                                  %plots base motion
legend('x_l_i_n_e_a_r','x_n_o_n_l_i_n_e_a_r','Base y-function'); xlabel('Time (sec)'); ylabel('System Response (m)');

hold off


%% TASK 3 
%% Convergence Testing
h_0 = h;
Es_x = 0.001;
%non linear
[t_conv, x_conv, v_conv, Fx_conv, h_conv, Ea_x_conv] = calculateConvergedSystemResponse(m, k, a, B, c, uN, w, Y, h_0, t_f, Es_x);

%linear
[t_conv_l, x_conv_l, v_conv_l, Fx_conv_l, h_conv_l, Ea_x_conv_l] = calculateConvergedSystemResponse(m, k, 0, 0, c, 0, w, Y, h_0, t_f, Es_x);

%% Plotting Convergence Function
% Plots the linear versus non-linear system displacement errors, 𝐸𝑎_𝑥, versus time step size, ∆𝑡 (h), 
% using the system parameters in Table 1 and the solver settings in Table 3

%figure 
f4 = figure;
 
hold on;
plot([0 h_0], [Es_x Es_x], 'c')                                 %plots a line for the displacement error tolerance
grid on; xlabel('Time Step Size (sec)'); ylabel('System Displacement Errors Ea (m)')
plot(h_conv, Ea_x_conv, 'b')                                    %plots non-linear error with time step size
plot(h_conv_l, Ea_x_conv_l, 'r')                                %plots linear error with time step size
legend('Esx', 'Nonlinear', 'Linear'); title('Displacement Errors (E_a_,_x) vs Time Step')
hold off

%% second figure
% Plots the linear versus non-linear system response versus time using the converged solutions
f5 = figure;
y = Y.*sin(w.*t_vec);                                               %creates a vector of basic position responses

hold on; grid on;
plot(t_conv_l, x_conv_l,'c','LineWidth',1)                          %plots the position response of linear converged solution
title('System Response vs Time (Converged Solutions)')
plot(t_conv, x_conv,'b', 'LineWidth', 1)                            %plots the position response of non-linear converged solution
plot(t_vec, y, 'r','LineWidth', 1)                                  %plots the Base motion
legend('x_l_i_n_e_a_r Converged','x_n_o_n_l_i_n_e_a_r Converged','Base y-function'); xlabel('Time (sec)'); ylabel('System Response (m)');

hold off

%% TASK 4 - Calculate displacement and force amplitudes versus frequency
%% 
h_0_l = h_conv_l(end);    %step size convergence linear

h_0_nl = h_conv(end);     %step size convergence non-linear 
w_i = 0.5;
t_ss = 130;
%% 
% Calculates Displacement Amplitude Analytically
w_min = 0.5;
w_max = 5;
w_test = w_min:0.5:w_max;
X_func = @(w) Y .* ((k.^2 +(c.*w).^2)./((k-m.*(w.^2)).^2 +(c.*w).^2)).^(1/2);
X_analytical = X_func(w_test);

%% 
% Calculates Displacement Amplitude for Linear and Non-Linear
X_linear = calculateDisplacementAmplitude(m, k, 0, 0, c, 0, w_test, Y, h_0_l, t_f, t_ss, Es_x);
X_nonlinear = calculateDisplacementAmplitude(m, k, a, B, c, uN, w_test, Y, h_0_nl, t_f, t_ss, Es_x);

%%
%Plots Displacement amplitude versus frequency for both the linear and non-linear systems, 
% including a line showing the expected displacement amplitude for the linear system 
% from the analytical solution
f6 = figure;
hold on; grid on;
plot(w_test, X_analytical,'c', 'LineWidth', 2)                      %Plots expected displacement
title('Displacement Amplitude vs Frequency') 
plot(w_test, X_linear,'b', 'LineWidth', 1)                          %Plots linear system Disp Ampl
plot(w_test, X_nonlinear, 'r','LineWidth', 1)                       %Plots nonlinear system Disp Ampl
legend('Expected','X_l_i_n_e_a_r','X_n_o_n_l_i_n_e_a_r'); xlabel('Frequency (rad/s)'); ylabel('Displacement Amplitude (m)');

hold off

%%
w_n = (k./m)^(1/2);
%Calculates Force Amplitudes Analytically 
F_func = @(w) (k.*Y) .* (w./w_n).^2 .* ((k.^2 +(c.*w).^2)./((k-m.*(w.^2)).^2 +(c.*w).^2)).^(1/2);
F_analytical = F_func(w_test);

%%
%Calculates Force Amplitudes for linear and Nonlinear
F_linear= calculateForceAmplitude(m, k, 0, 0, c, 0, w_test, Y, h_0_l, t_f, t_ss, Es_x);
F_nonlinear = calculateForceAmplitude(m, k, a, B, c, uN, w_test, Y, h_0_nl, t_f, t_ss, Es_x);


%%
f7 = figure;
hold on; grid on;
plot(w_test, F_analytical,'c', 'LineWidth', 2)                       %Plots expected force amplitude
title('Force Amplitude vs Frequency')
plot(w_test, F_linear,'b', 'LineWidth', 1)                           %Plots linear system Force ampl
plot(w_test, F_nonlinear, 'r','LineWidth', 1)                        %Plots nonlinear system Force ampl
legend('Expected','F_l_i_n_e_a_r','F_n_o_n_l_i_n_e_a_r'); xlabel('Frequency (rad/s)'); ylabel('Force Amplitude (N)');

hold off


%% TASK 5 - Determine damped natural frequency (Extra Credit)
Es_w = 0.01;

%analytical Td
Td = @(w) (((k.^2 +(c.*w).^2)./((k-m.*(w.^2)).^2 +(c.*w).^2)).^(1/2));

w_damp_analytical = GoldenSearch(1.25,1.75,Td, Es_w);              %initial bound guesses from plots
y_vec = 0:0.1:1;
w_damp_vec = ones(1, 11).* w_damp_analytical;                      %create a vector to plot analytcial answer
%% 
%Td = X/Y 
Td_linear = @(w) (calculateDisplacementAmplitude(m, k, 0, 0, c, 0, w, Y, h_0_l, t_f, t_ss, Es_x)./Y);
%%
w_damp_Td_linear = GoldenSearch(1.4,1.6,Td_linear, Es_w);           %initial bound guesses from plots
w_damp_vec_Td_linear = ones(1, 11).* w_damp_Td_linear;
%% 
Td_nonlinear = @(w) (calculateDisplacementAmplitude(m, k, a, B, c, uN, w, Y, h_0_nl, t_f, t_ss, Es_x)./Y);
%% 
w_damp_Td_nl = GoldenSearch(1.4,1.8,Td_nonlinear, Es_w);            %initial bound guesses from plots
w_damp_vec_Td_nonlinear = ones(1, 11).* w_damp_Td_nl;
%%
f8 = figure;
hold on; grid on;
plot(w_test, X_analytical,'c', 'LineWidth', 2)                      %plots frequency vs X analytical
title('Displacement Amplitude vs Frequency')
plot(w_test, X_linear,'b', 'LineWidth', 1)                          %plots frequency vs X linear (found with DisplacementAmplitude Function)
plot(w_test, X_nonlinear, 'r','LineWidth', 1)                       %plots frequency vs X non-linear (found with DisplacementAmplitude Function)
xlabel('Frequency (rad/s)'); ylabel('Displacement Amplitude (m)');
plot(w_damp_vec, y_vec, 'g', 'LineWidth', 2)                        %plots the dampened frequency found analytically
plot(w_damp_vec_Td_linear, y_vec, 'k')                              %plots the dampened frequency found with linear DispAmpl function
plot(w_damp_vec_Td_nonlinear, y_vec, 'm', 'LineWidth', 1.2)         %plots the dampened frequency found with non-linear DispAmpl function
legend('Expected','X_l_i_n_e_a_r','X_n_o_n_l_i_n_e_a_r', 'W dampened for linear analytical', ' W dampened for linear', 'W dampened for nonlinear');
hold off



%% TASK 6 - Determine frequency operating range (Extra Credit)
%% X Bounds
X_max = 0.2;
%analytical looks like it crosses X = 0.2 at 1, then back down at 1.9ish (same for linear)
%nonlinear looks like it passed X = 0.2 at 1.2 ish and then back down at 1.8

%Analytical 
X_below = @(w) ((Y .* ((k.^2 +(c.*w).^2)./((k-m.*(w.^2)).^2 +(c.*w).^2)).^(1/2)) - X_max);
intersect_lowX1 = falsePositionMethodProject(0.9,1.1,X_below,Es_w);        %leaves bounds (seen in graph)
intersect_highX1 = falsePositionMethodProject(1.8,2,X_below,Es_w);          %comes back into bounds (seen in graph

%x analytical in bounds [0.5 1.0019) and (1.7288 5]

%Linear 
X_below_linear = @(w) (calculateDisplacementAmplitude(m, k, 0, 0, c, 0, w, Y, h_0_l, t_f, t_ss, Es_x) - X_max);
intersect_lowX1_linear = falsePositionMethodProject(0.9,1.1,X_below_linear,Es_w);         %leaves bounds (seen in graph)
intersect_highX1_linear = falsePositionMethodProject(1.8,2,X_below_linear,Es_w);          %comes back into bounds (seen in graph

%x linear in bounds [0.5 1.0015) and (1.7290 5]

 
%Non-Linear 
X_below_nonlinear = @(w) (calculateDisplacementAmplitude(m, k, a, B, c, uN, w, Y, h_0_nl, t_f, t_ss, Es_x) - X_max);
intersect_lowX1_nonlinear = falsePositionMethodProject(1.15,1.25,X_below_nonlinear,Es_w);         %leaves bounds (seen in graph)
intersect_highX1_nonlinear = falsePositionMethodProject(1.7,1.9,X_below_nonlinear,Es_w);         %comes back into bounds (seen in graph

%x nonlinear in bound [0.5 1.2288) and (1.6737 5]

%% Td Bounds
Td_max = 2;
%analytical looks like it crosses X = 0.2 at 1, then back down at 1.9ish (same for linear)
%nonlinear looks like it passed X = 0.2 at 1.2 ish and then back down at 1.8

%Analytical 
Td_below = @(w) ( ((k.^2 +(c.*w).^2)./((k-m.*(w.^2)).^2 +(c.*w).^2)).^(1/2) - Td_max);
intersect_lowTd1 = falsePositionMethodProject(0.9,1.1,Td_below,Es_w);        %leaves bounds (seen in graph)
intersect_highTd1 = falsePositionMethodProject(1.8,2,Td_below,Es_w);          %comes back into bounds (seen in graph

%Td analytical in bounds [0.5 1.0019) and (1.7288 5]

%Linear 
Td_below_linear = @(w) ((calculateDisplacementAmplitude(m, k, 0, 0, c, 0, w, Y, h_0_l, t_f, t_ss, Es_x)./Y) - Td_max);
intersect_lowTd1_linear = falsePositionMethodProject(0.9,1.1,Td_below_linear,Es_w);         %leaves bounds (seen in graph)
intersect_highTd1_linear = falsePositionMethodProject(1.8,2,Td_below_linear,Es_w);          %comes back into bounds (seen in graph

%Td linear in bounds [0.5 1.0015) and (1.7290 5]

 
%Non-Linear 
Td_below_nonlinear = @(w) ((calculateDisplacementAmplitude(m, k, a, B, c, uN, w, Y, h_0_nl, t_f, t_ss, Es_x)./Y )- Td_max);
intersect_lowTd1_nonlinear = falsePositionMethodProject(1.15,1.25,Td_below_nonlinear,Es_w);         %leaves bounds (seen in graph)
intersect_highTd1_nonlinear = falsePositionMethodProject(1.7,1.9,Td_below_nonlinear,Es_w);         %comes back into bounds (seen in graph

%Td nonlinear in bound [0.5 1.2288) and (1.6737 5]
%(all Td bounds match X bounds)

%% F Bounds

F_max = 0.4;
%analytical leaves at 1.2 and returns at 1.8 (same for linear)
% nonlinear leaves at 1.4 and returns at 1.6


%analytical F
F_below = @(w) (((k.*Y) .* (w./w_n).^2 .* ((k.^2 +(c.*w).^2)./((k-m.*(w.^2)).^2 +(c.*w).^2)).^(1/2)) - F_max) ;
intersect_lowF1 = falsePositionMethodProject(1.1,1.25,F_below,Es_w);        %leaves bounds (seen in graph)
intersect_highF1 = falsePositionMethodProject(1.7,1.9,F_below,Es_w);          %comes back into bounds (seen in graph

%F analytical claims to be [0.5 to 1.2710) and (1.6257 to 5]
%Start at 0.5 bc its the first frequency we test

%Linear 
F_below_linear = @(w) (calculateForceAmplitude(m, k, 0, 0, c, 0, w, Y, h_0_l, t_f, t_ss, Es_x) - F_max);
intersect_lowF1_linear = falsePositionMethodProject(1.1,1.25,F_below_linear,Es_w);        %leaves bounds (seen in graph)
intersect_highF1_linear = falsePositionMethodProject(1.7,1.9,F_below_linear,Es_w);          %comes back into bounds (seen in graph

%F linear claims to be [0.5 to 1.2716) and (1.6241 to 5]

%Non-linear 
F_below_nonlinear = @(w) (calculateForceAmplitude(m, k, a, B, c, uN, w, Y, h_0_nl, t_f, t_ss, Es_x) - F_max);
intersect_lowF1_nonlinear = falsePositionMethodProject(1.3,1.5,F_below_nonlinear,Es_w);        %leaves bounds (seen in graph)
intersect_highF1_nonlinear = falsePositionMethodProject(1.5,1.7,F_below_nonlinear,Es_w);          %comes back into bounds (seen in graph

%F nonlinear claims to be [0.5 1.3527) and (1.5412 to 5]

%% Tf Bounds
Tf_max = 4;
%analytical leaves at 1.2 and returns at 1.8 (same for linear)
% nonlinear leaves at 1.4 and returns at 1.6


%analytical Tf
Tf_below = @(w) (((w./w_n).^2 .* ((k.^2 +(c.*w).^2)./((k-m.*(w.^2)).^2 +(c.*w).^2)).^(1/2)) - Tf_max) ;
intersect_lowTf1 = falsePositionMethodProject(1.1,1.25,Tf_below,Es_w);        %leaves bounds (seen in graph)
intersect_highTf1 = falsePositionMethodProject(1.7,1.9,Tf_below,Es_w);          %comes back into bounds (seen in graph

%Tf analytical claims to be [0.5 to 1.2711) and (1.6257 to 5]

%Linear 
Tf_below_linear = @(w) ((calculateForceAmplitude(m, k, 0, 0, c, 0, w, Y, h_0_l, t_f, t_ss, Es_x)./(k*Y)) - Tf_max);
intersect_lowTf1_linear = falsePositionMethodProject(1.1,1.25,Tf_below_linear,Es_w);        %leaves bounds (seen in graph)
intersect_highTf1_linear = falsePositionMethodProject(1.7,1.9,Tf_below_linear,Es_w);          %comes back into bounds (seen in graph

%Tf linear claims to be [0.5 to 1.2716) and (1.6241 to 5]

%Non-linear 
Tf_below_nonlinear = @(w) ((calculateForceAmplitude(m, k, a, B, c, uN, w, Y, h_0_nl, t_f, t_ss, Es_x)./(k*Y)) - Tf_max);
intersect_lowTf1_nonlinear = falsePositionMethodProject(1.3,1.5,Tf_below_nonlinear,Es_w);        %leaves bounds (seen in graph)
intersect_highTf1_nonlinear = falsePositionMethodProject(1.5,1.7,Tf_below_nonlinear,Es_w);          %comes back into bounds (seen in graph

%Tf nonlinear claims to be [0.5 1.3527) and (1.5412 to 5]
%(all Tf bounds match F bounds)

%% Plot Displacement Amplitude vs Frequency
%includes damepened frequency and bounds within X_max 

y_vec_int = 0:0.1:1;
lowX1_vec = ones(1, 11).* intersect_lowX1 ;
highX1_vec = ones(1, 11).* intersect_highX1; 

lowX1_linear_vec = ones(1, 11).* intersect_lowX1_linear ;
highX1_linear_vec = ones(1,11) .* intersect_highX1_linear;

lowX1_nonlinear_vec = ones(1,11) .* intersect_lowX1_nonlinear;
highX1_nonlinear_vec = ones(1,11) .* intersect_highX1_nonlinear;

%plot 
f9 = figure;
hold on; grid on;
plot(w_test, X_analytical,'c', 'LineWidth', 2)                      %plots frequency vs X analytical
title('Displacement Amplitude vs Frequency')
plot(w_test, X_linear,'b', 'LineWidth', 1)                          %plots frequency vs X linear (found with DisplacementAmplitude Function)
plot(w_test, X_nonlinear, 'r','LineWidth', 1)                       %plots frequency vs X non-linear (found with DisplacementAmplitude Function)
xlabel('Frequency (rad/s)'); ylabel('Displacement Amplitude (m)');
plot(w_damp_vec, y_vec, 'g', 'LineWidth', 2)                        %plots the dampened frequency found analytically
plot(w_damp_vec_Td_linear, y_vec, 'k')                              %plots the dampened frequency found with linear DispAmpl function
plot(w_damp_vec_Td_nonlinear, y_vec, 'm', 'LineWidth', 1.2)         %plots the dampened frequency found with non-linear DispAmpl function

plot(lowX1_vec,y_vec_int, 'c--', 'LineWidth', 2)                    %plots X_analytical leave bounds 
                                                                    %(different colors to see where it leaves and where returns (in case you don't know what the max is))
plot(highX1_vec, y_vec_int, 'g--', 'LineWidth', 2)                  %plots X analytcial return to bounds

plot(lowX1_linear_vec, y_vec_int, 'b--')                            %plots X linear leave bounds
plot(highX1_linear_vec, y_vec_int, 'b--')                           %plots X linear return to bounds

plot(lowX1_nonlinear_vec, y_vec_int, 'r--', 'LineWidth', 2)         %plots X nonlinear leave bounds
plot(highX1_nonlinear_vec, y_vec_int, 'm--', 'LineWidth', 2)        %plots X nonlinear leave bounds

legend('Expected','X_l_i_n_e_a_r','X_n_o_n_l_i_n_e_a_r', 'W dampened for linear analytical', ' W dampened for linear', ...
    'W dampened for nonlinear', 'Frequency Leaves X Bounds Analytical', 'Frequency Returns to X Bounds Analytical', ...
    'Frequency Leaves X Bounds Linear', 'Frequency Returns to X Bounds Linear','Frequency Leaves X Bounds Nonlinear', 'Frequency Returns to X Bounds Nonlinear');
hold off



%% 
y_vec_int = 0:0.1:1;
lowF1_vec = ones(1, 11).* intersect_lowF1 ;
highF1_vec = ones(1, 11).* intersect_highF1; 

lowF1_linear_vec = ones(1, 11).* intersect_lowF1_linear ;
highF1_linear_vec = ones(1,11) .* intersect_highF1_linear;

lowF1_nonlinear_vec = ones(1,11) .* intersect_lowF1_nonlinear;
highF1_nonlinear_vec = ones(1,11) .* intersect_highF1_nonlinear;

f10 = figure;
hold on; grid on;
plot(w_test, F_analytical,'c', 'LineWidth', 2)                       %Plots expected force amplitude
title('Force Amplitude vs Frequency')
plot(w_test, F_linear,'b', 'LineWidth', 1)                           %Plots linear system Force ampl
plot(w_test, F_nonlinear, 'r','LineWidth', 1)                        %Plots nonlinear system Force ampl
xlabel('Frequency (rad/s)'); ylabel('Force Amplitude (N)');

plot(lowF1_vec,y_vec_int, 'c--', 'LineWidth', 2)                    %plots F_analytical leave bounds 
plot(highF1_vec,y_vec_int, 'g--', 'LineWidth', 2)                   %plots X_analytical return to bounds 
                                                                    %(different colors to see where it leaves and where returns (in case you don't know what the max is))

plot(lowF1_linear_vec, y_vec_int, 'b--')                            %plots F linear leave bounds
plot(highF1_linear_vec, y_vec_int, 'b--')                           %plots f linear return to bounds

plot(lowF1_nonlinear_vec, y_vec_int, 'r--', 'LineWidth', 2)         %plots F linear leave bounds
plot(highF1_nonlinear_vec, y_vec_int, 'm--', 'LineWidth', 2)        %plots f linear return to bounds

legend('Expected','F_l_i_n_e_a_r','F_n_o_n_l_i_n_e_a_r', 'Frequency Leaves F Bounds Analytical', 'Frequency Returns to F Bounds Analytical', ...
    'Frequency Leaves F Bounds Linear', 'Frequency Returns to F Bounds linear', 'Frequency Leaves F Bounds Nonlinear','Frequency Returns to F Bounds Nonlinear');

hold off