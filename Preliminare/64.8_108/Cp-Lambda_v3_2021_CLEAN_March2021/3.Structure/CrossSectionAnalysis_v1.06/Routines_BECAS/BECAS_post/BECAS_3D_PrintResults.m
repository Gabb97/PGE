function BECAS_3D_PrintResults( Ks, ShearX, ShearY, ElasticX, ElasticY, ...
    AlphaPrincipleAxis,AlphaPrincipleAxis_ElasticCenter )
%********************************************************
% File: BECAS_3D_PrintResults.m
%   Function which prints the results from BECAS into a file.
%
% Syntax:
%   BECAS_3D_PrintResults( Ks, ShearX, ShearY, ElasticX, ElasticY, ...
%    AlphaPrincipleAxis,AlphaPrincipleAxis_ElasticCenter )
%
% Input:
%   ShearX, 
%   ShearY  :  Coordinates of shear center with respect to mid-chord point
%              (see HAWC2 documentation)
%   ElasticX, 
%   ElasticY:  Coordinates of elastic center with respect to mid-chord
%              point (see HAWC2 documentation)
%   AlphaPrincipleAxis_Ref :  Orientation of the principle axis
%              with calculated at the reference point
%   AlphaPrincipleAxis_ElasticCenter :  Orientation of the principle axis
%              with calculated at the elastic center
%   
% Output:
%   Results are printed to BECAS2D.out
%
% Calls:
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

%Printing to screen
Filename='BECAS_3D.out';
fid = fopen(Filename,'w+');
% fid=1;

if(fid ~= 1) 
    fprintf(1,'        Output results to BECAS_2D.out \n');
    a=clock;
    fprintf(fid,'********************************\n');
    fprintf(fid,'*                              *\n');
    fprintf(fid,'*          BECAS (v2)          *\n');
    fprintf(fid,'*              by              *\n');
    fprintf(fid,'*        J. P. Blasques        *\n');
    fprintf(fid,'*      jpbl@risoe.dtu.dk       *\n');
    fprintf(fid,'*                              *\n');
    fprintf(fid,'*   A cross section analysis   *\n');
    fprintf(fid,'*   program for anisotropic    *\n');
    fprintf(fid,'*   beams with arbitrary       *\n');
    fprintf(fid,'*   geometry.                  *\n');
    fprintf(fid,'*                              *\n');
    fprintf(fid,'*        (c)DTU-RISØ           *\n');
    fprintf(fid,'********************************\n');
    fprintf(fid,'\n');
    fprintf(fid,'Output generated at (hh.mm.ss): %2.0f.%2.0f.%2.0f  \n',a(4:6));
end

sk = size(Ks);
fprintf(fid,'\n');
fprintf(fid,'Stiffness matrix w.r.t. to the cross section reference point \n');
fprintf(fid,'K=\n');
fprintf(fid,[repmat('%19.12g\t',1,sk(2)-1) '%19.12g\n'],full(Ks).');
fprintf(fid,'\n');
fprintf(fid,'Compliance matrix w.r.t. to the cross section reference point \n');
fprintf(fid,'F=\n');
fprintf(fid,[repmat('%19.12g\t',1,sk(2)-1) '%19.12g\n'],full(inv(Ks)).');
fprintf(fid,'\n');
fprintf(fid,'Shear center;\n');
fprintf(fid,'ShearX=%19.12g \n', ShearX);
fprintf(fid,'ShearY=%19.12g \n', ShearY);
fprintf(fid,'\n');
fprintf(fid,'Elastic center:\n');
fprintf(fid,'ElasticX=%19.12g \n',ElasticX);
fprintf(fid,'ElasticY=%19.12g \n',ElasticY);
fprintf(fid,'\n');
fprintf(fid,'Orientation of principle axis w.r.t. reference center:\n');
fprintf(fid,'alpha_p=%19.12go or %19.12grad \n',[BECAS_rad2deg(AlphaPrincipleAxis) AlphaPrincipleAxis]);
fprintf(fid,'\n');
fprintf(fid,'Orientation of principle axis w.r.t. elastic center:\n');
fprintf(fid,'alpha_p=%19.12go or %19.12grad \n',[BECAS_rad2deg(AlphaPrincipleAxis_ElasticCenter) AlphaPrincipleAxis_ElasticCenter]);

p=[ShearX ShearY]; theta=0;
[Ksprime]=BECAS_TransformationMat(Ks,p,theta);
fprintf(fid,'\n');
fprintf(fid,'Stiffness matrix with respect to shear center:\n');
fprintf(fid,[repmat('%19.12g\t',1,sk(2)-1) '%19.12g\n'],full(Ksprime).');

p=[ElasticX ElasticY]; theta=BECAS_rad2deg(0);
[Ksprime]=BECAS_TransformationMat(Ks,p,theta);
fprintf(fid,'\n');
fprintf(fid,'Stiffness matrix with respect to the elastic center:\n');
fprintf(fid,[repmat('%19.12g\t',1,sk(2)-1) '%19.12g\n'],full(Ksprime).');

p=[0 0]; theta=BECAS_rad2deg(AlphaPrincipleAxis);
[Ksprime]=BECAS_TransformationMat(Ks,p,theta);
fprintf(fid,'\n');
fprintf(fid,'Stiffness matrix rotated along principle axis:\n');
fprintf(fid,[repmat('%19.12g\t',1,sk(2)-1) '%19.12g\n'],full(Ksprime).');

p=[ElasticX ElasticY]; theta=BECAS_rad2deg(AlphaPrincipleAxis_ElasticCenter);
[Ksprime]=BECAS_TransformationMat(Ks,p,theta);
fprintf(fid,'\n');
fprintf(fid,'Stiffness matrix at the elastic center rotated along principle axis:\n');
fprintf(fid,[repmat('%19.12g\t',1,sk(2)-1) '%19.12g\n'],full(Ksprime).');


end