% initialize 5th motor
initialize_motor5

%move one motor
motorID = 5; %corresponds to motor id
direction = 'forward' % or 'backward'
runtime = 0.1

pot_old_location = analogSlowRead(a, motorID)

motor5 = motorController(a, motor5, motorID, 'speed', 255);
motor5 = motorController(a, motor5, motorID, direction);
pause(runtime)
motor5 = motorController(a, motor5, motorID, 'release');
pot_new_location = analogSlowRead(a, motorID)
pause(0.15)
pot_new_location = analogSlowRead(a, motorID)
pause(0.15)
