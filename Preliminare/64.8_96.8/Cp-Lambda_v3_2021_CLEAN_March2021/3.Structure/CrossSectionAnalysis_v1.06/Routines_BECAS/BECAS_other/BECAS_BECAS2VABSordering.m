function [Kg]=BECAS_BECAS2VABSordering(Kg)


%Reorder stiffness matrix to match VABS
Kgeee=Kg;
Kg=zeros(6);
Kg(:,2)=Kgeee(:,1);
Kg(:,3)=Kgeee(:,2);
Kg(:,1)=Kgeee(:,3);
Kg(:,5)=Kgeee(:,4);
Kg(:,6)=Kgeee(:,5);
Kg(:,4)=Kgeee(:,6);
Kgeee=Kg;
Kg=zeros(6);
Kg(2,:)=Kgeee(1,:);
Kg(3,:)=Kgeee(2,:);
Kg(1,:)=Kgeee(3,:);
Kg(5,:)=Kgeee(4,:);
Kg(6,:)=Kgeee(5,:);
Kg(4,:)=Kgeee(6,:);

end