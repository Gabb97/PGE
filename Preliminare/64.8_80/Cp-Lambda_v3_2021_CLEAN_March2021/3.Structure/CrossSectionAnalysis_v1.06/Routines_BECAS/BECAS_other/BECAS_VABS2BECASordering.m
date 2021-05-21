function [Kg]=BECAS_VABS2BECASordering(Kg)
%Reorder stiffness matrix to match VABS
Kgeee=Kg;
Kg=zeros(6);
Kg(:,1)	=	Kgeee(:,2)	;
Kg(:,2)	=	Kgeee(:,3)	;
Kg(:,3)	=	Kgeee(:,1)	;
Kg(:,4)	=	Kgeee(:,5)	;
Kg(:,5)	=	Kgeee(:,6)	;
Kg(:,6)	=	Kgeee(:,4)	;

Kgeee=Kg;
Kg=zeros(6);
Kg(1,:)	=	Kgeee(2,:)	;
Kg(2,:)	=	Kgeee(3,:)	;
Kg(3,:)	=	Kgeee(1,:)	;
Kg(4,:)	=	Kgeee(5,:)	;
Kg(5,:)	=	Kgeee(6,:)	;
Kg(6,:)	=	Kgeee(4,:)	;

end