function prescribed_displacement_def( fpc , header , presc_disp_name , body_name , point_name , idi ,time_function_name, ctrl_name );

%-----------------------------------------------------------------
% This function prints the prescribed displacement model suitable
% for the multibody software.
%
% Syntax:
%   - prescribed_displacement_def( fpc , header , presc_disp_name,...
%                                  body_name , point_name , idi , ...
%                                  time_function_name );
% Ale. 04.feb.05.
% Added ctrl_name (used without time function)
%
%--------------------------------------------------------------------

if header == 'y',
    fprintf(fpc,'PrescribedDisplacements : \n');
end

fprintf(fpc,'  PrescribedDisplacement :\n');
fprintf(fpc,'    Name : %2s ; \n',deblank(presc_disp_name));
fprintf(fpc,'    AppliedTo : %2s ; \n',deblank(body_name));
fprintf(fpc,'    Where : %2s ; \n',deblank(point_name));
fprintf(fpc,'    DegreeOfFreedom : %1g ; \n',idi);
% Ale. 04.feb.05 
% fprintf(fpc,'    TimeFunction : %2s ; \n',deblank(time_function_name));
if (nargin==7) 
    fprintf(fpc,'    TimeFunction : %2s ; \n',deblank(time_function_name));
    fprintf(fpc,'#    Controller : Controller_4_Wind_Turbine  ; \n');
else
    fprintf(fpc,'#    TimeFunction : %2s ; \n',deblank(time_function_name));
    fprintf(fpc,'    Controller : %2s ; \n',deblank(ctrl_name));
end
%    
fprintf(fpc,'   ; \n');

if header == 'y',
    fprintf(fpc,' ; \n\n\n');
end

