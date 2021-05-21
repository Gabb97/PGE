function BS_CallModes(Input)

%% launch modes.exe
if Input.Modes.Location==1
    commandline='cd Routines_Modes & modes Blade_Modes_PA';
else
    commandline='cd Routines_Modes & modes Blade_Modes_RP';
end

system(commandline);

%% Move output file to correct folder
if Input.Modes.Location==1
    SourceFile=('Routines_Modes\Blade_Modes_PA.mod');
else
    SourceFile=('Routines_Modes\Blade_Modes_RP.mod');
end
TargetFile='Output\Blade\Blade_Frequencies.out';
movefile(SourceFile,TargetFile);
