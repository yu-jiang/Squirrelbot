close all
figure

h = 5;
s = 1;
a1 = 0; % angle
s1 = surf([cos(a1+pi/4) cos(-a1-pi/4) cos(a1+3*pi/2) cos(a1+5*pi/2) cos(a1+pi/2);1 1 -1 -1 1]*s,[1 -1 -1 1 1;1 -1 -1 1 1]*s,[0 0 0 0 0;1 1 1 1 1]*h);
axis([-10 10 -10 10 -10 10])