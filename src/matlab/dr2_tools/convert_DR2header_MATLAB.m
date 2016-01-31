function new_header = convert_DR2header_MATLAB(header)
% new_header = convert_DR2header_MATLAB(header)

new_header = header;

% double the left-bracket or equal sign to a double to mark separator
for i=1:numel(new_header)
    % check the headers fits .DR2 format
    assert(sum(new_header{i}=='[')<=1, '--> %s is not a .DR2 header (two [s)',new_header{i})
    assert(sum(new_header{i}==']')<=1, '--> %s is not a .DR2 header (two ]s)',new_header{i})
    assert(sum(new_header{i}=='=')<=1, '--> %s is not a .DR2 header (two =s)',new_header{i})
    
    j = 1; % loop throught the name
    while j <= length(new_header{i})
        if new_header{i}(j) == '['
            new_header{i} = [new_header{i}(1:j) '[' new_header{i}((j+1):end)];
            j = j+2; % skip the repeated [            
        elseif new_header{i}(j) == '='
            new_header{i} = [new_header{i}(1:j) '=' new_header{i}((j+1):end)];
            j = j+2; % skip the repeated =
        else
            j = j+1;
        end
    end
    % remove the second bracket
    new_header{i}(new_header{i} == ']') = []; 
end


% clean the remaining special characters
new_header = cellfun(@MATLABsafename, new_header, 'UniformOutput', false);



% check that there is no duplicate in the new headers
%    ---> needs to be dealt with the special cases
%    ---> only throwing an error for now (MH 15/12/15)
assert(length(unique(new_header(:))) == numel(header))
