function revolute_joint_definition ( fpc , int_flag , revolute_name , point0 , body0 , point1 , body1 , ...
                                     triad_name , mass_flag , rel_flag , spring_flag , damper_flag , ...
                                     mass_name , rel_name , body_rel , spring_name , damper_name , actuator_name);

%-----------------------------------------------------------------------------------------
%  This function prints in a .dat ascii file the multibody revolute joint model.
% 
%   Syntax:
%      -revolute_joint_definition ( fpc , int_flag , revolute_name , point0 , ...
%                                   body0 , point1 , body1 , triad_name , ...
%                                   mass_flag , rel_flag , spring_flag , ...
%                                   damper_flag , mass_name , rel_name , ...
%                                   body_rel , spring_name , damper_name );
%
%   Input:
%           -fpc             =  the .dat file in which the function will write;
%           -int_flag        =  'y' or 'n', if 'y' the header will be print;
%           -revolute_name   =  a character string which contains the beam name;
%           -point0 , point1 =  are two character strings which contains the revolute 
%                               joint end point names;
%           -body0 , body1   =  are two character strings which contains the name of 
%                               the bodies at which the joint is attached;
%           -mass_flag       = 'y' or 'n', 'y' means that the joint has a mass;
%           -rel_flag        = 'y' or 'n', 'y' means that a relative rotation will be defined;
%           -spring_flag     = 'y' or 'n', 'y' means that a spring will be defined;
%           -damper_flag     = 'y' or 'n', 'y' means that a damper will be defined;
%           -mass_name       = string which defines the name of the joint's mass ;
%           -rel_name        = string which defines the name of the joint's relative rotation;
%           -body_rel        = string which defines the name of the body at which the relative
%                              rotation is attaced to;
%           -spring_name     = string which defines the name of the joint's spring;
%           -damper_name     = string which defines the name of the joint's damper;
% Added by Ale 04.feb.05:
%           -actuator_name     = string which defines the name of the actuator;
%   
%---------------------------------------------------------------------------------------


if int_flag =='y';
    fprintf(fpc,'RevoluteJoints: \n');
end

fprintf(fpc,'  RevoluteJoint : \n');
fprintf(fpc,'    Name : %2s ; \n',deblank(revolute_name));
fprintf(fpc,'    ConnectedTo : %2s ; \n',deblank(body0));
fprintf(fpc,'    Where : %2s ; \n',deblank(point0));
fprintf(fpc,'    ConnectedTo : %2s ; \n',deblank(body1));
fprintf(fpc,'    Where : %2s ; \n',deblank(point1));
fprintf(fpc,'    Triad : %2s ; \n',deblank(triad_name));

if mass_flag == 'y';
    fprintf(fpc,'    MassProperty : %2s ; \n',deblank(mass_name));
end

% Old version:
% if ( rel_flag =='y' & spring_flag == 'y' & damper_flag == 'n' );
%     fprintf(fpc,'    RelativeRotation :  \n');
%     fprintf(fpc,'      Name : %2s ; \n',deblank(rel_name));
%     fprintf(fpc,'      ConnectedTo : %2s ; \n',deblank(body_rel));
%     fprintf(fpc,'      Where : %2s ; \n',deblank(point0));
%     fprintf(fpc,'      Spring : %2s ; \n',deblank(spring_name));
% %    fprintf(fpc,'#     Damper :     ;\n');
%     fprintf(fpc,'     ;\n ');
%     
% elseif ( rel_flag =='y' & spring_flag == 'n' & damper_flag == 'n' );
%     fprintf(fpc,'    RelativeRotation :  \n');
%     fprintf(fpc,'      Name : %2s ; \n',deblank(rel_name));
%     fprintf(fpc,'      ConnectedTo : %2s ; \n',deblank(body_rel));
%     fprintf(fpc,'      Where : %2s ; \n',deblank(point0));    
%     fprintf(fpc,'     ; \n');
% 
% elseif ( rel_flag =='y' & damper_flag == 'y' & spring_flag == 'n' );
%     fprintf(fpc,'     RelativeRotation :  \n');
%     fprintf(fpc,'      Name : %2s ; \n',deblank(rel_name));
%     fprintf(fpc,'      ConnectedTo : null ; \n');
%     fprintf(fpc,'      Where : %2s ; \n',deblank(point0));
% %    fprintf(fpc,'#      Spring : %2s ; \n',deblank(spring_name));
%     fprintf(fpc,'      Damper :  %2s   ;\n',deblank(damper_name));
%     fprintf(fpc,'     ; \n');    
%     
% elseif ( rel_flag =='y' & damper_flag == 'y' & spring_flag == 'y' );
%     fprintf(fpc,'     RelativeRotation :  \n');
%     fprintf(fpc,'      Name : %2s ; \n',deblank(rel_name));
%     fprintf(fpc,'      ConnectedTo : null ; \n');
%     fprintf(fpc,'      Where : %2s ; \n',deblank(point0));
%     fprintf(fpc,'      Spring : %2s ; \n',deblank(spring_name));
%     fprintf(fpc,'      Damper :  %2s   ;\n',deblank(damper_name));
%     fprintf(fpc,'     ; \n');        
%     
% end

% Ale: 04.feb.05 ... this is better and with actuator!!!!!!
if ( rel_flag =='y' )
    fprintf(fpc,'    RelativeRotation :  \n');
    fprintf(fpc,'      Name : %2s ; \n',deblank(rel_name));
    fprintf(fpc,'      ConnectedTo : %2s ; \n',deblank(body_rel));
    fprintf(fpc,'      Where : %2s ; \n',deblank(point0));
    if ( spring_flag == 'y' ) fprintf(fpc,'      Spring : %2s    ; \n',deblank(spring_name));   end
    if ( damper_flag == 'y' ) fprintf(fpc,'      Damper :  %2s   ; \n',deblank(damper_name));   end
    if ( nargin == 18)        fprintf(fpc,'      Actuator : %2s  ; \n',deblank(actuator_name)); end
    fprintf(fpc,'     ;\n ');
end

fprintf(fpc,'  ; \n');

if int_flag == 'y';
    fprintf(fpc,' ; \n\n\n');
end