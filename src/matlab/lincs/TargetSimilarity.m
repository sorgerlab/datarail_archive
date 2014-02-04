function TarSim = TargetSimilarity(d1, d2, metric, data)
% TarSim = TargetSimilarity(d1, d2, metric, data)
%   d1, d2 are datasets with a single compound  OR
%       are a list of HMSLids (using 'data' for distances)
%
%   metric is the similarity metric:
%       - Jaccard [default]
%       - JaccardPathway  (default 2nd layer)
%       - JaccardPathway2
%       - JaccardPathway3
%       - weighted
%       - weightedPathway  (default 2nd layer)
%       - weightedPathway2
%       - weightedPathway3
%       - all (--> TarSim is a subset of data, 3D struct)
%
%   data is IC50 [default] or kd, or other structure.
%

global TarSim_IC50 TarSim_Kd
if isempty(TarSim_IC50)
    load('../data/TargetInfo_dataset.mat', 'TarSim_IC50', 'TarSim_Kd');
end

if ~exist('metric', 'var') || isempty(metric)
    metric = 'Jaccard';
elseif strcmp('JaccardPathway',metric)
    metric = 'JaccardPathway2';    
elseif strcmp('weightedPathway',metric)
    metric = 'weightedPathway2';
end

if ischar(d1)
    d1 = {d1};
end

if ~exist('d2','var') || isempty(d2)
    d2=d1;
elseif ischar(d2)
    d2 = {d2};
end

if isa(d1,'dataset') || isa(d2,'dataset')
    assert(length(unique(d1.CompoundNames))==1)
    assert(length(unique(d2.CompoundNames))==1)
    
    TarSim = Generate_TargetSimilarity([d1;d2]);    
    iM = TarSim.metricMap(metric);    
    TarSim = TarSim.Sim(:,:,iM);
    return    
end

if ~exist('data', 'var') || strcmp(data,'IC50');
    TarSim = TarSim_IC50;
elseif strcmp(data,'Kd')
    TarSim = TarSim_Kd;
elseif isstruct(data) && isfield(data,'Sim') && isfield(data,'drugMap')
    TarSim = data;
else
    error('Wrong data input')
end

idx1 = zeros(1,length(d1));
for i=1:length(d1)
    if TarSim.drugMap.isKey(d1{i})
        idx1(i) = TarSim.drugMap(d1{i});
    end
end
idx2 = zeros(1,length(d2));
for i=1:length(d2)
    if TarSim.drugMap.isKey(d2{i})
        idx2(i) = TarSim.drugMap(d2{i});
    end
end

if strcmp(metric,'all')
    Sim = NaN(length(idx1), length(idx2),size(TarSim.Sim,3));
    Sim(idx1~=0, idx2~=0,:) = TarSim.Sim(idx1(idx1~=0),idx2(idx2~=0),:);
    TarSim.Sim = Sim;
    TarSim = rmfield(TarSim,'drugMap');
    TarSim = rmfield(TarSim,'drugs');
    TarSim.d1 = d1;
    TarSim.d2 = d2;
else
Sim = NaN(length(idx1), length(idx2));
    iM = TarSim.metricMap(metric);
    Sim(idx1~=0, idx2~=0) = TarSim.Sim(idx1(idx1~=0),idx2(idx2~=0),iM);
    TarSim = Sim;
end

