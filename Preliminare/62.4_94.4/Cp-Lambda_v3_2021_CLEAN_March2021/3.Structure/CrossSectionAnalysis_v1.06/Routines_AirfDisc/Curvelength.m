function [Length]=curvelength(x,y)

Length=0;
for i=1:(length(x)-1)
    dx=abs(x(i+1)-x(i));
    dy=abs(y(i+1)-y(i));
    l_seg=sqrt((dx)^2+(dy)^2);
    len_cumulative(i)=l_seg;
    Length=Length+l_seg;
end
% len_cumulative