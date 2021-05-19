
function BECAS_PrintResults(const, props, utils )
%********************************************************
% File: BECAS_PrintResults.m
%   Function which prints the results from BECAS into a file.
%
% Syntax:
%   BECAS_PrintResults( const, props  )
%
% Input:
%   const   :  Structure with constitutive matrices (see
%              BECAS_Constitutive*)
%   props   :  Structure with cross section properties (see
%              BECAS_CrossSectionProps)
%   utils   :  Structure with general data (see
%              BECAS_utils)
%
% Output:
%   Results are printed to BECAS2D.out
%
% Calls:
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
%   Version 1.1    07.09.2012   José Pedro Blasques: Removed BECAS_utils
%   and changed the input to receive the utils structure. Changed the ouput
%   to pass the props structure.
%
%   Version 1.2    28.09.2012   José Pedro Blasques: Now also plotting the
%   element type, directory, and BECAS version.
%
%   Version 1.3    29.09.2012   José Pedro Blasques: Now also printing the
%   date.
%
% (c) DTU Wind Energy
%********************************************************

fprintf(1,'> Started output results to BECAS_2D.out...');

%Printing to screen
Filename='BECAS_2D.out';
fid = fopen(Filename,'w+');
% fid=1;

%% Header
a=clock;
fprintf(fid,'********************************\n');
fprintf(fid,'*                              *\n');
fprintf(fid,'*          BECAS 2.3           *\n');
fprintf(fid,'*              by              *\n');
fprintf(fid,'*     becas-dtuwind@dtu.dk     *\n');
fprintf(fid,'*                              *\n');
fprintf(fid,'*   A cross section analysis   *\n');
fprintf(fid,'*   program for anisotropic    *\n');
fprintf(fid,'*   beams with arbitrary       *\n');
fprintf(fid,'*   geometry.                  *\n');
fprintf(fid,'*                              *\n');
fprintf(fid,'*     (c)DTU Wind Energy       *\n');
fprintf(fid,'********************************\n');
fprintf(fid,'\n');
fprintf(fid,'\n');


%% Some input properties
fprintf(fid,'Output generated on the (yyyy.mm.dd) %2.0f.%2.0f.%2.0f at (hh.mm.ss) %2.0f.%2.0f.%2.0f  \n',a(1:6));
fprintf(fid,'Element type is: %s \n',utils.etype_string);
fprintf(fid,'The input folder: is %s \n',utils.foldername);

%% Results
sk = size(const.Ks);
fprintf(fid,'\n');
fprintf(fid,'Stiffness matrix w.r.t. to the cross section reference point \n');
fprintf(fid,'K=\n');
fprintf(fid,[repmat('%19.12g\t',1,sk(2)-1) '%19.12g\n'],full(const.Ks).');
fprintf(fid,'\n');
fprintf(fid,'Compliance matrix w.r.t. to the cross section reference point \n');
fprintf(fid,'F=\n');
fprintf(fid,[repmat('%19.12g\t',1,sk(2)-1) '%19.12g\n'],full(inv(const.Ks)).');
fprintf(fid,'\n');
fprintf(fid,'Mass matrix w.r.t. to the cross section reference point \n');
fprintf(fid,'M=\n');
fprintf(fid,[repmat('%19.12g\t',1,sk(2)-1) '%19.12g\n'],full(const.Ms).');
fprintf(fid,'\n');
fprintf(fid,'Shear center;\n');
fprintf(fid,'ShearX=%19.12g \n', props.ShearX);
fprintf(fid,'ShearY=%19.12g \n', props.ShearY);
fprintf(fid,'\n');
fprintf(fid,'Elastic center:\n');
fprintf(fid,'ElasticX=%19.12g \n', props.ElasticX);
fprintf(fid,'ElasticY=%19.12g \n', props.ElasticY);
fprintf(fid,'\n');
fprintf(fid,'Orientation of principle axis w.r.t. reference center:\n');
fprintf(fid,'alpha_p=%19.12go or %19.12grad \n',[BECAS_rad2deg(props.AlphaPrincipleAxis_Ref) props.AlphaPrincipleAxis_Ref]);
fprintf(fid,'\n');
fprintf(fid,'Orientation of principle axis w.r.t. elastic center:\n');
fprintf(fid,'alpha_p=%19.12go or %19.12grad \n',[BECAS_rad2deg(props.AlphaPrincipleAxis_ElasticCenter) props.AlphaPrincipleAxis_ElasticCenter]);
fprintf(fid,'\n');
fprintf(fid,'Mass center:\n');
fprintf(fid,'MassX=%19.12g \n',props.MassX);
fprintf(fid,'MassY=%19.12g \n',props.MassY);
fprintf(fid,'\n');
fprintf(fid,'Mass per unit length:\n');
fprintf(fid,'Mass=%19.12g \n',props.MassTotal);
fprintf(fid,'\n');
fprintf(fid,'Mass moments of inertia:\n');
fprintf(fid,'Ixx=%19.12g \n',props.Ixx);
fprintf(fid,'Iyy=%19.12g \n',props.Iyy);
fprintf(fid,'Ixy=%19.12g \n',props.Ixy);
fprintf(fid,'\n');
fprintf(fid,'Area center:\n');
fprintf(fid,'AreaX=%19.12g \n',props.AreaX);
fprintf(fid,'AreaY=%19.12g \n',props.AreaY);
fprintf(fid,'\n');
fprintf(fid,'Area per unit length:\n');
fprintf(fid,'Area=%19.12g \n',props.AreaTotal);
fprintf(fid,'Area moments:\n');
fprintf(fid,'Ixx=%19.12g \n',props.Axx);
fprintf(fid,'Iyy=%19.12g \n',props.Ayy);
fprintf(fid,'Ixy=%19.12g \n',props.Axy);

p=[props.ShearX props.ShearY]; theta=0;
[Ksprime]=BECAS_TransformationMat(const.Ks,p,theta);
fprintf(fid,'\n');
fprintf(fid,'Stiffness matrix with respect to shear center:\n');
fprintf(fid,[repmat('%19.12g\t',1,sk(2)-1) '%19.12g\n'],full(Ksprime).');

p=[props.ElasticX props.ElasticY]; theta=BECAS_rad2deg(0);
[Ksprime]=BECAS_TransformationMat(const.Ks,p,theta);
fprintf(fid,'\n');
fprintf(fid,'Stiffness matrix with respect to the elastic center:\n');
fprintf(fid,[repmat('%19.12g\t',1,sk(2)-1) '%19.12g\n'],full(Ksprime).');

p=[0 0]; theta=BECAS_rad2deg(props.AlphaPrincipleAxis_Ref);
[Ksprime]=BECAS_TransformationMat(const.Ks,p,theta);
fprintf(fid,'\n');
fprintf(fid,'Stiffness matrix rotated along principle axis:\n');
fprintf(fid,[repmat('%19.12g\t',1,sk(2)-1) '%19.12g\n'],full(Ksprime).');

p=[props.ElasticX props.ElasticY]; theta=BECAS_rad2deg(props.AlphaPrincipleAxis_ElasticCenter);
[Ksprime]=BECAS_TransformationMat(const.Ks,p,theta);
fprintf(fid,'\n');
fprintf(fid,'Stiffness matrix at the elastic center rotated along principle axis:\n');
fprintf(fid,[repmat('%19.12g\t',1,sk(2)-1) '%19.12g\n'],full(Ksprime).');

p=[props.MassX props.MassY]; theta=0;
[Msprime]=BECAS_TransformationMat(const.Ms,p,theta);
fprintf(fid,'\n');
fprintf(fid,'Mass matrix with respect to mass center\n');
fprintf(fid,[repmat('%19.12g\t',1,sk(2)-1) '%19.12g\n'],full(Msprime).');

fclose('all');

fprintf(1,'DONE! \n');

end