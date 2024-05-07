classdef fftTransformLength_test < matlab.unittest.TestCase

    methods (Test)
        function alternateMethod(test_case)
            n = [0:20, 1150:1200];
            actual = fftTransformLength(n);
            expected = zeros(size(actual));
            for k = 1:numel(actual)
                expected(k) = alternateTransformLengthMethod(n(k));
            end

            test_case.verifyEqual(actual,expected);
        end

        function elementwiseBehavior(test_case)
            n = reshape(1:24,2,3,4);
            actual = fftTransformLength(n);
            expected = zeros(size(actual),'like',actual);
            for k = 1:numel(actual)
                expected(k) = fftTransformLength(n(k));
            end

            test_case.verifyEqual(actual,expected);
        end

        function emptyBehavior(test_case)
            n = zeros(2,3,0,4);
            actual = fftTransformLength(n);
            expected = zeros(size(actual),'like',actual);
            test_case.verifyEqual(actual,expected);
        end

        function typeBehavior(test_case)
            np = fftTransformLength(single(23));
            test_case.verifyClass(np,"double");

            np2 = fftTransformLength(int32(23));
            test_case.verifyClass(np2,"double");
        end

        function inputTooHigh(test_case)
            test_case.verifyError(...
                @() fftTransformLength(1e10 + 1),...
                "MATLAB:validators:mustBeInRange");
        end

        function integerValidation(test_case)
            test_case.verifyError(...
                @() fftTransformLength(1.5),...
                "MATLAB:validators:mustBeInteger");
        end

        function nonnegativeValidation(test_case)
            test_case.verifyError(...
                @() fftTransformLength(-2),...
                "MATLAB:validators:mustBeInRange");            
        end
    end

end

function np = alternateTransformLengthMethod(n)
    np = n;
    while (max(factor(np)) > 7)
        np = np + 1;
    end
end
