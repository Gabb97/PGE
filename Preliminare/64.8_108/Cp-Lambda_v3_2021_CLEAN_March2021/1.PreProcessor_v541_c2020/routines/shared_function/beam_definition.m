function beam_definition ( fpc , beam_name , point0 , body0 , point1 , body1 , curve_name , beam_property_name , varargin);

%--------------------------------------------------------------------------
%  This function prints in a .dat file the multibody BEAM model.
% 
%   Syntax:
%           -beam_definition ( fpc , beam_name , point0 , body0, ...
%                              point1 , body1 , curve_name , beam_property_name )
%
%   Input:
%           -fpc                =  the .dat file in which the function will write;
%           -beam_name          =  a character string which contain the beam name;
%           -point0 , point1    =  are two character string which contain the beam 
%                                  end point name;
%           -body0 , body1      =  are two character string which contain the body 
%                                  name at which the beam is attached;
%           -curve_name         =  a character string which contain the beam curve name;
%           -beam_property_name =  a character string which contain the beam properties 
%                                  name;
%   
%--------------------------------------------------------------------------

% ALEALE 03.April.2012
if nargin > 8
    ShapeFlag = 1;
    ShapeName = varargin{1};
else
    ShapeFlag = 0;
end
%

num = size(beam_name);

%fprintf(fpc,' Beams : \n');

for i = 1 : num(1);
    
    fprintf(fpc,'   Beam :\n'); 
    fprintf(fpc,'      Name : %2s ; \n',deblank(beam_name(i,:)));
    fprintf(fpc,'      ConnectedTo : %2s ; \n',deblank(body0(i,:)));
    fprintf(fpc,'      Where : %2s ; \n',deblank(point0(i,:)));
    fprintf(fpc,'      ConnectedTo : %2s; \n',deblank(body1(i,:)));
    fprintf(fpc,'      Where : %2s ; \n',deblank(point1(i,:)));
    fprintf(fpc,'      Curve : %2s ; \n',deblank(curve_name(i,:)));
    fprintf(fpc,'      BeamProperty : %2s ; \n',deblank(beam_property_name(i,:)));
    if ShapeFlag
            fprintf(fpc,'      Shape : %s ; \n',ShapeName);
    else
            fprintf(fpc,'      #Shape : shape name ; \n');
    end
    %fprintf(fpc,'      #ConnectedTo : shell1 name, shell2 name, ... shelln name ; \n');
    fprintf(fpc,'      ;\n');
    
end

%fprintf(fpt,'  ;\n\n\n');
