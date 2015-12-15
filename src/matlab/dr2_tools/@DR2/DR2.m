classdef DR2 < handle
    
    properties
        
        % internal data
        %--------------
        % by the default the data is stored as a long table
        %       alternative is a MD array
        hasTable = false;
        hasMDarray = false;
        
        % data stored as a table by default
        t_data = table();
        MDdata = NaN(0);
        %
        
        % Dimensions ( name of the dimensions )
        DimNames = {};
        DimLevels = {}; % stored as tables
        
    end
    
    methods
        function obj = DR2(data, keys, varargin)
            switch nargin
                case 2
                    obj = constructTwoArgument(obj, data, keys);
                otherwise
                    error('Expecting two arguments: (table or data), keys')
            end
        end
    end
    
    
    
    methods(Access = private)
        
        function obj = constructTwoArgument(obj, data, keys)
            
            if istable(data)
                % input is a table and its keys
                obj.DimNames = keys;
                keySets = ExtractRelatedKeys(varnames(data), keys);
                obj.DimLevels = cell(size(keySets));
                for i=1:length(keySets)
                    obj.DimLevels{i} = unique(data(:,keySets{i}));
                end
                obj.t_data = data;
                obj.hasTable = true;
            elseif isnumeric(data)
                % input is a matrix with the keys and levels as table
                
                %%%%% need to perform some checks on the consistency of inputs
                %%%%%     ---> matching dimensions
                %%%%%     ---> MH 15/12/15
                obj.DimLevels = keys;
                obj.DimNames = cellfun(@(x) ExtractKeyPrefix(varnames(x)), ...
                    keys, 'uniformoutput', false);
                obj.MDdata = data;
                obj.hasMDdata = true;
            else
                error('wrong type of input')
            end
            
        end
        
    end
    
end
