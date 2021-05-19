function [NodesX,NodesY,NodesID,NodesKP,WebNodesID,NumberFEwebs]=Nodes(AirfoilData,UpSparX,LowSparX,FENumb,beta)

xData=AirfoilData(:,1);
yData=AirfoilData(:,2);

DataLen=length(xData);
DataMidLen=DataLen/2;



% Separate Upper/Lower curves

upperXdata=xData(1:DataMidLen);
upperYdata=yData(1:DataMidLen);

lowerXdata=xData(DataMidLen+1:DataLen);
lowerYdata=yData(DataMidLen+1:DataLen);

chordLen=upperXdata(length(upperXdata))-upperXdata(1);
% Cut six curves. This is done in order to be sure that some nodes are
% placed exactly at the limiters of the spar caps.
%-1
for i=1:DataMidLen
    if(upperXdata(i)==UpSparX(2))
        pos6=i;
        break
    else
        
    end
end

%-2
for i=1:DataMidLen
    if(upperXdata(i) == UpSparX(1) )
        pos5=i;
        break
    else
        
    end
end

Curve6X=upperXdata(1:pos6-1);
Curve6Y=upperYdata(1:pos6-1);

Curve5X=upperXdata(pos6:pos5);
Curve5Y=upperYdata(pos6:pos5);

Curve4X=upperXdata(pos5+1:length(upperXdata));
Curve4Y=upperYdata(pos5+1:length(upperXdata));

%-3
for i=1:DataMidLen
    if(lowerXdata(i)==LowSparX(1))
        pos3=i;
        break
    else
        
    end
end
%-4
for i=1:DataMidLen
    if(lowerXdata(i) == LowSparX(2) )
        pos2=i;
        break
    else
        
    end
end

Curve3X=lowerXdata(1:pos3-1);
Curve3Y=lowerYdata(1:pos3-1);
Curve2X=lowerXdata(pos3:pos2);
Curve2Y=lowerYdata(pos3:pos2);
Curve1X=lowerXdata(pos2+1:length(lowerXdata));
Curve1Y=lowerYdata(pos2+1:length(lowerXdata));


%% Calculate Airfoil Surface Length
[UpperSurfaceLength,seglen] = arclength(upperXdata,upperYdata,'linear');
[LowerSurfaceLength,seglen] = arclength(lowerXdata,lowerYdata,'linear');

% calculate FE length
upperFELength=UpperSurfaceLength/FENumb;
lowerFELength=LowerSurfaceLength/FENumb;

% calculate Curves length
% keyboard
[Curve1Length,seglen] = arclength(Curve1X,Curve1Y,'linear');
[Curve2Length,seglen] = arclength(Curve2X,Curve2Y,'linear');
[Curve3Length,seglen] = arclength(Curve3X,Curve3Y,'linear');
[Curve4Length,seglen] = arclength(Curve4X,Curve4Y,'linear');
[Curve5Length,seglen] = arclength(Curve5X,Curve5Y,'linear');
[Curve6Length,seglen] = arclength(Curve6X,Curve6Y,'linear');

% determine number of FE of size --FElength in each curve

n1=round(Curve1Length/lowerFELength);
n2=round(Curve2Length/lowerFELength);
n3=round(Curve3Length/lowerFELength);
n4=round(Curve4Length/upperFELength);
n5=round(Curve5Length/upperFELength);
n6=round(Curve6Length/upperFELength);

% divide curves into nodes
p1=[Curve1X Curve1Y]; qN1 = curvspace(p1,n1+1); n1X=qN1(:,1); n1Y=qN1(:,2);
p2=[Curve2X Curve2Y]; qN2 = curvspace(p2,n2+1); n2X=qN2(:,1); n2Y=qN2(:,2);
p3=[Curve3X Curve3Y]; qN3 = curvspace(p3,n3+1); n3X=qN3(:,1); n3Y=qN3(:,2);
p4=[Curve4X Curve4Y]; qN4 = curvspace(p4,n4+1); n4X=qN4(:,1); n4Y=qN4(:,2);
p5=[Curve5X Curve5Y]; qN5 = curvspace(p5,n5+1); n5X=qN5(:,1); n5Y=qN5(:,2);
p6=[Curve6X Curve6Y]; qN6 = curvspace(p6,n6+1); n6X=qN6(:,1); n6Y=qN6(:,2);

% Place Upper Nodes in correct orientation. See Airf2Becas docs for info.
n1X=flipud(n1X);n1Y=flipud(n1Y);
n2X=flipud(n2X);n2Y=flipud(n2Y);
n3X=flipud(n3X);n3Y=flipud(n3Y);
n4X=flipud(n4X);n4Y=flipud(n4Y);
n5X=flipud(n5X);n5Y=flipud(n5Y);
n6X=flipud(n6X);n6Y=flipud(n6Y);

% Erase Common or proximity-nodes
n1X=n1X(1:length(n1X)-1);n1Y=n1Y(1:length(n1Y)-1);
n3X=n3X(2:length(n3X)-1);n3Y=n3Y(2:length(n3Y)-1);
n4X=n4X(1:length(n4X)-1);n4Y=n4Y(1:length(n4Y)-1);
n6X=n6X(2:length(n6X));n6Y=n6Y(2:length(n6Y));


% Prepare Nodes
NodesX=[n1X;n2X;n3X;n4X;n5X;n6X];
NodesY=[n1Y;n2Y;n3Y;n4Y;n5Y;n6Y];

%% Nodes ID generation
for i=1:length(NodesX)
    NodesID(i)=i;
end


%% Nodes KP generation
for i=1:length(NodesX)
    NodesKP(i)=0;
end

NodesKP(1)=1;
NodesKP(length(NodesKP))=1;

% determine KP2 position
KP2_X=upperXdata(1)+0.1*chordLen;
for i=1:length(NodesX);
    if(NodesX(i)<=KP2_X)
        KP2_pos=i;
    else
        break
    end
end
% determine KP8 position
KP8_X=KP2_X;
for i=round(length(NodesX)/2)+1:length(NodesX);
    if(NodesX(i)>=KP8_X)
        KP8_pos=i+1;
    else
        break
    end
end
NodesKP(KP2_pos)=1;
NodesKP(KP8_pos)=1;

% determine KP3 KP4 position
KP3_pos=n1+1;
KP4_pos=n1+n2+1;

NodesKP(KP3_pos)=1;
NodesKP(KP4_pos)=1;

% KP5
KP5_pos=n1+n2+n3+1;
NodesKP(KP5_pos)=1;

% KP6 KP7
KP6_pos=n1+n2+n3+n4+1;
NodesKP(KP6_pos)=1;

KP7_pos=n1+n2+n3+n4+n5+1;
NodesKP(KP7_pos)=1;

%% Determination of Nodes ID for Shear Web Connection
WebNodesID(1,1)=NodesID(KP7_pos);
WebNodesID(1,2)=NodesID(KP6_pos);

WebNodesID(2,1)=NodesID(KP3_pos);
WebNodesID(2,2)=NodesID(KP4_pos);

%% Determination of Number of FE for webs
Web10Length=sqrt(abs(NodesY(KP7_pos)-NodesY(KP3_pos))^2+abs(NodesX(KP7_pos)-NodesX(KP3_pos))^2);
Web9Length=sqrt(abs(NodesY(KP6_pos)-NodesY(KP4_pos))^2+abs(NodesX(KP6_pos)-NodesX(KP4_pos))^2);

% Fe length along webs should be greater than spar thickness for connection
% requirements
% if(upperFELength>SparThickness)
    webFElength=upperFELength;
% else
%     webFElength=SparThickness+1.2;
% end


NumberFEwebs(1)=round(Web10Length/webFElength);
NumberFEwebs(2)=round(Web9Length/webFElength);

%% Twist Section
% [NodesX,NodesY]=PPtwist(NodesX,NodesY,beta);


%% Check Figure
% figure
% grid on
% hold on
% axis equal
% %----------------------------
% plot(xData,yData,'k')
% % %----------------------------
% % % plot(Curve3X,Curve3Y,'.g')
% % % plot(Curve2X,Curve2Y,'.b')
% % % plot(Curve1X,Curve1Y,'.m')
% % % plot(Curve6X,Curve6Y,'.g')
% % % plot(Curve5X,Curve5Y,'.b')
% % % plot(Curve4X,Curve4Y,'.m')
% % %----------------------------
% plot(n1X,n1Y,'.m')
% plot(n2X,n2Y,'.b')
% plot(n3X,n3Y,'.g')
% plot(n4X,n4Y,'.m')
% plot(n5X,n5Y,'.b')
% plot(n6X,n6Y,'.g')
%----------------------------
% plot(NodesX,NodesY,'.c')
%----------------------------
% for i=1:length(NodesKP)
%     if(NodesKP(i)==1)
%         text(NodesX(i),NodesY(i)-0.03*chordLen,'KP');
%         plot(NodesX(i),NodesY(i),'or');
%     end 
% end
%----------------------------
% for i=1:length(NodesID)
%         text(NodesX(i),NodesY(i)+0.01*chordLen,num2str(NodesID(i)));
% end


