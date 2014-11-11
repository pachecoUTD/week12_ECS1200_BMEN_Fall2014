fprintf('Welcome to Week #12 of ECS1200 for Bioengineering\n');

% determine the Arduino comport
serialInfo = instrhwinfo('serial');

for k = 1:length(serialInfo.SerialPorts),
    comports(k) = str2num(serialInfo.SerialPorts{k}(4:end));
end

h = find(comports>=3);
if isempty(h)
    fprintf('No Arduino COM port found.\nMake sure your Arduino is plugged in and then restart Matlab\n');
else
    fprintf('Your Arduino COM port is ');
    for k = 1:length(h),
        if k == length(h)
            fprintf('COM%d', comports(h(k)));
        else
            fprintf('COM%d or ', comports(h(k)));
        end
    end
end
fprintf('\n');
