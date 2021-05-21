function [Section]=BS_ReadSection(SectionID)


NumberOfElements=12;

% Read section File
FileAddress=strcat('SectionFiles\Sections\Section_Layout_',num2str(SectionID),'.inp');
f=fopen(FileAddress);
    for j=1:4
        fgetl(f);
    end
    % Read radial position and Eta
    Read=textscan(f,'%s %f',2);
    ReadRadialEta=Read{2};
        Section.RadialPos=ReadRadialEta(1);
        Section.Eta=ReadRadialEta(2);
    fgetl(f);
    fgetl(f);
    % Read geometric configuration
    Section.Chord           =   fscanf(f,'%f');         fgetl(f);
    Section.Twist           =   fscanf(f,'%f');         fgetl(f);
    Section.LeadingEdge     =   fscanf(f,'%f ');        fgetl(f);
    Section.TrailingEdge    =   fscanf(f,'%f ');        fgetl(f);
    Section.FrontSpar       =   fscanf(f,'%f ');        fgetl(f);
    Section.RearSpar        =   fscanf(f,'%f ');        fgetl(f);
    Section.LEReinf         =   fscanf(f,'%f ');        fgetl(f);
    Section.TEReinf         =   fscanf(f,'%f ');        fgetl(f);
    Section.ThirdWeb        =   fscanf(f,'%f ');        fgetl(f); % Not supported
    
    % Find spar cap width
    SparWidth=Section.RearSpar-Section.FrontSpar;

    if SparWidth==0
        Section.Type='A';
        % Type-A is a cylinder or transitional section. No spar caps, no
        % LE/TE reinforcements. Allocate a single-item cell.
        Section.Thickness=cell(1,1);
        Section.MaterialsNames=cell(1,1);
    else
        if Section.LEReinf==0 && Section.TEReinf == 0
            % Type-B is a box layout with spar caps but no LE/TE
            % reinforcements.
            Section.Type='B';
        else
            % Type-C is a classical box layout with spar caps and LE/TE
            % reinforcements
            Section.Type='C';
        end
        % allocate a full-item cell
        Section.Thickness       =   cell(NumberOfElements,1);
        Section.MaterialsNames  =   cell(NumberOfElements,1);
    end
    
    for j=1:3
        fgetl(f);
    end
        
    % Scan the properties of the elements    
    for i =1:NumberOfElements
        ReadElement=[];
        for j=1:2
            fgetl(f);
        end
        % Read if the element is present or not
        ElementFlag=fscanf(f,'%c ',4);
        
        if ElementFlag=='None'
            i_NumberOfLayers            =   0;
            Section.Thickness{i}        =   0;
            Section.MaterialsNames{i}   =   'None';
                        
        else           
            fgetl(f);
            % Read Number of layers assigned to the i-th element.
            i_NumberOfLayers            =   fscanf(f,'%d');
            fgetl(f);
            ReadElement                 =   textscan(f,'%s %f',i_NumberOfLayers);
            Section.Thickness{i}        =   ReadElement{2};
            Section.MaterialsNames{i}   =   ReadElement{1};
            fgetl(f);
        end
    end
    % Scan loads
    fgetl(f);
    Section.Loads.Tx=fscanf(f,'%f');fgetl(f);
    Section.Loads.Ty=fscanf(f,'%f');fgetl(f);
    Section.Loads.Tz=fscanf(f,'%f');fgetl(f);
    Section.Loads.Mx=fscanf(f,'%f');fgetl(f);
    Section.Loads.My=fscanf(f,'%f');fgetl(f);
    Section.Loads.Mz=fscanf(f,'%f');fgetl(f);
fclose(f);
        
        
        
        