function FtrArr = getFeatureArr(A, N, varargin)
% Feature Vectors/Matrices stored as matrix or high-dimensional array
% varargin{1}     : T, transformation to apply to features (e.g., Fourier,
%                   wavelet transform)
% varargin{j}     : auxiliary parameters to varargin{1}.
%
% ***
%     N.B. in loD, columns of FtrArr must be set in the order 
%     (k-1)*szA(1) + j and NOT in the order (j-1)*szA(2) +k
%     This is because Matlab column-wise vectorizes matrices --- i.e., 
%     Matlab turns [ 1 2 3 ; 4 5 6 ; 7 8 9 ] into [ 1 4 7 2 5 8 3 6 9 ].'
%     and the code needs to be consistent with that paradigm.
% ***

szA = size(A);
Awide = widen(A, N, 'Neumann'); % Widen A for convolution

if nargin-2 > 0
    T = varargin{1};
    if ~isa(T, 'function_handle')
        % probably trying to select highD or aux param to widen
        warning('auxiliary parameter to widen, high dimensional array return not supported.');
    end
else
    % T is the identity transformation
    T = [];
end
if nargin-2 > 1
    % T requires auxiliary parameters
    for j = 1:nargin-3
        opt{j} = varargin{j+1};
    end
else
    opt = cell(0);
end
    

% 'highD' is vestigial, and would probably now clash with other methods. 
% the size of FtrArr is a dirty hack; change it.
warning('Number of rows of FtrArr has not been made adjustable to suit output size of arbitrary transformations. Transformation output must be same size as input: (2N+1)^2. A future update should take care of this.');
FtrArr = zeros((2*N+1)^2, prod(szA));
szftr = size(FtrArr);

for k = 1:szA(2)
    for j = 1:szA(1)
        tmp = Awide((-N:N)+j+N, (-N:N)+k+N);
        if isa(T, 'function_handle')
            tmp = T(tmp, opt{:});
        end
        FtrArr(:, (k-1)*szA(1) + j) = tmp(:);  % (j-1)*szA(2) + k
    end
end



end