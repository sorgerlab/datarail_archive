function out = normalize_vars_arg_(arg)
    if isstr_(arg)
        arg = strsplit(arg);
    elseif iscolumn(arg)
        arg = reshape(arg, 1, []);
    else
        assert(isrow(arg), 'second argument is not 1-dimensional');
    end
end
