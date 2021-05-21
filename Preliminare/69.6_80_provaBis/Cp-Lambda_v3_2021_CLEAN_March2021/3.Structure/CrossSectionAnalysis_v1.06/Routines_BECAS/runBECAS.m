% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Template file for running BECAS
%
% (c) DTU Wind Energy
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [GlobalStress,GlobalStrain]=runBECAS(Parameters,Input, eta, secID)

%% Build loads array
Loads=[];
Loads(1)=Parameters.Loads.Tx(secID);
Loads(2)=Parameters.Loads.Ty(secID);
Loads(3)=Parameters.Loads.Tz(secID);
Loads(4)=Parameters.Loads.Mx(secID);
Loads(5)=Parameters.Loads.My(secID);
Loads(6)=Parameters.Loads.Mz(secID);

%% Setup path for BECAS library and SuiteSparse
BECAS_SetupPath

%% Options
%Folder name contining input data (MUST BE DEFINED)
FolderAddress=strcat(pwd,'\BECASFiles\BECAS_Section_',num2str(secID));
FileAddress='BECAS_SECTION';

options.foldername=fullfile(FolderAddress, FileAddress);
%Element type (Q4, Q8 or Q8R - Optional)
% options.etype='Q8R';

%% Build arrays for BECAS
[ utils ] = BECAS_Utils( options );

%% Call BECAS module for the evaluation of the cross section stiffness matrix
[constitutive.Ks,solutions] = BECAS_Constitutive_Ks(utils);

%% Call BECAS module for the evaluation of the cross section mass matrix
[constitutive.Ms] = BECAS_Constitutive_Ms(utils);

%% Call BECAS module for the evaluation of the cross section properties
[csprops] = BECAS_CrossSectionProps(constitutive.Ks,utils);

%% Recover strains and stress for a given force and moment vector
%Load vector
theta0=Loads;

%Calculate strains
[ strain ] = BECAS_RecoverStrains( theta0, solutions, utils );

%Calculate stresses
[ stress ] = BECAS_RecoverStresses( strain, utils );
    % Build output stress
    StressValue=stress.GlobalElement;
    StrainValue=strain.GlobalElement;
    ElemFileAddress=strcat(pwd,'\BECASFiles\BECAS_Section_',num2str(secID),'\BECAS_SECTION\E2D.in');
    f=fopen(ElemFileAddress);
    ReadElementFile=cell2mat(textscan(f,'%f %f %f %f %f %f %f %f %f'));
    ElementsID=ReadElementFile(:,1);
    GlobalStress(:,1)=ElementsID;
    GlobalStrain(:,1)=ElementsID;
        for j=1:6
            GlobalStress(:,j+1)=StressValue(:,j);
            GlobalStrain(:,j+1)=StrainValue(:,j);
        end
    fclose(f);



%% Output of results to HAWC2
%Output to HAWC2
RadialPosition=1; %Define radial position
OutputFilename='BECAS2HAWC2.out'; %File name
BECAS_Becas2Hawc2(OutputFilename,RadialPosition,constitutive,csprops,utils)

%% Output results to PARAVIEW
warping=solutions.X*theta0';
BECAS_PARAVIEW( 'BECAS_PARAVIEW', utils, csprops, warping, strain.MaterialElement, stress.MaterialElement )

%% Plotting and priting routines

    %Print results
    BECAS_PrintResults( constitutive, csprops, utils );
    
if Input.PlotOption>0
%     %Generate figures based on input
    savefig_flag=0;
    if Input.PlotOption==1
        BECAS_PlotInput( savefig_flag, utils, eta, secID );  % Mesh, Fiber orientation, Materials..
    end

    if Input.PlotOption==2
        %Generate figures based on output
        savefig_flag=0;
        BECAS_PlotOutput(savefig_flag, utils, csprops, eta, secID );
    end
    
    if Input.PlotOption==3
        %Plot ALL components of stresses and strains
        savefig_flag=0;
          
          BECAS_PlotElementResults(savefig_flag,utils,strain.GlobalElement, eta, secID);
%         BECAS_PlotElementResults(savefig_flag,utils,strain.MaterialElement, eta, secID);
          BECAS_PlotElementResults(savefig_flag,utils,stress.GlobalElement, eta, secID);
%         BECAS_PlotElementResults(savefig_flag,utils,stress.MaterialElement, eta, secID);
%         BECAS_PlotGaussPointResults(savefig_flag,utils,strain.GlobalGauss);
%         BECAS_PlotGaussPointResults(savefig_flag,utils,strain.MaterialGauss);
%         BECAS_PlotGaussPointResults(savefig_flag,utils,stress.GlobalGauss);
%         BECAS_PlotGaussPointResults(savefig_flag,utils,stress.MaterialGauss);
    end
    
    if Input.PlotOption==4
        %Plot normal stresses and strains
        savefig_flag=0;    
        comp = 6;
        
          BECAS_PlotElementResults_Individual(savefig_flag,utils,stress.GlobalElement, eta, secID, comp, 'stress');    
          BECAS_PlotElementResults_Individual(savefig_flag,utils,strain.GlobalElement, eta, secID, comp, 'strain');     
          
          
    end
end


