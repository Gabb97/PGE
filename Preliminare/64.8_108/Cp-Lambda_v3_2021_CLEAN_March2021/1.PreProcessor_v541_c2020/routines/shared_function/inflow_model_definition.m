function inflow_model_definition( fpc , name , body0 , point0 , triad , inflow_type , lifting_list , parameters );
%-----------------------------------------
% For more details about input data see
% the Cp-Lambda user's manual.
%-----------------------------------------


fprintf(fpc,' Inflows :\n');
fprintf(fpc,'   Inflow :\n');
fprintf(fpc,'    Name : %2s ;\n',deblank(name));
fprintf(fpc,'    ConnectedTo : %2s ;\n',deblank(body0));
fprintf(fpc,'    Where : %2s ;\n',deblank(point0));
fprintf(fpc,'    Triad : %2s ;\n',deblank(triad));
fprintf(fpc,'    InflowLengthFactor : %2g ;\n',parameters(3));
fprintf(fpc,'    InflowVelocityFactor : %2g ;\n',parameters(3));
fprintf(fpc,'    InflowType : %2s ;\n',deblank(inflow_type));
fprintf(fpc,'    LiftingLineList : %2s ;\n',deblank(lifting_list));

inflow_type_temp = deblank(inflow_type);

if inflow_type_temp(1:3) == 'Thr',

    fprintf(fpc,'    NumberOfStates : %2g ;\n',parameters(1));
    fprintf(fpc,'    FactorizationFrequency : %2g ;\n',parameters(2));
   
elseif inflow_type_temp(1:3) == 'BEM'
        
    fprintf(fpc,'    NumberOfBlades : %2g ;\n',parameters(1));
    fprintf(fpc,'    HubRadius : %2g ;\n',parameters(2));
    fprintf(fpc,'    TipRadius : %2g ;\n',parameters(3));
    fprintf(fpc,'    TSRSmoothRange  : 1.0 , 2.0;\n');
    fprintf(fpc,'    TgInductionFactorLowerRadius  :%2g;\n',0.1*parameters(3));
    
    
end

fprintf(fpc,'   ;\n');
fprintf(fpc,' ;\n\n\n');

