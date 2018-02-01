function [ MTL ] = ustripMTLABCD( w1, h1, w2, h2, eps1, eps2, f, len)

mu0 = pi*4e-7;
eps0=8.854e-12;
omega = 2*pi*f;

%see Elek et al., "Dispersion Analysis of the Shielded Sievenpiper 
%Structure Using Multiconductor Transmission-Line Theory" for an
%explanation of what's going on here

[~, C12, L12, ~] = microstrip(w1, h1-h2, eps1); %I'm using microstrip per-unit-length capacitance values here
[Z2, C2G, L2G, epseff2] = microstrip(w2, h2, eps2);

cap = [C12, -C12; -C12, C2G+C12]; %Symmetric; see MTL book for where this comes from

[~, C120, ~, ~] = microstrip(w1, h1-h2, 1); 
[~, C2G0, ~, ~] = microstrip(w2, h2, 1);
cap0 = [C120, -C120; -C120, C2G0+C120]; %symmetric

%alternative option for calculating PUL capacitance - also not so hot
%really
% cap = SellbergMTLC([0 h1-h2; h1-h2 0],[h1 h2],[w1 w2],[0.0001 0.0001],[1 2],[eps1 eps2]);
% cap0=SellbergMTLC([0 h1-h2; h1-h2 0],[h1 h2],[w1 w2],[0.0001 0.0001],[1 2],[1 1]);

ind = mu0*eps0*inv(cap0); %symmetric

Z = (j*omega*ind); %symmetric
Y = (j*omega*cap); %symmetric
Gam = sqrtm(Z*Y);

[T,gamsq]=eig(Z*Y); %Z*Y not necessarily symmetric
%get gamma^2 because if you do the eigenvalues of sqrtm(Z*Y) you have a
%root ambiguity

gameig = sqrt(diag(gamsq));

Zw = Gam\Z; %symmetric 
Yw = Y/Gam; %symmetric

MTL = [T*diag(cosh(gameig*len))/T, (T*diag(sinh(gameig*len))/T)*Zw; 
        Yw*T*diag(sinh(gameig*len))/T, Yw*T*diag(cosh(gameig*len))/T*Zw];

end
