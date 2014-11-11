%% Setup
% Before running this code, connect to the Arduino using the command
% a = arduino('COM3');
% Note: your COM port number may be different

%% Initialize motors and assign ID to variable name
initialize_motor5

GripperMotion_ID = 5;
WristMotion_ID = 4;
ElbowMotion_ID = 3;
BaseMotion_ID = 2;
BaseRotation_ID = 1;

potRange(GripperMotion_ID, :) = [300 700];
potRange(WristMotion_ID, :) = [455 790];
potRange(ElbowMotion_ID, :) = [250 636];
potRange(BaseMotion_ID, :) = [380 511];
potRange(BaseRotation_ID, :) = [280 780];


% list of motors to test. Note gripper is not current on the list due to a
% possible problem with the system
motorID_list = [BaseRotation_ID BaseMotion_ID ElbowMotion_ID WristMotion_ID ...
                GripperMotion_ID];


%% Preliminary error checking

% the error_flag is initialized to 0 (i.e., no error) 
error_flag = 0;

for motorID = motorID_list, 
    % get pot signal value before moving motor
    pot_current_location = analogRead(a, motorID);
    pause(0.1)
    pot_current_location = analogRead(a, motorID);
    motor5 = motorController(a, motor5, motorID, 'speed', 200);
    motor5 = motorController(a, motor5, motorID, 'forward');
    pause(0.5);
    motor5 = motorController(a, motor5, motorID, 'release');
    pause(0.2);
    pot_new_location = analogRead(a, motorID);
    if pot_new_location < pot_current_location
        fprintf('Error found on motorID = %g\n', motorID);
        error_flag = 1;
    end
end

if error_flag == 1
    error('Errors found on motors. Fix before proceeding.');
end

%% motor move2Location parameter
moveTime = 0.15; % seconds, increment of time to move robot
pauseTime = 0.15; % seconds, pause time to allow motor to spin down
LocTol = 5; % location tolerance

% move all motors the center of the potentiometer range
for idx = motorID_list, 
    potDesiredLocation = mean(potRange(idx,:))
    finalPotLocation = move2Location(a, motor5, motorID, ...
        potDesiredLocation, moveTime, pauseTime, LocTol);
    fprintf('Final position = %g, Desired position = %g\n', ...
        finalPotLocation, potDesiredLocation);
end

% move each motor to its min and max positions and then return to center
for idx = motorID_list,
    for k = 1:2,
        potDesiredLocation = potRange(idx, k)
        finalPotLocation = move2Location(a, motor5, motorID, ...
            potDesiredLocation, moveTime, pauseTime, LocTol);
        fprintf('Final position = %g, Desired position = %g\n', ...
            finalPotLocation, potDesiredLocation);
    end
    potDesiredLocation = mean(potRange(idx, :))
    finalPotLocation = move2Location(a, motor5, motorID, ...
        potDesiredLocation, moveTime, pauseTime, LocTol);
end






