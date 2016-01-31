function varargout = unpack_row(row)
    tmp = table2cell(row);
    varargout = tmp(1, 1:min(nargout, size(tmp, 2)));
end
