function [tbl, kns, vns, aggrs, outer] = process_args__(tokeep, orig)
    function yn = keep(nm)
        yn = ismember(nm, tokeep);
    end

    p = inputParser;
    p.addRequired('tbl');
    params = {'KeyVars', []; ...
              'ValVars', []; ...
              %'Aggrs',   @(x) sum(x, 'native'); ...
              %'Aggrs',   @(x) x(1); ...
              'Aggrs',   @fail_on_repeats; ...
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
    end

    if keep('ValVars')
        if ismember('ValVars', p.UsingDefaults)
            vis = setdiff(find(arrayfun(@(i) ~iscategorical(tbl.(i)), ...
                                        1:width(tbl))), kis, 'stable');
            assert(isrow(vis));
        else
            vis = dr.vidxs(tbl, args.ValVars);
            if ~default_keyvars
                assert(isempty(intersect(vis, kis, 'stable')), ...
                       'non-empty keyvar-valvar intersection');
            end
        end
    end

    if keep('Aggrs')
        assert(keep('ValVars'));
        aggrs = args.Aggrs;
        if iscell(aggrs)
            % if make it to here: user specified array of aggrs
            assert(numel(aggrs) == numel(vis), ...
                   'numbers of valvars and aggregators differ');
        end
    end

    if keep('Outer')
        outer = args.Outer;
    end

    kns = dr.vns(tbl, kis);
    vns = dr.vns(tbl, vis);
end

function x = fail_on_repeats(x)
    if size(x, 1) ~= 1
        error(['keyvars do not make up a key: ', ...
               'aggregator(s) must be specified']);
    end
end
