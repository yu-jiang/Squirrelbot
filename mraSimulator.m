classdef mraSimulator < handle
	% This is to simulate a robotic arm with 3
	properties (Constant)
		ha = 0.5;  % length of auxillary line
		h1 = 1;    % length of the base arm
		h2 = 1;    % length of the middle arm
		h3 = 1;    % length of the upper arm
		xyz0 = [0 0 0];  % coordinates of joint 1
		xyz1 = [0 0 mraSimulator.h1];  % coordinates of joint 2
		
		za = 0;   % z value of auxillary point
	end
	
	properties
		theta1 = 0
		theta2 = pi;
		theta3 = 0
	end
	
	properties (Dependent)
		xyza
		xyz2
		xyz3
	end
	
	methods
		function this = mraSimulator(t1,t2,t3)
			this.theta1 = t1;
			this.theta2 = t2;
			this.theta3 = t3;
		end
		
		function value = get.xyz2(this)
			dtheta = this.theta2;
			x2 = this.h2*cos(dtheta)*cos(this.theta1);
			y2 = this.h2*cos(dtheta)*sin(this.theta1);
			z2 = this.h2*sin(dtheta);
			value = [x2 y2 z2] + this.xyz1;
		end
		
		function value = get.xyza(this)			
			value = [this.ha*cos(this.theta1) this.ha*sin(this.theta1) this.za];
		end
		
		function value = get.xyz3(this)
			dtheta = this.theta3 - (pi/2 - this.theta2);
			x3 = this.h2*cos(dtheta)*cos(this.theta1);
			y3 = this.h2*cos(dtheta)*sin(this.theta1);
			z3 = this.h2*sin(dtheta);
			value = [x3 y3 z3] + this.xyz2;
		end
		
		function copyAngle(this, val)
			this.theta1 = val(1);
			this.theta2 = val(2);
			this.theta3 = val(3);
		end
	end
	
	methods (Static)
		% method for simple coordinate conversion
		function xyz3 = getEndPointXYZ(thetas)
			t1 = thetas(1);
			t2 = thetas(2);
			t3 = thetas(3);
			dtheta = t2;
			x2 = mraSimulator.h2*cos(dtheta)*cos(t1);
			y2 = mraSimulator.h2*cos(dtheta)*sin(t1);
			z2 = mraSimulator.h2*sin(dtheta);
			xyz2 = [x2 y2 z2] + mraSimulator.xyz1;
			
			dtheta = t3 - (pi/2 - t2);
			x3 = mraSimulator.h2*cos(dtheta)*cos(t1);
			y3 = mraSimulator.h2*cos(dtheta)*sin(t1);
			z3 = mraSimulator.h2*sin(dtheta);
			xyz3 = [x3 y3 z3] + xyz2;
		end
	end
end