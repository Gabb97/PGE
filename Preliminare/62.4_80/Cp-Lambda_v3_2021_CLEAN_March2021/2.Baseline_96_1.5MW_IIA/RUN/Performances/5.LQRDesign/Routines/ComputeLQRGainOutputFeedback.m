function K = ComputeLQRGainOutputFeedback(A,B,C,Q,R,K_0,filename,x0,varargin)

%-----------------------------------------------------------------
% Compute LQR Output feedback gains for continuous system:
% dot x = A x + B u
% y   = C x
%
% with control law:
% u = -K y
%
% Reference: Aircraft Control and Simulation; Stevens and Lewis
% pages 403-418
%
% Input:   Q R matrix weights
% Usage: aresolv
% solution to the continuous algebraic Riccati equation
%
%             A'P + PA - PRP + Q = 0
%-----------------------------------------------------------------

debug = 0;

if (debug)
    fid = fopen(filename,'w');
    fprintf(fid,'Iter    J     res      alpha     \n');
end

MaxIter = 300;
Toll = 1e-9;

alpha = 0.1;

Noutput = size(C,1);

%---------------------------------------
%WARNING!
% X = eye(size(A)); %as on page 408
X = x0'*x0;         % 


%WARNING!
% Calculating initial Stabilizing Gain as state feedback gain (page 436)
% K_0 = lqr(A,B,Q,R,varargin{:});
% Selecting terms that corresponds to measured outputs otherwise a more complex J should be chosen: J = 0.5Tr(PX)+sum(g_ij*k_ij)
K_k = K_0;%(:,2:end);

%---------------------------------------

% preliminary checks
% if (any(real(eig(A-B*K_0))>=0))
%   fprintf('K_0 not stabilizing\n');
%   keyboard
% end

if (any(real(eig(A-B*K_k*C))>=0))
    fprintf('K_k0 not stabilizing');
    keyboard
end


if (rank(C)<size(C,1))
    fprintf('Output matrix C has not full rank');
    keyboard
end

Ob = obsv(sqrt(Q),A);
if (rank(Ob)<size(A,1))
    fprintf('(sqrt(Q),A) is not detectable');
    keyboard
end


% Iter 0
A_k = A - B*K_k*C;

% Solution for P : A'P + PA + C'KRKC +Q = 0
R_usage = zeros(size(A));
Q_usage = Q + C'*K_k'*R*K_k*C;
[P1,P2,LAMP,PERR,WELLPOSED,P] = aresolv(A_k,Q_usage,R_usage,'eigen');
if (~WELLPOSED)
    fprintf('\nP: %s ',WELLPOSED);
end
% Solution for S : AS + SA' + X
A_usage = A_k';
[S1,S2,LAMP,PERR,WELLPOSED,S] = aresolv(A_usage,X,R_usage,'eigen');
if (~WELLPOSED)
    fprintf('S: %s \n',WELLPOSED);
end

% Calculating J_k
J_k = 0.5*trace(P*X);


Ik=1;
while Ik<=MaxIter

    DeltaK = inv(R)*B'*P*S*C'*inv(C*S*C') - K_k;

    K_kp1 = K_k + alpha*DeltaK;

    try
        if (any(real(eig(A-B*K_kp1*C))>=0))
            fprintf('ITER %i: K_kp1 not stabilizing\n\n',Ik);
        end
    catch
        fprintf('In ComputeLQRGainOutputFeedback\n');
    end
    A_kp1 = A - B*K_kp1*C;

    % Solution for P
    R_usage = zeros(size(A));
    Q_usage = Q + C'*K_kp1'*R*K_kp1*C;
    [P1,P2,LAMP,PERR,WELLPOSED,P] = aresolv(A_kp1,Q,R_usage,'eigen');
    if (~WELLPOSED)
        fprintf('\nP: %s ',WELLPOSED);
    end

    % Solution for S
    A_usage = A_kp1';
    [S1,S2,LAMP,PERR,WELLPOSED,S] = aresolv(A_usage,X,R_usage,'eigen');
    if (~WELLPOSED)
        fprintf('S: %s\n',WELLPOSED);
    end

    J_kp1 = 0.5*trace(P*X);

    res = J_kp1-J_k;

    if (debug)
        fprintf(fid,'%d    %1.12f     %1.12f     %1.12f      \n',Ik, J_kp1,res,alpha);
    end

    if res>0

        %        fprintf('ITER %i: reducing step\n\n',Ik);
        alpha = alpha*0.5;

    else

        if abs(res)<Toll
            break
        else
            K_k = K_kp1;
            J_k = J_kp1;
            alpha = alpha*1.2;
        end

    end


    Ik = Ik+1;

end

if (debug)
    fprintf(fid,'\n\nK: \n');
    for i=1:size(K_k,1)
        for j=1:size(K_k,2)
            fprintf(fid,'%1.9f ',K_k(i,j));
        end
        fprintf(fid,'\n',K_k(i,j));
    end
    fclose(fid);
end
K=K_k;



% sort(abs(eig(A-B*K_k*C)))
% pause

