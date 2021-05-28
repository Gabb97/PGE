function BS_ReadSection(SectionID)

% Read section File
FileAddress=strcat('..\SectionFiles\Sections\Section_Layout_',numb2str(SectionID),'.inp');
f=fopen(FileAddress);
    for j=1:5
        fget(f);
    end
    % Read geometric configuration
    Section.Chord=fscanf(f,'%f \n');
    Section.Twist=fscanf(f,'%f \n');
    Section.LeadingEdge=fscanf(f,'%f \n');
    Section.TrailingEdge=fscanf(f,'%f \n');
    Section.FrontSpar=fscanf(f,'%f \n');
    Section.RearSpar=fscanf(f,'%f \n');
    Section.ThirdWeb=fscanf(f,'%f \n'); % Not supported
    % Find spar cap width
    SparWidth=Section.RearSpar
    
