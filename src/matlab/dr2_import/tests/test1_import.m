
test_filename = '_test1.tsv';

test_data = [
    {'header1' 'header 2' 'header2[qualificatif]' 'header 2[qual2]=unit' 'header#3'}
    [repmat({'true'},5,1); repmat({'false'},5,1)] ...
    num2cell('A':'J')' ...
    ['a'; repmat({'b';'c';'d'},3,1)] ...
    num2cellstr((1:10)'/7) ...
    strcat('test', num2cellstr(repmat([1;2],5,1)))];
cell2csv(test_filename,test_data,'\t');


t_in = DR2file2table(test_filename);


assert(islogical(t_in.header1))
assert(iscellstr(t_in.header2))
assert(iscategorical(t_in.header2__qualificatif))
assert(isnumeric(t_in.header2__qual2__unit))
assert(iscategorical(t_in.header_3))

