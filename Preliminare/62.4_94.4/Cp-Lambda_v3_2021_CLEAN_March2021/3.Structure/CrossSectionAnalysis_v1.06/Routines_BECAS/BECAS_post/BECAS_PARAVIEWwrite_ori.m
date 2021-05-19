function [ Filename1, Filename2, Filename3 ] = BECAS_PARAVIEWwrite_ori(utils )

%% Open file
Filename1='becas_input.ensi.matori1';
fid(1) = fopen(Filename1,'w+');

Filename2='becas_input.ensi.matori2';
fid(2) = fopen(Filename2,'w+');

Filename3='becas_input.ensi.matori3';
fid(3) = fopen(Filename3,'w+');


%% Determine unit vector orientations

% Unit vectors are scaled so that they visualize nicely when arrows
% with scale factor
l_char_ele = sqrt(max(utils.ElArea));

vdir=zeros(utils.ne_2d,3,3);
for i=1:utils.ne_2d
    %Fiber rotation
    rmat1=[cosd(utils.emat(i,4))  -sind(utils.emat(i,4)) 0;
        sind(utils.emat(i,4))   cosd(utils.emat(i,4)) 0;
        0 0 1];
    %Fiber plane rotation
    rmat2=[cosd(utils.emat(i,3))  0 sind(utils.emat(i,3));
        0 1 0;
        -sind(utils.emat(i,3))  0 cosd(utils.emat(i,3))];
    %Unit vectors, scaled
    vdir(i,:,1)=(rmat1*rmat2*[0;0;1])'*l_char_ele;
    vdir(i,:,2)=(rmat1*rmat2*[1;0;0])'*l_char_ele;
    vdir(i,:,3)=(rmat1*rmat2*[0;1;0])'*l_char_ele;
end

for i=1:3
    fprintf(fid(i),'BECAS: material orientation 1 \n');
    fprintf(fid(i),'part \n');
    fprintf(fid(i),'1 \n');
    if(utils.etype == 1)
        fprintf(fid(i),'quad4 \n');
    elseif(utils.etype == 2)
        fprintf(fid(i),'quad8 \n');
    end
    vdir_re=reshape(vdir(:,:,i),[],1);
    fprintf(fid(i),'%12.5e \n',vdir_re);
end


fclose(fid(1)); fclose(fid(2)); fclose(fid(3));
end
