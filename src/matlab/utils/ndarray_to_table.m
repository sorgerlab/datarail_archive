function tbl = ndarray_to_table(ndarray, labels)

    narginchk(2, 2);

    uo = {'UniformOutput' false};
    ndsz = size(ndarray);
    % lbsz = cell2mat(cellfun(@numel_, labels, uo{:}));
    % lbsz = lbsz(1:find(x~=1, 1, 'last'));

    % assert(isequal(ndsz, lbsz));

    vvs = labels{end};
    if ischar(vvs)
        vvs = {vvs};
    end
    if iscell(vvs)
        vvs = make_label('Value', vvs);
    end
    labels = labels(1:end-1);

    % tbl = cartesian_product_table(cellfun(@levels_, labels, uo{:}), ...
    %                               cellfun(@(t) t.Properties.VariableNames{1}, labels, uo{:}));

    tbl = cartesian_product_table(cellfun(@(t) t{:, 1}, labels, uo{:}), ...
                                  cellfun(@(t) t.Properties.VariableNames{1}, labels, uo{:}));

    m = numel(ndarray);
    p = ndims(ndarray):-1:1;
    if numel(vvs) > 1
        m = m/ndsz(end);
        p = circshift(p, [0 -1]);
    end
    data = reshape(permute(ndarray, p), m, []);
    for i = 1:numel(vvs)
        tbl.(vvs{i, 1}{:}) = data(:, i);
    end

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
