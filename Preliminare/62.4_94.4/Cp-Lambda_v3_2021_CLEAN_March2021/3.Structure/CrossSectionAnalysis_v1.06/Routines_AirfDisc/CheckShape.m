function [Section]=CheckShape(Parameters,Section,SectionID)

% In this subroutine, we check if the section has spar caps and/or LE and
% TE reinfrocement. If so, then the section si a 'full' section and nothing
% is done. Otherwise, fictional division points are created.


chord           =   Section.Chord;
LeadingEdgeX    =   -Section.LeadingEdge;
UpperSparX      =   -[Section.FrontSpar Section.RearSpar];
LowerSparX      =   UpperSparX;
UpperReinfX     =   -[Section.LEReinf Section.TEReinf];
LowerReinfX     =   UpperReinfX;
beta            =   -Parameters.Blade.Twist(SectionID);
type            =   Section.Type;


%% Build fictional Key Points (KPs) or just overwrite the original ones
if type=='A'
    % Cylinder/Transition --> Create fictional positions for spar caps and
    % LE/TE reinfrocements
    XOffset  =  chord/8;
    X2Offset =  chord/4;
    
    UpperSparX  =   [LeadingEdgeX-X2Offset LeadingEdgeX-3*X2Offset ];
    LowerSparX  =   UpperSparX;
    
    UpperReinfX =   [LeadingEdgeX-XOffset LeadingEdgeX-7*XOffset ];
    LowerReinfX =   UpperReinfX;
end

if type=='B'
    % Box w/out LE/TE --> Create fictional positions for 
    % LE/TE reinfrocements    
    XOffset  =  chord/8;

%     UpperSparX  =   UpperSparX;
%     LowerSparX  =   LowerSparX;
    
    UpperReinfX =   [LeadingEdgeX-XOffset LeadingEdgeX-7*XOffset ];
    LowerReinfX =   UpperReinfX;
end

if  type=='C'
    % Box --> Just keep the original positions of spar caps and LE/TE
    % reinforcements
%     UpperSparX      =   UpSparX;
%     LowerSparX      =   LowSparX;
%     
%     UpperReinfX     =   UpReinfX;
%     LowerReinfX     =   LowReinfX;
end


%% Complete topologial description with undefined elements
if type=='A'
    % Cylinder/Transition:
        
        % Element 1 (TE reinforcements PS) is taken equel to Element 2 (Shell TE PS)
        Section.Thickness{1} = Section.Thickness{2};
        Section.MaterialsNames{1} = Section.MaterialsNames{2};
        
        % Element 5 (LE reinforcements PS) is taken equel to Element 4 (Shell LE PS)
        Section.Thickness{5} = Section.Thickness{4};
        Section.MaterialsNames{5} = Section.MaterialsNames{4};
        
        % Element 6 (LE reinforcements sS) is taken equel to Element 7 (Shell LE PS)
        Section.Thickness{6} = Section.Thickness{7};
        Section.MaterialsNames{6} = Section.MaterialsNames{7};
        
        % Element 10 (TE reinforcements SS) is taken equel to Element 9 (Shell tE sS)
        Section.Thickness{10} = Section.Thickness{9};
        Section.MaterialsNames{10} = Section.MaterialsNames{9};
        
        % If the lamination sequence of Element 2,4 is the same, Element 3
        % is taken equal to the average of Eleents 2,4:
        e2.thickness    = Section.Thickness{2};
        e2.names        = Section.MaterialsNames{2};
        
        e4.thickness    = Section.Thickness{4};
        e4.names        = Section.MaterialsNames{4};
        
        if length(e2.names) == length(e4.names)
            for ii = 1:length(e2.names)
                if strcmp(e2.names{ii},e4.names{ii})
                    e3.thickness(ii) =(e2.thickness(ii)+e4.thickness(ii))/2 ;
                else                 
                    warning('Shell elements must be consinstent in transitional sections.');
                    keyboard
                    return
                end
            end
        else
                    warning('Shell elements must be consinstent in transitional sections.');
                    keyboard
                    return
        end
        Section.Thickness{3}        =       e3.thickness;
        Section.MaterialsNames{3}	=       Section.MaterialsNames{2};
        
        % If the lamination sequence of Element 7,8 is the same, Element 8
        % is taken equal to the average of Eleents 7,8:
        e7.thickness    = Section.Thickness{7};
        e7.names        = Section.MaterialsNames{7};
        
        e9.thickness    = Section.Thickness{9};
        e9.names        = Section.MaterialsNames{9};
        
        if length(e7.names) == length(e9.names)
            for ii = 1:length(e7.names)
                if strcmp(e7.names{ii},e9.names{ii})
                    e8.thickness(ii) =(e7.thickness(ii)+e9.thickness(ii))/2 ;
                else                 
                    warning('Shell elements must be consinstent in transitional sections.');
                    keyboard
                    return
                end
            end
        else
                    warning('Shell elements must be consinstent in transitional sections.');
                    keyboard
                    return
        end
        Section.Thickness{8}        =       e8.thickness;
        Section.MaterialsNames{8}	=       Section.MaterialsNames{7};
       
        % Build fictional Element 11,12 (Webs)
        Section.Thickness{11}       =       0.000001;
        Section.MaterialsNames{11}  =       {'FICT_WEBS'};
        
        Section.Thickness{12}       =       0.000001;
        Section.MaterialsNames{12}  =       {'FICT_WEBS'};
end

if type=='B'
    % Box w/out LE/TE reinforcements:
        
        % Element 1 (TE reinforcements PS) is taken equel to Element 2 (Shell TE PS)
        Section.Thickness{1} = Section.Thickness{2};
        Section.MaterialsNames{1} = Section.MaterialsNames{2};
        
        % Element 5 (LE reinforcements PS) is taken equel to Element 4 (Shell LE PS)
        Section.Thickness{5} = Section.Thickness{4};
        Section.MaterialsNames{5} = Section.MaterialsNames{4};
        
        % Element 6 (LE reinforcements sS) is taken equel to Element 7 (Shell LE PS)
        Section.Thickness{6} = Section.Thickness{7};
        Section.MaterialsNames{6} = Section.MaterialsNames{7};
        
        % Element 10 (TE reinforcements SS) is taken equel to Element 9 (Shell tE sS)
        Section.Thickness{10} = Section.Thickness{9};
        Section.MaterialsNames{10} = Section.MaterialsNames{9};
        
     
end

% Overwrite output
Section.FrontSpar   =   - UpperSparX(1);
Section.RearSpar    =   - UpperSparX(2);
Section.LEReinf     =   - UpperReinfX(1);
Section.TEReinf     =   - UpperReinfX(2);

