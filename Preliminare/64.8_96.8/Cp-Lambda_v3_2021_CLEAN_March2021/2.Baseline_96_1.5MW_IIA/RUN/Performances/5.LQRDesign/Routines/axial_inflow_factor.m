function [a,Cp] = axial_inflow_factor(nome_file) ;

% load AeroTorqueLookUp;  % ALE. questo nome nascosto qui è pericoloso....
% ALE. risolto:
load(nome_file);

n_iter = 1 ;
count = 1 ;

Cp =[0 :(max(max(LookUp.Cp))/max(size(LookUp.TSR))):max(max(LookUp.Cp))]; % perchè 231 elementi?

for i = 0 :(max(max(LookUp.Cp))/max(size(LookUp.TSR))):max(max(LookUp.Cp)), 
 
    xn = 0.15;
    
    while 1,
        
        xn1 = -1 * ( xn * ( 1 - xn )^2 - (i/4)) / (( 1 - xn )*( 1 - 3*xn )) + xn ;
        
        if abs(xn1 - xn) <= 10^-5,
            a(count) = xn1;            
            count = count + 1;
            n_iter = 1;
            break;
            
        else
            
            n_iter = n_iter + 1 ;
            
            if n_iter > 50,
                disp('**********************************')                
                xn
                xn1
                toll= xn1-xn;
                toll
                n_iter
                break;
            end
            
            xn = xn1;
            
        end
        
    end
    
end

