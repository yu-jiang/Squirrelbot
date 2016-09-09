classdef armUI < handle
    properties
        fig
        axis
        lines
        ac %arduno controller
        sliderMotor1
        sliderMotor2
    end
    
    methods
        function this = armUI()
            this.fig = figure('Position',[400 200 800 400]);
            
            this.ac = arduinoController;
            this.ac.connectArduino();
            this.sliderMotor1 = uicontrol(this.fig, 'style', 'slider', ...
                'Max', 1, 'Min', 0, ...
                'Value', this.ac.angle1, ...
                'Position', [420 300 360 30], ...
                'callback', {@slider1callback, this});
            this.sliderMotor2 = uicontrol(this.fig, 'style', 'slider', ...
                'Max', 1, 'Min', 0, ...
                'Value', this.ac.angle2, ...
                'Position', [420 250 360 30], ...
                'callback', {@slider2callback, this});
            
            [this.lines.l, this.lines.lbase] = initializeVirtualArm(this);
        end
        
        function updateVirtualArm(this)
            ha = 0.5;
            xa = ha*cos(this.ac.angle1*pi);
            ya = ha*sin(this.ac.angle1*pi);
            za = 0;
            this.lines.lbase.XData = [0 xa];
            this.lines.lbase.YData = [0 ya];
        end
    end
    
    
    
    events
        positionChanged
    end
    
end

% Local functions
function slider1callback(handle,~,this)
this.ac.angle1 = handle.Value;
update(this.ac);
updateVirtualArm(this);
end

function slider2callback(handle,~,this)
this.ac.angle2 = handle.Value;
update(this.ac);
updateVirtualArm(this);
end

function [l, lbase] = initializeVirtualArm(this)
this.fig;
this.axis  = gca;
this.axis.Position = [0.1 0.1 0.4 0.8];
axis(this.axis, [-5 5 -5 5 0 10]/4);
grid on;

% Base
x0 = 0;
y0 = 0;
z0 = 0;
h0 = 1;

% auxillary point;
ha = 0.5;
xa = ha*cos(this.ac.angle1);
ya = ha*sin(this.ac.angle1);
za = 0;

% First joint
x1 = 0;
y1 = 0;
h1 = 1;
z1 = h1;

lbase = line([x0,xa],[y0 ya],[z0 za], 'LineWidth', 2, ...
    'LineStyle', '-.',...
    'Color', [1 0 0]);
l = line([x0 x1], [y0 y1], [z0 z1], 'LineWidth', 2);

end