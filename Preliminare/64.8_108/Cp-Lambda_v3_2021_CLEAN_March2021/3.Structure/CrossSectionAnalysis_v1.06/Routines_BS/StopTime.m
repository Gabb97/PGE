function StopTime

% Get time
time=toc;

% Get Hours
hours       =   floor(time/3600);
rem_secs    =   ((time/3600)-hours )*3600;

% Get Minutes
minutes     =   floor(rem_secs/60);
rem_secs    =   ((rem_secs/60)-minutes)*60;

% Get Seconds
secs        =   round(rem_secs);

% Display
dispstr =   ['Time elapsed is: ' num2str(hours) ' hours ' num2str(minutes) ' min '  num2str(secs) ' seconds.'];
disp(dispstr);
