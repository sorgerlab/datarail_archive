function  dr2_out = broadcastArithmetic(dr2, A, flag)

dr2_out = dr2;

dims_dr = size(dr2_out.data);
dims_A = [size(A) ones(1,length(dims_dr)-length(size(A)))];

if any(dims_dr~=dims_A & dims_A~=1)
    ME = MException('DR2:mismatchedDimensions', ...
        ['Dimensions of A should match the ones DR2 object or be =1;' ...
        '\n\tsize(A): ' strjoin(num2cellstr(dims_A),', ') ...
        '\n\tsize(DR2): ' strjoin(num2cellstr(dims_dr),', ')]);
    throw(ME)
end
dims_rep = dims_dr;
dims_rep(dims_A==dims_dr) = 1;

eval(['dr2_out.data = ' flag '(dr2_out.data, repmat(A, dims_rep));']);

dr2_out = dr2_out.addlog([flag ' (dims: ' strjoin(num2cellstr(dims_A), ', ') ')']);
