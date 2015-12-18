classdef DR2
    
    properties
        
        % data values
        %--------------
        % by the default the data is stored as a long table
        %       alternative is a MD array
        
        % table is up to date with m_data and Dimensions
        updatedTable = false;
        % MD matrix is up to date with t_data and Dimensions
        updatedMDarray = false;
        
        % data stored as a table
        t_data = table();
        % data stored as a multi-dimensional matix
        m_data = NaN(0);
        
        
        % Dimensions
        %   some dimensions can have multiple names sharing the same prefix
        %   (like DrugName and DrugName[HMSLid]), but all levels of the
        %   paired dimensions will have a one-to-one mapping.
        Dimensions = {}; % stored as tables of categorical of numeric values
        
    end
    
    
    
    methods
        function obj = DR2(data, keys, varargin)
            % obj = DR2(data, keys, varargin)
            switch nargin
                case 0
                    return
                case 2
                    obj = constructTwoArgument(obj, data, keys);
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
            
            if obj.updatedTable
                % operate on the table
                idx = filterOnTable(obj.t_data, Variables, Conditions, Operators);
                obj = constructTwoArgument(obj, obj.t_data(idx,:), [obj.DimNames{:}]);
                
            elseif obj.updatedMDarray
                % operate on the matrix
                idx = filterOnLevels(obj.Dimensions, Variables, Conditions, Operators);
                newMD = obj.m_data(idx{:});
                newDimensions = cellfun_(@(x,y) x(y,:), obj.Dimensions, idx);
                % push the dimensions with only have one level at the end.
                % These are removed from the matrix, but kept in the levels
                obj = constructTwoArgument(obj, squeeze(newMD), ...
                    newDimensions([find(cellfun(@height,newDimensions)~=1) ...
                    find(cellfun(@height,newDimensions)==1)]));
                
            end
            
        end
        
        
        %         function obj = createMDarrayFromTable(obj)
        %
        %             obj.m_data = table_to_ndarray(obj.t_data, 'keyvars', ...
        %                 [cellfun_(@(x) x{1}, obj.DimNames)]);
        %
        %         end
        
    end
    
    
    
    methods(Access = private)
        
        function obj = constructTwoArgument(obj, data, keys)
            
            if istable(data)
                % input is a table and its keys
                
                obj.Dimensions = ExtractMatchedKeys(data, keys);
                obj.t_data = data;
                obj.updatedTable = true;
                
            elseif isnumeric(data)
                % input is a matrix with the keys and levels as table
                assert(all(cellfun(@istable,keys)))
                % accept some extra dimensions only if they have one level
                assert(all(size(data) == cellfun(@height,keys(1:ndims(data)))))
                assert(all(cellfun(@height,keys((ndims(data)+1):end))==1))
                
                obj.Dimensions = cellfun_(@TableToCategorical, keys);
                obj.m_data = data;
                obj.updatedMDarray = true;
            else
                error('wrong type of input')
            end
            
        end
        
        function dimNames = get_dimNames(obj)
            dimNames = cellfun_(@varnames, obj.Dimensions);
        end
    end
    
end
