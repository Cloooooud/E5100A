function E5100ARecorder(Center,Span,Number_of_points,outputfile)

Min = Center - Span/2;
Max = Center + Span/2;

if Min < 10e3
    Min = 10e3;
    Max = 10e3 + Span;
end

if Max > 300e6
    Min = 300e6 - Span;
    Max = 300e6;
end

ImpedanceRecorder = zeros(1,Number_of_points);
PhaseRecorder = zeros(1,Number_of_points);
TimeRecorder = zeros(1,Number_of_points);
Frequency_Points = linspace(Min,Max,Number_of_points);

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

% Configure instrument object, obj1.
set(obj1, 'InputBufferSize', 10000);

% Configure instrument object, obj1.
set(obj1, 'OutputBufferSize', 10000);

magPlot = figure();
config_mag = gca;
set(config_mag,'XLim',[Min,Max])
set(config_mag,'YLim',[0 5e-3])
mag_x = linspace(Min,Max,Number_of_points);
mag_y = zeros(Number_of_points);
magLine = plot(config_mag,mag_x,mag_y,'k');
hold();

phaPlot = figure();
config_pha = gca;
set(config_pha,'XLim',[Min,Max])
set(config_pha,'YLim',[-180 180])
pha_x = linspace(Min,Max,Number_of_points);
pha_y = zeros(Number_of_points);
phaLine =plot(config_pha,pha_x,pha_y,'k');
hold();
% Connect to instrument object, obj1.
fopen(obj1);

Measurement_count = 1;
tstart = tic;

while 1
% Communicating with instrument object, obj1.

    try
        
        data = query(obj1, 'OUTPDATA?');

        AtoRratio = ProcessRAW(data,Number_of_points);
        time = toc(tstart);

        mag = abs(AtoRratio);
        pha = angle(AtoRratio);

        set(magLine,'ydata',mag);
        set(config_mag,'XLim',[Min,Max])
        set(phaLine,'ydata',pha);
        set(config_pha,'XLim',[Min,Max])
        drawnow

        TimeRecorder(Measurement_count,:) = time;
        ImpedanceRecorder(Measurement_count,:) = mag;
        PhaseRecorder(Measurement_count,:) = pha;

        Measurement_count = Measurement_count + 1;
        disp("Finish measurements, the total number of finished is " +  num2str(Measurement_count));

    catch
        
        disp('Experiment Terminated. The result has been saved ');
        
        RecorderArray= struct('Center',Center,'Span',Span,'Min',Min,'Max', ...
        Max,'Number_of_points',Number_of_points,'Frequency_Points',Frequency_Points,...
        'PhaseRecorder',PhaseRecorder,'ImpedanceRecorder',ImpedanceRecorder,...
        'Measurement_count',Measurement_count - 1,'TimeRecorder',TimeRecorder);
        % same frequency i the same column different rows different
        % recording times goes from low frequency to high frequency
        save(outputfile,'RecorderArray');
        break;
    end

end

end
