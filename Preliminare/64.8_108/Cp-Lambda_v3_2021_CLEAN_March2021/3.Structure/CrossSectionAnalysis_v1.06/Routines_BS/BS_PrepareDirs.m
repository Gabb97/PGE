function BS_PrepareDirs

Check=exist('Output','dir');

if Check==0
else
    rmdir('Output','s');
end
Check=exist('SectionFiles','dir');
if Check==0
else
    rmdir('SectionFiles','s');
end
Check=exist('BECASFiles','dir');
if Check==0
else
    rmdir('BECASFiles','s');
end

mkdir('Output');
mkdir('Output\Sections');
mkdir('Output\Elements');
mkdir('Output\Blade');
mkdir('SectionFiles');
mkdir('SectionFiles\Airfoils');
mkdir('SectionFiles\Sections');
mkdir('BECASFiles');
