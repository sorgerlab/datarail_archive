function tbl = ndarray_to_table(ndarray, labels)

    ndsz = size(ndarray);
    % lbsz = cell2mat(cellmap(@numel_, labels));
    % lbsz = lbsz(1:find(x~=1, 1, 'last'));

    % assert(isequal(ndsz, lbsz));
    vvs = labels{end};
    labels = labels(1:end-1);

    if ischar(vvs)
        vvs = {vvs};
    elseif istable(vvs)
        vvs = vvs{:, :}.';
    else
        vvs = reshape(vvs, 1, []);
    end

    kvs = cellmap(@(t) t.Properties.VariableNames{1}, labels);
    levels = cellmap(@(t) t{:, 1}, labels);
    keys = cartesian_product(levels);

    m = numel(ndarray);
    nd = ndims(ndarray);
    p = nd:-1:1;
    if numel(vvs) > 1
        m = m/ndsz(end);
        p = circshift(p, [0 -1]);
        nd = nd - 1;
    end
    assert(nd == numel(keys));
    values = num2cell(reshape(permute(ndarray, p), m, []), 1);
    data = [keys values];
    tbl = make_table(data, kvs, vvs);
end

% function out = levels_(lbl)
%     out = lbl{:, 1};
%     return;
%     cls = class(out);
%     if iscategorical(out)
%         out = cellstr(out);
%     elseif isnumeric(out)
%         out = num2cell(out);
%     end
% end
  
% function n = numel_(seq)
%     if istable(seq)
%         n = height(seq);
%     else
%         n = numel(seq);
%     end
% end
