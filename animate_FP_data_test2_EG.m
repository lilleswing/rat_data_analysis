clear all
    clc
    %h=animatedline;


start_stim = 850
test_end = 1000
end_stim = 2900

load('KRSY20180327rec2-180327-111655.mat')
filename = 'Ca_white_noise.gif';

Ca=downsample(Ca,30);

time=1:length(Ca);
y = double(Ca);

h = plot(NaN,NaN,'k');
axis([850,2900,760,860]);

for k = (start_stim:end_stim)
    set(h, 'XData', time(start_stim:k),'YData', y(start_stim:k));
    drawnow limitrate;
    %hold on
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if k == start_stim;
        imwrite(imind,cm,filename,'gif','Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
end

blah = 0;
