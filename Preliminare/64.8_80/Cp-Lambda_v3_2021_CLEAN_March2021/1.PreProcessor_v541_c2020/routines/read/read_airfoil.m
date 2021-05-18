function [airfoil] = read_airfoil(PathStruct);

%---------------------------------------------------------------
%  This function reads the Bladed's report file which schedule 
%  the Cl, Cd and Cm of the given airfoil at a defined value of 
%  thickness, Reynolds number, chordwise origin for pitch moment 
%  and ailerons deployment angle.
%  After this, the function returns a structure called 'airfoil'.
%  
%
%   Syntax:
%         -[airfoil] = read_airfoil(n_airfoil);
%
%   Input:
%         -n_airfoil = number of tabulated airfoil used in the model;
%
%
%   Output:
%         -'airfoil' structure composed as follows:
%
%           1) name      = this field is a vector which contain the
%                         names of scheduled airfoil;
%
%           2) reference = it is a cell array and each cell are 
%             composed by a vector which represent:
%               i) Thickness (%chord) of the scheduled airfoil;
%              ii) Reynolds number at which the aerodynamic 
%                  coefficients are reported;
%             iii) Chordwise origin for pitch moment;
%              iv) Aileron deployment angle;
%
%            3) data_set = it is a (nx4) matrix (n is the number
%                          of angle of incidence at which the 
%                          aerodynamic coefficients are reported).
%                1° colum = angle of incidence;
%                2° colum = Cl;
%                3° colum = Cd;
%                4° colum = Cm
%                    
%
%-----------------------------------------------------------------

%airfoil structure pre-allocation
airfoil = struct ('name' , [] , ...
                  'reference' , cell(1) , ...
                  'data_set'  , cell(1));                      
              

try
    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_a.txt') ,  1 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_b.txt') ,  2 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_c.txt') ,  3 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_d.txt') ,  4 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_e.txt') ,  5 );        
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_f.txt') ,  6 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_g.txt') ,  7 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_h.txt') ,  8 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_i.txt') ,  9 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_j.txt') , 10 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_k.txt') , 11 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_l.txt') , 12 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_m.txt') , 13 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_n.txt') , 14 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_o.txt') , 15 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_p.txt') , 16 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_q.txt') , 17 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_r.txt') , 18 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_s.txt') , 19 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_t.txt') , 20 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_u.txt') , 21 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_v.txt') , 22 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_w.txt') , 23 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_x.txt') , 24 );  %there was a "z" here, I think that's wrong
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_y.txt') , 25 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_z.txt') , 26 );    
    
    % ALE 04.march.2006
    % I add these names but I know that this is a awful way to write a
    % code (I do not wat to chage Walter's code!!!!!!)
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_aa.txt') , 27 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_ab.txt') , 28 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_ac.txt') , 29 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_ad.txt') , 30 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_ae.txt') , 31 );        
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_af.txt') , 32 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_ag.txt') , 33 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_ah.txt') , 34 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_ai.txt') , 35 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_aj.txt') , 36 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_ak.txt') , 37 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_al.txt') , 38 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_am.txt') , 39 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_an.txt') , 40 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_ao.txt') , 41 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_ap.txt') , 42 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_aq.txt') , 43 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_ar.txt') , 44 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_as.txt') , 45 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_at.txt') , 46 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_au.txt') , 47 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_av.txt') , 48 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_aw.txt') , 49 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_ax.txt') , 50 ); %there was a "z" here, I think that's wrong
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_ay.txt') , 51 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_az.txt') , 52 );  
    
    % CEDR 30.march.2012
    % I totally agree with ALE's comments above: this code is dreadful!!!
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_ba.txt') , 53 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bb.txt') , 54 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bc.txt') , 55 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bd.txt') , 56 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_be.txt') , 57 );        
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bf.txt') , 58 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bg.txt') , 59 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bh.txt') , 60 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bi.txt') , 61 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bj.txt') , 62 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bk.txt') , 63 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bl.txt') , 64 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bm.txt') , 65 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bn.txt') , 66 );
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bo.txt') , 67 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bp.txt') , 68 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bq.txt') , 69 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_br.txt') , 70 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bs.txt') , 71 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bt.txt') , 72 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bu.txt') , 73 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bv.txt') , 74 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bw.txt') , 75 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bx.txt') , 76 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_by.txt') , 77 );    
    airfoil=auxiliary_read_airfoil( airfoil , strcat(PathStruct.FullPathInputDir,'\airfoil_bz.txt') , 78 ); 
end
