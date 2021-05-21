function BECAS_Becas2Hawc2( filename, r, const,...
    props, ...
    utils )
%********************************************************
% File: BECAS_Becas2Hawc2.m
%   This function generates input to HAWC2 based on the cross section
%   analysis results from BECAS
%
% Syntax:
%   BECAS_Becas2Hawc2( filename, r, const, props )
%
% Input:
%   filename:  String holding the name of the file to which the HAWC2 data
%              is output
%   r       :  Radial position of section
%   const   :  Structure with constitutive matrices (see
%              BECAS_Constitutive*)
%   props   :  Structure with constitutive matrices (see
%              BECAS_CrossSectionProps)
%   utils   :  Structure with all inputdata and other data necessary (see
%              BECAS_utils).
%   
% Output:   Output to file filename
%           
% Calls:
%
% Date:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
%   Version 2.0    07.09.2012   José Pedro Blasques: Removed BECAS_utils 
%   and changed the input to receive the utils structure. Changed the ouput
%   to pass the props structure.
%
% (c) DTU Wind Energy
%********************************************************

%%
fprintf(1,'> Started generating input for HAWC2 and writing to BECAS2HAWC2.out...')

%Mass per unit length
mpl= const.Ms(1,1);

%Mass center coordinates with respect to c/2
xm= props.MassX;
ym= props.MassY;

%Radius of inertia with respect to elastic center
p=[ props.ElasticX  props.ElasticY]; theta=rad2deg( props.AlphaPrincipleAxis_ElasticCenter);
[Msprime]=BECAS_TransformationMat(const.Ms,p,theta);
rx=sqrt(Msprime(4,4)/ mpl);
ry=sqrt(Msprime(5,5)/ mpl);

%Shear center coordinates with respect to c/2
xs= props.ShearX;
ys= props.ShearY;

%Modulus of elasticity (averaged)
p=[ props.ElasticX  props.ElasticY]; theta=rad2deg( props.AlphaPrincipleAxis_ElasticCenter);
[Ksprime]=BECAS_TransformationMat(const.Ks,p,theta);
Em=Ksprime(3,3)/ props.AreaTotal; %
%Shear modulus (averaged)
% Em=0;
Gm=0;
nQ=(6)*(6);
for e=1:utils.ne_2d
    Qe=sparse(utils.iQ((e-1)*nQ+1:e*nQ),utils.jQ((e-1)*nQ+1:e*nQ),utils.vQ((e-1)*nQ+1:e*nQ));
    Gm=Gm+utils.ElArea(e)*Qe(4,4);
end
Gm=Gm/props.AreaTotal;

%Area moment of inertia with respect to principal bending axis
Ax_ea=Ksprime(4,4)/Em;
Ay_ea=Ksprime(5,5)/Em;

%Torsional stiffness
p=[ props.ShearX  props.ShearY]; theta=rad2deg(0);
[Ksprime]=BECAS_TransformationMat(const.Ks,p,theta);
K=Ksprime(6,6)/Gm;

%Shear factor
kx=Ksprime(1,1)/(Gm* props.AreaTotal);
ky=Ksprime(2,2)/(Gm* props.AreaTotal);

%Cross section area
A= props.AreaTotal;

%Structural pitch
theta_s=rad2deg(props.AlphaPrincipleAxis_ElasticCenter);

%Elastic center position
xe= props.ElasticX;
ye= props.ElasticY;

%Output to HAWC2
outvec=[r mpl xm ym rx ry xs ys Em Gm Ax_ea Ay_ea K kx ky A theta_s xe ye];

%Print to file
filename=[pwd '\' filename];
fid = fopen(filename,'a+');
fprintf(fid,'%19.12g %19.12g %19.12g %19.12g %19.12g %19.12g %19.12g %19.12g %19.12g %19.12g %19.12g %19.12g %19.12g %19.12g %19.12g %19.12g %19.12g %19.12g %19.12g\n', outvec);
fclose(fid);

    function [var]=rad2deg(var)
        %Turning radians to degrees
        var=var*180/(pi);
    end

fprintf(1,'DONE! \n');

end
