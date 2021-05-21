function BS_WriteModesInputFile(Input,Output)

% This function prepares two input file for MOdes. The first is expressed
% w.r.t the reference point (usually, the pitch axis) and the twsit is
% reported. The second is exprespressd w.r.t the principal axis and, in
% this case, the structural twist is reported

format='%-8.4f %-8.4f %-15.12e %-15.12e %-15.12e \n  ';


if Input.Modes.Location==2
    %% Refine RP data
    NumbDisc=60;
    RefinedEtaRP=linspace(0,1,NumbDisc);
    RefinedTwistRP=interp1(Input.Blade.Eta,Input.Blade.Twist,RefinedEtaRP);
    RefinedMassRP=interp1(Input.Blade.Eta,Output.Blade.MassUnitLength,RefinedEtaRP);
    RefinedFlapRP=interp1(Input.Blade.Eta,Output.Blade.FlapBendingStiffnessRP,RefinedEtaRP);
    RefinedEdgeRP=interp1(Input.Blade.Eta,Output.Blade.EdgeBendingStiffnessRP,RefinedEtaRP);

    %% Write refined (Reference Point) Modes file
    File=strcat('Routines_Modes\Blade_Modes_RP.inp');
    f=fopen(File,'w');
        fprintf(f,'%-15s %s \n','True','True = Blade, False = Tower');
        if Input.Modes.RotationalOption==1
            fprintf(f,'%-15.2f %s \n',Input.Modes.Omega,'Steady state angular velocity of rotor (rpm) ');
        else
            fprintf(f,'%-15s %s \n','0.0','Steady state angular velocity of rotor (rpm) ');
        end
        fprintf(f,'%-15.2f %s \n',Input.Modes.Beta,'Pitch angle for blades (degrees)');
        fprintf(f,'%-16.12e %s \n',Input.RotorRad,'Total beam length (m)');
        fprintf(f,'%-15.3f %s \n',Input.HubRad,'Rigid beam length (m)');
        fprintf(f,'%-15s %s \n','0.0','End mass (kg)');
        fprintf(f,'%-15s %s \n','5','Number of modes shapes or coefficients');
        fprintf(f,'%-15s %s \n','2','Order of first coefficient');
        fprintf(f,'%-15d %s \n',NumbDisc,'Number of input stations for distributed parameters');
        fprintf(f,'%-15.1f %s \n',Input.Modes.AdjFact(1),'Factor to adjust mass');
        fprintf(f,'%-15.1f %s \n',Input.Modes.AdjFact(2),'Factor to adjust out-of-plane or tower stiffness');
        fprintf(f,'%-15.1f %s \n',Input.Modes.AdjFact(3),'Factor to adjust in-plane stiffness');
        for i=1:NumbDisc
            fprintf(f,format,RefinedEtaRP(i),RefinedTwistRP(i),RefinedMassRP(i),RefinedFlapRP(i),RefinedEdgeRP(i));
        end
    fclose(f);
end

if Input.Modes.Location==1
    %% Refine PA data
    NumbDisc=60;
    RefinedEtaPA=linspace(0,1,NumbDisc);
    RefinedTwistPA=interp1(Input.Blade.Eta,Output.Blade.StructuralTwist,RefinedEtaPA);
    RefinedMassPA=interp1(Input.Blade.Eta,Output.Blade.MassUnitLength,RefinedEtaPA);
    RefinedFlapPA=interp1(Input.Blade.Eta,Output.Blade.FlapBendingStiffnessPA,RefinedEtaPA);
    RefinedEdgePA=interp1(Input.Blade.Eta,Output.Blade.EdgeBendingStiffnessPA,RefinedEtaPA);

    %% Write refined (Principal Axis) Modes file
    File=strcat('Routines_Modes\Blade_Modes_PA.inp');
    f=fopen(File,'w');
        fprintf(f,'%-15s %s \n','True','True = Blade, False = Tower');
         if Input.Modes.RotationalOption==1
            fprintf(f,'%-15.2f %s \n',Input.Modes.Omega,'Steady state angular velocity of rotor (rpm) ');
        else
            fprintf(f,'%-15s %s \n','0.0','Steady state angular velocity of rotor (rpm) ');
        end
        fprintf(f,'%-15.2f %s \n',Input.Modes.Beta,'Pitch angle for blades (degrees)');
        fprintf(f,'%-16.12e %s \n',Input.RotorRad,'Total beam length (m)');
        fprintf(f,'%-15.3f %s \n',Input.HubRad,'Rigid beam length (m)');
        fprintf(f,'%-15s %s \n','0.0','End mass (kg)');
        fprintf(f,'%-15s %s \n','5','Number of modes shapes or coefficients');
        fprintf(f,'%-15s %s \n','2','Order of first coefficient');
        fprintf(f,'%-15d %s \n',NumbDisc,'Number of input stations for distributed parameters');
        fprintf(f,'%-15.1f %s \n',Input.Modes.AdjFact(1),'Factor to adjust mass');
        fprintf(f,'%-15.1f %s \n',Input.Modes.AdjFact(2),'Factor to adjust out-of-plane or tower stiffness');
        fprintf(f,'%-15.1f %s \n',Input.Modes.AdjFact(3),'Factor to adjust in-plane stiffness');
        for i=1:NumbDisc
            fprintf(f,format,RefinedEtaPA(i),RefinedTwistPA(i),RefinedMassPA(i),RefinedFlapPA(i),RefinedEdgePA(i));
        end
    fclose(f);
end

%% Write first (Reference Point) Modes file
% File=strcat('Output\Blade\Blade_Modes_RP.inp');
% f=fopen(File,'w');
%     fprintf(f,'%-15s %s \n','True','True = Blade, False = Tower');
%     fprintf(f,'%-15.2f %s \n',Input.Omega,'Steady state angular velocity of rotor (rpm) ');
%     fprintf(f,'%-15.2f %s \n',Input.Beta,'Pitch angle for blades (degrees)');
%     fprintf(f,'%-15.3f %s \n',Input.RotorRad,'Total beam length (m)');
%     fprintf(f,'%-15.3f %s \n',Input.HubRad,'Rigid beam length (m)');
%     fprintf(f,'%-15s %s \n','0.0','End mass (kg)');
%     fprintf(f,'%-15s %s \n','5','Number of modes shapes or coefficients');
%     fprintf(f,'%-15s %s \n','2','Order of first coefficient');
%     fprintf(f,'%-15d %s \n',length(Input.Blade.RadialPos),'Number of input stations for distributed parameters');
%     fprintf(f,'%-15s %s \n','1.0','Factor to adjust mass');
%     fprintf(f,'%-15s %s \n','1.0','Factor to adjust out-of-plane or tower stiffness');
%     fprintf(f,'%-15s %s \n','1.0','Factor to adjust in-plane stiffness');
%     for i=1:length(Input.Blade.RadialPos)
%         fprintf(f,format,Input.Blade.Eta(i),Input.Blade.Twist(i),Output.Blade.MassUnitLength(i),Output.Blade.FlapBendingStiffnessRP(i),Output.Blade.EdgeBendingStiffnessRP(i));
%     end
% fclose(f);

%% Write second (Principal Axis) Modes file
% File=strcat('Output\Blade\Blade_Modes_PA.inp');
% f=fopen(File,'w');
%     fprintf(f,'%-15s %s \n','True','True = Blade, False = Tower');
%     fprintf(f,'%-15.2f %s \n',Input.Omega,'Steady state angular velocity of rotor (rpm) ');
%     fprintf(f,'%-15.2f %s \n',Input.Beta,'Pitch angle for blades (degrees)');
%     fprintf(f,'%-15.3f %s \n',Input.RotorRad,'Total beam length (m)');
%     fprintf(f,'%-15.3f %s \n',Input.HubRad,'Rigid beam length (m)');
%     fprintf(f,'%-15s %s \n','0.0','End mass (kg)');
%     fprintf(f,'%-15s %s \n','5','Number of modes shapes or coefficients');
%     fprintf(f,'%-15s %s \n','2','Order of first coefficient');
%     fprintf(f,'%-15d %s \n',length(Input.Blade.RadialPos),'Number of input stations for distributed parameters');
%     fprintf(f,'%-15s %s \n','1.0','Factor to adjust mass');
%     fprintf(f,'%-15s %s \n','1.0','Factor to adjust out-of-plane or tower stiffness');
%     fprintf(f,'%-15s %s \n','1.0','Factor to adjust in-plane stiffness');
%     for i=1:length(Input.Blade.RadialPos)
%         fprintf(f,format,Input.Blade.Eta(i),Output.Blade.CumulatedTwist(i),Output.Blade.MassUnitLength(i),Output.Blade.FlapBendingStiffnessPA(i),Output.Blade.EdgeBendingStiffnessPA(i));
%     end
% fclose(f);