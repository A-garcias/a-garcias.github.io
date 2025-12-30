function [F_damper]= calculateDamperForce(v, c, uN)
%Takes in damper velocity (v), the damper coefficient (c), and the damper 
%friction force (uN), should return the corresponding damper force,
%F_damper
F_damper = -1*(c.*v + sign(v).*uN);
end 