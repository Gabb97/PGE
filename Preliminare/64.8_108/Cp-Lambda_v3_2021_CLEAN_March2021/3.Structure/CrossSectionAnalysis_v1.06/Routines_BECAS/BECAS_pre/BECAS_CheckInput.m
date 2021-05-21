function [ check ] = BECAS_CheckInput( options, utils )
%********************************************************
% File: BECAS_CheckInput.m
%   This function checks the input to BECAS.
%
% Syntax:
%   [ utils ] = BECAS_Utils( inputdata )
%
% Input:
%   utils   :  structure containing the input data.
%
% Output:
%   check   :  structure containing flags from the input check.
%
% Calls:
%
% Revisions:
%   Version 1.0    28.02.2012   José Pedro Blasques
%   Version 1.0    10.10.2012   José Pedro Blasques: Using error function
%   from Matlab. It creates a lotta blood but it is the only way to stop
%   BECAS execution. Checking that element type is compatible with ELIST
%   input.
%
% (c) DTU Wind Energy
%********************************************************

%Check that size of emat and elist files are the same
if (size(utils.emat,1) ~= size(utils.el_2d,1))
    errormessage='\n ERROR Message from BECAS_CheckInput: \n \n The inputdata.emat.in and E2D.in files must have the same \n Terminating BECAS \n';
    error('something:anything',errormessage);
end

%Check if the etype variable is defined
if isfield(options,'etype')
    check.exist_etype=1;
else
    fprintf(1,'\n');
    fprintf(1,'Warning message from BECAS_CheckInput: \n')
    fprintf(1,'Element type is not defined, using default based on ELIST.in...');
    check.exist_etype=0;
end

%Check if the etype variable is defined and if so matches the input
errormessage='\n ERROR Message from BECAS_CheckInput: \n \n An element type was specified using options.etype\n which does not match your input in ELIST.in!\n Terminating BECAS \n';
if isfield(options,'etype')
    check.exist_etype=1;
    if strcmp(options.etype,'Q4')
       if(size(utils.el_2d,2)>5 && utils.el_2d(1,6)~=0) 
           error('something:anything',errormessage);
       end
    end
    if strcmp(options.etype,'Q8')
       if(size(utils.el_2d,2)<9 || utils.el_2d(1,6)==0) 
           error('something:anything',errormessage);
       end
    end    
    if strcmp(options.etype,'Q8R')
       if(size(utils.el_2d,2)<9 || utils.el_2d(1,6)==0) 
           error('something:anything',errormessage);
       end
    end     
end
    
%Check that the materials assigned in EMAT are defined in MATPROPS
[val,ind]=max(utils.emat(:,2));
if ( val > size(utils.matprops,1) )
    errormessage='\n ERROR Message from BECAS_CheckInput: \n \n Material number in line %d of EMAT.in is not defined in MATPROPS.in! \n Terminating BECAS \n';
    error('something:anything', errormessage, val);
end

%Check that EMAT has the right size
if(size(utils.emat,1) ~= size(utils.emat,1) && size(utils.emat,1) ~= 4)
    errormessage='\n ERROR Message from BECAS_CheckInput: \n \n Dimensions of EMAT.in are incorrect!\n Terminating BECAS \n';
    error('something:anything',errormessage);
end

if(max(utils.el_2d(:,1))>10000000)
    errormessage='\n ERROR Message from BECAS_CheckInput: \n \n Renumber your elements or you will have memory issues!\n You are creating a vector which is %d elements long \n Terminating BECAS \n';
    error('something:anything',errormessage,max(utils.el_2d(:,1)));
end
