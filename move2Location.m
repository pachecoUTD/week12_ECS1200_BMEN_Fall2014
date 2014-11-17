function finalPotLocation = move2Location(a, motor5, motorID, potRange, ...
    potDesiredLocation, moveTime, pauseTime, LocTol)

% finalPotLocation = MOVE2LOCATION(a, motor5, motorID, potRange, ...
%    potDesiredLocation, moveTime, pauseTime, LocTol)
%
% a, motor5 are variables used to access and control the 5 motors
% 
% motorID is the specific motor to move
% potRange is a 1x2 vector containing the min/max pot range for motorID
%
% potDesiredLocation is the location where you want to move the specific
% robot motor to at this time
%
% moveTime controls how long the program runs the motor before stopping it
% to check it position. 
%
% pauseTime controls how long the program waits after a motor release
% statement before checking the pot value
%
% LocTol is the location tolerance

% create an object that when destroyed stops all motors. Object is
% destroyed whenever function is exited whether by function finishing or
% being abruptly stopped with Ctrl-C or an error
finishup = onCleanup(@() myCleanupFun(a, motor5));

% check if desired pot location is within the potRange
if (potDesiredLocation > max(potRange)) || (potDesiredLocation < min(potRange))
    error('Pot desired location outside of pot range');
end

% assume potID corresponds to motorID, i.e., pot1 monitors motor1
potID = motorID;

% get the current value / location of potID
potCurrentLocation = analogSlowRead(a, potID);

% if debug==0, then no debugging statements are printed
% if debug==1, then debugging statements are printed as function runs
debug = 0;

% output debugging statement
if debug
    fprintf('Initial position = %g, Desired position = %g\n', ...
        potCurrentLocation, potDesiredLocation);
end

% initialize motor speed to 0
motorSpeed = 0;

while abs(potDesiredLocation-potCurrentLocation) > LocTol
    
    % Note: the code below assumes that when the motor is moving "forward"
    % the potentiometer value will be increasing.
    if potCurrentLocation < potDesiredLocation
        motorDirection = 'forward';
    else
        motorDirection = 'backward';
    end

    dist2go = abs(potCurrentLocation-potDesiredLocation) / diff(potRange);
    
    % slow motor speed as you approach the desired location
    motorSpeed = compute_speed(dist2go);
    
    % set the motor speed
    motor5 = motorController(a, motor5, motorID, 'speed', motorSpeed);

    % set the motor direction
    motor5 = motorController(a, motor5, motorID, motorDirection);

    % pause to let motor run for a short time
    pause(moveTime); % small increment of time to move in

    % stop the motor
    motor5 = motorController(a, motor5, motorID, 'release');
    
    % wait for the motor to stop spinning
    pause(pauseTime);

    % output debugging statement
    if debug
        fprintf('Current position = %g, Desired position = %g, motorSpeed = %g\n', ...
            potCurrentLocation, potDesiredLocation, motorSpeed);
    end
    
    % get the current value of the potentiometer
    potCurrentLocation = analogSlowRead(a, potID);
end

% output debugging statement
if debug
    fprintf('Final position = %g, Desired position = %g, motorSpeed = %g\n', ...
        potCurrentLocation, potDesiredLocation, motorSpeed);
end

% set the latest value of the potentiometer to be the final value which is
% the output of the function
finalPotLocation = potCurrentLocation;

% end of main function
return

function motorSpeed = compute_speed(dist2go)

% dist2go is the distance to go as a percentage of the total potRange
% dist2go varies between 0 and 1

% motorSpeed will range from 100 to 255
motorSpeed = min(255, round(dist2go * 155) + 100);

% end of compute_speed aux function
return

function myCleanupFun(a, motor5);

% Stop all motors when exiting the move2Location function

% Note: This function will be called even if move2Location is stopped 
% with a Ctrl-C

for motorID = 1:5,
    motor5 = motorController(a, motor5, motorID, 'release');
end

% end of myCleanupFun aux function
return










