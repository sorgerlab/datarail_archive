function varargout = subsref(dr2, S)

varargout = cell(1,max(1,nargout));

if strcmp(S(1).type,'.')
    if length(S)==2 && ismember(S(1).subs,methods(DR2))
        % calling an internal method        
        [varargout{:}]= dr2.(S(1).subs)(S(2).subs{:});
        
    elseif ismember(S(1).subs,[methods(DR2);fields(DR2)])
        % calling an internal field  
        if length(S)==1      
            [varargout{:}] = dr2.(S(1).subs);
        else
            [varargout{:}] = subsref(dr2.(S(1).subs), S(2:end));
        end
        
    elseif  ismember(S(1).subs, get_dimNames(dr2))
        % this allows to address the class with its dimensions directly
        % (but doesnt offer autocompletion)
        if length(S)==1
            [varargout{:}] = dr2.get_dimLevels(S(1).subs);
        else
            if strcmp(S(2).type, '()')
                [varargout{:}] = dr2.lvls.(S(1).subs)(S(2).subs{:});
            end
        end
    else
        disp('. case not recognized')
        {S.type}
        {S.subs}
        
    end
    
elseif strcmp(S(1).type,'()')
    if length(S)==1 && iscellstr(S(1).subs)
        [varargout{:}] = dr2.substr(S(1).subs);
    elseif length(S)==1 && iscell(S(1).subs) && ...
            all(cellfun(@(x) isnumeric(x) || islogical(x) || (ischar(x) && strcmp(x,':')), S(1).subs))
        colon_idx = find(cellfun(@(x) ischar(x) && strcmp(x,':'), S(1).subs));
        S(1).subs(colon_idx) = cellfun_(@(x) 1:height(x), dr2.Properties.Dimensions(colon_idx));
        [varargout{:}] = dr2.filterDR2matrix(S(1).subs);
    else
        disp('() case not implemented in subsref')
        S
        {S.type}
        S.subs{:}
        
    end
    
else
    disp('not implemented in subsref')
    {S.type}
    {S.subs}
end

