function d_out = dataset_2Dtolist(data,d_row,d_column)

assert(all(size(data)==[length(d_row) length(d_column)]))

d_allrow = repmat(d_row,length(d_column),1);
cache = ones(length(d_row),1)*[1:length(d_column)];
d_allcolumn = d_column(cache(:),:);

d_out = [d_allrow d_allcolumn dataset(data(:),'VarNames','data')];