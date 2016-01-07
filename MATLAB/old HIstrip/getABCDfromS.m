function [ABCD] = getABCDfromS(S,Z0)
A = ((1+S(1,1))*(1-S(2,2))+S(1,2)*S(2,1))/(2*S(2,1));
B = Z0*((1+S(1,1))*(1+S(2,2))-S(1,2)*S(2,1))/(2*S(2,1));
C = ((1-S(1,1))*(1-S(2,2))-S(1,2)*S(2,1))/(2*S(2,1)*Z0);
D = ((1-S(1,1))*(1+S(2,2))+S(1,2)*S(2,1))/(2*S(2,1));

ABCD = [A B; C D];

end