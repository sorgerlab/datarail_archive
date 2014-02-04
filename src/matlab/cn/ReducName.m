function Redstr = ReducName(str,RemovedCharacters,IsUp)
% Redstr = ReducName(str,RemovedCharacters,IsUp)

if ~exist('RemovedCharacters','var') || isempty(RemovedCharacters);
    RemovedCharacters = ' -_';
end

if ~exist('IsUp','var')
    IsUp = false;
end

if iscell(str)
    for i=1:length(str)
        Redstr{i} = ReducName(str{i},RemovedCharacters,IsUp);
    end
else
    Redstr = str;
    for i=1:length(RemovedCharacters)
        idx = find(Redstr~=RemovedCharacters(i));
        if IsUp
            Redstr = upper(Redstr(idx));
        else
            Redstr = Redstr(idx);
        end
    end
end