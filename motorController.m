function motor5 = motorController(a, motor5, motorID, motorCMD, varargin)

% MOTORCONTROLLER   Motor controller
%    motor5 = MOTORCONTROLLER(a, motor5, motorID, CMD, [CMD_ARG])
%    controls motors #1 - #5. For motors #1 - #4, it uses the ArduinioIO 
%    functions motorRun and motorSpeed in the Arduino object 'a'. For 
%    motor #5, it controls an external L293 H-bridge IC using the pin 
%    definitions stored in the motor5 structure. CMD and CMD_ARG are 
%    additional arguments illustrated by the below examples:
%
%    Set speed of motor motorID. SPEED is an integer between 0 and 255:
%    motor5 = MOTORCONTROLLER(a, motor5, motorID, 'speed', SPEED);
%
%    Move motor motorID forward:
%    motor5 = MOTORCONTROLLER(a, motor5, motorID, 'forward');
%
%    Move motor motorID backward:
%    motor5 = MOTORCONTROLLER(a, motor5, motorID, 'backward');
%
%    Stop motor motorID:
%    motor5 = MOTORCONTROLLER(a, motor5, motorID, 'release');
%

% Last update: 10/8/2014 by Joe Pacheco
%
% Note: the structure motor5 is a required input AND output since its field
% 'speed' could be updated in the function call. This was done in order to
% make the function call similar to the built-in ArduinoIO library function
% motorSpeed.

% The motorMap defines which physical motor controls to which Matlab
% motor. If motorMap = [1 2 3 4 5], then physical motor N maps to Matlab
% motor N.
motorMap = [1 2 3 4 5];

% lower motorCMD
motorCMD = lower(motorCMD);

if strcmp(motorCMD,'speed')
    if nargin < 5
        error('Missing speed value arg');
    else
        motorCMD_SPEED = varargin{1};
    end
    
    % clean up and check motorCMD_SPEED value
    motorCMD_SPEED = round(motorCMD_SPEED);
    if motorCMD_SPEED > 255, 
        motorCMD_SPEED = 255;
        warning('Motor speed limited to 255. Using 255.');
    end
    if motorCMD_SPEED < 0 
        motorCMD_SPEED = 0;
        warning('Motor speed must be greater than or equal to 0. Using 0.');
    end
    
    if motorMap(motorID)<5
        motorSpeed(a,motorMap(motorID),motorCMD_SPEED);
    else
        % just save the speed to the motor5 variable
        motor5.speed = motorCMD_SPEED;
    end
    
elseif strcmp(motorCMD,'forward')+strcmp(motorCMD,'backward')+strcmp(motorCMD,'release')
    if motorMap(motorID)<5
        motorRun(a,motorMap(motorID),motorCMD);
    else
        if strcmp(motorCMD,'forward')
            analogWrite(a,motor5.enablePin,motor5.speed);
            digitalWrite(a,motor5.in1Pin,0); 
            digitalWrite(a,motor5.in2Pin,1);
        elseif strcmp(motorCMD,'backward')
            analogWrite(a,motor5.enablePin,motor5.speed);
            digitalWrite(a,motor5.in1Pin,1); 
            digitalWrite(a,motor5.in2Pin,0);
        elseif strcmp(motorCMD,'release');
            analogWrite(a,motor5.enablePin,0);
        else
            % unknown, do nothing
            error('Unknown motorController command');
        end
    end
end


