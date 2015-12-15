p = fileparts(mfilename('fullpath'));
folders = setdiff(regexp(genpath(p),';','split')','');
folders = folders(cellfun(@isempty,strfind(folders,'tests')));
addpath(strjoin(folders,';'));
