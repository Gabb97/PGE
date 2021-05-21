function [Output]=BS_WriteBladeOutput(Input,RadialPositions,Eta,NumbSec)



%% Scan BECAS Cross-sectional output file.
for i=1:NumbSec
    File=strcat('Output\Sections\Section_',num2str(i),'\Section_',num2str(i),'.out');
    f=fopen(File);
        % Read stiffness (Reference Point)
        while ~feof(f)
            if findstr(fgetl(f),'Stiffness matrix w.r.t. to the cross section reference point')==1
                fgetl(f);
                format long g
                ReadStiffnessRP=cell2mat(textscan(f,'%f %f %f %f %f %f'));
                StiffnessMatrixRP{i}=abs(ReadStiffnessRP);
                FlapBendingStiffnessRP(i)=abs(ReadStiffnessRP(4,4));
                EdgeBendingStiffnessRP(i)=abs(ReadStiffnessRP(5,5));
                TorsionalStiffnessRP(i)=abs(ReadStiffnessRP(6,6));
                FlapShearStiffnessRP(i)=abs(ReadStiffnessRP(1,1));
                EdgeShearStiffnessRP(i)=abs(ReadStiffnessRP(2,2));
                ExtensionalStiffnessRP(i)=abs(ReadStiffnessRP(3,3));
                
                break
            end
        end
        % Read stiffness (Principal Axis)
        while ~feof(f)
            if findstr(fgetl(f),'Stiffness matrix rotated along principle axis:')==1
                ReadStiffnessPA=cell2mat(textscan(f,'%f %f %f %f %f %f'));
                StiffnessMatrixPA{i}=abs(ReadStiffnessPA);
                FlapBendingStiffnessPA(i)=abs(ReadStiffnessPA(4,4));
                EdgeBendingStiffnessPA(i)=abs(ReadStiffnessPA(5,5));
                TorsionalStiffnessPA(i)=abs(ReadStiffnessPA(6,6));
                FlapShearStiffnessPA(i)=abs(ReadStiffnessPA(1,1));
                EdgeShearStiffnessPA(i)=abs(ReadStiffnessPA(2,2));
                ExtensionalStiffnessPA(i)=abs(ReadStiffnessPA(3,3));
                
                break
            end
        end
        frewind(f);
        % Read stiffness (Elastic Center)
        while ~feof(f)
            if findstr(fgetl(f),'Stiffness matrix with respect to the elastic center:')==1
                ReadStiffnessEC=cell2mat(textscan(f,'%f %f %f %f %f %f'));
                StiffnessMatrixEC{i}=abs(ReadStiffnessPA);
                FlapBendingStiffnessEC(i)=abs(ReadStiffnessEC(4,4));
                EdgeBendingStiffnessEC(i)=abs(ReadStiffnessEC(5,5));
                TorsionalStiffnessEC(i)=abs(ReadStiffnessEC(6,6));
                FlapShearStiffnessEC(i)=abs(ReadStiffnessEC(1,1));
                EdgeShearStiffnessEC(i)=abs(ReadStiffnessEC(2,2));
                ExtensionalStiffnessEC(i)=abs(ReadStiffnessEC(3,3));
                
                break
            end
        end
        frewind(f);
        % Read Mass per unit length
        while ~feof(f)
            if findstr(fgetl(f),'Mass per unit length:')==1
                fscanf(f,'%[Mass=]');
                MassUnitLength(i)=abs(fscanf(f,'%f'));
                break
            end
        end
        frewind(f);
         % Read Shear Center
        while ~feof(f)
            if findstr(fgetl(f),'Shear center;')==1
                fscanf(f,'%[ShearX=]');
                ShearCenter(i,1)=-fscanf(f,'%f');
                fscanf(f,'%[ShearY=]');
                ShearCenter(i,2)=fscanf(f,'%f');
                break
            end
        end
        frewind(f);  
         % Read Elastic Center
        while ~feof(f)
            if findstr(fgetl(f),'Elastic center:')==1
                fscanf(f,'%[ElasticX=]');
                ElasticCenter(i,1)=-fscanf(f,'%f');
                fscanf(f,'%[ElasticY=]');
                ElasticCenter(i,2)=fscanf(f,'%f');
                break
            end
        end
        frewind(f);
          % Read Mass Center
        while ~feof(f)
            if findstr(fgetl(f),'Mass center:')==1
                fscanf(f,'%[MassX=]');
                MassCenter(i,1)=-fscanf(f,'%f');
                fscanf(f,'%[MassY=]');
                MassCenter(i,2)=fscanf(f,'%f');
                break
            end
        end
        frewind(f);
         % Read Centroid
        while ~feof(f)
            if findstr(fgetl(f),'Area center:')==1
                fscanf(f,'%[AreaX=]');
                AreaCenter(i,1)=-fscanf(f,'%f');
                fscanf(f,'%[AreaY=]');
                AreaCenter(i,2)=fscanf(f,'%f');
                break
            end
        end
        frewind(f);  
         % Read alpha Principal Axis
        while ~feof(f)
%             if findstr(fgetl(f),'Orientation of principle axis w.r.t. reference center:')==1
            if findstr(fgetl(f),'Orientation of principle axis w.r.t. elastic center:')==1
                % POSITIVE PITCH=NOSE DOWN!!!!)
                fscanf(f,'%[alpha_p=]');
                AlphaPrincipalAxis(i)=-fscanf(f,'%f');
                break
            end
        end
        frewind(f);  
        % Read Moments of inertia
        while ~feof(f)
            if findstr(fgetl(f),'Mass moments of inertia:')==1
                fscanf(f,'%[Ixx=]');
                Ixx(i)=abs(fscanf(f,'%f'));
                fscanf(f,'%[Iyy=]');
                Iyy(i)=abs(fscanf(f,'%f'));
                fscanf(f,'%[Ixy=]');
                Ixy(i)=abs(fscanf(f,'%f'));
                break
            end
        end
        fclose(f);
end

%% Interpolate on all the required coordinates
% Interpolate stiffness (RP)
Output.Blade.FlapBendingStiffnessRP     =   interp1(RadialPositions,FlapBendingStiffnessRP,Input.Blade.RadialPos);
Output.Blade.EdgeBendingStiffnessRP     =   interp1(RadialPositions,EdgeBendingStiffnessRP,Input.Blade.RadialPos);
Output.Blade.TorsionalStiffnessRP       =   interp1(RadialPositions,TorsionalStiffnessRP,Input.Blade.RadialPos);
Output.Blade.FlapShearStiffnessRP       =   interp1(RadialPositions,FlapShearStiffnessRP,Input.Blade.RadialPos);
Output.Blade.EdgeShearStiffnessRP       =   interp1(RadialPositions,EdgeShearStiffnessRP,Input.Blade.RadialPos);
Output.Blade.ExtensionalStiffnessRP     =   interp1(RadialPositions,ExtensionalStiffnessRP,Input.Blade.RadialPos);

% Interpolate stiffness (PA)
Output.Blade.FlapBendingStiffnessPA     =   interp1(RadialPositions,FlapBendingStiffnessPA,Input.Blade.RadialPos);
Output.Blade.EdgeBendingStiffnessPA     =   interp1(RadialPositions,EdgeBendingStiffnessPA,Input.Blade.RadialPos);
Output.Blade.TorsionalStiffnessPA       =   interp1(RadialPositions,TorsionalStiffnessPA,Input.Blade.RadialPos);
Output.Blade.FlapShearStiffnessPA       =   interp1(RadialPositions,FlapShearStiffnessPA,Input.Blade.RadialPos);
Output.Blade.EdgeShearStiffnessPA       =   interp1(RadialPositions,EdgeShearStiffnessPA,Input.Blade.RadialPos);
Output.Blade.ExtensionalStiffnessPA     =   interp1(RadialPositions,ExtensionalStiffnessPA,Input.Blade.RadialPos);

% Interpolate stiffness (EC)
Output.Blade.FlapBendingStiffnessEC     =   interp1(RadialPositions,FlapBendingStiffnessEC,Input.Blade.RadialPos);
Output.Blade.EdgeBendingStiffnessEC     =   interp1(RadialPositions,EdgeBendingStiffnessEC,Input.Blade.RadialPos);
Output.Blade.TorsionalStiffnessEC       =   interp1(RadialPositions,TorsionalStiffnessEC,Input.Blade.RadialPos);
Output.Blade.FlapShearStiffnessEC       =   interp1(RadialPositions,FlapShearStiffnessEC,Input.Blade.RadialPos);
Output.Blade.EdgeShearStiffnessEC       =   interp1(RadialPositions,EdgeShearStiffnessEC,Input.Blade.RadialPos);
Output.Blade.ExtensionalStiffnessEC     =   interp1(RadialPositions,ExtensionalStiffnessEC,Input.Blade.RadialPos);

% Interpolate mass
Output.Blade.MassUnitLength     =   interp1(RadialPositions,MassUnitLength,Input.Blade.RadialPos);
Output.Blade.MassCenterX        =   interp1(RadialPositions,MassCenter(:,1),Input.Blade.RadialPos);
Output.Blade.MassCenterY        =   interp1(RadialPositions,MassCenter(:,2),Input.Blade.RadialPos);
Output.Blade.ElasticCenterX     =   interp1(RadialPositions,ElasticCenter(:,1),Input.Blade.RadialPos);
Output.Blade.ElasticCenterY     =   interp1(RadialPositions,ElasticCenter(:,2),Input.Blade.RadialPos);
Output.Blade.ShearCenterX       =   interp1(RadialPositions,ShearCenter(:,1),Input.Blade.RadialPos);
Output.Blade.ShearCenterY       =   interp1(RadialPositions,ShearCenter(:,2),Input.Blade.RadialPos);
Output.Blade.AreaCenterX        =   interp1(RadialPositions,AreaCenter(:,1),Input.Blade.RadialPos);
Output.Blade.AreaCenterY        =   interp1(RadialPositions,AreaCenter(:,2),Input.Blade.RadialPos);

% Interpolate Inertia
Output.Blade.Inertia_Ixx        =   interp1(RadialPositions,Ixx,Input.Blade.RadialPos);
Output.Blade.Inertia_Iyy        =   interp1(RadialPositions,Iyy,Input.Blade.RadialPos);
Output.Blade.Inertia_Ixy        =   interp1(RadialPositions,Ixy,Input.Blade.RadialPos);

Output.Blade.Inertia_Ipp        =   Output.Blade.Inertia_Ixx + Output.Blade.Inertia_Iyy; 

% Interpolate angle of principal axis
Output.Blade.StructuralTwist=interp1(RadialPositions,AlphaPrincipalAxis,Input.Blade.RadialPos);
% Build cumulate (geometric+structural) twist (Notation: like many authors, we assume that
% POSITIVE PITCH=NOSE DOWN!!!!)
Output.Blade.CumulatedTwist=Input.Blade.Twist+Output.Blade.StructuralTwist;


% Add non-structural mass (if specified in the Settings_Modes.inp)
if Input.Modes.NonStrucOption==1
    
    Output.BladeStrucMass           =   trapz(Input.Blade.RadialPos,Output.Blade.MassUnitLength);
    Output.BladeNSM                 =   trapz(Input.Blade.RadialPos,Input.Blade.NonStrucMass);
    
    Output.Blade.MassUnitLength     =   Output.Blade.MassUnitLength+Input.Blade.NonStrucMass;
    
    % Compute total blade mass
    Output.BladeMass=trapz(Input.Blade.RadialPos,Output.Blade.MassUnitLength);

    % Send output
    disp(' ')
    dispstr = ['Total NSM mass:                       ' num2str(Output.BladeNSM) ' kg.'];
    disp(dispstr)
    dispstr = ['Total blade mass (structural + NSM):  ' num2str(Output.BladeMass) ' kg.'];
    disp(dispstr)
    disp(' ')
   
else
    
    % Compute total blade mass
    Output.BladeMass=trapz(Input.Blade.RadialPos,Output.Blade.MassUnitLength);

    % Send output
    disp(' ')
    dispstr = ['Total blade mass (structural):  ' num2str(Output.BladeMass) ' kg.'];
    disp(dispstr)
    disp(' ')
    
end



%% Output files in the format of Cp-Lambda Preprocessor

if Input.Files4PPP == 1
    
    disp(' ')
    disp('Writing files for Cp-Lambda PreProcessor....')
    
    % Compute MassCenter as % of chord
    Output.Blade.MassCenterX_Perc   = ((abs(Input.Blade.LeadingEdge) + Output.Blade.MassCenterX)./Input.Blade.Chord)*100;
    Output.Blade.AreaCenterX_Perc   = ((abs(Input.Blade.LeadingEdge) + Output.Blade.AreaCenterX)./Input.Blade.Chord)*100;

    Output.Blade.PitchAxis          =  abs(Input.Blade.LeadingEdge./Input.Blade.Chord)*100;
    
    % ==== Hub details ====================================================
    disp(' ')
    disp('Please identify the file hub_details.txt in your drive or close the window to generate the files in the Output folder.');
    disp(' ')
    
    [hub_file,ppp_path,~] = uigetfile('.\..\..\1.PreProcessor_v530_c2018\input\*.txt');
   
   
    % If an address is given, generate the files in the PPP folder,
    % otherwise, generate in 'Output' folder of Rotor_CS
   
    if hub_file == 0
       output_path = 'Output\Blade';
    else
       output_path = ppp_path;
    end
   
    % ==== Hub details ====================================================
    if hub_file ~= 0
        
        % Scan hub_details.txt
        file = [ppp_path  hub_file];
        
        ff = fopen(file, 'r');
        
        iline = 0;
        while ~feof(ff)
            iline = iline +1;
            data{iline} = fgetl(ff);
        end
        
        fclose(ff);
        
        % Find rotor diameter information and update 
        for il = 1: iline
            if ~isempty(findstr(data{il},'Rotor diameter'))
                
                data{il}   = [ '%  Rotor diameter[m] --> Modified by RotorCS on ' datestr(datetime)];
                data{il+1} = ['   ' num2str(Input.RotorRad*2)];
                
            end
        end
        
        % Overwrite file
        ff = fopen(file, 'w');
             for il = 1: iline
                 fprintf(ff,'%s \n',data{il});
             end
        fclose(ff);        
    end
       
    
    % ==== Blade geometry =================================================
    File=[output_path '\blade_geometry.txt' ];
    
    f=fopen(File,'w');
        fprintf(f,'%s \n','%--------------------------------%');
        fprintf(f,'%s \n','%   BLADE GEOMETRY DEFINITION    %');
        fprintf(f,'%s \n','%--------------------------------%');
        fprintf(f,'\n');
        formatH='%-26s %-20s %-20s %-20s %-20s %-20s %-20s \n'; 
        fprintf(f,formatH,'% Distance from root [m]','Chord [m]','Twist [deg]','Thickness [%]','Pitch axis [%]','PreBend [m]','Airfoil');
        
        fprintf(f,'\n');
        fprintf(f,'\n');
        
        formatD='%-10.2f %-15.6f %-15.6f %-15.6e %-15.6f  %-15.6f %d \n' ;
        
        for i=1:length(Input.Blade.RadialPos)
            fprintf(f,formatD,  Input.Blade.DistanceFromRoot(i), Input.Blade.Chord(i),Input.Blade.Twist(i),...
                                Input.Blade.Thickness(i),  Output.Blade.PitchAxis(i),...
                                Input.Blade.Prebend(i), Input.Blade.AirfoilID(i));
        end
        
    fclose(f);    
        
    % ==== Blade stiffness ================================================
    File=[output_path '\blade_stiffness.txt'];
    
    f=fopen(File,'w');
        fprintf(f,'%s \n','%--------------------------------%');
        fprintf(f,'%s \n','%   BLADE STIFFNESS DEFINITION   %');
        fprintf(f,'%s \n','%--------------------------------%');
        fprintf(f,'\n');
        formatH='%-24s %-36s %-45s %-27s %-21s \n'; 
        fprintf(f,formatH,'% Radial Position [m]','Stiffness about Chord Line [Nm2]','Stiffness perpendicular to Chord Line [Nm2]','Torsional rigidity [Nm2]','Neutral axis [%chord]');
        
        fprintf(f,'\n');
        fprintf(f,'\n');
        fprintf(f,'\n');
        
        formatD='%-10.2f %-15.6e %-15.6e %-15.6e %-15.6f  \n' ;
        
        for i=1:length(Input.Blade.RadialPos)
            fprintf(f,formatD,  Input.Blade.DistanceFromRoot(i), Output.Blade.FlapBendingStiffnessRP(i),Output.Blade.EdgeBendingStiffnessRP(i),...
                                Output.Blade.TorsionalStiffnessRP(i),Output.Blade.AreaCenterX_Perc(i));
        end
        
    fclose(f);
          
    
    % ==== Blade mass =====================================================
    File=[output_path '\blade_mass.txt'];
    f=fopen(File,'w');
        f=fopen(File,'w');
        fprintf(f,'%s \n','%--------------------------------%');
        fprintf(f,'%s \n','%      BLADE MASS DEFINITION     %');
        fprintf(f,'%s \n','%--------------------------------%');
        fprintf(f,'\n');
        formatH='%-28s %-28s %-28s %-30s \n'; 
        fprintf(f,formatH,'% Distance from root [m]','Centre of Mass [% chord]','Mass/unit length [kg/m]','Mom. Inertia/unit length [kgm]');
        
        fprintf(f,'\n');
        fprintf(f,'\n');
        fprintf(f,'\n');
        
        formatD='%-10.2f %-15.6f %-15.6f %-15.6f  \n' ;
        
        for i=1:length(Input.Blade.RadialPos)
            fprintf(f,formatD,  Input.Blade.DistanceFromRoot(i),       Output.Blade.MassCenterX_Perc(i),...
                                Output.Blade.MassUnitLength(i), Output.Blade.Inertia_Ipp(i));
        end
        
    fclose(f);
    
     % ==== Point Masses ==================================================
    File=[output_path '\Point_masses.txt'];
    
    f=fopen(File,'w');
        f=fopen(File,'w');
        fprintf(f,'%s \n','%------------------------------%');
        fprintf(f,'%s \n','% Point masses along the blade %');
        fprintf(f,'%s \n','%------------------------------%');
        fprintf(f,'\n');
        fprintf(f,'\n');
        formatH='%-24s %1s %-21s %1s %-11s  \n'; 
        fprintf(f,formatH,'% Distance from root [m]','|','Chordwise Position','|','Mass (kg)');
        
        fprintf(f,'\n');
        
        formatD='%15.4f %10.2f %10.2f  \n' ;
        
        fprintf(f,formatD,  Input.LocationOfMass, 50, 0);
        
    fclose(f);
      
    disp('Done!')
      
else
    % Output files in the native format
    
    %% Write stiffness RP (Reference Point) output 
    File=strcat('Output\Blade\Blade_StiffnessRP.out');
    f=fopen(File,'w');
        formatH='%-10s %-15s %-20s %-20s %-20s %-20s %-20s %-20s \n'; 
        fprintf(f,formatH,'Eta',    'RadialPos [m]',   'Flapwise ',        'Edgewise',         'Flapwise',     'Edgewise',     'Torsional',    'Extensional');
        fprintf(f,formatH,'',       '',                'Bending Stiff.',   'Bending Stiff. ',  'Shear Stiff.', 'Shear Stiff.', 'Stiff.',       'Stiff.');
        fprintf(f,formatH,'[-]',    '[m]',             '[Nm2]',            '[Nm2]',            '[N]',          '[N]',          '[Nm2]',        '[N]');

        fprintf(f,'\n');
        formatD='%-10.6f %-15.4f %-20.5e %-20.5e %-20.5e %-20.5e %-20.5e %-20.5e  \n' ;
        for i=1:length(Input.Blade.RadialPos)
            fprintf(f,formatD,Input.Blade.Eta(i), Input.Blade.RadialPos(i),Output.Blade.FlapBendingStiffnessRP(i),Output.Blade.EdgeBendingStiffnessRP(i),...
                    Output.Blade.FlapShearStiffnessRP(i),Output.Blade.EdgeShearStiffnessRP(i),Output.Blade.TorsionalStiffnessRP(i),Output.Blade.ExtensionalStiffnessRP(i));
        end
    fclose(f);


    %% Write stiffness EC (Elastic Center) output 
    File=strcat('Output\Blade\Blade_StiffnessEC.out');
    f=fopen(File,'w');
        formatH='%-10s %-15s %-20s %-20s %-20s %-20s %-20s %-20s \n'; 
        fprintf(f,formatH,'Eta',    'RadialPos [m]',   'Flapwise ',        'Edgewise',         'Flapwise',     'Edgewise',     'Torsional',    'Extensional');
        fprintf(f,formatH,'',       '',                'Bending Stiff.',   'Bending Stiff. ',  'Shear Stiff.', 'Shear Stiff.', 'Stiff.',       'Stiff.');
        fprintf(f,formatH,'[-]',    '[m]',             '[Nm2]',            '[Nm2]',            '[N]',          '[N]',          '[Nm2]',        '[N]');

        fprintf(f,'\n');
        formatD='%-10.6f %-15.4f %-20.5e %-20.5e %-20.5e %-20.5e %-20.5e %-20.5e  \n' ;
        for i=1:length(Input.Blade.RadialPos)
            fprintf(f,formatD,Input.Blade.Eta(i), Input.Blade.RadialPos(i),Output.Blade.FlapBendingStiffnessEC(i),Output.Blade.EdgeBendingStiffnessEC(i),...
                    Output.Blade.FlapShearStiffnessEC(i),Output.Blade.EdgeShearStiffnessEC(i),Output.Blade.TorsionalStiffnessEC(i),Output.Blade.ExtensionalStiffnessEC(i));
        end
    fclose(f);


    %% Write stiffness PA (Principal Axis) output 
    File=strcat('Output\Blade\Blade_StiffnessPA.out');
    f=fopen(File,'w');
        formatH='%-10s %-15s %-20s %-20s %-20s %-20s %-20s %-20s %-20s \n'; 
        fprintf(f,formatH,'Eta',    'RadialPos [m]', 'Structural',  'Flapwise ',        'Edgewise',         'Flapwise',     'Edgewise',     'Torsional',    'Extensional');
        fprintf(f,formatH,'',       '',              'Twist',       'Bending Stiff.',   'Bending Stiff. ',  'Shear Stiff.', 'Shear Stiff.', 'Stiff.',       'Stiff.');
        fprintf(f,formatH,'[-]',    '[m]',           '[deg]',       '[Nm2]',            '[Nm2]',            '[N]',          '[N]',          '[Nm2]',        '[N]');

        fprintf(f,'\n');
        formatD='%-10.6f %-15.4f %-20.5f %-20.5e %-20.5e %-20.5e %-20.5e %-20.5e %-20.5e  \n' ;
        for i=1:length(Input.Blade.RadialPos)
            fprintf(f,formatD,Input.Blade.Eta(i), Input.Blade.RadialPos(i),Output.Blade.StructuralTwist(i),Output.Blade.FlapBendingStiffnessPA(i),Output.Blade.EdgeBendingStiffnessPA(i),...
                    Output.Blade.FlapShearStiffnessPA(i),Output.Blade.EdgeShearStiffnessPA(i),Output.Blade.TorsionalStiffnessPA(i),Output.Blade.ExtensionalStiffnessPA(i));
        end
    fclose(f);



    %% Write mass output
    File=strcat('Output\Blade\Blade_Mass.out');
    f=fopen(File,'w');
        formatH='%-10s %-15s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s \n'; 
        fprintf(f,formatH,'Eta',    'RadialPos [m]',   'Mass per ',     'Mass',       'Mass',     'Elastic',  'Elastic',   'Shear',     'Shear',     'Area', 'Area');
        fprintf(f,formatH,'',       '',                'unit length',   'Center X ',  'Center Y', 'Center X', 'Center Y',  'Center X',  'Center Y',  'Center X',  'Center Y');
        fprintf(f,formatH,'[-]',    '[m]',             '[Kg/m]',        '[m]',        '[m]',      '[m]',      '[m]',       '[m]',       '[m]',       '[m]',       '[m]');

        fprintf(f,'\n');
        formatD='%-10.6f %-15.4f %-20.5f %-20.5f %-20.5f %-20.5f %-20.5f %-20.5f %-20.5f %-20.5f %-20.5f \n' ;
        for i=1:length(Input.Blade.RadialPos)
            fprintf(f,formatD,Input.Blade.Eta(i), Input.Blade.RadialPos(i),Output.Blade.MassUnitLength(i),Output.Blade.MassCenterX(i),Output.Blade.MassCenterY(i),...
                    Output.Blade.ElasticCenterX(i),Output.Blade.ElasticCenterY(i),Output.Blade.ShearCenterX(i),Output.Blade.ShearCenterY(i),...
                    Output.Blade.AreaCenterX(i),Output.Blade.AreaCenterY(i));
        end
    fclose(f);
end

