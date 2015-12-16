classdef DR2 
    
    properties
        
        % data values
        %--------------
        % by the default the data is stored as a long table
        %       alternative is a MD array
        
        % table is up to date with m_data and Dimensions
        updatedTable = false;
        % MD matrix is up to date with t_data and Dimensions
        % updatedMDarray = false;
        
        % data stored as a table 
        t_data = table();
        % data stored as a multi-dimensional matix
        % m_data = NaN(0);
        
        
        % Dimensions 
        %   some dimensions can have multiple names sharing the same prefix
        %   (like DrugName and DrugName[HMSLid]), but all levels of the
        %   paired dimensions will have a one-to-one mapping.
        DimNames = {};
        DimLevels = {}; % stored as tables of categorical of numeric values
        
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
            Nconditions = nargin/3;
            Variables = varargin(1:3:end);
            Conditions = varargin(2:3:end);
            Operators = [varargin(3:3:end) {'and'}];
            
            % operate on the table type of data
            % starts from the last condition 
            idx = true(height(obj.t_data),1);
            
            for i=Nconditions:-1:1
                % evaluate the conditions
                if ishandle(Conditions{i})
                    idx2 = Conditions{i}(obj.t_data.(Variables{i}));
                else
                    eval(Conditions{i}(3:end))
                    eval(['idx2 = obj.t_data.(Variables{i})' Conditions{i} ';'])
                end
                % applying the conditions
                nIdx = strfind(Operators{i}, 'not');
                if isempty(nIdx)
                    eval(['idx = ' Operators{i} '(idx, idx2);'])
                else
                    eval(['idx = ' Operators{i}(1:nIdx-1) '(not(idx), idx2);'])
                end
                    
            end
            
            obj = constructTwoArgument(obj, obj.t_data(idx,:), [obj.DimNames{:}]);
            
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
                
                [obj.DimNames, obj.DimLevels] = ExtractMatchedKeys(data, keys);
                obj.t_data = data;
                obj.updatedTable = true;
                
            elseif isnumeric(data)
                % input is a matrix with the keys and levels as table
                
                %%%%% need to perform some checks on the consistency of inputs
                %%%%%     ---> matching dimensions
                %%%%%     ---> MH 15/12/15
                obj.DimLevels = keys;
                obj.DimNames = cellfun_(@(x) ExtractKeyPrefix(varnames(x)), ...
                    keys);
                obj.m_data = data;
                obj.updatedMDarray = true;
            else
                error('wrong type of input')
            end
            
        end
        
    end
    
end
