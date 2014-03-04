function [tbl, kns, vns, aggrs, outer] = process_args__(tokeep, orig)
    function yn = keep(nm)
        yn = ismember(nm, tokeep);
    end

    p = inputParser;
    p.addRequired('tbl');
    DEFAULT = make_sentinel();
    %DEFAULT = [];
    params = {'KeyVars', DEFAULT; ...
              'ValVars', DEFAULT; ...
              'Aggrs',   DEFAULT; ...
              'Outer',   false};

    for kv = params.'
        if keep(kv{1})
            p.addParameter(kv{:});
        end
    end
    function varargout = unpack_ca_(c)
        [varargout{1:nargout}] = c{:};
    end
    defaults = params(:, 2).';
%     [kis, vis, aggrs, outer] = defaults{:};
    [kis, vis, aggrs, outer] = unpack_ca_(defaults);
    clear('defaults');
    p.parse(orig{:});
    args = p.Results;

    tbl = args.tbl;

    if keep('KeyVars')
        default_keyvars = ismember('KeyVars', p.UsingDefaults);
        if default_keyvars
            kis = find(varfun(@iscategorical, tbl, 'OutputFormat', 'uniform'));
            assert(isrow(kis));
        else
            kis = dr.vidxs(tbl, args.KeyVars);
        end
    else
        default_keyvars = true;
        kis = [];
    end

    if keep('ValVars')
        if ismember('ValVars', p.UsingDefaults)
            vis = setdiff(find(arrayfun(@(i) ~iscategorical(tbl.(i)), ...
                                        1:width(tbl))), ...
                          kis, 'stable');
            assert(isrow(vis));
        else
            vis = dr.vidxs(tbl, args.ValVars);
            if ~default_keyvars
                assert(isempty(intersect(vis, kis, 'stable')), ...
                       'non-empty keyvar-valvar intersection');
            end
        end
%     else
%         vis = [];
    end

    if keep('Aggrs')
        assert(keep('ValVars'));
        if ismember('Aggrs', p.UsingDefaults)
            aggrs = @(x) sum(x, 'native');
        else
            aggrs = args.Aggrs;
        end
        nvs = numel(vis);
        if iscell(aggrs)
            assert(numel(aggrs) == nvs, ...
                   'numbers of valvars and aggregators differ');
        end
%     else
%         aggrs = {};
    end

    if keep('Outer')
        outer = args.Outer;
%     else
%         outer = false;
    end

    kns = dr.vns(tbl, kis);
    vns = dr.vns(tbl, vis);
    clear('kis', 'vis');

    % out = {tbl kis vis aggrs outer};
    % varargout = out(1:nargout);

end
