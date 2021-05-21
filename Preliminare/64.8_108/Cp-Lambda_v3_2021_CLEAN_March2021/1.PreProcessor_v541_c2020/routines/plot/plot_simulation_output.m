function plot_simulation_output( simulation_output , sensors , tower , hub , blade_number , avrswap );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             BLADES PLOTTING                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if sensors.blade_studied(1,1:3) == 'all',
    
    n_blade_studied = blade_number;
        
elseif ( sensors.blade_studied(1,1:3) ~='non' & sensors.blade_studied(1,1:3) ~='all' ),
    
    n_blade_studied = 1 ;
    
end



if ( sensors.blade_studied(1,1:3) ~='non' & n_blade_studied == 1 ),
    
    for i = 1 : max(size(simulation_output.blade01_local_f)),       
        
        % BLADE 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        std_graph( (i*100)+1 , strcat('Blade 1 local forces at ETA =',num2str(sensors.eta_blade(i))) , 'FORCE [N]' , 'TIME [s]' , ...
                   simulation_output.time , simulation_output.blade01_local_f{i} , '-' , 2 );legend('AXIAL','CHORD','BENDING',0);               
        
        std_graph( (i*100)+2 , strcat('Blade 1 local torque at ETA =',num2str(sensors.eta_blade(i))) , 'TORQUE [N*m]' , 'TIME [s]' , ...
                   simulation_output.time , simulation_output.blade01_local_m{i} , '-' , 2 );legend('TORSIONAL ','BENDING ','CHORD ',0);
        
        std_graph( (i*100)+3 , strcat('Blade 1 inertial displacements at ETA =',num2str(sensors.eta_blade(i))) , 'DISPLACEMETS [m]' , ...
                  'TIME [s]' , simulation_output.time , simulation_output.blade01_inertial_d{i} , '-' , 2 );legend('X','Y','Z',0);  
        
        % ROTATION definition (not much efficient)
        n=max(size(simulation_output.blade01_inertial_r{i}));
        for ii=1:n;
            f=(simulation_output.blade01_inertial_r{i}(ii,:)*simulation_output.blade01_inertial_r{i}(ii,:)')^0.5;
            phi=4*atan(f/4);
            if f ~= 0,
                k=simulation_output.blade02_inertial_r{i}(ii,:)'*(1/f);
            else
                k=simulation_output.blade02_inertial_r{i}(ii,:)'*0;
            end            
            theta=phi*k;
            blade01_rot{i}(ii,1) = theta(1)*180/pi;
            blade01_rot{i}(ii,2) = theta(2)*180/pi;
            blade01_rot{i}(ii,3) = theta(3)*180/pi;
        end
        
        
        std_graph( (i*100)+4 , strcat('Blade 1 inertial rotations at ETA =',num2str(sensors.eta_blade(i))) , 'ROTATIONS [rad]' , ...
            'TIME [s]' , simulation_output.time , blade01_rot{i} , '-' , 2 );legend('X','Y','Z',0);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        
    end

elseif ( sensors.blade_studied(1,1:3) ~='non' & n_blade_studied == 2 );
    
    for i = 1 : max(size(simulation_output.blade01_local_f)),
        
        % BLADE 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        std_graph( (i*100)+1 , strcat('Blade 1 local forces at ETA =',num2str(sensors.eta_blade(i))) , 'FORCE [N]' , 'TIME [s]' , ...
                   simulation_output.time , simulation_output.blade01_local_f{i} , '-' , 2 );legend('AXIAL','CHORD','BENDING',0);
               
        std_graph( (i*100)+2 , strcat('Blade 1 local torque at ETA =',num2str(sensors.eta_blade(i))) , 'TORQUE [N*m]' , 'TIME [s]' , ...
                   simulation_output.time , simulation_output.blade01_local_m{i} , '-' , 2 );legend('TORSIONAL ','BENDING ','CHORD ',0);
               
        std_graph( (i*100)+3 , strcat('Blade 1 inertial displacements at ETA =',num2str(sensors.eta_blade(i))) , 'DISPLACEMETS [m]' , ...
                   'TIME [s]' , simulation_output.time , simulation_output.blade01_inertial_d{i} , '-' , 2 );legend('X','Y','Z',0);  

        % ROTATION definition (not much efficient)
        n=max(size(simulation_output.blade01_inertial_r{i}));
        for ii=1:n;
            f=(simulation_output.blade01_inertial_r{i}(ii,:)*simulation_output.blade01_inertial_r{i}(ii,:)')^0.5;
            phi=4*atan(f/4);
            if f ~= 0,
                k=simulation_output.blade02_inertial_r{i}(ii,:)'*(1/f);
            else
                k=simulation_output.blade02_inertial_r{i}(ii,:)'*0;
            end            
            theta=phi*k;
            blade01_rot{i}(ii,1) = theta(1)*180/pi;
            blade01_rot{i}(ii,2) = theta(2)*180/pi;
            blade01_rot{i}(ii,3) = theta(3)*180/pi;
        end        
        
        std_graph( (i*100)+4 , strcat('Blade 1 inertial rotations at ETA =',num2str(sensors.eta_blade(i))) , 'ROTATIONS [rad]' , ...
                   'TIME [s]' , simulation_output.time , blade01_rot{i} , '-' , 2 );legend('X','Y','Z',0);
        

        % BLADE 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        std_graph( (i*100)+5 , strcat('Blade 2 local forces at ETA =',num2str(sensors.eta_blade(i))) , 'FORCE [N]' , 'TIME [s]' , ...
                   simulation_output.time , simulation_output.blade02_local_f{i} , '-' , 2 );legend('AXIAL','CHORD','BENDING',0);
               
        std_graph( (i*100)+6 , strcat('Blade 2 local torque at ETA =',num2str(sensors.eta_blade(i))) , 'TORQUE [N*m]' , 'TIME [s]' , ...
                   simulation_output.time , simulation_output.blade02_local_m{i} , '-' , 2 );legend('TORSIONAL ','BENDING ','CHORD ',0);
               
        std_graph( (i*100)+7 , strcat('Blade 2 inertial displacements at ETA =',num2str(sensors.eta_blade(i))) , 'DISPLACEMETS [m]' , ...
                   'TIME [s]' , simulation_output.time , simulation_output.blade02_inertial_d{i} , '-' , 2 );legend('X','Y','Z',0);  
               
        % ROTATION definition (not much efficient)       
        n=max(size(simulation_output.blade02_inertial_r{i}));
        for ii=1:n;
            f=(simulation_output.blade02_inertial_r{i}(ii,:)*simulation_output.blade02_inertial_r{i}(ii,:)')^0.5;
            phi=4*atan(f/4);
            if f ~= 0,
                k=simulation_output.blade02_inertial_r{i}(ii,:)'*(1/f);
            else
                k=simulation_output.blade02_inertial_r{i}(ii,:)'*0;
            end
            theta=phi*k;
            blade02_rot{i}(ii,1) = theta(1)*180/pi;
            blade02_rot{i}(ii,2) = theta(2)*180/pi;
            blade02_rot{i}(ii,3) = theta(3)*180/pi;
        end        
               
        std_graph( (i*100)+8 , strcat('Blade 2 inertial rotations at ETA =',num2str(sensors.eta_blade(i))) , 'ROTATIONS [rad]' , ...
                   'TIME [s]' , simulation_output.time , blade02_rot{i} , '-' , 2 );legend('X','Y','Z',0);
         
     end    
    
elseif ( sensors.blade_studied(1,1:3) ~='non' & n_blade_studied == 3 );
        
    for i = 1 : max(size(simulation_output.blade01_local_f)),               
        
        % BLADE 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        std_graph( (i*100)+1 , strcat('Blade 1 local forces at ETA =',num2str(sensors.eta_blade(i))) , 'FORCE [N]' , 'TIME [s]' , ...
        std_graph( (i*100)+1 , '' , 'Blade 1 root local forces [N]' , 'Time [s]' , ...
                   simulation_output.time , simulation_output.blade01_local_f{i} , '-' , 2 );legend('Axial','Chord','Bending',0);              

% % %------------------------------------------------------------------%
% %                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                %   Temporary adjoint for internal use   %
% %                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% %                Axis([10 50 -1*10^5 4*10^5]);
% %                
% %                if sensors.eta_blade(i)==0
% %                    print -depsc Blade_root_local_forces.eps
% %                end               
% % %-------------------------------------------------------------------%

        std_graph( (i*100)+2 , strcat('Blade 1 local torque at ETA =',num2str(sensors.eta_blade(i))) , 'TORQUE [N*m]' , 'TIME [s]' , ...
                   simulation_output.time , simulation_output.blade01_local_m{i} , '-' , 2 );legend('TORSIONAL ','BENDING ','CHORD ',0);
               
        std_graph( (i*100)+3 , strcat('Blade 1 inertial displacements at ETA =',num2str(sensors.eta_blade(i))) , 'DISPLACEMETS [m]' , ...
                   'TIME [s]' , simulation_output.time , simulation_output.blade01_inertial_d{i} , '-' , 2 );legend('X','Y','Z',0);  

        % ROTATION definition (not much efficient)
        n=max(size(simulation_output.blade01_inertial_r{i}));        
        for ii=1:n;
            f=(simulation_output.blade01_inertial_r{i}(ii,:)*simulation_output.blade01_inertial_r{i}(ii,:)')^0.5;
            phi=4*atan(f/4);
            if f ~= 0,
                k=simulation_output.blade02_inertial_r{i}(ii,:)'*(1/f);
            else
                k=simulation_output.blade02_inertial_r{i}(ii,:)'*0;
            end            
            theta=phi*k;
            blade01_rot{i}(ii,1) = theta(1)*180/pi;
            blade01_rot{i}(ii,2) = theta(2)*180/pi;
            blade01_rot{i}(ii,3) = theta(3)*180/pi;
        end                       
               
        std_graph( (i*100)+4 , strcat('Blade 1 inertial rotations at ETA =',num2str(sensors.eta_blade(i))) , 'ROTATIONS [rad]' , ...
                   'TIME [s]' , simulation_output.time , blade01_rot{i} , '-' , 2 );legend('X','Y','Z',0);
        

        % BLADE 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        std_graph( (i*100)+5 , strcat('Blade 2 local forces at ETA =',num2str(sensors.eta_blade(i))) , 'FORCE [N]' , 'TIME [s]' , ...
                   simulation_output.time , simulation_output.blade02_local_f{i} , '-' , 2 );legend('AXIAL','CHORD','BENDING',0);
               
        std_graph( (i*100)+6 , strcat('Blade 2 local torque at ETA =',num2str(sensors.eta_blade(i))) , 'TORQUE [N*m]' , 'TIME [s]' , ...
                   simulation_output.time , simulation_output.blade02_local_m{i} , '-' , 2 );legend('TORSIONAL','BENDING ','CHORD ',0);
               
        std_graph( (i*100)+7 , strcat('Blade 2 inertial displacements at ETA =',num2str(sensors.eta_blade(i))) , 'DISPLACEMETS [m]' , ...
                   'TIME [s]' , simulation_output.time , simulation_output.blade02_inertial_d{i} , '-' , 2 );legend('X','Y','Z',0);  
               
               
        % ROTATION definition (not much efficient)
        n=max(size(simulation_output.blade02_inertial_r{i}));
        for ii=1:n;
            f=(simulation_output.blade02_inertial_r{i}(ii,:)*simulation_output.blade02_inertial_r{i}(ii,:)')^0.5;
            phi=4*atan(f/4);
            if f ~= 0,
                k=simulation_output.blade02_inertial_r{i}(ii,:)'*(1/f);
            else
                k=simulation_output.blade02_inertial_r{i}(ii,:)'*0;
            end            
            theta=phi*k;
            blade02_rot{i}(ii,1) = theta(1)*180/pi;
            blade02_rot{i}(ii,2) = theta(2)*180/pi;
            blade02_rot{i}(ii,3) = theta(3)*180/pi;
        end                       
               
        std_graph( (i*100)+8 , strcat('Blade 2 inertial rotations at ETA =',num2str(sensors.eta_blade(i))) , 'ROTATIONS [rad]' , ...
                   'TIME [s]' , simulation_output.time , blade02_rot{i} , '-' , 2 );legend('X','Y','Z',0);
        

        % BLADE 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        std_graph( (i*100)+9 , strcat('Blade 3 local forces at ETA =',num2str(sensors.eta_blade(i))) , 'FORCE [N]' ,'TIME [s]' , ...
                   simulation_output.time , simulation_output.blade03_local_f{i} , '-' , 2 );legend('AXIAL','CHORD','BENDING',0);
               
        std_graph( (i*100)+10 , strcat('Blade 3 local torque at ETA =',num2str(sensors.eta_blade(i))) , 'TORQUE [N*m]' , 'TIME [s]' , ...
                   simulation_output.time , simulation_output.blade03_local_m{i} , '-' , 2 );legend('TORSIONAL ','BENDING ','CHORD ',0);
               
        std_graph( (i*100)+11 , strcat('Blade 3 inertial displacements at ETA =',num2str(sensors.eta_blade(i))) , 'DISPLACEMETS [m]' , ...
                   'TIME [s]' , simulation_output.time , simulation_output.blade03_inertial_d{i} , '-' , 2 );legend('X','Y','Z',0);  

        % ROTATION definition (not much efficient)
        n=max(size(simulation_output.blade03_inertial_r{i}));
        for ii=1:n;
            f=(simulation_output.blade03_inertial_r{i}(ii,:)*simulation_output.blade03_inertial_r{i}(ii,:)')^0.5;
            phi=4*atan(f/4);
            if f ~= 0,
                k=simulation_output.blade02_inertial_r{i}(ii,:)'*(1/f);
            else
                k=simulation_output.blade02_inertial_r{i}(ii,:)'*0;
            end            
            theta=phi*k;
            blade03_rot{i}(ii,1) = theta(1)*180/pi;
            blade03_rot{i}(ii,2) = theta(2)*180/pi;
            blade03_rot{i}(ii,3) = theta(3)*180/pi;
        end                               
        
        std_graph( (i*100)+12 , strcat('Blade 3 inertial rotations at ETA =',num2str(sensors.eta_blade(i))) , 'ROTATIONS [rad]' , ...
                   'TIME [s]' , simulation_output.time , blade03_rot{i} , '-' , 2 );legend('X','Y','Z',0);
         
     end        
    
end       

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             TOWER PLOTTING                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ( sensors.tower_flag(1,1:2) == 'ye' | sensors.tower_flag(1,1:2) == 'YE' ),
    
    for i = 1 : max(size(sensors.eta_tower)),
        
        std_graph( (i*1000)+1 , strcat('Tower local forces at ETA =',num2str(sensors.eta_tower(i))) , 'FORCE [N]' , 'TIME [s]' , ...
                   simulation_output.time , simulation_output.tower_local_f{i} , '-' , 2 );legend('AXIAL','FORE-AFT','SIDE-SIDE',0);
               
        std_graph( (i*1000)+2 , strcat('Tower local torque at ETA =',num2str(sensors.eta_tower(i))) , 'TORQUE [N*m]' , 'TIME [s]' , ...
                   simulation_output.time , simulation_output.tower_local_m{i} , '-' , 2 );legend('TORSIONAL','SIDE-SIDE','FORE-AFT',0);
               
        std_graph( (i*1000)+3 , strcat('Tower inertial displacements at ETA =',num2str(sensors.eta_tower(i))) , 'DISPLACEMETS [m]' , ...
                   'TIME [s]' , simulation_output.time , simulation_output.tower_inertial_d{i} , '-' , 2 );legend('AXIAL','FORE-AFT','SIDE-SIDE',0);

        % ROTATION definition (not much efficient)
        n=max(size(simulation_output.tower_inertial_r{i}));
        for ii=1:n;
            f=(simulation_output.tower_inertial_r{i}(ii,:)*simulation_output.tower_inertial_r{i}(ii,:)')^0.5;
            phi=4*atan(f/4);
            if f~=0,
                k=simulation_output.tower_inertial_r{i}(ii,:)'*(1/f);
            else
                k=simulation_output.tower_inertial_r{i}(ii,:)'*0;
            end            
            theta=phi*k;
            tower_rot{i}(ii,1) = theta(1)*180/pi;
            tower_rot{i}(ii,2) = theta(2)*180/pi;
            tower_rot{i}(ii,3) = theta(3)*180/pi;
        end                                              
               
        std_graph( (i*1000)+4 , strcat('Tower inertial rotations at ETA =',num2str(sensors.eta_tower(i))) , 'ROTATIONS [rad]' , ...
                   'TIME [s]' , simulation_output.time , tower_rot{i} , '-' , 2 );legend('TORSIONAL','SIDE-SIDE','FORE-AFT',0);

    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             HUB PLOTTING                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fig_num = 0;

if ( sensors.hub_flag(1,1:2) == 'ye' | sensors.hub_flag(1,1:2) == 'YE' ),
    
    
    std_graph(  1 , 'Hub inertial velocities' , 'VELOCITY [m/s]' , 'TIME [s]' , simulation_output.time , ...
               simulation_output.hub_inertial_v , '-' , 2 );legend('VERTICAL','FORE-AFT','SIDE-SIDE',0);
           
    std_graph(  2 , 'Hub inertial angular velocities' , 'ANGULAR VELOCITY [rad/s]' , 'TIME [s]' , simulation_output.time , ...
               simulation_output.hub_inertial_o , '-' , 2 );legend('YAW','AZIMUTAL','PITCH',0);
           
    std_graph(  3 , 'Hub local velocities' , 'VELOCITY [m/s]' , 'TIME [s]' , simulation_output.time , simulation_output.hub_local_v , ...
               '-' , 2 );legend('X','Y','Z',0);
           
    std_graph(  4 , 'Hub local angular velocities' , 'ANGULAR VELOCITY [rad/s]' , 'TIME [s]' , simulation_output.time , ...
               simulation_output.hub_local_o , '-' , 2 );legend('YAW','AZIMUTAL','PITCH',0);
           
    std_graph(  5 , 'Hub inertial displacements' , 'DISPLACEMET [m]' , 'TIME [s]' , simulation_output.time , ...
                simulation_output.hub_inertial_d , '-' , 2 );legend('VERTICAL','FORE-AFT','SIDE-SIDE',0);

    % ROTATION definition (not much efficient)
    n=max(size(simulation_output.hub_inertial_r));
    for ii=1:n;
        f=(simulation_output.hub_inertial_r(ii,:)*simulation_output.hub_inertial_r(ii,:)')^0.5;
        phi=4*atan(f/4);
            if f ~= 0,
                k=simulation_output.hub_inertial_r(ii,:)'*(1/f);
            else
                k=simulation_output.hub_inertial_r(ii,:)'*0;
            end        
        theta=phi*k;
        hub_rot(ii,1) = theta(1)*180/pi;
        hub_rot(ii,2) = theta(2)*180/pi;
        hub_rot(ii,3) = theta(3)*180/pi;
    end                                       
            
    std_graph(  6 , 'Hub inertial rotations' , 'ROTATION [rad]' , 'TIME [s]' , simulation_output.time , ...
                hub_rot , '-' , 2 );legend('YAW','AZIMUTAL','PITCH',0);
        
    fig_num = 6 ;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             SHAFT PLOTTING                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ( sensors.drive_train(1,1:2) == 'ye' | sensors.drive_train(1,1:2) == 'YE' ),
    
    std_graph( fig_num+1 , 'Shaft 1 local forces' , 'FORCE [N]' , 'TIME [s]' , simulation_output.time , ...
               simulation_output.shaft01_local_f , '-' , 2 );legend('X','Y','Z',0);
           
    std_graph( fig_num+2 , 'Shaft 1 local torque' , 'TORQUE [N*m]' , 'TIME [s]' , simulation_output.time , ...
               simulation_output.shaft01_local_m , '-' , 2 );legend('X','Y','Z',0);
           
    std_graph( fig_num+3 , 'Shaft 2 local forces' , 'FORCE [N]' , 'TIME [s]' , simulation_output.time , ...
               simulation_output.shaft01_local_f , '-' , 2 );legend('X','Y','Z',0);
           
    std_graph( fig_num+4 , 'Shaft 2 local torque' , 'TORQUE [N*m]' , 'TIME [s]' , simulation_output.time , ...
               simulation_output.shaft01_local_m , '-' , 2 );legend('X','Y','Z',0);
           
    std_graph( fig_num+5 , 'Shaft link to nacelle forces' , 'FORCE [N]' , 'TIME [s]' , simulation_output.time , ...
               simulation_output.shaft_link_local_f , '-' , 2 );legend('X','Y','Z',0);
           
    std_graph( fig_num+6 , 'Shaft link to nacelle local torque' , 'TORQUE [N*m]' , 'TIME [s]' , simulation_output.time , ...
               simulation_output.shaft_link_local_m , '-' , 2 );legend('X','Y','Z',0);
           
end


post_menu(n_blade_studied,sensors.eta_blade,sensors.tower_flag,sensors.eta_tower,sensors.hub_flag,sensors.drive_train ,fig_num , avrswap );