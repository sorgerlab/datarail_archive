function test_TargetFile()
% test_TargetFile()
%   simple function to initialize the target references
%   display warning for multiple row (cls file nee to be corrected)
%

global TargetReference
TargetFile = '../data/Pathway_Jerry_20140102.xlsx';
TargetReference = dataset('xlsfile', TargetFile);

[~,~,idx2] = unique(TargetReference.GENENAME);
n = hist(idx2,1:max(idx2));
disp(' ')
disp(['Dupliates in ' TargetFile])
disp('---------------------------------------')
for i=find(n>1)
    idx = find(idx2==i);
    fprintf('%i duplicates for gene %s :\n', n(i), ...
        TargetReference.GENENAME{idx(1)});
    for j=1:n(i)
        fprintf('\t XLS row: %i\n', idx(j)+1);
    end
    fprintf('\n');
end