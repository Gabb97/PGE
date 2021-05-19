function [pstar1,pgradrow, pgradcolumn] = LookUpDerivative(Table,RowVect,ColumnVect,RowValue,ColumnValue)


pstar1=interp2(ColumnVect,RowVect,Table,ColumnValue,RowValue,'spline');
X1=linspace(ColumnVect(1),ColumnVect(end),100);
Y1=linspace(RowVect(1),RowVect(end),100)';
p_column = spline(X1,interp2(ColumnVect,RowVect,Table,X1,RowValue,'spline'));
p_row = spline(Y1,interp2(ColumnVect,RowVect,Table,ColumnValue,Y1,'spline'));
pgradcolumn = fnval(fnder(p_column,1),ColumnValue);
pgradrow = fnval(fnder(p_row,1),RowValue);

% 
% ii=find(RowVect<=RowValue);
% if isempty(ii)
%     i1=1;
% else
%     i1=ii(end);
% end
% if i1==length(RowVect)
%     i1 = i1 - 1 ;
% end
% dr=RowValue-RowVect(i1);
% i2=i1+1;
% dR1R2=RowVect(i2)-RowVect(i1);
% 
% 
% jj=find(ColumnVect<=ColumnValue);
% if isempty(jj)
%     j1=1;
% else
%     j1=jj(end);
% end
% 
% if j1==length(ColumnVect)
%     j1 = j1 - 1 ;
% end
% dc=ColumnValue-ColumnVect(j1);
% j2=j1+1;
% dC1C2=ColumnVect(j2)-ColumnVect(j1);
% 
% 
% p1 = Table(i1,j1);
% p2 = Table(i1,j2);
% p3 = Table(i2,j1);
% p4 = Table(i2,j2);
% 
% Ps1=p1+(p2-p1)/dC1C2*dc;
% Ps2=p1+(p3-p1)/dR1R2*dr;
% Ps3=p2+(p4-p2)/dR1R2*dr;
% Ps4=p3+(p4-p3)/dC1C2*dc;
% 
% pgradcolumn   =(Ps3-Ps2)/dC1C2;
% pgradrow      =(Ps4-Ps1)/dR1R2;
% 
% pstar1 = Ps2+pgradcolumn*dc;
% pstar2 = Ps1+pgradrow*dr;
