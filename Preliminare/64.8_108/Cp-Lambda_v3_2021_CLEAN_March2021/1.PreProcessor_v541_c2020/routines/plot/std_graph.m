function std_graph( i , title_str , ylabel_str , xlabel_str , x_val , y_val , effects , linewidth );

figure(i);
hold on;
zoom on;
ht = title ( title_str );
hx = xlabel( xlabel_str );
hy = ylabel( ylabel_str );

hk = plot ( x_val , y_val , effects );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I don't remember the meaning of this function
%   TO   VERIFY!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% check_1 = min((min(y_val)+(min(y_val)*10)/100));
% check_2 = max((max(y_val)+(max(y_val)*10)/100));
% 
% if check_1<check_2,
% 
%     axis([min(x_val) max(x_val) min((min(y_val)+(min(y_val)*10)/100)) max((max(y_val)+(max(y_val)*10)/100))]);
%     
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

box on;
grid on;

set (ht,'FontSize' , 10 , 'FontWeight','bold');
set (hx,'FontSize' , 10 , 'FontWeight','bold');
set (hy,'FontSize' , 10 , 'FontWeight','bold');

set (hk,'LineWidth', linewidth );