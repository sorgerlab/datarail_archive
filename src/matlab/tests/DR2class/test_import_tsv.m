
t_in = DR2file2table('../../../DR2_fixture_files/DrugCoTreatmentResults.tsv');

%%

dr = DR2(t_in, {'cellline' 'drug1' 'drug2' 'drug1__conc__uM' ...
    'drug2__conc__uM' 'treatmentfile__DesignNumber'})


%%
