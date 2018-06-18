% x=[-3:0.1:3];
% y=[-3:0.1:3];
% t=[0:0.1:5];
% for i = 1:length(t);
% [x,y]=meshgrid(-3:.1:3,-3:.1:3);
% z=exp(-(x-t(1,i)).^2-(y-t(1,i)).^2);
% surf(x,y,z);
% axis('tight')
% clear('M');
% M(i)=getframe;
% end





% clear; close all;
% 
% x=linspace(0,1,100);
% [X,Y] = meshgrid(x,x);
% 
% N=100; % Number of frames
% for i = 1:N
%     % Example of plot
%     Z = sin(2*pi*(X-i/N)).*sin(2*pi*(Y-i/N));
%     surf(X,Y,Z)
% 
%     % Store the frame
%     %M(i)=getframe(gcf); % leaving gcf out crops the frame in the movie.
% end




figure;
r12 = 1;
steps = 200
axis([-5 5 -5 5])
hold;
hPlot = plot(NaN,NaN,'-');
theta1 = zeros(steps+1,1);
x12    = zeros(steps+1,2);
y12    = zeros(steps+1,2);
MM(steps+1) = struct('cdata',[],'colormap',[]);
for k = 1:1:steps+1;
    theta1(k) = 2*pi/steps*(k-1);
    x12(k,1) = 0;
    x12(k,2) = r12*cos(theta1(k));
    y12(k,1) = 0;
    y12(k,2) = r12*sin(theta1(k));
    set(hPlot,'XData',x12(k,:),'YData',y12(k,:));
    MM(k) = getframe;  
end




figure;
%r12 = 1;
%steps = 200
axis([850 2900 700 900])
hold;
hPlot = plot(NaN,NaN,'-');
%theta1 = zeros(steps+1,1);
%x12    = zeros(steps+1,2);
%y12    = zeros(steps+1,2);
MM(test_end) = struct('cdata',[],'colormap',[]);
for k = start_stim:test_end;
    %time(k)
    %y(k)
    set(hPlot,'XData',time(k),'YData',y(k));
    set(hPlot,'XData',x12(k,:),'YData',y12(k,:));
    MM(k-start_stim+1) = getframe;  
end
