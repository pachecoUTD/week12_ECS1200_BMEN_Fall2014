%% Setup
% Before running this code, connect to the Arduino using the command
% a = arduino('COM3');
% Note: your COM port number may be different

%% Initialize motors and assign ID to variable name
initialize_motor5

Gripper_ID = 1; % <-- CHANGE THIS ID TO MATCH YOUR SETUP
BaseMotion_ID = 2; % <-- CHANGE THIS ID TO MATCH YOUR SETUP
ElbowMotion_ID = 3; % <-- CHANGE THIS ID TO MATCH YOUR SETUP
WristMotion_ID = 4; % <-- CHANGE THIS ID TO MATCH YOUR SETUP
BaseRotation_ID = 5; % <-- CHANGE THIS ID TO MATCH YOUR SETUP

potRange(Gripper_ID, :) = [681 980]; % <-- CHANGE THESE VALUES
potRange(BaseMotion_ID, :) = [320 386]; % <-- CHANGE THESE VALUES
potRange(ElbowMotion_ID, :) = [930 1023]; % <-- CHANGE THESE VALUES
potRange(WristMotion_ID, :) = [532 670];  % <-- CHANGE THESE VALUES
potRange(BaseRotation_ID, :) = [380 600]; % <-- CHANGE THESE VALUES

% list of motors to test.
motorID_list = [BaseRotation_ID BaseMotion_ID ElbowMotion_ID WristMotion_ID ...
                Gripper_ID];

%% Preliminary error checking

% the error_flag is initialized to 0 (i.e., no error) 
error_flag = 0;

for motorID = motorID_list, 
    % get pot signal value before moving motor
    pot_current_location = analogSlowRead(a, motorID);

    motor5 = motorController(a, motor5, motorID, 'speed', 200);
    motor5 = motorController(a, motor5, motorID, 'forward');
    pause(0.2);
    motor5 = motorController(a, motor5, motorID, 'release');
    pause(0.2);
    pot_new_location = analogSlowRead(a, motorID);
    if pot_new_location < pot_current_location
        fprintf('Error found on motorID = %g\n', motorID);
        error_flag = 1;
    end
end

if error_flag == 1
    error('Errors found on motors. Fix before proceeding.');
end

%% motor move2Location parameter
moveTime = 0.1; % seconds, increment of time to move robot
pauseTime = 0.15; % seconds, pause time to allow motor to spin down
LocTol = 5; % location tolerance

% move all motors the center of the potentiometer range
for motorID = motorID_list, 
    % calculate the center of the potentiometer range
    potDesiredLocation = mean(potRange(motorID,:));

    % now move to this location
    finalPotLocation = move2Location(a, motor5, motorID, ...
        potRange(motorID,:), potDesiredLocation, moveTime, pauseTime, LocTol);
    fprintf('Final position = %g, Desired position = %g\n', ...
        finalPotLocation, potDesiredLocation);
end

% move each motor to its min and max positions and then return to center
for motorID = motorID_list,
    for k = 1:2,
        potDesiredLocation = potRange(motorID, k);
        finalPotLocation = move2Location(a, motor5, motorID, ...
            potRange(motorID,:), potDesiredLocation, moveTime, pauseTime, LocTol);
        fprintf('Final position = %g, Desired position = %g\n', ...
            finalPotLocation, potDesiredLocation);
    end
    potDesiredLocation = mean(potRange(motorID, :))
    finalPotLocation = move2Location(a, motor5, motorID, ...
        potRange(motorID,:), potDesiredLocation, moveTime, pauseTime, LocTol);
end







