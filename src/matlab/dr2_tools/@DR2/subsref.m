function [varargout] = subsref(dr2, S)


if strcmp(S(1).type,'.')
    if length(S)==2 && ismember(S(1).subs,methods(DR2))
        % calling an internal method
        varargout = cell(1,nargout(dr2.(S(1).subs)))
        eval(['[varargout{:}]=' S(1).subs '(dr2, S(2).subs{:})'])
    elseif ismember(S(1).subs,[methods(DR2);fields(DR2)])
        % calling an internal field
        eval(['varargout=dr2.' S(1).subs ';'])
        if length(S)>1
            varargout = subsref(s, S(2:end));
        end
    elseif length(S)==1 && ismember(S(1).subs, get_dimNames(dr2))
        % this allows to address the class with its dimensions directly
        % (but doesnt offer autocompletion)
        [vargout, dim] = dr2.get_dimLevels(S(1).subs);
    else
        disp('. case not recognized')
        {S.type}
        {S.subs}
        
    end
    
elseif strcmp(S(1).type,'()')
    if length(S)==1 && iscellstr(S(1).subs)
        varargout = dr2.substr(S(1).subs);
    else
        disp('not implemented in subsref')
        {S.type}
        S.subs{:}
    end
    
else
    disp('not implemented in subsref')
    {S.type}
    {S.subs}
end
