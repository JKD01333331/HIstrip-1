%uses a dipole or probe fed relationship to enforce boundary conditions on
%input relationships 

%create function that automatically uses these relationships 
%Probe fed
v1a = vin;
v1b = vin;
v2a = v2b;
i1a + iin = i1b;
i2a = i2b; 

%Dipole/differential fed
v1a = v1b + vin;
v2a = v2b; 
i1a = iin;
i1b = iin; 
i2a = i2b; 