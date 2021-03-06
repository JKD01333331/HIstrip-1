function [ MTL ] = ustripPPMTLABCD( w1, h1, w2, h2, eps1, eps2, f, len)
%calculates multiconductor transmission line ABCD matrix if top-middle line
%is treated as microstrip and middle-bottom (HIS layer) is treated as 
%parallel plate.
%w2 should be width of entire HIS.
mu0 = pi*4e-7;
eps0=8.854e-12;
omega = 2*pi*f;

%see Elek et al., "Dispersion Analysis of the Shielded Sievenpiper 
%Structure Using Multiconductor Transmission-Line Theory" for an
%explanation of what's going on here

[~, C12, L12, ~] = microstrip(w1, h1-h2, eps1); %I'm using microstrip per-unit-length capacitance values here
[Z2, C2G, L2G] = parallelplate(w2, h2, eps2);

cap = [C12, -C12; -C12, C2G+C12]; %Symmetric; see MTL book for where this comes from

[~, C120, ~, ~] = microstrip(w1, h1-h2, 1); 
[~, C2G0, ~, ~] = parallelplate(w2, h2, 1);
cap0 = [C120, -C120; -C120, C2G0+C120]; %symmetric
ind = mu0*eps0*inv(cap0); %symmetric

Z = (j*omega*ind); %symmetric
Y = (j*omega*cap); %symmetric
Gam = sqrtm(Z*Y);

[T,gamsq]=eig(Z*Y); %Z*Y not necessarily symmetric
%get gamma^2 because if you do the eigenvalues of sqrtm(Z*Y) you have a
%root ambiguity

gameig = [sqrt(gamsq(1,1)) 0; 0 sqrt(gamsq(2,2))];

Zw = Gam\Z; %symmetric 
Yw = Y/Gam; %symmetric
% 
MTL = vpa([T*[cosh(gameig(1,1)*len) 0; 0 cosh(gameig(2,2)*len)]/T,...
        (T*sinh(gameig*len)/T)*Zw; Yw*T*sinh(gameig*len)/T, ...
        Yw*T*[cosh(gameig(1,1)*len) 0; 0 cosh(gameig(2,2)*len)]/T*Zw]);
   
% 
% MTL = vpa([T*[cosh(gameig(1,1)*len) 0; 0 cosh(gameig(2,2)*len)]/T,...
%         (T\sinh(gameig*len)*T)*Zw; Yw*T*sinh(gameig*len)/T, ...
%         T\[cosh(gameig(1,1)*len) 0; 0 cosh(gameig(2,2)*len)]*T]);
    %rearranged because: diagonal matrices commute during multiplication
    %even if others don't.
    %and because the current modal-to-terminal conversion matrix is inv(T)
end
