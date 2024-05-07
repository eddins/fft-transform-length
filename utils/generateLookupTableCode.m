%generateLookupTableCode Generate lookup table code for fftTransformLength
%   s = generateLookupTable(P) returns a string containing MATLAB code
%   to initialize a vector containing all the integers in P.
%
%   This function is used to create the code inside fftTransformLength.m.
%   It is not meant to be installed on the MATLAB search path for general
%   use.
%
%   See also fftTransformLength, generateLookupTable

function s = generateLookupTableCode(P)
    s = "[ ..." + newline;

    K = length(P);
    values_per_line = 7;
    first = 1;
    while first <= K
        last = min(first + values_per_line - 1, K);
        s = s + sprintf("%d ",P(first:last)) + " ..." + newline;
        first = first + values_per_line;
    end

    s = s + "];" + newline;
end