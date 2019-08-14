%% Instrument Connection

% Find a GPIB object.
obj1 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 17, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = gpib('NI', 0, 17);
else
    fclose(obj1);
    obj1 = obj1(1);
end

% Connect to instrument object, obj1.
fopen(obj1);
y = zeros(1,200)
x = 1:200

figure()
hold()
line = plot(x,y);


while(1)
k = query(obj1, 'OUTPDATA?');

real = str2num(k(1,1:9));
real = real * 10^(str2num(k(1,11:13)));
img = str2num(k(1,16:24));
img = img * 10^(str2num(k(1,26:28)));
r = real + img * i;
Zl = 50 * (1+r)/(1-r);

y(1,1:199)= y(1,2:200);
y(1,200) = abs(Zl);

set(line,'YData',y);
drawnow

end