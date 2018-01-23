function y = calckl(h, freq)
%CALCKL(H, FREQ) returns e^(-kl)
%   where k is the complex propagation constant and l is the transmission
%   line length.
%
%   See also RFCKT.PARALLELPLATE

%   Copyright 2003-2008 The MathWorks, Inc.

w = 2*pi*freq;             % Convert f to w
width = get(h, 'Width'); % plate width
d = get(h, 'Separation'); % plate separation
c0 = 299792458; % speed of light in vacuum
mu0 = pi*4e-7; % Permeability in vacuum
mu = get(h, 'MuR')*mu0; % mu = Mu0 * MuR
e0 = 1/mu0/c0^2; % Permittivity in vacuum
e = get(h, 'EpsilonR')*e0; % e = Epsilon0 * EpsilonR
sigmacond = get(h, 'SigmaCond');
e_imag = get(h, 'LossTangent')*e;
len = get(h, 'LineLength');     % transmission line length
% Calculate Skin Depth delta
% delta is frequency dependent, hence delta is a vector
delta = 1./sqrt(pi*sigmacond*mu*freq);

% Calculate line parameters L, C, R and G
L = mu*d/width;
C = e*width/d;
G = w*e_imag*width/d;
if ~isinf(sigmacond)
    R = 2./(width*sigmacond*delta);
else
    R = 0;
end

% Convert f to w
z0 = sqrt((R+1j*w*L)./(G+1j*w*C));  % characteristic impedance
k = sqrt((R+1j*w*L).*(G+1j*w*C)); % complex propagation constant

% Set characteristic impedance and phase velocity
set(h, 'Z0', z0)
pv = w./imag(k);
set(h, 'PV', pv)
alphadB = 20*log10(exp(real(k)));
alphadB(alphadB==inf) = 1/eps;
set(h, 'Loss', alphadB)
y = exp(-k*len);