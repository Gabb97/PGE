function beam_properties_definition ( fpc , prop_name , eta , beam_stiff , torsional_stiff , mass , ...
                                      moments_of_inertia , cg , sc , cl , axial_stiffness, DampingCoefficient );

%-----------------------------------------------------------------------------
%  This function prints in a .dat file the multibody beam properties model.
% 
%   Syntax:
%        -beam_properties_definition ( fpc , prop_name , eta , beam_stiff , torsional_stiff , mass , ...
%                                         moments_of_inertia , cg , sc , cl )
%
%   Input:
%       -fpc = the .dat file in which the function will write;
%       -prop_name = a character string which contains the blade properties model name;
%       -eta = abscissa position of the section in which triad of the curve are defined;
%       -beam_stiff = it is a matrix(Nx2): N is the number of sections,
%                     and for each of these, colums define EJx and EJy;
%                         
%            TO BE COMPLETED
%
%-----------------------------------------------------------------------------

fprintf(fpc,'  BeamProperty : \n');
fprintf(fpc,'     Name : %2s  ; \n',deblank(prop_name));
fprintf(fpc,'     NumberOfTerms : %2g  ;\n',max(size(eta)));

for section_number = 1 : max(size(eta)) ;
    
    if beam_stiff(1) ~= 's',
        temp = max(beam_stiff(section_number,:));
        if  fix(log10(temp)) < 11,
            temp_stiff = 10 ^ ( 1 + fix(log10(temp)) );
        else
            temp_stiff = 10 ^ 12;
        end
    end
               
    fprintf(fpc,'      EtaValue : %2.16g ; : \n',eta(section_number));
    
    if beam_stiff(1) == 's';        
        fprintf(fpc,'      AxialStiffness : 1E+12 ;\n');
        fprintf(fpc,'      BendingStiffnesses : 1E+12 , 1E+12 , 0.0  ; \n');
    elseif beam_stiff(1) == 'v';
        fprintf(fpc,'      AxialStiffness : 1E+15 ;\n');        
        fprintf(fpc,'      BendingStiffnesses : 1E+15 , 1E+15 , 0.0  ; \n');
    elseif axial_stiffness(1) == 's'
        fprintf(fpc,'      AxialStiffness : 1E+010 ;\n' );
        fprintf(fpc,'      BendingStiffnesses : %4g , %4g , 0.0 ; \n',beam_stiff(section_number,:));        
    else
        fprintf(fpc,'      AxialStiffness : %2g ;\n', axial_stiffness(section_number) );
        fprintf(fpc,'      BendingStiffnesses : %4g , %4g , 0.0 ; \n',beam_stiff(section_number,:));
    end

    if torsional_stiff(1) == 's' & beam_stiff(1) ~= 's';
        fprintf(fpc,'      TorsionalStiffness :  %2g ; \n' , temp_stiff );
    elseif torsional_stiff(1) == 's' & beam_stiff(1) == 's';        
        fprintf(fpc,'      TorsionalStiffness :  1E+011 ; \n');
    elseif torsional_stiff(1) == 'v';
        fprintf(fpc,'      TorsionalStiffness :  1E+15 ; \n');
    else        
        fprintf(fpc,'      TorsionalStiffness :  %4g ; \n',torsional_stiff(section_number));        
    end
    
    if torsional_stiff(1) == 's' & beam_stiff(1) ~= 's';
        fprintf(fpc,'      ShearingStiffnesses : %2g , %2g , 0.0 ; \n', temp_stiff , temp_stiff );
    elseif torsional_stiff(1) == 's' & beam_stiff(1) == 's';
        fprintf(fpc,'      ShearingStiffnesses : 1E+12 , 1E+12 , 0.0 ; \n');
    else
          fprintf(fpc,'      ShearingStiffnesses : %2g , %2g, 0.0 ; \n',10*beam_stiff(section_number,:));
    end

    fprintf(fpc,'      MassPerUnitSpan : %2.16g ; \n',mass(section_number));
    
    if moments_of_inertia(1) == 'n';
        
        fprintf(fpc,'      MomentsOfInertia : 0 , 0 , 0 ; \n');
        
    else
        
        % Original:
        % fprintf(fpc,'      MomentsOfInertia : %2.16g,%2.16g,%2.16g ; \n',moments_of_inertia(section_number,:));
        % Ale 04.feb.05.
        % At the moment you can use only one moment of inertia (wrt the
        % longitudinal axis of the blade):
        %fprintf(fpc,'      MomentsOfInertia : 0.0 , 0.0 , %2.16g ; \n',moments_of_inertia(section_number,:));
        fprintf(fpc,'      MomentsOfInertia : %2.16g,%2.16g,%2.16g ; \n',moments_of_inertia(section_number,:));
        
    end
    
    if cg(1) == 'n';        
        fprintf(fpc,'      CenterOfMass :  0.0 , 0.0 ; \n');        
    else        
        fprintf(fpc,'      CenterOfMass :  %2.16g , %2.16g ; \n',cg(section_number,:));
    end
    
    if sc(1) =='n';        
        fprintf(fpc,'      ShearCenter : 0.0 , 0.0 ; \n');        
    else        
        fprintf(fpc,'      ShearCenter : %2g,%2g ; \n',sc(section_number,:));        
    end
    
    if cl(1) == 'n';
        fprintf(fpc,'      Centroid : 0.0 , 0.0 ; \n');        
    else        
        fprintf(fpc,'      Centroid : %2g , %2g ; \n',cl(section_number,:));        
    end
    
    % Ale 04.feb.05. added for numerical stability.
    if DampingCoefficient>0
        fprintf(fpc,'      DampingCoefficient : 0.005 ; \n');
    end
    fprintf(fpc,'     ;\n');
    
end

fprintf(fpc,'  ;\n');
