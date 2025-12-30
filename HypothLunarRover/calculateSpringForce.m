function [F_spring] = calculateSpringForce(d, k, a, B)
%Takes in spring displacement (d), spring constant (k), and the non-linear spring
%coefficients a and B and should return the corresponding spring force,
%F_spring
F_spring = -1*k.*(d+(a.*(d.^B)));
end 