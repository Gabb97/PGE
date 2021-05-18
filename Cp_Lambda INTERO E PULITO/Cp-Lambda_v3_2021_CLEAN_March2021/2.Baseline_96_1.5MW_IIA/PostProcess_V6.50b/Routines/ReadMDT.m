function MDT = ReadMDT(Parameters, fileName)


%% Get the input components and measurament units.

[unit, forces, displacements, displacements0, displacements1,  ...
    velocities, relativeRotations, relativeDisplacements,  ...
    airstationAeroProperties, airstationAeroAngles,  ...
    airstationLoads, totalAirloads] =  ...
    RequestType(Parameters);


%% Open the MDT file.

% File name of the MDT.
fileNameMDT = [fileName '.mdt'];

% Log.
fprintf('\n>>>>>>>>>>>>>> READING FILE: %s\n', fileNameMDT);

% Open the MDT file.
fidMDT = fopen(fileNameMDT, 'r');

% Check for IO problems.
if fidMDT == -1
    fprintf('\n$$$ ERROR: File [%s] NOT FOUND!!!', fileNameMDT);
    MDT = [];
    return;
end


%% Read the header of the MDT file.

% Should return '****************************'.
fgetl(fidMDT);

% Should return ''.
fgetl(fidMDT);

% Loop over the sensors.
while true
    
    % Read and parse the first line.
    currentLine = regexp(fgetl(fidMDT), ' *(\d+) +(\w+) +(\w+)', 'tokens');
    % If the end of the header part has been reached exit the loop.
    if isempty(currentLine)
        break;
    end
    % Get the sensor name.
    currentSensorName = currentLine{1}{3};
    % Get the sensor ID.
    MDT.(currentSensorName).ID = str2double(currentLine{1}{1});
    
    % Read and parse the second line.
    currentLine = regexp(fgetl(fidMDT), ' *(\w+) +(\w+)', 'tokens');
    % Get the request type.
    MDT.(currentSensorName).Type = currentLine{1}{2};
    
    % Read and parse the third line.
    currentLine = regexp(fgetl(fidMDT), ' *(\w+) +(\w+)', 'tokens');
    % Get the sensor frame.
    MDT.(currentSensorName).Frame = currentLine{1}{2};
    
end  % WHILE: MDT file header.

% Should return '****************************'.
fgetl(fidMDT);

% List of sensors names.
sensorNameList = fieldnames(MDT);

% Number of sensors.
nSensor = length(sensorNameList);


%% Read the measures.

measures = textscan(fidMDT, '%f %f %f %f %f %f', ...
    'CollectOutput',true, 'MultipleDelimsAsOne',true);


%% Close the MDT file.

% Close the MDT file.
status = fclose(fidMDT);

% Check for IO problems.
if status == -1
    warning('ReadMDT:closeMDT', ...
        '>|< Cannot close file: %s\n', fileNameMDT);
end


%% Add the measures to the MDT variable.

% Loop over the sensors.
for iSensor = 1:nSensor
    
    % Get the current sensor name.
    currentSensorName = sensorNameList{iSensor};
    
    % Get the current time history.
    currentTimeHistory = measures{1}(iSensor+1:nSensor+1:end,:);
    
    % Add the information about the units, and convert the measures into
    % the requested units.
    switch MDT.(currentSensorName).Type
        case 'Forces'
            % Add the units.
            MDT.(currentSensorName).Units = forces(2,:);
            % Add the extensions.
            MDT.(currentSensorName).Extensions =  ...
                strcat(currentSensorName, forces(1,:));
            % Convert the measures.
            currentTimeHistory = bsxfun(@times, currentTimeHistory, unit(1,:));
            % Compute the combined measures.
            force12  = hypot(currentTimeHistory(:,1), currentTimeHistory(:,2));
            force23  = hypot(currentTimeHistory(:,2), currentTimeHistory(:,3));
            force31  = hypot(currentTimeHistory(:,3), currentTimeHistory(:,1));
            moment12 = hypot(currentTimeHistory(:,4), currentTimeHistory(:,5));
            moment23 = hypot(currentTimeHistory(:,5), currentTimeHistory(:,6));
            moment31 = hypot(currentTimeHistory(:,6), currentTimeHistory(:,4));
            % Add all the measures.
            MDT.(currentSensorName).TimeHistories =  ...
                [currentTimeHistory force12 force23 force31 moment12 moment23 moment31];
            
        case 'Displacements'
            % Add the units.
            MDT.(currentSensorName).Units = displacements(2,:);
            % Add the extensions.
            MDT.(currentSensorName).Extensions =  ...
                strcat(currentSensorName, displacements(1,:));
            % Convert the measures.
            currentTimeHistory = bsxfun(@times, currentTimeHistory, unit(2,:));
            % Compute the combined measures.
            force12  = hypot(currentTimeHistory(:,1), currentTimeHistory(:,2));
            force23  = hypot(currentTimeHistory(:,2), currentTimeHistory(:,3));
            force31  = hypot(currentTimeHistory(:,3), currentTimeHistory(:,1));
            moment12 = hypot(currentTimeHistory(:,4), currentTimeHistory(:,5));
            moment23 = hypot(currentTimeHistory(:,5), currentTimeHistory(:,6));
            moment31 = hypot(currentTimeHistory(:,6), currentTimeHistory(:,4));
            % Add all the measures.
            MDT.(currentSensorName).TimeHistories =  ...
                [currentTimeHistory force12 force23 force31 moment12 moment23 moment31];
            
        case 'Displacements0'
            % Add the units.
            MDT.(currentSensorName).Units = displacements0(2,:);
            % Add the extensions.
            MDT.(currentSensorName).Extensions =  ...
                strcat(currentSensorName, displacements0(1,:));
            % Convert the measures.
            currentTimeHistory = bsxfun(@times, currentTimeHistory, unit(3,:));
            % Compute the combined measures.
            force12  = hypot(currentTimeHistory(:,1), currentTimeHistory(:,2));
            force23  = hypot(currentTimeHistory(:,2), currentTimeHistory(:,3));
            force31  = hypot(currentTimeHistory(:,3), currentTimeHistory(:,1));
            moment12 = hypot(currentTimeHistory(:,4), currentTimeHistory(:,5));
            moment23 = hypot(currentTimeHistory(:,5), currentTimeHistory(:,6));
            moment31 = hypot(currentTimeHistory(:,6), currentTimeHistory(:,4));
            % Add all the measures.
            MDT.(currentSensorName).TimeHistories =  ...
                [currentTimeHistory force12 force23 force31 moment12 moment23 moment31];
            
        case 'Displacements1'
            % Add the units.
            MDT.(currentSensorName).Units = displacements1(2,:);
            % Add the extensions.
            MDT.(currentSensorName).Extensions =  ...
                strcat(currentSensorName, displacements1(1,:));
            % Convert the measures.
            currentTimeHistory = bsxfun(@times, currentTimeHistory, unit(4,:));
            % Compute the combined measures.
            force12  = hypot(currentTimeHistory(:,1), currentTimeHistory(:,2));
            force23  = hypot(currentTimeHistory(:,2), currentTimeHistory(:,3));
            force31  = hypot(currentTimeHistory(:,3), currentTimeHistory(:,1));
            moment12 = hypot(currentTimeHistory(:,4), currentTimeHistory(:,5));
            moment23 = hypot(currentTimeHistory(:,5), currentTimeHistory(:,6));
            moment31 = hypot(currentTimeHistory(:,6), currentTimeHistory(:,4));
            % Add all the measures.
            MDT.(currentSensorName).TimeHistories =  ...
                [currentTimeHistory force12 force23 force31 moment12 moment23 moment31];
            
        case 'Velocities'
            % Add the units.
            MDT.(currentSensorName).Units = velocities(2,:);
            % Add the extensions.
            MDT.(currentSensorName).Extensions =  ...
                strcat(currentSensorName, velocities(1,:));
            % Convert the measures.
            currentTimeHistory = bsxfun(@times, currentTimeHistory, unit(5,:));
            % Compute the combined measures.
            force12  = hypot(currentTimeHistory(:,1), currentTimeHistory(:,2));
            force23  = hypot(currentTimeHistory(:,2), currentTimeHistory(:,3));
            force31  = hypot(currentTimeHistory(:,3), currentTimeHistory(:,1));
            moment12 = hypot(currentTimeHistory(:,4), currentTimeHistory(:,5));
            moment23 = hypot(currentTimeHistory(:,5), currentTimeHistory(:,6));
            moment31 = hypot(currentTimeHistory(:,6), currentTimeHistory(:,4));
            % Add all the measures.
            MDT.(currentSensorName).TimeHistories =  ...
                [currentTimeHistory force12 force23 force31 moment12 moment23 moment31];
            
        case 'RelativeRotations'
            % Add the units.
            MDT.(currentSensorName).Units = relativeRotations(2,4);
            % Add the extensions.
            MDT.(currentSensorName).Extensions =  ...
                strcat(currentSensorName, relativeRotations(1,4));
            % Convert the measures.
            currentTimeHistory = currentTimeHistory(:,4) * unit(6,4);
            % Add all the measures.
            MDT.(currentSensorName).TimeHistories = currentTimeHistory;
            
        case 'RelativeDisplacements'
            % Add the units.
            MDT.(currentSensorName).Units = relativeDisplacements(2,1);
            % Add the extensions.
            MDT.(currentSensorName).Extensions =  ...
                strcat(currentSensorName, relativeDisplacements(1,1));
            % Convert and add the measures.
            MDT.(currentSensorName).TimeHistories =  ...
                currentTimeHistory(:,1) * unit(7,1);
            
        case 'AirstationAeroProperties'
            % Add the units.
            MDT.(currentSensorName).Units = airstationAeroProperties(2,1:6);
            % Add the extensions.
            MDT.(currentSensorName).Extensions =  ...
                strcat(currentSensorName, airstationAeroProperties(1,1:6));
            % Convert and add the measures.
            MDT.(currentSensorName).TimeHistories =  ...
                bsxfun(@times, currentTimeHistory(:,1:6), unit(8,1:6));
            
        case 'AirstationAeroAngles'
            % Add the units.
            MDT.(currentSensorName).Units = airstationAeroAngles(2,1:5);
            % Add the extensions.
            MDT.(currentSensorName).Extensions =  ...
                strcat(currentSensorName, airstationAeroAngles(1,1:5));
            % Convert and add the measures.
            MDT.(currentSensorName).TimeHistories =  ...
                bsxfun(@times, currentTimeHistory(:,1:5), unit(9,1:5));
            
        case 'AirstationLoads'
            % Add the units.
            MDT.(currentSensorName).Units = airstationLoads(2,:);
            % Add the extensions.
            MDT.(currentSensorName).Extensions =  ...
                strcat(currentSensorName, airstationLoads(1,:));
            % Convert the measures.
            currentTimeHistory = bsxfun(@times, currentTimeHistory, unit(10,:));
            % Compute the combined measures.
            force12  = hypot(currentTimeHistory(:,1), currentTimeHistory(:,2));
            force23  = hypot(currentTimeHistory(:,2), currentTimeHistory(:,3));
            force31  = hypot(currentTimeHistory(:,3), currentTimeHistory(:,1));
            moment12 = hypot(currentTimeHistory(:,4), currentTimeHistory(:,5));
            moment23 = hypot(currentTimeHistory(:,5), currentTimeHistory(:,6));
            moment31 = hypot(currentTimeHistory(:,6), currentTimeHistory(:,4));
            % Add all the measures.
            MDT.(currentSensorName).TimeHistories =  ...
                [currentTimeHistory force12 force23 force31 moment12 moment23 moment31];
            
        case 'TotalAirloads'
            % Add the units.
            MDT.(currentSensorName).Units = totalAirloads(2,:);
            % Add the extensions.
            MDT.(currentSensorName).Extensions =  ...
                strcat(currentSensorName, totalAirloads(1,:));
            % Convert the measures.
            currentTimeHistory = bsxfun(@times, currentTimeHistory, unit(11,:));
            % Compute the combined measures.
            force12  = hypot(currentTimeHistory(:,1), currentTimeHistory(:,2));
            force23  = hypot(currentTimeHistory(:,2), currentTimeHistory(:,3));
            force31  = hypot(currentTimeHistory(:,3), currentTimeHistory(:,1));
            moment12 = hypot(currentTimeHistory(:,4), currentTimeHistory(:,5));
            moment23 = hypot(currentTimeHistory(:,5), currentTimeHistory(:,6));
            moment31 = hypot(currentTimeHistory(:,6), currentTimeHistory(:,4));
            % Add all the measures.
            MDT.(currentSensorName).TimeHistories =  ...
                [currentTimeHistory force12 force23 force31 moment12 moment23 moment31];
            
        otherwise
            % Add the units.
            MDT.(currentSensorName).Units(1,1:12) = {' [...]'};
            % Add the extensions.
            MDT.(currentSensorName).Extensions(1,1:12) =  ...
                strcat(currentSensorName, {' - NONE'});
            % Compute the combined measures.
            force12  = hypot(currentTimeHistory(:,1), currentTimeHistory(:,2));
            force23  = hypot(currentTimeHistory(:,2), currentTimeHistory(:,3));
            force31  = hypot(currentTimeHistory(:,3), currentTimeHistory(:,1));
            moment12 = hypot(currentTimeHistory(:,4), currentTimeHistory(:,5));
            moment23 = hypot(currentTimeHistory(:,5), currentTimeHistory(:,6));
            moment31 = hypot(currentTimeHistory(:,6), currentTimeHistory(:,4));
            % Add all the measures.
            MDT.(currentSensorName).TimeHistories =  ...
                [currentTimeHistory force12 force23 force31 moment12 moment23 moment31];
            % Log.
            fprintf('\nRequestType -%s- of %s NOT FOUND',  ...
                MDT.(currentSensorName).Type, currentSensorName);
            
            
    end  % SWITCH: sensor type.
    
end  % FOR: sensors.

% Add the time.
MDT.Time = measures{1}(1:nSensor+1:end,2);


%% Save the MDT file.

save([fileName '_MDT_new.mat'], 'MDT');



















