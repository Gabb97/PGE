function mass_property_definition( int_flag , fpc , mass_name , mass , cg_location , moments_of_inertia );

%--------------------------------------------------------------------------------
%  This function prints in a .dat file the multibody MASS PROPERTY model
% 
%   Syntax:
%           -mass_property_definition( int_flag , fid , mass_name , mass,...
%                                      cg_location , moments_of_inertia )
%
%   Input:
%           -int_flag            = 'y'(yes) or 'n'(no). This string define if is 
%                                   necessary print the head text;
%           -fpc                 =  the .dat file in which the function will write;
%           -mass_name           =  a character string which contains the mass name;
%           -mass                =  number which represents the total mass ;
%           -cg_location         =  coordintates of the mass cg location with 
%                                   respect the local triad of the body at which 
%                                   the mass is refered to;
%           -moments_of_inertia  =  it is a vector which contains the moments
%                                   of inertia respect the local axis;
%---------------------------------------------------------------------------------

if int_flag == 'y';
    fprintf(fpc,'MassProperties : \n');
end

fprintf(fpc,'  MassProperty : \n');
fprintf(fpc,'    Name :  %2s  ; \n' , deblank(mass_name) );
fprintf(fpc,'    Mass :  %2.16g  ; \n' , mass );
fprintf(fpc,'    CenterOfMass : %2.16g , %2.16g , %2.16g ; \n' , cg_location );
fprintf(fpc,'    MomentsOfInertia : %2.16g , %2.16g , %2.16g , %2.16g , %2.16g , %2.16g  ; \n',moments_of_inertia);
fprintf(fpc,'   ; \n');

if int_flag =='y',
    fprintf(fpc,' ;\n\n\n');
else
end