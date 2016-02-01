classdef DR2
    
    properties (Access = public)
        comment = '';
    end
        
    properties(GetAccess = public, SetAccess = private)
        
        % data values
        %--------------
        % the data is stored as a long table or a MD array
        %   currently there is no conversion between formats MH 16/1/20
        
        Properties = struct(...
            'isTable', false, ... % data is in table format
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
         function out = end(obj,k,n)
             e = str2func('end');
             out = e(obj.data,k,n);
         end
         
        function obj = DR2(data, keys, varargin)
            % obj = DR2(data, keys, comment, varargin)
            %   constructor
            switch nargin
                case 0
                    return
                case 2
                    obj = constructTwoArgument_(obj, data, keys);
                case 3
                    obj = constructTwoArgument_(obj, data, keys);
                    obj.comment = varargin{1};
                otherwise
                    error('Expecting two arguments: (table or data), keys')
            end
        end
        
        function sub_obj = subcond(obj, varargin)
            % DR2out = DR2in.subcond('varname', 'condition', [ ...
            %           'logical', 'varname', 'condition'])
            %   varargin are pairs of keys and conditions (either as
            %   symbolic functions or strings. multiple pairs should be
            %   separated by logical operator ('or', 'and', 'or not',
            %   'and not', 'xor'). Operators are applied from right to left
            %   e.g.:
            %   > DR2in.subcond( ...
            %       'cellline', @(x) ismember(x, {'BT20','MCF10A'}), ...
            %       'and', 'DrugName', '=''Lapatinib''', ...
            %
            assert(mod(nargin,3)==0)
            DimNames = varargin(1:3:end);
            Conditions = varargin(2:3:end);
            Operators = cellfun_(@lower, [varargin(3:3:end) {'and'}]);
            obj.checkDimNames(DimNames);
            
            sub_obj = obj.filterDR2(DimNames, Conditions, Operators);
            
            varstr = cellfun_(@(x) evalc('disp(x)'), varargin);
            varstr = cellfun_(@(x) x(x>32), varstr);
            sub_obj = sub_obj.addlog(['subcond: ' strjoin(varstr,' ')]);
        end
        
        
        function sub_obj = substr(obj, varargin)
            % DR2out = DR2in.substr('logical string')
            %   string is a list of conditions applied on the DR2 object
            %   (refered as 'x') and separated by logical operator ('or',
            %   'and'). The 'or' can only be used only on keys of the same
            %   dimension and will be evaluated first. [-- Multiple string
            %   will be applied indivdually and then merged
            %       still to implement -- MH 16/1/21]
            %   Examples:
            %   > DR2in.subDR2( ...
            %       'ismember(x.cellline, {''BT20'',''MCF10A''}) & x.Time==24')
            %   > DR2in.subDR2( ...
            %       'ismember(x.cellline, {''BT20'',''MCF10A''}) & x.Time==24')
            %
            
            if any(ismember('|~', [varargin{1}{:}]))
                ME = MException('DR2:notSupported', 'only & operator is supported');
                throw(ME)
            end
                
            Conditions = regexp([varargin{:}], '&', 'split');Conditions = Conditions{1};
            
            % DimNames = cellfun_(@(x) regexp(x, 'x.([_\w]*)', 'tokens'), modules)
            DimNames = cell(1,length(Conditions));
            LogicalIdx = cell(1,length(Conditions));
            dr2_DimNames = get_dimNames(obj);
            for i=1:length(Conditions)                
                DimName = dr2_DimNames(~cellfun(@isempty, ...
                    cellfun_(@(x) strfind(Conditions{i},x), dr2_DimNames)));
                if isempty(DimName)
                    ME = MException('DR2:badCondition', ...
                        'unknown dimension for condition: %s', Conditions{i});
                    throw(ME)
                elseif length(DimName)>1 || length(strfind(Conditions{i}, DimName{1}))~=1
                    ME = MException('DR2:badCondition', ...
                        'ambiguous condition: %s', Conditions{i});
                    throw(ME)
                end
                DimNames(i) = DimName;
                try
                    LogicalIdx{i} = eval(regexprep(Conditions{i}, DimName{1}, ...
                        ['obj.get_dimLevels(''' DimName{1} ''')']));
                catch                    
                    ME = MException('DR2:badCondition', ...
                        'error for condition: %s', Conditions{i});
                    throw(ME)
                end
            end            
            Operators = repmat({'and'}, 1, length(DimNames));            
            
            sub_obj = obj.filterDR2(DimNames, LogicalIdx, Operators);            
            sub_obj = sub_obj.addlog(['substr: ' strjoin(varargin{:}, ' & ')]);
        end
        
        %         function obj = createMDarrayFromTable(obj)
        %
        %             obj.m_data = table_to_ndarray(obj.t_data, 'keyvars', ...
        %                 [cellfun_(@(x) x{1}, obj.DimNames)]);
        %
        %         end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% functions meant to be private on the long term
        
        function [dimNames, dimLevels, dimIdx] = get_dimNames(obj)
            dims = cellfun_(@varnames, obj.Properties.Dimensions);
            dimNames = cell(length(dims),1);
            dimLevels = dimNames;
            dimIdx = cellfun_(@(x,y) y*ones(1,width(x)), obj.Properties.Dimensions, ...
                num2cell(1:length(obj.Properties.Dimensions)));
            dimIdx = [dimIdx{:}];
            for i=1:length(dims)
                dimNames((1:length(dims{i})) + sum(cellfun(@length, dims(1:(i-1))))) = ...
                    dims{i};
                for j=1:length(dims{i})
                    dimLevels{j + sum(cellfun(@length, dims(1:(i-1))))} = ...
                        obj.Properties.Dimensions{i}.(j);
                end                
            end
        end
        
        function [dimLevels, dimIdx] = get_dimLevels(obj, DimName)
            dims = cellfun_(@varnames, obj.Properties.Dimensions);
            dimIdx = find(cellfun(@(x) ismember(DimName, x), dims));
            dimLevels = obj.lvls.(DimName);
        end
        
        
        function obj = constructTwoArgument_(obj, data, keys)
            
            if istable(data)
                % input is a table and its keys
                
                obj.Properties.Dimensions = ExtractMatchedKeys(data, keys);
                obj.Properties.isTable = true;
                obj.data = data;
                
            elseif isnumeric(data)
                % input is a matrix with the keys and levels as table
                if ~all(cellfun(@istable,keys))
                    ME = MException('DR2:contructorkeys','keys must be a cell of tables');
                    throw(ME)
                end
                % accept some extra dimensions only if they have one level
                if ~all(size(data) == cellfun(@height,keys(1:ndims(data))))
                    ME = MException('DR2:contructorkeys',...
                        'keys must have as many tables as number of dimensions of data');
                    throw(ME)
                end
                if ~all(cellfun(@height,keys((ndims(data)+1):end))==1)
                    ME = MException('DR2:contructorkeys',...
                        'extra tables (more than data dimensions) must have height=1');
                    throw(ME)
                end
                
                % push the dimensions with only have one level at the end.
                % These are removed from the matrix, but kept in the levels
                data = squeeze(data);
                keys = keys([find(cellfun(@height,keys)~=1) find(cellfun(@height,keys)==1)]);
                
                obj.Properties.Dimensions = cellfun_(@TableToCategorical, keys);
                obj.Properties.isMDarray = true;
                obj.data = data;
            else
                error('wrong type of input')
            end
            
            obj = obj.assignLevels;
        end
    end
    
    methods(Access = private)
        
        
        function obj = assignLevels(obj)
            [dimNames, dimLevels] = get_dimNames(obj);            
            obj.lvls = struct();
            
            % add the dimensions as new fields
            for i=1:length(dimNames)
                obj.lvls.(dimNames{i}) = dimLevels{i};
            end
            
        end
        
        
        function obj = copylog(obj, dr2_in)
            obj.comment = dr2_in.comment;
            obj.Properties.Operations = dr2_in.Properties.Operations;
        end
        
        function obj = addlog(obj, str)
            if isempty(obj.comment)
                obj.comment = [obj.comment sprintf(' -') str];
            else
                obj.comment = [obj.comment sprintf('\n -') str];
            end
            if isempty(obj.Properties.Operations)
                obj.Properties.Operations = [obj.Properties.Operations ...
                    sprintf(' ') str];
            else
                obj.Properties.Operations = [obj.Properties.Operations ...
                    sprintf('\n ') str];
            end
        end
        
        
        function checkDimNames(obj, DimNames)
            idx = ismember(DimNames, get_dimNames(obj));
            if any(~idx)
                ME = MException('DR2:noSuchDimension', '%s is/are not dimension', ...
                    strjoin( strcat('''', DimNames(~idx), ''''), ', '));
                throw(ME)
            end
        end
    end
    
end
