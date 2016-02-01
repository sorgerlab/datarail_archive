function [b, flag] = eq(dr2_1, dr2_2)
% [b, flag] = eq(dr2_1, dr2_2)
%   b is true is dimensions, levels and data are equals
%   flag:
%        1 : DR2 objects are of the same type (MDarray vs. long table)
%       10 : matching keys have different levels
%      100 : dimensions are matching
%     1000 : data are matching

%%%% this should be split in multiple small functions

% check that the DR2 objects have the same type
b = dr2_1.Properties.isMDarray==dr2_2.Properties.isMDarray;
if ~b, flag=0; return, end

dr2 = {sort_dims(dr2_1, 1), sort_dims(dr2_2, 1)};
dims = cell(1,2); 
lvls = cell(1,2);
dimIdx = cell(1,2);
data = cell(1,2);
% check the dimensions with multiple levels only and sort them by name
for i=1:2
    [dims{i}, lvls{i}] = dr2{i}.get_dimNames;
    dims{i} = dims{i}(cellfun(@length, lvls{i})>2);
    lvls{i} = lvls{i}(cellfun(@length, lvls{i})>2);
end
% check the number of levels and their names for matching dimensions
[~,i1,i2] = intersect(dims{:});
b = all(cellfun(@(x,y) length(x)==length(y) && all(x==y), lvls{1}(i1), lvls{2}(i2)));
if b, flag=11; else flag=1; return, end

% check the number of dimensions and their names
b = length(dims{1})==length(dims{2}) && all(strcmp(dims{1}, dims{2}));
if b, flag=flag+1e2; end

% check that the data match
if all(dr2_1.data(:)==dr2_2.data(:))
    b = true & b;
    flag = flag+1e3;
else
    b = false;
end
