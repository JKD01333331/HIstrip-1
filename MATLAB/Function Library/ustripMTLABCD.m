function [ MTL ] = ustripMTLABCD( w1, h1, w2, h2, eps1, eps2, f, len)

mu0 = pi*4e-7;
eps0=8.854e-12;
omega = 2*pi*f;

%see Elek et al., "Dispersion Analysis of the Shielded Sievenpiper 
%Structure Using Multiconductor Transmission-Line Theory" for an
%explanation of what's going on here

[~, C12, L12, ~] = microstrip(w1, h1-h2, eps1); %I'm using microstrip per-unit-length capacitance values here
[Z2, C2G, L2G, epseff2] = microstrip(w2, h2, eps2);
% HFSS model results
C12=28e-12;
C2G=430e-12;

C12=29e-12*sf;
C2G=117e-12*sf;

cap = [C12, -C12; -C12, C2G+C12]; %Symmetric; see MTL book for where this comes from
% HFSS model results

[~, C120, ~, ~] = microstrip(w1, h1-h2, 1); 
[~, C2G0, ~, ~] = microstrip(w2, h2, 1);

C120=29e-12*sf;
C2G0=75e-12*sf;

cap0 = [C120, -C120; -C120, C2G0+C120]; %symmetric

%alternative option for calculating PUL capacitance - also not so hot
%really
% cap = SellbergMTLC([0 h1-h2; h1-h2 0],[h1 h2],[w1 w2],[0.0001 0.0001],[1 2],[eps1 eps2]);
% cap0=SellbergMTLC([0 h1-h2; h1-h2 0],[h1 h2],[w1 w2],[0.0001 0.0001],[1 2],[1 1]);


MTL = nbynMTL(cap, cap0, f, len);

end
