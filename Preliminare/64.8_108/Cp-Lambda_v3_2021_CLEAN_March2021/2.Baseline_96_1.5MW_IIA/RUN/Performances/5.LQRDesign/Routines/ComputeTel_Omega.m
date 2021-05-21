function Tel_omega = ComputeTel_Omega(Ref_cond,GlobalData,Ref_wind)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 07 September 2006 
%%%% Compute the derivative of Tel wrt Omega
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% keyboard
tol = 1.0e-4;

RefWindVect = Ref_wind*[(1-tol) (1+tol)];

TempTorque = spline(GlobalData.Ref.Wind,GlobalData.Ref.RefCond(:,6),RefWindVect);
TempOmega = spline(GlobalData.Ref.Wind,GlobalData.Ref.RefCond(:,3),RefWindVect);
deltaT = TempTorque(2) - TempTorque(1);
deltaO = TempOmega(2)  - TempOmega(1)
Tel_omega = deltaT / deltaO


return

omega_ref   = Ref_cond(3);

ii=find(GlobalData.CONTROL.LookUpTable.PL.O<=omega_ref);
if isempty(ii)
    i1=1;
else
    i1=ii(end);
end
if i1==length(GlobalData.CONTROL.LookUpTable.PL.O)
    i1 = i1 - 1 ;
end
i2=i1+1;

deltaO=GlobalData.CONTROL.LookUpTable.PL.O(i2)-GlobalData.CONTROL.LookUpTable.PL.O(i1);
deltaT=GlobalData.CONTROL.LookUpTable.PL.P(i2)/GlobalData.CONTROL.LookUpTable.PL.O(i2)-GlobalData.CONTROL.LookUpTable.PL.P(i1)/GlobalData.CONTROL.LookUpTable.PL.O(i1);

Tel_omega = deltaT/deltaO;
