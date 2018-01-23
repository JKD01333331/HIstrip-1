function abcd_params = s2abcd(s_params, z0)
%S2ABCD Convert S-parameters to ABCD-parameters
%   ABCD_PARAMS = S2ABCD(S_PARAMS, Z0) converts the scattering parameters
%   S_PARAMS into the ABCD-parameters ABCD_PARAMS. 
%   
%   S_PARAMS is a complex 2Nx2NxM array of M 2N-port S-parameters. Z0 is
%   the reference impedance, the default is 50 ohms. The output ABCD_PARAMS
%   is a complex 2Nx2NxM array of M 2N-port ABCD-parameters.
%
%   See also ABCD2S, S2Y, S2Z, S2H, Y2ABCD, Z2ABCD, H2ABCD

%   Copyright 2003-2011 The MathWorks, Inc.

narginchk(1,2);

% Check the input S-parameters
[freq, s_params] = CheckNetworkData(s_params, '2N', 'S_PARAMS');

% Check the reference impedance
if nargin < 2
    z0 = 50*ones(1,1,freq);
else
    z0 = CheckZ(z0, freq, 'Z0');
end

% Check the dimension
siz = size(s_params);
m = siz(1)/2; %2N/2 dimension

% Allocate memory for the ABCD-parameters
abcd_params = zeros(siz);

% Choose the optimal math depending on the size of the network parameter
if siz(1) == 2
    % Get the S-parameters
    [s11, s12, s21, s22] = deal(s_params(1,1,:), s_params(1,2,:), ...
        s_params(2,1,:), s_params(2,2,:));
    
    % Calculate the ABCD-parameters
    temp1 = 1 - s11;        temp2 = 1 + s11;
    temp3 = 1 - s22;        temp4 = 1 + s22;
    s12s21 = s12 .* s21;
    
    abcd_params = [temp2 .* temp3 + s12s21, (temp2 .* temp4 - s12s21) .* z0; ...
        (temp1 .* temp3 - s12s21) ./ z0, temp1 .* temp4 + s12s21] ./ ...
        repmat(2 * s21, [2 2 1]);
    
else
    I = eye(m);
    for k = 1:freq
        % Get the S-parameters
        s11 = s_params(1:m,1:m,k);
        s12 = s_params(1:m,(m+1):(2*m),k);
        s21 = s_params((m+1):(2*m),1:m,k);
        s22 = s_params((m+1):(2*m),(m+1):(2*m),k);
        
        A = 0.5*((I+s11)/s21*(I-s22)+s12);
        B = z0(k)*0.5*((I+s11)/s21*(I+s22)-s12);
        C = 0.5/z0(k)*((I-s11)/s21*(I-s22)-s12);
        D = 0.5*((I-s11)/s21*(I+s22)+s12);
        
        % Calculate ABCD-parameters
        abcd_params(:,:,k) = [A , B ; C , D];
    end
end