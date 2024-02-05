function [xx, yy] = calcPos(kernel, x, y)

homogenous = [x; y; 1];
homogenous = kernel * homogenous;

two_d = [homogenous(1)/homogenous(3) homogenous(2)/homogenous(3)];

xx = round(two_d(1));
yy = round(two_d(2));

end