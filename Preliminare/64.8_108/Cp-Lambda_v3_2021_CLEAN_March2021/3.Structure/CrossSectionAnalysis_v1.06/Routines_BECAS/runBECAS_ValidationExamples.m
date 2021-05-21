% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run a list of validation examples and write output to file
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear all; clc; format short;
BECAS_SetupPath;


folder_names = {'S1'; 'S2_1'; 'S2_10'; 'S2_100'; 'S2_1000'; 'S2_10000'; 'S2_100000'; 'S3_0'; 'S3_22.5'; 'S3_45'; 'S3_67.5'; 'S3_90'; 'C1'; 'C2'; 'C3_1'; 'C3_10'; 'C3_100'; 'C3_1000'; 'C3_10000'; 'C3_100000'; 'C4'; 'T1'; 'T2'; 'T3';'Detailed WT Section';'S4'};
etype =        {'Q4';   'Q4';    'Q4';     'Q4';      'Q4';       'Q4';        'Q4';   'Q4';      'Q4';    'Q4';      'Q4';    'Q4'; 'Q4'; 'Q4';   'Q4';    'Q4';     'Q4';      'Q4';       'Q4';        'Q4'; 'Q4'; 'Q4'; 'Q4'; 'Q8R';                 'Q8R';'Q4'};

outputfilename = 'BECAS_ValidationResults.out';

original_directory = pwd;
fid = fopen(outputfilename,'w+');

%% Load results for comparison
[Ks_v,Ms_v,Scp_v,Ecp_v]=BECAS_VABSresults;

%% Loop through examples
for i=1:length(folder_names)
    %% Define input data and build arrays for BECAS
    fprintf('\nLoading example %s \n\n', folder_names{i});
    options.foldername=fullfile('BECAS_examples',folder_names{i});
    [ utils ] = BECAS_Utils( options );

    %% Call BECAS module for the evaluation of the cross section stiffness matrix
    [constitutive.Ks,solutions] = BECAS_Constitutive_Ks(utils);
    
    %% Call BECAS module for the evaluation of the cross section mass matrix
    [constitutive.Ms] = BECAS_Constitutive_Ms(utils);
    
    %% Call BECAS module for the evaluation of the cross section properties
    [csprops] = BECAS_CrossSectionProps(constitutive.Ks,utils);
    
    %% Compare results
    %Stiffness and mass matrix
    [Ks_v(:,:,i)]=BECAS_VABS2BECASordering( Ks_v(:,:,i));
    Ks_compare=((Ks_v(:,:,i)-constitutive.Ks)./Ks_v(:,:,i))*100;
    Ks_gb=zeros(6);
    [Ms_v(:,:,i)]=BECAS_VABS2BECASordering( Ms_v(:,:,i));
    Ms_compare=((Ms_v(:,:,i)-constitutive.Ms)./Ms_v(:,:,i))*100;
    Ms_gb=zeros(6);
    for ii=1:6
        for iii=1:6
            if(isnan(Ks_compare(ii,iii)) || isinf(Ks_compare(ii,iii)) || Ks_compare(ii,iii)<1E-12)
                Ks_compare(ii,iii)=0;
            end
            if(isnan(Ms_compare(ii,iii)) || isinf(Ms_compare(ii,iii)) || Ms_compare(ii,iii)<1E-12)
                Ms_compare(ii,iii)=0;
            end
        end
    end
    %Shear and elastic center
    Sc_compare(1)=abs((Scp_v(i,1)-csprops.ShearX)/Scp_v(i,1))*100;
    Sc_compare(2)=abs((Scp_v(i,2)-csprops.ShearY)/Scp_v(i,2))*100;
    Ec_compare(1)=abs((Ecp_v(i,1)-csprops.ElasticX)/Ecp_v(i,1))*100;
    Ec_compare(2)=abs((Ecp_v(i,2)-csprops.ElasticY)/Ecp_v(i,2))*100;
    for ii=1:2
       if( isnan(Sc_compare(ii)) || isinf(Sc_compare(ii)) || Sc_compare(ii)<1E-12)
           Sc_compare(ii)=0;
       end
       if( isnan(Ec_compare(ii)) || isinf(Ec_compare(ii)) || Ec_compare(ii)<1E-12)
           Ec_compare(ii)=0;
       end       
    end
    
    %% Write results to file
    error_flag=0;
    fprintf(fid,'\n======================================================================\n');
    fprintf(fid,'Example %s \n', folder_names{i});
    fprintf(fid,'======================================================================\n');
    sk = size(constitutive.Ks);
    fprintf(fid,'\n');
    fprintf(fid,'Stiffness matrix w.r.t. to the cross section reference point - relative  \n');
    fprintf(fid,'difference (in percent) between BECAS and VABS: \n');
    fprintf(fid,'\n');
    fprintf(fid,'(K_becas-K_vabs)/K_becas*100 =\n');
    fprintf(fid,'\n');
    fprintf(fid,[repmat('%19.12g\t',1,sk(2)-1) '%19.12g\n'],full(Ks_compare).');
    fprintf(fid,'\n');
    fprintf(fid,'*********************** TEST K MATRIX **********************');
    fprintf(fid,'\n');
    if(max(max(abs(Ks_compare))) < 0.01)
        fprintf(fid,'Stiffness matrix looks correct compared to VABS!');
        fprintf(fid,'\n');
    else
        fprintf(fid,'WARNING!!! Stiffness matrix looks INCORRECT compared to VABS!');
        fprintf(fid,'\n');
        error_flag=i;
    end
    fprintf(fid,'Maximum relative error is (in percent): %19.12g \n', max(max(abs(Ks_compare))));
    fprintf(fid,'************************************************************');
    fprintf(fid,'\n');
    fprintf(fid,'Mass matrix w.r.t. to the cross section reference point - relative  \n');
    fprintf(fid,'difference (in percent) between BECAS and VABS: \n');
    fprintf(fid,'\n');
    fprintf(fid,'(M_becas-M_vabs)/M_becas*100 =\n');
    fprintf(fid,'\n');
    fprintf(fid,[repmat('%19.12g\t',1,sk(2)-1) '%19.12g\n'],full(Ms_compare).');
    fprintf(fid,'\n');
    fprintf(fid,'*********************** TEST M MATRIX **********************');
    fprintf(fid,'\n');
    if(max(max(abs(Ms_compare))) < 0.01)
        fprintf(fid,'Mass matrix looks correct compared to VABS!');
        fprintf(fid,'\n');
    else
        fprintf(fid,'WARNING!!! Mass matrix looks INCORRECT compared to VABS!');
        fprintf(fid,'\n');
        error_flag=i;
    end
    fprintf(fid,'Maximum relative error is (in percent): %19.12g \n', max(max(abs(Ms_compare))));
    fprintf(fid,'************************************************************');    
    fprintf(fid,'\n');    
    fprintf(fid,'Shear center - relative difference (in percent) between BECAS and VABS:\n');
    fprintf(fid,'(Xs_becas-Xs_vabs)/Xs_becas*100 = %19.12g \n', Sc_compare(1));
    fprintf(fid,'(Ys_becas-Ys_vabs)/Ys_becas*100 = %19.12g \n', Sc_compare(2));
    fprintf(fid,'*************** TEST SHEAR CENTER ***************');
    fprintf(fid,'\n');
    if(max(abs(Sc_compare)) < 0.01)
        fprintf(fid,'Shear center looks correct compared to VABS!');
        fprintf(fid,'\n');
    else
        fprintf(fid,'WARNING!!! Shear center looks INCORRECT compared to VABS!');
        fprintf(fid,'\n');
        error_flag=i;
    end
    fprintf(fid,'Maximum relative error is: %19.12g \n', max(abs(Sc_compare)));
    fprintf(fid,'*************************************************');
    fprintf(fid,'\n');
    fprintf(fid,'Elastic center - relative difference (in percent) between BECAS and VABS:\n');
    fprintf(fid,'(Xt_becas-Xt_vabs)/Xt_becas*100 = %19.12g \n', Ec_compare(1));
    fprintf(fid,'(Yt_becas-Yt_vabs)/Yt_becas*100 = %19.12g \n', Ec_compare(2));
    fprintf(fid,'*************** TEST ELASTIC CENTER ***************');
    fprintf(fid,'\n');
    if(max(abs(Ec_compare)) < 0.01)
        fprintf(fid,'Elastic center looks correct compared to VABS!');
        fprintf(fid,'\n');
    else
        fprintf(fid,'WARNING!!! Elastic center looks INCORRECT compared to VABS!');
        fprintf(fid,'\n');
        error_flag=i;
    end
    fprintf(fid,'Maximum relative error is: %19.12g \n', max(abs(Ec_compare)));
    fprintf(fid,'***************************************************');
    fprintf(fid,'\n');  
end

%% Results from all validation
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'*************************************************** \n');
fprintf(fid,'*************************************************** \n');
fprintf(fid,'\n');
fprintf(fid,'           SUMMARY OF THE VALIDATION \n');
if(error_flag ~= 0)
fprintf(fid,'       WARNING!!! CASE NUMBER %d IS WRONG \n', error_flag);
else
fprintf(fid,'   Congratulations! Everything looks very fine! \n');
end
fprintf(fid,'\n');
fprintf(fid,'*************************************************** \n');
fprintf(fid,'*************************************************** \n');

% Close all files
fclose('all');


