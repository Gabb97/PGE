function [ ShearX, ShearY, ElasticX, ElasticY ] = ...
         BECAS_CalcShearAndElasticCenter( Ks )

F=Ks\eye(6);     
%Shear center
z=1;
ShearX = -(F(6,2)+F(6,4)*(1-z))/F(6,6);
ShearY = (F(6,1)+F(6,5)*(1-z))/F(6,6);

%Elastic center
ElasticX = -(-F(4,4)*F(5,3)+F(4,5)*F(4,3))/(F(4,4)*F(5,5)-F(4,5)^2);
ElasticY = -(F(4,3)*F(5,5)-F(4,5)*F(5,3))/(F(4,4)*F(5,5)-F(4,5)^2);


end