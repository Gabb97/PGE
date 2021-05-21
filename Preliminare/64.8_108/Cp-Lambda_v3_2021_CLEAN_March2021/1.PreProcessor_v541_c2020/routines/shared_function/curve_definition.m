function curve_definition( fpc , curve_name , frame , point_0 , point_1 , eta , e2 , e3 , mesh_flag , mesh_name );

%----------------------------------------------------------------------------------------
%  This function prints in a .dat file the multibody curve model.
% 
%   Syntax:
%           -curve_definition( fpc , curve_name , frame , point_0 , point_1 , eta , e2 , e3 , mesh_flag , mesh_name );
%
%   Input:
%           -fpc        = the .dat file in which the function will write;
%           -curve_name = characters string which contains the curve name;
%           -frame_name = characters string which contains the curve reference 
%                         frame name;
%           -point_0 , point_1 = end point of the curve ([%g , %g , %g ]);
%           -eta        = abscissa position of the section in which triads of 
%                         the curve are defined;
%           -e2 , e3    = these are (3xN) matrix where each coluom define 
%                         direction cosines of the triad at the previously  
%                         defined eta positions;
%           -mesh_flag  = 'y' or 'no', define if a mesh model is present;
%           -mesh_name  = characters string which contains the curve mesh model name;
%-------------------------------------------------------------------------------------------



ntriad = max(size(eta));
fprintf(fpc,' Curve : \n'); 
fprintf(fpc,'    Name : %2s ; \n',deblank(curve_name));
fprintf(fpc,'       InReferenceFrame : %2s ; \n',deblank(frame));
fprintf(fpc,'       Points : \n ');
fprintf(fpc,'      NumberOfControlPoints : 2 ; \n');
fprintf(fpc,'       DegreeOfCurve : 1 ; \n');
fprintf(fpc,'       RationalCurveFlag : NO ; \n');
fprintf(fpc,'       EndPoint0 : %2s ; \n',deblank(point_0));
fprintf(fpc,'       EndPoint1 : %2s ; \n',deblank(point_1));
fprintf(fpc,'       ; \n');
fprintf(fpc,'       Triads : \n');


%if ( max(size(e2))==3 & min(size(e2))==1),
if ( size(e2,1)*size(e2,2)*size(e2,3)==3),
% %size(e2)
% %e2
% size(e2,3)
% % keyboard;
% if ( size(e2,3) == 1),
% 
%     keyboard;
    
    fprintf(fpc,'       NumberOfTerms : %2g ;\n',  2 );    
    fprintf(fpc,'       EtaValue : %2g  ;  ',0.0);
    fprintf(fpc,'       YVector : %1.16g , %2.16g , %2.16g ; ', e2);
    fprintf(fpc,'       ZVector : %1.16g , %2.16g , %2.16g ;  \n', e3);  

    fprintf(fpc,'       EtaValue : %2g ; ',1.0);
    fprintf(fpc,'       YVector : %1.16g , %2.16g , %2.16g ;  ', e2);
    fprintf(fpc,'       ZVector : %1.16g , %2.16g , %2.16g ; \n', e3);  
    
else
    
    fprintf(fpc,'       NumberOfTerms : %2g ;\n' , ntriad);
    
    for section_number = 1 : max(size(eta)),   

        fprintf(fpc,'       EtaValue : %1.16g ;',eta(section_number));
        fprintf(fpc,'       YVector : %1.16g , %1.16g , %1.16g ;  ', e2(:,section_number));
        fprintf(fpc,'       ZVector : %1.16g , %1.16g , %1.16g ; \n', e3(:,section_number));     
        
    end
    
end

fprintf(fpc,'    ;\n');    

if mesh_flag=='y';
    
    fprintf(fpc,'  CurveMeshParameter : %2s ; \n',deblank(mesh_name));
    
end

fprintf(fpc,'  ;\n'); 