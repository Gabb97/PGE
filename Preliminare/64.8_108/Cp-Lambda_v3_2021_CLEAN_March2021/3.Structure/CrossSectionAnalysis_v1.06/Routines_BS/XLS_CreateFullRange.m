function range_full=XLS_CreateFullRange

list = {
            'A';
            'B';
            'C';
            'D';
            'E';
            'F';
            'G';
            'H';
            'I';
            'J';
            'K';
            'L';
            'M';
            'N';
            'O';
            'P';
            'Q';
            'R';
            'S';
            'T';
            'U';
            'V';
            'W';
            'X';
            'Y';
            'Z';
            
            };
        
        
len = length(list);      

for il = 1: len
    for ik = 1:len
        list{end+1}=[list{il} list{ik}];
    end
end

range_full = list;
        