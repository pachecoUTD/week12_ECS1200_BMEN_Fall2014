function finalPotLocation = move2Location(a, motor5, motorID, potRange, ...
    potDLoc, moveTime, pauseTime, LocTol);

potID = motorID;

potCLoc = analogRead(a, potID);
debug = 0;

if debug
    fprintf('Initial position = %g, Desired position = %g\n', ...
        potCLoc, potDLoc);
end

motorSpeed = 0;
while abs(potDLoc-potCLoc) > LocTol
    
    % Note: the code below assumes that when the motor is moving "forward"
    % the potentiometer value will be increasing.
    if potCLoc < potDLoc
        motorDirection = 'forward';
    else
        motorDirection = 'backward';
    end

    dist2go = abs(potCLoc-potDLoc) / diff(potRange);
    
    % slow motor speed as you approach the desired location
    motorSpeed = compute_speed(dist2go);
    motor5 = motorController(a, motor5, motorID, 'speed', motorSpeed);
    motor5 = motorController(a, motor5, motorID, motorDirection);
    pause(moveTime); % small increment of time to move in
    motor5 = motorController(a, motor5, motorID, 'release');
    pause(pauseTime);
    if debug
        fprintf('Current position = %g, Desired position = %g, motorSpeed = %g\n', ...
            potCLoc, potDLoc, motorSpeed);
    end
    potCLoc = analogRead(a, potID);
end

if debug
    fprintf('Final position = %g, Desired position = %g, motorSpeed = %g\n', ...
        potCLoc, potDLoc, motorSpeed);
end
finalPotLocation = potCLoc;

function motorSpeed = compute_speed(dist2go)

% dist2go is the distance to go as a percentage of the total potRange
% dist2go varies between 0 and 1

% motorSpeed will range from 100 to 255
motorSpeed = min(255, round(dist2go * 155) + 100);








