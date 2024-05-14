%generateLookupTable Generate lookup table for fftTransformLength
%   P = generateLookupTable(N) returns a sort list of nonnegative integers
%   that are less than or equal to N and that have no prime factor larger
%   than 7.
%
%   This function is used to create the code inside fftTransformLength.m.
%   It is not meant to be installed on the MATLAB search path for general
%   use.
%
%   Thanks to Chris Turnes for sharing the concepts underlying this
%   function.
%
%   See also fftTransformLength, generateLookupTableCode

function P = generateLookupTable(N)
    arguments
        N (1,1) double = 2e9
    end

    P = 2.^(0:ceil(log2(N)));
    P = P(:) * 3.^(0:ceil(log(N)/log(3)));
    P = P(:) * 5.^(0:ceil(log(N)/log(5)));
    P = P(:) * 7.^(0:ceil(log(N)/log(7)));

    P = sort(P(:));
    i = find(P >= N, 1, "first");
    P = [0 ; P(1:i)];
end