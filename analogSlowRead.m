function value = analogSlowRead(a,pin)
value1 = 0;
value2 = 1;

while value1 ~= value2
    value1 = analogRead(a,pin);
    pause(0.02)
    value2 = analogRead(a,pin);
end
value = value1;