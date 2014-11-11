% Before running this code, connect to the Arduino using the command
% a = arduino('COM3'); 
% Note: your COM port number may be different

%% Code to initialize motor5 which is controlled by the external L293 IC

% define pins to control motor5 (L293 chip that is external to motor shield)
motor5.enablePin = 9; 
motor5.in1Pin = 2; 
motor5.in2Pin = 13;

% initialize pins to output mode
pinMode(a,motor5.in1Pin,'output');
pinMode(a,motor5.in2Pin,'output');
pinMode(a,motor5.enablePin,'output')

% initial speed for motor 5
motor5.speed = 0;


