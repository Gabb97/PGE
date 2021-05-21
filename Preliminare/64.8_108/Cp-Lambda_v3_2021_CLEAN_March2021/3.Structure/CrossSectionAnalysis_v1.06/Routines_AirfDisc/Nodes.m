function [NodesX,NodesY,NodesID,NodesKP,WebNodesID,NumberFEwebs]=Nodes(AirfoilData,UpSparX,LowSparX,UpperReinfX,LowerReinfX,FENumb,beta)

%% 1) Preliminary oprations + Data-Handling 1
% Retrieve airfoil (x,y) points
xData   =   AirfoilData(:,1);
yData   =   AirfoilData(:,2);

% Find middle point separating Upper/Lower surfaces
DataLen     =   length(xData);
DataMidLen  =   DataLen/2;

% Separate Upper/Lower curves

upperXdata  =   xData(1:DataMidLen);
upperYdata  =   yData(1:DataMidLen);

lowerXdata  =   xData(DataMidLen+1:DataLen);
lowerYdata  =   yData(DataMidLen+1:DataLen);

% Compute local chord length
chordLen    =   upperXdata(length(upperXdata))-upperXdata(1);

% Debug
% figure
% hold on
% grid on
% plot(xData,yData)
% plot(upperXdata,upperYdata,'c')
% plot(lowerXdata,lowerYdata,'m')
% axis equal


%% 2) Data-Handling 2
% Cut individual curves. This is done in order to be sure that nodes are
% placed exactly at the limiters of the spar caps and the LE/TE
% reinforcements

% Positions are:
    % pos11 =  SS (upper) TE
    % pos10 =  SS (upper) TE reinforcement
    % pos9  =  SS (upper) spar cap end
    % pos8  =  SS (upper) spar cap start
    % pos7  =  SS (upper) LE reinforcement
    % pos6  =  SS (upper) LE 
    % pos5  =  PS (lower) LE reinforcement
    % pos4  =  PS (lower) spar cap start
    % pos3  =  PS (lower) spar cap end
    % pos2  =  PS (lower) TE reinforcement
    % pos1  =  PS (lower) TE 
 
% Curves are:   
    % Curve10 = SS (upper) TE --> TE reinforcement
    % Curve9  = SS (upper) TE reinforcement --> spar cap end
    % Curve8  = SS (upper) spar cap end --> spar cap start
    % Curve7  = SS (upper) spar cap start --> LE reinforcement
    % Curve6  = SS (upper) LE reinforcement --> LE
    % Curve5  = PS (lower) LE --> LE reinforcement
    % Curve4  = PS (lower) LE reinforcement --> spar cap start
    % Curve3  = PS (lower) spar cap start --> spar cap end
    % Curve2  = PS (lower) spar cap start --> TE reinforcement
    % Curve1  = PS (lower) TE reinforcement --> TE

% Find positions
 pos11    =     1;
[pos10,~] =     find(upperXdata==UpperReinfX(2));
[pos9,~]  =     find(upperXdata==UpSparX(2));
[pos8,~]  =     find(upperXdata==UpSparX(1));
[pos7,~]  =     find(upperXdata==UpperReinfX(1));
 pos6     =     length(upperXdata);
[pos5,~]  =     find(lowerXdata==LowerReinfX(1));
[pos4,~]  =     find(lowerXdata==LowSparX(1));
[pos3,~]  =     find(lowerXdata==LowSparX(2));
[pos2,~]  =     find(lowerXdata==LowerReinfX(2));
 pos1     =     length(lowerXdata);


% Cut curves
Curve10X    =   upperXdata(pos11:pos10);
Curve10Y    =   upperYdata(pos11:pos10);

Curve9X     =   upperXdata(pos10+1:pos9-1);
Curve9Y     =   upperYdata(pos10+1:pos9-1);

Curve8X     =   upperXdata(pos9:pos8);
Curve8Y     =   upperYdata(pos9:pos8);

Curve7X     =   upperXdata(pos8+1:pos7-1);
Curve7Y     =   upperYdata(pos8+1:pos7-1);

Curve6X     =   upperXdata(pos7:pos6);
Curve6Y     =   upperYdata(pos7:pos6);

Curve5X     =   lowerXdata(1:pos5);
Curve5Y     =   lowerYdata(1:pos5);

Curve4X     =   lowerXdata(pos5+1:pos4-1);
Curve4Y     =   lowerYdata(pos5+1:pos4-1);

Curve3X     =   lowerXdata(pos4:pos3);
Curve3Y     =   lowerYdata(pos4:pos3);

Curve2X     =   lowerXdata(pos3+1:pos2-1);
Curve2Y     =   lowerYdata(pos3+1:pos2-1);

Curve1X     =   lowerXdata(pos2:pos1);
Curve1Y     =   lowerYdata(pos2:pos1);

% 
% Curve5X=upperXdata(pos6:pos5);
% Curve5Y=upperYdata(pos6:pos5);
% 
% Curve4X=upperXdata(pos5+1:length(upperXdata));
% Curve4Y=upperYdata(pos5+1:length(upperXdata));
% 
% %-3
% for i=1:DataMidLen
%     if(lowerXdata(i)==LowSparX(1))
%         pos3=i;
%         break
%     else
%         
%     end
% end
% %-4
% for i=1:DataMidLen
%     if(lowerXdata(i) == LowSparX(2) )
%         pos2=i;
%         break
%     else
%         
%     end
% end
% 
% Curve3X=lowerXdata(1:pos3-1);
% Curve3Y=lowerYdata(1:pos3-1);
% Curve2X=lowerXdata(pos3:pos2);
% Curve2Y=lowerYdata(pos3:pos2);
% Curve1X=lowerXdata(pos2+1:length(lowerXdata));
% Curve1Y=lowerYdata(pos2+1:length(lowerXdata));

%% FE Generation
% Calculate Airfoil Surface Length
[UpperSurfaceLength,seglen] = arclength(upperXdata,upperYdata,'linear');
[LowerSurfaceLength,seglen] = arclength(lowerXdata,lowerYdata,'linear');

% Calculate FE length
upperFELength   =   UpperSurfaceLength/FENumb;
lowerFELength   =   LowerSurfaceLength/FENumb;

% Calculate Curves length
% keyboard
[Curve1Length,seglen] = arclength(Curve1X,Curve1Y,'linear');
[Curve2Length,seglen] = arclength(Curve2X,Curve2Y,'linear');
[Curve3Length,seglen] = arclength(Curve3X,Curve3Y,'linear');
[Curve4Length,seglen] = arclength(Curve4X,Curve4Y,'linear');
[Curve5Length,seglen] = arclength(Curve5X,Curve5Y,'linear');
[Curve6Length,seglen] = arclength(Curve6X,Curve6Y,'linear');
[Curve7Length,seglen] = arclength(Curve7X,Curve7Y,'linear');
[Curve8Length,seglen] = arclength(Curve8X,Curve8Y,'linear');
[Curve9Length,seglen] = arclength(Curve9X,Curve9Y,'linear');
[Curve10Length,seglen] = arclength(Curve10X,Curve10Y,'linear');

% Determine number of FE of size FElength in each curve

n1=round(Curve1Length/lowerFELength);
n2=round(Curve2Length/lowerFELength);
n3=round(Curve3Length/lowerFELength);
n4=round(Curve4Length/lowerFELength);
n5=round(Curve5Length/lowerFELength);
n6=round(Curve6Length/upperFELength);
n7=round(Curve7Length/upperFELength);
n8=round(Curve8Length/upperFELength);
n9=round(Curve9Length/upperFELength);
n10=round(Curve10Length/upperFELength);


% Divide curves into nodes
p1=[Curve1X Curve1Y]; qN1 = curvspace(p1,n1+1); n1X=qN1(:,1); n1Y=qN1(:,2);
p2=[Curve2X Curve2Y]; qN2 = curvspace(p2,n2+1); n2X=qN2(:,1); n2Y=qN2(:,2);
p3=[Curve3X Curve3Y]; qN3 = curvspace(p3,n3+1); n3X=qN3(:,1); n3Y=qN3(:,2);
p4=[Curve4X Curve4Y]; qN4 = curvspace(p4,n4+1); n4X=qN4(:,1); n4Y=qN4(:,2);
p5=[Curve5X Curve5Y]; qN5 = curvspace(p5,n5+1); n5X=qN5(:,1); n5Y=qN5(:,2);
p6=[Curve6X Curve6Y]; qN6 = curvspace(p6,n6+1); n6X=qN6(:,1); n6Y=qN6(:,2);
p7=[Curve7X Curve7Y]; qN7 = curvspace(p7,n7+1); n7X=qN7(:,1); n7Y=qN7(:,2);
p8=[Curve8X Curve8Y]; qN8 = curvspace(p8,n8+1); n8X=qN8(:,1); n8Y=qN8(:,2);
p9=[Curve9X Curve9Y]; qN9 = curvspace(p9,n9+1); n9X=qN9(:,1); n9Y=qN9(:,2);
p10=[Curve10X Curve10Y]; qN10 = curvspace(p10,n10+1); n10X=qN10(:,1); n10Y=qN10(:,2);

% Place Upper Nodes in correct orientation. See Airf2Becas docs for info.
n1X=flipud(n1X);n1Y=flipud(n1Y);
n2X=flipud(n2X);n2Y=flipud(n2Y);
n3X=flipud(n3X);n3Y=flipud(n3Y);
n4X=flipud(n4X);n4Y=flipud(n4Y);
n5X=flipud(n5X);n5Y=flipud(n5Y);
n6X=flipud(n6X);n6Y=flipud(n6Y);
n7X=flipud(n7X);n7Y=flipud(n7Y);
n8X=flipud(n8X);n8Y=flipud(n8Y);
n9X=flipud(n9X);n9Y=flipud(n9Y);
n10X=flipud(n10X);n10Y=flipud(n10Y);

% Erase Common or proximity-nodes
% n1X=n1X(1:length(n1X)-1);n1Y=n1Y(1:length(n1Y)-1);
% n3X=n3X(2:length(n3X)-1);n3Y=n3Y(2:length(n3Y)-1);
% n4X=n4X(1:length(n4X)-1);n4Y=n4Y(1:length(n4Y)-1);
% n6X=n6X(2:length(n6X));n6Y=n6Y(2:length(n6Y));

n1Xc=n1X;                   n1Yc =n1Y;
n2Xc=n2X(2:length(n2X)-1);  n2Yc=n2Y(2:length(n2Y)-1);
n3Xc=n3X;                   n3Yc =n3Y;
n4Xc=n4X(2:length(n4X)-1);  n4Yc=n4Y(2:length(n4Y)-1);
n5Xc=n5X;                   n5Yc =n5Y;
n6Xc=n6X(2:length(n6X));    n6Yc=n6Y(2:length(n6Y));
n7Xc=n7X(2:length(n7X)-1);  n7Yc=n7Y(2:length(n7Y)-1);
n8Xc=n8X;                   n8Yc=n8Y;
n9Xc=n9X(2:length(n9X)-1);  n9Yc=n9Y(2:length(n9Y)-1);
n10Xc=n10X;                 n10Yc =n10Y;

% Prepare Nodes
NodesX=[n1Xc;n2Xc;n3Xc;n4Xc;n5Xc;n6Xc;n7Xc;n8Xc;n9Xc;n10Xc];
NodesY=[n1Yc;n2Yc;n3Yc;n4Yc;n5Yc;n6Yc;n7Yc;n8Yc;n9Yc;n10Yc];

%% Nodes ID generation
for i=1:length(NodesX)
    NodesID(i)=i;
end


%% Nodes KP generation
for i=1:length(NodesX)
    NodesKP(i)=0;
end

% Set first(TE PS) nad last(TE SS) KPs
NodesKP(1)=1;
NodesKP(length(NodesKP))=1;

% KP2 is located @ the end of TE reinf (PS)
for i=1:length(NodesX)
    if(NodesX(i)<=LowerReinfX(2))
        KP2_pos=i;
    else
        break
    end
end

% KP10 is located @ the end of TE reinf (SS)
for i=length(NodesX):-1:1
    if(NodesX(i)<=UpperReinfX(2))
        KP10_pos=i;
    else
        break
    end
end
NodesKP(KP2_pos)=1;
NodesKP(KP10_pos)=1;

% KP3 is located @ the end of spar cap (PS)
for i=1:length(NodesX)
    if round(NodesX(i)*1000)<=round(LowSparX(2)*1000)
        KP3_pos=i;
    else
        break
    end
end

% KP9 is located @ the end of spar cap (SS)
for i=length(NodesX):-1:1
    if(NodesX(i)<=UpSparX(2))
        KP9_pos=i;
    else
        break
    end
end

NodesKP(KP3_pos)=1;
NodesKP(KP9_pos)=1;


% KP4 is located @ the start of spar cap (PS)
for i=1:length(NodesX)
    if(NodesX(i)<=LowSparX(1))
        KP4_pos=i;
    else
        break
    end
end


% KP8 is located @ the end of spar cap (SS)
for i=length(NodesX):-1:1
    if(NodesX(i)<=UpSparX(1))
        KP8_pos=i;
    else
        break
    end
end

NodesKP(KP4_pos)=1;
NodesKP(KP8_pos)=1;


% KP5 is located @ the start of LE reinforcements (PS)
for i=1:length(NodesX)
    if(NodesX(i)<=LowerReinfX(1))
        K5_pos=i;
    else
        break
    end
end


% KP7 is located @ the start of LE reinforcements (SS)
for i=length(NodesX):-1:1
    if(NodesX(i)<=UpperReinfX(1))
        KP7_pos=i;
    else
        break
    end
end


NodesKP(K5_pos)=1;
NodesKP(KP7_pos)=1;

% KP6 is located @ the LE
KP6_pos = floor(length(NodesKP)/2)+1;

NodesKP(KP6_pos)=1;

%% Determination of Nodes ID for Shear Web Connection
WebNodesID(1,1)=NodesID(KP9_pos-1);
WebNodesID(1,2)=NodesID(KP8_pos+1);

WebNodesID(2,1)=NodesID(KP3_pos+1);
WebNodesID(2,2)=NodesID(KP4_pos-1);

%% Determination of Number of FE for webs
Web12Length=sqrt(abs(NodesY(KP9_pos)-NodesY(KP3_pos))^2+abs(NodesX(KP9_pos)-NodesX(KP3_pos))^2);
Web11Length=sqrt(abs(NodesY(KP8_pos)-NodesY(KP4_pos))^2+abs(NodesX(KP8_pos)-NodesX(KP4_pos))^2);

% Fe length along webs should be greater than spar thickness for connection
% requirements
% if(upperFELength>SparThickness)
    webFElength=upperFELength;
% else
%     webFElength=SparThickness+1.2;
% end


NumberFEwebs(1)=round(Web12Length/webFElength);
NumberFEwebs(2)=round(Web11Length/webFElength);

%% Twist Section
% [NodesX,NodesY]=PPtwist(NodesX,NodesY,beta);


%% Check Figure
% figure
% grid on
% hold on
% axis equal
% legendstr = {};
% % % %----------------------------
% plot(xData,yData,'k')
% legendstr =[legendstr  'AF Data'];
% % % % %----------------------------
% % plot(Curve10X,Curve10Y,'Color',[0 0 0.5])
% % plot(Curve9X,Curve9Y,'Color',[0 0.2 1])
% % plot(Curve8X,Curve8Y,'Color',[0 0.4 0.7])
% % plot(Curve7X,Curve7Y,'Color',[0 0.8 1])
% % plot(Curve6X,Curve6Y,'Color',[0 0.9 0.2])
% % plot(Curve5X,Curve5Y,'Color',[0.1 0.4 0.1])
% % plot(Curve4X,Curve4Y,'Color',[0.2 1 0.5])
% % plot(Curve3X,Curve3Y,'Color',[0.3 0 0.1])
% % plot(Curve2X,Curve2Y,'Color',[0.6 0 0.9])
% % plot(Curve1X,Curve1Y,'Color',[0.8 0 0.4])
% % legendstr =[legendstr 'Curve10' 'Curve9' 'Curve8' 'Curve7' 'Curve6' 'Curve5' 'Curve4' 'Curve3' 'Curve2' 'Curve1'];
% % % % %----------------------------
% % % % plot(n1Xc,n1Yc,'Marker','.','Color',[0.8 0 0.4])
% % % % plot(n2Xc,n2Yc,'Marker','.','Color',[0.6 0 0.9])
% % % % plot(n3Xc,n3Yc,'Marker','.','Color',[0.3 0 0.1])
% % % % plot(n4Xc,n4Yc,'Marker','.','Color',[0.2 1 0.5])
% % % % plot(n5Xc,n5Yc,'Marker','.','Color',[0.1 0.4 0.1])
% % % % plot(n6Xc,n6Yc,'Marker','.','Color',[0 0.9 0.2])
% % % % plot(n7Xc,n7Yc,'Marker','.','Color',[0 0.8 1])
% % % % plot(n8Xc,n8Yc,'Marker','.','Color',[0 0.4 0.7])
% % % % plot(n9Xc,n9Yc,'Marker','.','Color',[0 0.2 1])
% % % % plot(n10Xc,n10Yc,'Marker','.','Color',[0 0 0.5])
% % % % legendstr = [legendstr 'Nodes 1' 'Nodes 2' 'Nodes 3' 'Nodes 4' 'Nodes 5' 'Nodes 6' 'Nodes 7' 'Nodes 8' 'Nodes 9' 'Nodes 10'];
% % % % ----------------------------
% plot(NodesX,NodesY,'.c')
% legendstr = [legendstr 'Nodes'];
% % % % ----------------------------
% for i=1:length(NodesKP)
%     if(NodesKP(i)==1)
%         text(NodesX(i),NodesY(i)-0.03*chordLen,'KP');
%         plot(NodesX(i),NodesY(i),'or');
%     end 
% end
% legendstr = [legendstr 'KP'];
% % % % ----------------------------
% % % for i=1:length(NodesID)
% % %         text(NodesX(i),NodesY(i)+0.01*chordLen,num2str(NodesID(i)));
% % % end
% % % % ----------------------------
% legend(legendstr)

