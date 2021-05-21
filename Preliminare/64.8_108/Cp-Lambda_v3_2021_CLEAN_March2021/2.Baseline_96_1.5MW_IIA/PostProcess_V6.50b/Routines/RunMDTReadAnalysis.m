function Parameters = RunMDTReadAnalysis(Parameters, iDLC)

%% Check the simulation.

% Base file name.
% -- LS -- 
% I add a strtrim here to get rid of the blank spaces. They might cause
% errors.
fileName = strtrim(Parameters.DLC.Run{iDLC});
% -- end -- 

% File name of the OUT.
fileNameOUT = [fileName '.out'];

% Open the OUT file.
fidOUT = fopen(fileNameOUT, 'r');

% Check for IO problems.
if fidOUT ~= -1  % The OUT file has been found.
    
    % Try to move close to the end of the OUT file.
    fseek(fidOUT, -1024, 'eof');
    
    % Flag that is true if the simulation has been completed.
    simulationOK = false;
    
    % Look for a string.
    while ~feof(fidOUT)
        if strncmp(fgetl(fidOUT), ' *** Simulation is over', 23)
            simulationOK = true;
            break;
        end
    end
    
	% Close the OUT file.
	status = fclose(fidOUT);

	% Check for IO problems.
	if status == -1
		warning('MyRunMDTReadAnalysis:closeOUT', ...
			'>|< Cannot close file: %s\n', fileNameOUT);
	end
		
    % Log.
    if ~simulationOK
        fprintf('\n *** Error on simulation [%s]!', fileNameOUT);
        fprintf('\n *** CHECK THE .OUT FILE');
    end
    
else  % The OUT file has not been found.
    
    % Log.
    fprintf('\n *** WARNING: Unable to find [%s] file!', fileNameOut);
    
end




%% Read the MDT file.

Parameters.MDT{iDLC} = ReadMDT(Parameters, fileName);








