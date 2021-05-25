function CheckPythonPath(python_path)

python  =   [python_path '.\python.exe'];
flag    =   exist(python);

if flag > 0
    
else
    disp('WARNING. Python executable not found in the specified directory.');
    keyboard
end



