% Calculates the L0 matrix using the previously determined G10 and G20
% matrices. This function needs to be checked!

function[L0] = L0(G10,G20,sub_size,depth)

% The algorithm requires that l1 and l2 be the known positive or negative
% roots of the ratio matrices. Every element of l1 and l2 should be
% positive here and a corrective constant will be applied later in the
% algorithm. THIS NEEDS TO BE CHECKED.

ratio1 = zeros(1,1,depth);
ratio2 = zeros(1,1,depth);

for ii = 1:depth
    ratio1(1,1,ii) = G20(1,1,ii)/G10(1,1,ii);
    ratio2(1,1,ii) = G20(2,2,ii)/G10(2,2,ii);
end

l1 = zeros(1,1,depth);
l2 = zeros(1,1,depth);

for ii = 1:depth
    l1(1,1,ii) = sqrt(ratio1(1,1,ii));
    l2(1,1,ii) = sqrt(ratio2(1,1,ii));
end

% Only one of these values needs to be calculated. Both are being
% calculated right now as a method of checking if the coding/data are
% correct.

l12 = zeros(1,2,depth);

for ii = 1:depth
    l12(1,1,ii) = G20(1,2,ii)/G10(1,2,ii);
    l12(1,2,ii) = G20(2,1,ii)/G10(2,1,ii);
end

% Calculates the L0 matrix.

L0 = zeros(sub_size,sub_size,depth);

for ii = 1:depth
    L0(1,1,ii) = l10(1,1,ii);
    L0(2,2,ii) = l12(1,1,ii)/l10(1,1,ii);
end


