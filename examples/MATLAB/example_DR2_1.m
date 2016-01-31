addpath(genpath('../../SRC/MATLAB/'))

%%

t_in = DR2file2table('../../DR2_fixture_files/DrugTreatmentResults.tsv');
dr = DR2(t_in, {'cellline' 'drug' 'SeedingNumber' 'drug__conc__uM'})

