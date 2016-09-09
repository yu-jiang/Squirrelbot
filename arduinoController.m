classdef arduinoController < handle
    properties
        arduinoObj       % arduino object
        servo1           % base servo
        angle1 = 0;      % angle for base servo
        servo2
        angle2 = 1;
        savedTrj         % saved Trajectory
    end
    
    methods
        function connectArduino(this)
            % Create the arduino object
            this.arduinoObj = arduino('com4','uno');
            this.servo1 = this.arduinoObj.servo('D9');
            this.servo2 = this.arduinoObj.servo('D10');
            update(this);
        end
        
        function update(this)
            this.servo1.writePosition(this.angle1);
            this.servo2.writePosition(this.angle2);
        end
        
        function replay(this, dt)
            % Replay saved trajectory
            for ct = 1:numel(this.savedTrj)
                this.angle1 = this.savedTrj(ct);
                update(this);
                pause(dt);
            end
        end
    end
end