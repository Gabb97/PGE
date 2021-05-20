function [x,y]=PPtwist(xdata,ydata,beta)
beta
beta=(360-beta)*pi/180;

R = [ cos(beta) sin(beta); 
     -sin(beta) cos(beta)];


array=[xdata';ydata'];


rotatedarray=R*array;

x=rotatedarray(1,:)';
y=rotatedarray(2,:)';