function [w_r] = falsePositionMethodProject(w_l, w_u, f, e_s)
% takes in a lower bound and upper bound and calculates at a position based on the formula.
%w_l = lower bound
%w_u = upper bound
%f = function handle
%e_s = error tolerance
%w_r = approximation for frequency right before it goes out of bounds 
e_a = 9999999;
old = 0;
while e_a > e_s 
    f_up = f(w_u);
    f_low = f(w_l);
    guess = w_u - (f_up.*((w_l-w_u)/(f_low-f_up))) ;   %find next point
    test = f(guess);                                         %find function value at guess
    if (test*f_low) > 0 
      w_l = guess;
    else 
        w_u = guess;
    end 
    e_a = abs((guess - old)./guess) .* 100;                     %calculate approx. error
    old = guess;                                            %update old value 
end 
w_r = guess;
end 