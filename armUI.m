classdef armUI < handle
    properties
        fig
        axis
        lines
        ac %arduno controller
		
		% Sliders
        sliderMotor1
        sliderMotor2
		sliderMotor3
		
		simulationOnly = false;
		positionData 
		
		buttonConnect
		buttonReplay
		
		% 
	end
    
    methods
        function this = armUI()			
            this.fig = figure('String', 'Micro Robotic Arm Controller', ...
				'Position',[400 200 800 400]);
            this.ac = arduinoController;
			this.positionData = mraSimulator(this.ac.angle1, this.ac.angle2, this.ac.angle3);
            this.sliderMotor1 = uicontrol(this.fig, 'style', 'slider', ...
                'Max', pi, 'Min', 0, ...
                'Value', this.positionData.theta1, ...
                'Position', [420 300 360 30], ...
                'callback', {@slider1callback, this});
            this.sliderMotor2 = uicontrol(this.fig, 'style', 'slider', ...
                'Max', pi, 'Min', 0, ...
                'Value', this.positionData.theta2, ...
                'Position', [420 250 360 30], ...
                'callback', {@slider2callback, this});           
			this.sliderMotor3 = uicontrol(this.fig, 'style', 'slider', ...
				'Max', pi, 'Min', 0, ...
				'Value', this.positionData.theta3, ...
				'Position', [420 200 360 30], ...
				'callback', {@slider3callback, this});
			this.buttonConnect = uicontrol(this.fig, 'style', 'pushButton', ...
				'Position', [420 20 100 50], ...,
				'String', 'Connect', ...
				'callback', {@connectButtonCallback, this});
			this.buttonConnect = uicontrol(this.fig, 'style', 'pushButton', ...
				'Position', [520 20 100 50], ...,
				'String', 'Replay', ...
				'callback', {@replayButtonCallback, this});
			
            [this.lines.l, this.lines.lbase] = initializeAxes(this);	
        end
        
		function updateVirtualArm(this)
			% Draw auxillary dashed line
			set(this.lines.lbase, 'XData', [this.positionData.xyz0(1), this.positionData.xyza(1)]);
			set(this.lines.lbase, 'YData', [this.positionData.xyz0(2), this.positionData.xyza(2)]);
			set(this.lines.lbase, 'ZData', [this.positionData.xyz0(3), this.positionData.xyza(3)]);
			
			% Draw the arm
			set(this.lines.l, 'XData',[this.positionData.xyz0(1) this.positionData.xyz1(1) this.positionData.xyz2(1) this.positionData.xyz3(1)]);
			set(this.lines.l, 'YData',[this.positionData.xyz0(2) this.positionData.xyz1(2) this.positionData.xyz2(2) this.positionData.xyz3(2)]);
			set(this.lines.l, 'ZData',[this.positionData.xyz0(3) this.positionData.xyz1(3) this.positionData.xyz2(3) this.positionData.xyz3(3)]);		
			
			drawnow;
		end
	end
	
    methods (Access = protected)
		function update(this)
			updateVirtualArm(this);		
			update(this.ac);			
		end
		
		function updateSliders(this, val)
			this.sliderMotor1.Value = val(1);
			this.sliderMotor2.Value = val(2);
			this.sliderMotor3.Value = val(3);			
		end
	end
% 	
%     
%     events
%         positionChange
%     end
    
end

% Local functions
function slider1callback(handle,~,this)
this.positionData.theta1 = handle.Value;
this.ac.angle1 = handle.Value;
update(this);
end

function slider2callback(handle,~,this)
this.positionData.theta2 = handle.Value;
this.ac.angle2 = handle.Value;
update(this);
end

function slider3callback(handle,~,this)
this.positionData.theta3 = handle.Value;
this.ac.angle3 = handle.Value;
update(this);
end

function connectButtonCallback(handle, ~, this)
if this.ac.isconnected
	disConnectArduino(this.ac);
	this.ac.isconnected = false;
else
	this.ac.isconnected = connectArduino(this.ac);
end

if this.ac.isconnected
	this.String = 'Disconnect';
end
end

function replayButtonCallback(handle, ~, this)

for ct = 1:size(this.ac.SavedTrj, 1);
	this.positionData.copyAngle(this.ac.SavedTrj(ct,:))
	this.ac.copyAngle(this.positionData);
	update(this);
	updateSliders(this, this.ac.SavedTrj(ct,:));
	disp(this.ac.SavedTrj(ct,:));
	pause(0.1);
end
end

function [l, lbase] = initializeAxes(this)
this.fig;
this.axis  = gca;
this.axis.Position = [0.1 0.1 0.4 0.8];
axis(this.axis, [-5 5 -5 5 0 10]/2);
grid on;

% Draw auxillary dashed line
lbase = line([this.positionData.xyz0(1), this.positionData.xyza(1)], ...
	[this.positionData.xyz0(2), this.positionData.xyza(2)], ...
	[this.positionData.xyz0(3), this.positionData.xyza(3)], ...
	'LineWidth', 2, ...
	'LineStyle', '-.',...
	'Color', [1 0 0]);

% Draw the arm
l = line([this.positionData.xyz0(1) this.positionData.xyz1(1) this.positionData.xyz2(1) this.positionData.xyz3(1)], ...
		 [this.positionData.xyz0(2) this.positionData.xyz1(2) this.positionData.xyz2(2) this.positionData.xyz3(2)], ...
	     [this.positionData.xyz0(3) this.positionData.xyz1(3) this.positionData.xyz2(3) this.positionData.xyz3(3)], ...
	     'LineWidth', 2);
end