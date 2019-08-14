plot(X50o(2:52,1),X50o(2:52,2))
hold()
plot(X206(2:52,1),X206(2:52,2))
plot(X470o(2:52,1),X470o(2:52,2))
title('Resistor test')
xlabel('Frequency /Hz')
ylabel('Impedance /ohm')
legend('50ohm','260ohm','470ohm')
%%
yyaxis left
plot(rinima(:,1),rinima(:,2));
hold()
ylabel('Gain /dB')
yyaxis right
plot(rinima(:,1),rinima(:,3));
ylabel('Phase /degree')
legend('Gain','Phase')
title('Gain/Phase Plot')
xlabel('Frequency /Hz')
%%
plot(X20pff(2:52,1),X20pff(2:52,2))
title('Impedance Spectroscopy')
legend('20pF')
xlabel('Frequency /Hz')
ylabel('Impedance /ohm')