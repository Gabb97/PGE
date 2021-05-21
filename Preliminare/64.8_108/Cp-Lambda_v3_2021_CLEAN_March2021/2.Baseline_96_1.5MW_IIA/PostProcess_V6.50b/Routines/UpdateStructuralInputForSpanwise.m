function UpdateStructuralInputForSpanwise(spanwise_loads)

% Send status
disp('Please locate the Strucutral xls input file');

% Ask user to locate structural input file
basic_target_file = ['.\..\..\3.Structure\CrossSectionAnalysis_v1.06\Input\*.xlsx'];

[file, path] = uigetfile(basic_target_file);

target_file = [path '\' file];



% Find which condition (MAX/Min) is more demanding
spanwise_loads.diff = abs(spanwise_loads.min) - abs(spanwise_loads.max);
mean_diff = mean(spanwise_loads.diff);

if mean_diff >=0
    sizing_condition = 'min';
else
    sizing_condition = 'max';
end
    


% Create output structure
dummy_vec       = zeros(length(spanwise_loads.eta),1);
sizing_loads    = spanwise_loads.(sizing_condition)';

data2write      = [spanwise_loads.eta' dummy_vec dummy_vec dummy_vec sizing_loads dummy_vec dummy_vec];


% Update structural Input file
disp('Updating structural input file...')
try
    xlswrite(target_file,data2write,'Loads','A3');
catch
    disp('WARNING:UNable to update the file. Maybe it is open or in use?')
end
disp('Done!')

