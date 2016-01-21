classdef DR2
    
    properties (Access = public)
        comment = '';
    end
        
    properties(GetAccess = public, SetAccess = private)
        
        % data values
        %--------------
        % the data is stored as a long table or a MD array
        %   currently there is no conversion between formats MH 16/1/20
        
        Properties = struct('isTable', false, ... % data is in table format
            'isMDarray', false, ... % data is in matrix format
            'Dimensions', {{}}, ... % stored as tables of categorical of numeric values
            ... % Dimensions
            ...%   some dimensions can have multiple names sharing the same prefix
            ...%   (like DrugName and DrugName[HMSLid]), but all levels of the
            ...%   paired dimensions will have a one-to-one mapping.
            'Operations', '');
        
        % data stored as a table or multi-dimensional matix
        data = [];
        
        % all levels of all dimensions in a scructure
        %%%%% ideally should be directly accessible from the class but new
        %%%%% properties cannot be assigned dynamically. maybe check what
        %%%%% can be done with dynamicproperty: 
        %%%%% http://www.mathworks.com/help/matlab/ref/meta.dynamicproperty.html
        %%%%% MH 16/1/20
        lvls = struct();
        
    end
    
    
    
    methods
        function obj = DR2(data, keys, varargin)
            % obj = DR2(data, keys, varargin)
            %   constructor
            switch nargin
                case 0
                    return
                case 2
                    obj = constructTwoArgument_(obj, data, keys);
                otherwise
                    error('Expecting two arguments: (table or data), keys')
            end
        end
        
        function obj = sub(obj, varargin)
            % DR2out = DR2in.sub('varname', 'condition', [ ...
            %           'logical', 'varname', 'condition'])
            %   varargin are pairs of keys and conditions (either as
            %   symbolic functions or strings. multiple pairs should be
            %   separated by logical operator ('or', 'and', 'or not',
            %   'and not', 'xor'). Operators are applied from right to left
            %   e.g.:
            %   subDR2(DR2in, ...
            %       'cellline', @(x) ismember(x, {'BT20','MCF10A'}), ...
            %       'and', 'DrugName', '=''Lapatinib''', ...
            %
            assert(mod(nargin,3)==0)
            Variables = varargin(1:3:end);
            Conditions = varargin(2:3:end);
            Operators = cellfun_(@lower, [varargin(3:3:end) {'and'}]);
            
            if obj.Properties.isTable
                % operate on the table
                idx = filterOnTable(obj.data, Variables, Conditions, Operators);
                obj = constructTwoArgument_(obj, obj.data(idx,:), [obj.DimNames{:}]);
                
            elseif obj.Properties.isMDarray
                % operate on the matrix
                idx = filterOnLevels(obj.Properties.Dimensions, Variables, Conditions, Operators);
                newMD = obj.data(idx{:});
                newDimensions = cellfun_(@(x,y) x(y,:), obj.Properties.Dimensions, idx);
                % push the dimensions with only have one level at the end.
                % These are removed from the matrix, but kept in the levels
                obj = constructTwoArgument_(obj, squeeze(newMD), ...
                    newDimensions([find(cellfun(@height,newDimensions)~=1) ...
                    find(cellfun(@height,newDimensions)==1)]));
                
            end
            varstr = cellfun_(@(x) evalc('disp(x)'), varargin);
            varstr = cellfun_(@(x) x(x>32), varstr);
            
            operation = strjoin(varstr,' ');
            obj.comment = [obj.comment sprintf('\nsub: ') operation];
            obj.Properties.Operations = [obj.Properties.Operations ...
                sprintf('\nsub: ') operation];
        end
        
        
        %         function obj = createMDarrayFromTable(obj)
        %
        %             obj.m_data = table_to_ndarray(obj.t_data, 'keyvars', ...
        %                 [cellfun_(@(x) x{1}, obj.DimNames)]);
        %
        %         end
        
        
        function [dimNames, dimLevels] = get_dimNames(obj)
            dims = cellfun_(@varnames, obj.Properties.Dimensions);
            dimNames = cell(length(dims),1);
            dimLevels = dimNames;
            for i=1:length(dims)
                dimNames((1:length(dims{i})) + sum(cellfun(@length, dims(1:(i-1))))) = ...
                    dims{i};
                for j=1:length(dims{i})
                    dimLevels{j + sum(cellfun(@length, dims(1:(i-1))))} = ...
                        obj.Properties.Dimensions{i}.(j);
                end
                
            end
        end
        
        function obj = assignLevels(obj)
            [dimNames, dimLevels] = get_dimNames(obj);
            
            obj.lvls = struct();
            
            % add the dimensions as new fields
            for i=1:length(dimNames)
                obj.lvls.(dimNames{i}) = dimLevels{i};
            end
            
        end
        
    end
    
    methods(Access = private)
        
        function obj = constructTwoArgument_(obj, data, keys)
            
            if istable(data)
                % input is a table and its keys
                
                obj.Properties.Dimensions = ExtractMatchedKeys(data, keys);
                obj.Properties.isTable = true;
                obj.data = data;
                
            elseif isnumeric(data)
                % input is a matrix with the keys and levels as table
                assert(all(cellfun(@istable,keys)))
                % accept some extra dimensions only if they have one level
                assert(all(size(data) == cellfun(@height,keys(1:ndims(data)))))
                assert(all(cellfun(@height,keys((ndims(data)+1):end))==1))
                
                obj.Properties.Dimensions = cellfun_(@TableToCategorical, keys);
                obj.Properties.isMDarray = true;
                obj.data = data;
            else
                error('wrong type of input')
            end
            
            obj = obj.assignLevels;
        end
        
    end
    
end
