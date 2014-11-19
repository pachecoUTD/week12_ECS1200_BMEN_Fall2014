% initialize 5th motor
initialize_motor5

%move one motor
motorID = 3; %corresponds to motor id
direction = 'backward' % or 'backward'
runtime = 0.5

pot_old_location = analogSlowRead(a, motorID)

motor5 = motorController(a, motor5, motorID, 'speed', 255);
motor5 = motorController(a, motor5, motorID, direction);
pause(runtime)
motor5 = motorController(a, motor5, motorID, 'release');
pot_new_location = analogSlowRead(a, motorID)
pause(0.15)
pot_new_location = analogSlowRead(a, motorID)
pause(0.15)
