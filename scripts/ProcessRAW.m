function AtoRratio = ProcessRAW(RawData,num_of_Point)

AtoRratio = complex(zeros(1,num_of_Point));
index = 1;

for i = 1 : 30  : length(RawData)
    
    real_exp = 10^(str2double(RawData(1,i+10:i+12)));
    real = str2double(RawData(1,i:i+8)) * real_exp;
    
    img_exp = 10^(str2double(RawData(1,i+25:i+27)));
    img = str2double(RawData(1,i + 15:i+23)) * img_exp;
    
    difference =  complex(real,img);
    AtoRratio(index) = difference;
    
    index = index + 1;
end  

end
