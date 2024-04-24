%fftTransformLength Optimized length for computing FFT
%   np = fftTransformLength(n) returns a padded transform length that is
%   optimized for efficient FFT computation.  Given a nonnegative integer,
%   n, the output is the smallest integer greater than or equal to n whose
%   maximum prime factor is 7.  This choice is based on the standard
%   form of the FFTW library, which computes FFTs most efficiently on
%   lengths whose prime factors are 2, 3, 5, and 7.
%
%   If n is an array, then fftTransformLength operates element-wise,
%   and np is the same size as n.
%
%   fftTransformLength is useful for choosing the padded transform length
%   in situations where an FFT is zero-padded using syntaxes such as
%   fft(x,n), fft2(x,m,n), and fftn(x,sz).
%
%   EXAMPLE
%
%     Compute a two-dimensional convolution using FFTs.
%
%       M = 1170;
%       A = rand(M,M);
%       N = 101;
%       B = rand(N,N);
%
%       K = M + N - 1;               % convolution length
%       Kp = fftTransformLength(K);  % zero-padded transform length
%
%       Cp = ifft2(fft2(A,Kp,Kp) .* fft2(B,Kp,Kp));
%       C = Cp(1:K,1:K);
%
%   Reference: FFTW 3.3.10 Introduction
%   (http://www.fftw.org/fftw3_doc/Introduction.html#Introduction)
%
%   See also FFT, IFFT, FFT2, IFFT2, FFTN, IFFTN

function np = fftTransformLength(n)
    arguments
        n {mustBeInteger, mustBeNonnegative}
    end

    np = zeros(size(n),'like',n);
    for k = 1:numel(n)
        np(k) = padsize(n(k));
    end
end

function np = padsize(n)
    if isfloat(n) && (n > flintmax(class(n)))
        error("fftTransformLength:tooHigh",...
            "Input is greater than FLINTMAX.")
    end

    np = n;

    while true
        % Divide n evenly, as many times as possible, by the factors 2, 3,
        % 5, and 7.
        r = np;
        for p = [2 3 5 7]
            while (r > 1) && (mod(r, p) == 0)
                r = r / p;
            end
        end

        % If the result after the above divisions is 1, then we have found
        % the desired number, so break out of the loop.
        %
        % The result can also be 0, if the input was 0. In that case, also
        % break out of the loop, returning 0.
        if r <= 1
            break;
        else
            % np has one or more prime factors greater than 7, so try the
            % next integer.
            tmp = np + 1;
            if (tmp == np)
                error("fftTransformLength:overflow",...
                    "Integer value too high for the data type.")
            end
            np = tmp;
        end
    end
end