t_in = DR2file2table('../../../DR2_fixture_files/DrugTreatmentResults.tsv');

%%

dr = DR2(t_in, {'cellline' 'drug' 'SeedingNumber' 'drug__conc__uM'})

%%

subdr = dr.sub(dr.DimNames{1}{1}, '==obj.DimLevels{1}.(1)(1)', ...
    'and', dr.DimNames{2}{1}, '==obj.DimLevels{2}.(1)(1)', ...
    'and', dr.DimNames{3}{1}, '==obj.DimLevels{3}.(1)(1)')
