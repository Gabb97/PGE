%% STABILITY
function [] = PlotStabilityCurves(Parameters,varargin)

if nargin<2
    print_flag = 0;
else
    if nargin >= 2
        print_flag = varargin{1};
        if nargin == 3
            symb = varargin{2};
        else
            symb = '-or';
        end
    end
end

%% COMPUTE DATA
pitch(1) = Parameters.CP_TSR.pitch(1);
TSR(1) = Parameters.CP_TSR.TSR(1);
counter=1;

for i = 1: size(Parameters.CP_TSR.pitch,2)-1

    for j=Parameters.CP_TSR.LookUp.Pitch

        if Parameters.CP_TSR.pitch(i)>j && Parameters.CP_TSR.pitch(i+1)<j
            counter=counter+1;
            pitch(counter)= j;
            TSR(counter)=interp1(Parameters.CP_TSR.pitch(i:i+1),Parameters.CP_TSR.TSR(i:i+1),j);
        end;

        if Parameters.CP_TSR.pitch(i)<j && Parameters.CP_TSR.pitch(i+1)>j
            counter=counter+1;
            pitch(counter)= j;
            TSR(counter)=interp1(Parameters.CP_TSR.pitch(i:i+1),Parameters.CP_TSR.TSR(i:i+1),j);
        end;

        if Parameters.CP_TSR.pitch(i)==j 
            counter=counter+1;
            pitch(counter)= j;
            TSR(counter)=Parameters.CP_TSR.TSR(i);
        end;
    end;
end;

int=[TSR;pitch];
int=int';
int=sortrows(int);
int=flipud(int);
int=int';
TSR=int(1,:);
pitch=int(2,:);

%% PLOT CT CURVES

figure(103);  set(gcf, 'Name','Torque Regulation Trajectory', 'NumberTitle','off')
hold on; zoom on; grid on;
n=0;
for j=Parameters.CP_TSR.LookUp.Pitch
    n=n+1;
    plot([Parameters.CP_TSR.LookUp.TSR(1):.01:Parameters.CP_TSR.LookUp.TSR(end)],...
        interp1(Parameters.CP_TSR.LookUp.TSR,Parameters.CP_TSR.LookUp.Ct(:,n),...
        [Parameters.CP_TSR.LookUp.TSR(1):.01:Parameters.CP_TSR.LookUp.TSR(end)],'spline'),symb)
end;
axis([Parameters.CP_TSR.LookUp.TSR(1) Parameters.CP_TSR.LookUp.TSR(end) 0 1.1*max(max(Parameters.CP_TSR.LookUp.Ct))])
% axis([-Inf Inf 0 0.08])
axe=axis;
% ht=title('Torque Regulation Trajectory');set (ht,'FontSize',14,'FontWeight','bold');
hx=xlabel('\lambda');set (hx,'FontSize',12,'FontWeight','bold');
hy=ylabel('C_{T}');set (hy,'FontSize',12,'FontWeight','bold');


%%  PLOT POINTS ON CURVES
for i = 1:counter
    CT(i)=interp2(Parameters.CP_TSR.LookUp.TSR,Parameters.CP_TSR.LookUp.Pitch,Parameters.CP_TSR.LookUp.Ct',TSR(i),pitch(i),'spline');
    plot(TSR(i),CT(i),'+k','MarkerSize',10,'LineWidth',3)
%     text(-axe(2)*.05+TSR(i),axe(4)*.05+CT(i),strcat(['   ',num2str(pitch(i))]),'FontSize',12)
end
plot(TSR,CT,symb,'LineWidth',3)


%% PLOT ENDREGION2.5 POINT

aa=find(Parameters.CP_TSR.Power==Parameters.maxPower,1);
bb=Parameters.CP_TSR.TSR(aa);

% cc=interp1(TSR,CT,bb);
% plot(bb,cc,'*r','MarkerSize',15,'LineWidth',2)

%% PRINT
if (print_flag)
    print('-djpeg','.\Output\Figures\TorqueCurveTrajectory.jpg');
    print('-depsc','.\Output\Figures\TorqueCurveTrajectory.eps');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

%% PLOT CP CURVES

figure(104);  set(gcf, 'Name','Power Regulation Trajectory', 'NumberTitle','off')
hold on; zoom on; grid on;
n=0;
for j=Parameters.CP_TSR.LookUp.Pitch
    n=n+1;
    plot([Parameters.CP_TSR.LookUp.TSR(1):.01:Parameters.CP_TSR.LookUp.TSR(end)],...
        interp1(Parameters.CP_TSR.LookUp.TSR,Parameters.CP_TSR.LookUp.Cp(:,n),...
        [Parameters.CP_TSR.LookUp.TSR(1):.01:Parameters.CP_TSR.LookUp.TSR(end)],'spline'),symb)
end;
axis([Parameters.CP_TSR.LookUp.TSR(1) Parameters.CP_TSR.LookUp.TSR(end) 0 1.1*max(max(Parameters.CP_TSR.LookUp.Cp))])
% axis([2 10 0 0.5])
% axe=axis;
% ht=title('Power Regulation Trajectory');set (ht,'FontSize',14,'FontWeight','bold');
hx=xlabel('\lambda');set (hx,'FontSize',12,'FontWeight','bold');
hy=ylabel('C_{P}');set (hy,'FontSize',12,'FontWeight','bold');


%%  PLOT POINTS ON CP CURVES

for i = 1:counter
    CP(i)=interp2(Parameters.CP_TSR.LookUp.TSR,Parameters.CP_TSR.LookUp.Pitch,Parameters.CP_TSR.LookUp.Cp',TSR(i),pitch(i),'spline');
    plot(TSR(i),CP(i),'+k','MarkerSize',10,'LineWidth',3)
%     text(-axe(2)*.05+TSR(i),axe(4)*.05+CP(i),strcat(['   ',num2str(pitch(i))]),'FontSize',12)
end

plot(TSR,CP,symb,'LineWidth',3)


%% PLOT ENDREGION2.5 POINT on CP CURVES

aa=find(Parameters.CP_TSR.Power==Parameters.maxPower,1);
bb=Parameters.CP_TSR.TSR(aa);

try
    cc=interp1(TSR,CP,bb);
    plot(bb,cc,'*r','MarkerSize',15,'LineWidth',2)
end
%% PRINT
if (print_flag)
    print('-djpeg','.\Output\Figures\PowerCurveTrajectory.jpg');
    print('-depsc','.\Output\Figures\PowerCurveTrajectory.eps');
end
